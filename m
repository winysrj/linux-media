Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab1G3ODQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 10:03:16 -0400
Message-ID: <4E340F17.7020501@redhat.com>
Date: Sat, 30 Jul 2011 11:03:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Istvan Varga <istvan_v@mailbox.hu>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com> <4E33C426.50000@mailbox.hu>
In-Reply-To: <4E33C426.50000@mailbox.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-07-2011 05:43, Istvan Varga escreveu:
> On 07/29/2011 07:31 PM, Mauro Carvalho Chehab wrote:
> 
>> istvan_v@mailbox.hu (11):
>>        [media] xc4000: code cleanup
>>        [media] dvb-usb/Kconfig: auto-select XC4000 tuner for dib0700
>>        [media] xc4000: check firmware version
>>        [media] xc4000: removed card_type
> 
> I assume a firmware file for XC4000 is still needed ? 

Yes, it is.

> I did create a
> firmware package some time ago and sent it to Devin Heitmueller so that
> he can check if it is OK for being submitted, and also asked if the
> Xceive sources that the firmware building utility depends on can be
> redistributed, but I did not get a reply yet.

Devin,

Any return about that?

> In addition to the utility that creates the firmware from the official
> Xceive sources, I have written one that can extract the firmware
> (version 1.2 or 1.4) from Windows drivers; both utilities produce
> identical output files.

Let's try first with Xceive.

> Another XC4000 issue that may need to be resolved is I2C problems on
> dib0700 based devices like the PCTV 340e. I cannot test these, since
> I have only a cx88 based card with XC4000, and it does not have any
> I2C reliability issues. If PCTV 340e users report I2C related problems,
> perhaps some code may need to be added to retry failed operations before
> reporting an error. I think there is also a hack still in the driver
> that ignores I2C errors during various operations.

Maybe Patrick can help us with dib0700/xc4000. I have a few devices here
with dib0700, but they don't suffer any problem. However, afaik, those
tuner devices require I2C clock stretching. Maybe the current I2C implementation
at dib0700 doesn't implement it.

> 
>>        [media] cx88: implemented luma notch filter control
> 
> In cx88-core.c, there is a change that may be unneeded:
> 
> @@ -636,6 +636,9 @@
>         cx_write(MO_PCI_INTSTAT,   0xFFFFFFFF); // Clear PCI int
>         cx_write(MO_INT1_STAT,     0xFFFFFFFF); // Clear RISC int
> 
> +       /* set default notch filter */
> +       cx_andor(MO_HTOTAL, 0x1800, (  << 11));
> +
>         /* Reset on-board parts */
>         cx_write(MO_SRST_IO, 0);
>         msleep(10);
> 
> In fact, I have re-submitted the patch with this change removed, but
> it is the first version that was incorporated. Having some look at the
> cx88 sources, it seems cx88_reset() is not supposed to set/initialize
> controls, because it is done elsewhere ?

Control Initialization should occur at device init, or when the user
changes something. 

In the specific case of the notch filter, however, it might make sense to 
initialize it after changing the video standard, in order to fulfill the 
cx88 specs.

Btw, It may actually make sense to not allow using the PAL filter with a
NTSC source and vice-versa, e. g. reducing the notch filter to only 3
possible values:

	0 - 4xFSC			(00)
	1 - square pixel		(01)
	2 - std-optimized filter	(10 or 11)

Where 2 would man 10 for NTSC standard or 11 for PAL standard. I suspect,
however, that the std-optimized filter only works if the sampling frequency
is set to 27 MHz. However, at cx88 code, we set the sampling frequency to
be 8xFSC, instead of fixing it to 27MHz. Due to that, I doubt that the
PAL or NTSC optimized filters will give a good result. So, maybe we can change
it to just:

	0 - 4xFSC
	1 - square pixel

In other words, except if you found that the std-optimized filters are giving
better results, I would change the control to only select between 00 and 01, 
and initialize it at device init, with 00.

Cheers,
Mauro
