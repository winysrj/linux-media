Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FHC0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 22:26:44 -0400
Received: by yxh35 with SMTP id 35so23125yxh.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 19:26:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110607074552.499550e7@bike.lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
	<BANLkTim3ZCCti79FKn9-3toc56jZ9=w3-A@mail.gmail.com>
	<20110607074552.499550e7@bike.lwn.net>
Date: Wed, 8 Jun 2011 10:26:43 +0800
Message-ID: <BANLkTi=B1T2Ng11VGYR2Sibve5ow+wxTag@mail.gmail.com>
Subject: Re: [RFC] Refactor the cafe_ccic driver and add Armada 610 support
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, ytang5@marvell.com,
	jwan@marvell.com, leiwen@marvell.com
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Jon:
    for PXA910, MMP2(Armda 610)
    actually,  CCIC are almost the same.
    but MMP2 has 2 CCIC controllers, and PXA910 only has 1 CCIC controller.
    so it is quite make your driver works on MMP2 and PXA910.

On Tue, Jun 7, 2011 at 9:45 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 7 Jun 2011 13:30:11 +0800
> Kassey Lee <kassey1216@gmail.com> wrote:
>
>>       1)  this driver is still based on cafe_ccic.c, as you said, we
>> can abstract the low level register function, and use soc_camera and
>> videofbu2 to manage the buff and state machine,  how do you think ?
>
> As I said, videobuf2 is on my list of things to do.  Note that the driver
> works just fine without - that code has been in the kernel and working for
> years.  But it's a cleanup that needs to be done at this point, and I will
> do it.
>
Since we have converted a videfbuf2 version for PXA910, could you have
time to review ?
and find the common part to make a better one works on cafe-ccic,
PXA910, and MMP2 ?
 it takes quite time to convert from cafe-ccic.c to videfbuf2 for me.
>>       2) i2c_adapter, how about move this code to driver/i2c, then
>> ccic driver will become clean?
>
> The problem there is that you can't easily disentangle the two devices -
> they use the same registers, the same IRQ line, etc.  One *could* turn the
> whole thing into an MFD driver and split them apart, but I honestly don't
> see a reason to do that.  I'd be surprised if a Cafe chip ever shows up in
> anything new these days, so it's only used in the OLPC XO 1, and that i2c
> will never be used for anything but the sensor.
>
> The i2c *has* been abstracted out of the camera core, so the Cafe i2c
> implementation will not get in the way of any new drivers.
>
for cafe i2c, it is OK.
but for PXA910 and MMP2, the i2c adapter is out of CCIC.

>>       3) in mmp_driver.c, it has the sensor name, OV7670,  we wish
>> that ccic driver do not need to aware of the sensor, also we need to
>> support front and back camera sensor cases.
>
> The only reason the ov7670 dependency is there is because that's the only
> sensor the driver has ever been used with.  Adding other sensors has been
> complicated a bit by Hans's changes which pushed awareness of the
> available video formats into the controller driver (I complained at the
> time), but that can be worked around.
>
> For front and back: I didn't wire up the second controller in the mmp
> driver because I don't have a device that uses both.  I very much wrote
> the driver with the idea that both controllers could be used, though;
> finishing that job will be easy.
>
sorry for confusion, we have another case:
one CCIC should work with two sensors, and switch them by need.
what i mean, for CCIC driver it should not aware the sensor, it can be
 done by user application.

> One thing I haven't done is to look at your driver closely enough to think
> about whether mmp_camera can drive your hardware or not.  You'll have a
> better idea of that than me, I suspect; is the hardware pretty much the
> same?
>
I will update my driver again after Guennadi's comments, would you
please have time to review ?

1) add Jon's email, and cafe-ccic.c copyright.
2) set_bus_param  check for HSYNC, PCLK
3) code stye fix.

> Thanks,
>
> jon
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
