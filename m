Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2F2QNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 12:13:23 -0400
Message-ID: <4FEDD41E.3000608@redhat.com>
Date: Fri, 29 Jun 2012 13:13:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] drxk: Make the QAM demodulator command configurable.
References: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com> <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com> <20461.26585.508583.521723@morden.metzler> <CAFBinCApTRMdut01wPqT08ViOW=++57UHBY2ok=k=EfQSaEVCQ@mail.gmail.com>
In-Reply-To: <CAFBinCApTRMdut01wPqT08ViOW=++57UHBY2ok=k=EfQSaEVCQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-06-2012 12:58, Martin Blumenstingl escreveu:
> Hi Ralph,
> 
>> are you sure about this?
>>  From what I have been told, the 2 parameter command is in the
>> firmware ROM and older loadable/patch firmwares.
>> Newer firmwares provided the 4 parameter command.
> The firmwares in the ROM are a good point.
> 
> I discussed with  Mauro Carvalho Chehab before I started writing my patch,
> and he told me that the only (loadable) firmware that uses the old command
> is the "drxk_a3.mc" one.
>
> But you are right, there is some firmware (for DVB-C, afaik it's NOT for DVB-T)
> stored in the ROM.
> 
> If  I find out that the ROM uses the "old" command then I'll probably try
> making this smart:
> old_qam_demod_cmd will be an int with the following possible values:
> * -1: unknown - trial and error approach will be used
> (afterwards this will be updated to either 0 or 1)
> * 0: use the 2-parameter command
> * 1: use the 4-parameter command
> 
> I'll also try to guess a smart default value:
> -1 will be used if no firmware was given.
> Otherwise 0 will be the default.
> The remaining two drxk_config instances that are still using the old
> firmware will be set to 1 (like in my first patch).

I didn't tell "old command", or at least not in the sense of old firmware. I told
that the first drivers (ddbridge and mantis), based on drxk_ac3.mc firmware, use the
4-parameters variant, while the other drivers use the 2-parameters variant.

Anyway, using the name "old" for such parameter is not a good idea. IMHO, you
should use something like qam_demod_needs_4_parameters for this config data,
or, maybe "number_of_qam_demod_parameters".

If number_of_qam_demod_parameters is not 2 or 4, try both ways. So, a device driver
that won't specify it will be auto-probed.

> 
> If everything goes right then I'll be able to test and update my patch tonight.
> 
> Regards,
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Regards,
Mauro
