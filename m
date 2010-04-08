Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42416 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab0DHXJt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 19:09:49 -0400
Date: Fri, 9 Apr 2010 01:09:48 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [patch 3/3] Convert drivers/media/dvb/ttpci/budget-ci.c to use
	ir-core
Message-ID: <20100408230948.GB18316@hardeman.nu>
References: <20100402185827.425741206@hardeman.nu> <20100402190255.774628605@hardeman.nu> <4BBE51C2.8060505@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBE51C2.8060505@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:59:30PM -0300, Mauro Carvalho Chehab wrote:
>david@hardeman.nu wrote:
>> This patch converts drivers/media/dvb/ttpci/budget-ci.c to use ir-core
>> rather than rolling its own keydown timeout handler and reporting keys
>> via drivers/media/IR/ir-functions.c.
>
>Hmm... had you test this patch? It got me an error here:

Sorry, I must have sent you the wrong one :)

>drivers/media/dvb/ttpci/budget-ci.c: In function ‘msp430_ir_init’:
>drivers/media/dvb/ttpci/budget-ci.c:228: error: implicit declaration of function ‘ir_input_init’
>drivers/media/dvb/ttpci/budget-ci.c:228: error: ‘struct budget_ci_ir’ has no member named ‘state’
>
>The fix is trivial. Just drop this line:
>
>        ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
>
>It shouldn't cause any troubles, since the only things this function currently do are:
>        ir->ir_type = ir_type;
>
>        if (repeat)
>                set_bit(EV_REP, dev->evbit);
>
>As the repeat is inside ir-core, and the ir struct is not used anymore, this removal
>should cause no harm.
>
>So, I am dropping the line at the code I'm committing at v4l-dvb.git, to avoid bisect
>breakages.

You're entirely correct, that line should have been dropped (I even sent 
the same thing as part of my latest patch series before I read this 
mail, but if you can fixup the original patch that'd be even better).


-- 
David Härdeman
