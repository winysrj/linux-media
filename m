Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57352 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2KGV5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2012 16:57:49 -0500
Message-ID: <509AD957.5070301@gmail.com>
Date: Wed, 07 Nov 2012 22:57:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com> <50979998.8090809@gmail.com> <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com> <50983CFD.2030104@gmail.com> <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com>
In-Reply-To: <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2012 10:34 PM, Andrey Gusakov wrote:
> Hi.
>
>> Does the sensor still hang after 0x2f is written to REG_GRCOM instead ?
> Work!
> I'm looking at drivers/media/usb/gspca/m5602/m5602_ov9650.h
> It use significantly different init sequence. Some of settings
> described in Application note for ov9650, some look like magic.

I guess there are many ways the sensor can be configured initially.
I'd like to keep this initialization sequence as thin as possible,
and to move relevant settings to corresponding v4l2 controls.
Then after v4l2_control_handler_setup() is called, following the initial
register list write, the sensor would be configured into some known
state. I realize it might be more difficult in practice than it sounds
now. :-)

>> Do you have CONFIG_PM_RUNTIME enabled ? Can you try and see it works
>> if you enable it, without additional changes to the clock handling ?
> Work. With CONFIG_PM_RUNTIME and without enabling CLK_GATE at probe.

Ok, thanks. I will add the missing CONFIG_PM_RUNTIME dependency in Kconfig.
The driver has to have PM_RUNTIME enabled since on s3c64xx SoCs there are
power domains and the camera power domain needs to be enabled for the CAMIF
operation. The pm_runtime_* calls in the driver are supposed to ensure 
that.
I wonder why it works for you without PM_RUNTIME, i.e. how comes the power
domain is enabled. It is supposed to be off by default.

>> I hope to eventually prepare the ov9650 sensor driver for mainline. Your
>> help in making it ready for VER=0x52 would be very much appreciated. :-)
> I'll try to helpful.
>
>
>>> Next step is to make ov2460 work.
>> For now I can only recommend you to make the ov2460 driver more similar
>> to the ov9650 one.
> Thanks, I'll try.
>
> P.S. I add support of image effects just for fun. And found in DS that
> s3c2450 also support effects. It's FIMC in-between of 2440 and
> 6400/6410. Does anyone have s3c2450 hardware to test it?

Patches adding image effect are welcome. I'm bit to busy to play with these
things, other than I don't have hardware to test it.
I wasn't really aware of CAMIF in s3c2450. I think a separate variant data
structure would need to be defined for s3c2450. If anyone ever needs it
it could be added easily. For now I'll pretend this version doesn't 
exist. :-)

--

Regards,
Sylwester
