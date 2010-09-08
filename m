Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:50912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0IHWxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 18:53:54 -0400
Message-ID: <4C881408.2030606@infradead.org>
Date: Wed, 08 Sep 2010 19:54:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com> <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com> <4C88113C.8040703@infradead.org> <20100908224915.GA6699@hardeman.nu>
In-Reply-To: <20100908224915.GA6699@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 08-09-2010 19:49, David Härdeman escreveu:
> On Wed, Sep 08, 2010 at 07:42:04PM -0300, Mauro Carvalho Chehab wrote:
>> Em 06-09-2010 18:26, Maxim Levitsky escreveu:
>>> diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
>>> index f1624b8..d25da91 100644
>>> --- a/drivers/media/IR/ir-rc6-decoder.c
>>> +++ b/drivers/media/IR/ir-rc6-decoder.c
>>> @@ -85,8 +85,9 @@ static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>>>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC6))
>>>  		return 0;
>>>  
>>> -	if (IS_RESET(ev)) {
>>> -		data->state = STATE_INACTIVE;
>>> +	if (!is_timing_event(ev)) {
>>> +		if (ev.reset)
>>
>> Again, why do you need to test first for !is_timing_event()?
> 
> Because the decoder should return early if the event is not a timing 
> event (the return 0 two lines below)...think carrier report event...

Yeah, I saw that. I was supposed to remove all the comments about that, but I
forgot to remove the last one ;)

Cheers,
Mauro.
