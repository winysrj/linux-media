Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56335 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbcJOQnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 12:43:03 -0400
Subject: Re: [PATCH 4/5] [media] winbond-cir: One variable and its check less
 in wbcir_shutdown() after error detection
To: Sean Young <sean@mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <84757ae3-24d2-cf9b-2217-fd9793b86078@users.sourceforge.net>
 <20161015132956.GA3393@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <7fe65702-ac76-39f2-edea-eba007a3ee96@users.sourceforge.net>
Date: Sat, 15 Oct 2016 18:42:52 +0200
MIME-Version: 1.0
In-Reply-To: <20161015132956.GA3393@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +	/* Set CEIR_EN */
>> +	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);
>> +set_irqmask:
>>  	/*
>>  	 * ACPI will set the HW disable bit for SP3 which means that the
>>  	 * output signals are left in an undefined state which may cause
>> @@ -876,6 +858,14 @@ wbcir_shutdown(struct pnp_dev *device)
>>  	 */
>>  	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
>>  	disable_irq(data->irq);
>> +	return;
>> +clear_bits:
>> +	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
>> +	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
>> +
>> +	/* Clear CEIR_EN */
>> +	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
>> +	goto set_irqmask;
> 
> I'm not convinced that adding a goto which goes backwards is making this
> code any more readible, just so that a local variable can be dropped.

Thanks for your feedback.

Is such a "backward jump" usual and finally required when you would like
to move a bit of common error handling code to the end without using extra
local variables and a few statements should still be performed after it?

Regards,
Markus
