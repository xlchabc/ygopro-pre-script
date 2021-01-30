--福悲喜
--
--Script by JustFish
function c101104080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101104080.target)
	e1:SetOperation(c101104080.activate)
	c:RegisterEffect(e1)
end
function c101104080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,PLAYER_ALL,1)
end
function c101104080.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if not tc1 or not tc2 then return end
	local atk1,atk2=0,0
	if not tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc1:GetTextAttack()>=0 then
		atk1=tc1:GetTextAttack()
	end
	if not tc2:IsType(TYPE_SPELL+TYPE_TRAP) and tc2:GetTextAttack()>=0 then
		atk2=tc2:GetTextAttack()
	end
	if atk1>atk2 then
		if not tc1:IsAbleToHand() then return end
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc1,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc2,REASON_EFFECT)
		end
	elseif atk1<atk2 then
		if not tc2:IsAbleToHand() then return end
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc2,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(1-tp)
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc1,REASON_EFFECT)
		end
	else
		Duel.MoveSequence(tc1,1)
		Duel.MoveSequence(tc2,1)
	end
end
