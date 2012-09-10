Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab2IJOr3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 10:47:29 -0400
Message-ID: <504DFD60.8020809@redhat.com>
Date: Mon, 10 Sep 2012 11:46:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>
CC: Matthijs Kooijman <matthijs@stdin.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl> <20120816080932.GP21274@login.drsnuggles.stderr.nl> <20120817150415.GC2693@zeus>
In-Reply-To: <20120817150415.GC2693@zeus>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-08-2012 12:04, Luis Henriques escreveu:
> (Adding Mauro to CC has he is the maintainer)

I'm actually waiting for Jarod's comments on it, as he wrote this driver
and the similar ones.

Jarod?

Regards,
Mauro

> 
> On Thu, Aug 16, 2012 at 10:09:32AM +0200, Matthijs Kooijman wrote:
>> Hi folks,
>>
>>> I'm currently compiling a 3.5 kernel with just the rdev initialization
>>> moved up to see if this will fix my problem at all, but I'd like your
>>> view on this in the meantime as well.
>> Ok, this seems to fix my problem:
>>
>> --- a/drivers/media/rc/nuvoton-cir.c
>> +++ b/drivers/media/rc/nuvoton-cir.c
>> @@ -1066,6 +1066,7 @@
>>         /* tx bits */
>>         rdev->tx_resolution = XYZ;
>>  #endif
>> +       nvt->rdev = rdev;
> 
> This makes sense to me.  Note however that there are more drivers with
> a similar problem (e.g., fintek-cir.c).
> 
>>  
>>         ret = -EBUSY; /* now claim resources */ @@ -1090,7 +1091,6
>> @@ goto failure5;
>>  
>>         device_init_wakeup(&pdev->dev, true);
>> -       nvt->rdev = rdev;
>>         nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
>>         if (debug) {
>>                 cir_dump_regs(nvt);
>>
>>
>> I'm still not sure if the rc_register_device shouldn't also be moved up. It
>> seems this doesn't trigger a problem right now, but if there is a problem, I
>> suspect its trigger window is a lot smaller than with the rdev initialization
>> problem...
> 
> I'm not sure as well, I'm not very familiar with this code.  However,
> it looks like the IRQ request should actually be one of the last
> things to do here.
> 
> Cheers,
> --
> Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

