Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab0DHXak (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 19:30:40 -0400
Message-ID: <4BBE671D.7070308@infradead.org>
Date: Thu, 08 Apr 2010 20:30:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [patch 3/3] Convert drivers/media/dvb/ttpci/budget-ci.c to use
 ir-core
References: <20100402185827.425741206@hardeman.nu> <20100402190255.774628605@hardeman.nu> <4BBE51C2.8060505@infradead.org> <20100408230948.GB18316@hardeman.nu>
In-Reply-To: <20100408230948.GB18316@hardeman.nu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Härdeman wrote:
> On Thu, Apr 08, 2010 at 06:59:30PM -0300, Mauro Carvalho Chehab wrote:
>> david@hardeman.nu wrote:
>>> This patch converts drivers/media/dvb/ttpci/budget-ci.c to use ir-core
>>> rather than rolling its own keydown timeout handler and reporting keys
>>> via drivers/media/IR/ir-functions.c.
>>
>> Hmm... had you test this patch? It got me an error here:
> 
> Sorry, I must have sent you the wrong one :)
> 
>> drivers/media/dvb/ttpci/budget-ci.c: In function ‘msp430_ir_init’:
>> drivers/media/dvb/ttpci/budget-ci.c:228: error: implicit declaration
>> of function ‘ir_input_init’
>> drivers/media/dvb/ttpci/budget-ci.c:228: error: ‘struct budget_ci_ir’
>> has no member named ‘state’
>>
>> The fix is trivial. Just drop this line:
>>
>>        ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
>>
>> It shouldn't cause any troubles, since the only things this function
>> currently do are:
>>        ir->ir_type = ir_type;
>>
>>        if (repeat)
>>                set_bit(EV_REP, dev->evbit);
>>
>> As the repeat is inside ir-core, and the ir struct is not used
>> anymore, this removal
>> should cause no harm.
>>
>> So, I am dropping the line at the code I'm committing at v4l-dvb.git,
>> to avoid bisect
>> breakages.
> 
> You're entirely correct, that line should have been dropped (I even sent
> the same thing as part of my latest patch series before I read this
> mail, but if you can fixup the original patch that'd be even better).

While I don't care much on experimental trees, I always do a make allyesconfig
and try to compile all drivers before pushing on my master tree. This helps
to avoid some silly mistakes to go upstream ;)

-- 

Cheers,
Mauro
