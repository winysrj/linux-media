Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45036 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1CBTqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 14:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinjZ8qiT5XpK5qXir3PNCi13CNObLE=x8DeHF2b@mail.gmail.com>
References: <AANLkTincndvx154DXHgeNCnxe+KhtaH+tFUTfqXufFdp@mail.gmail.com>
	<AANLkTikVTgo48gfSUc9DyOhTCwSOuGS0gnjP6xTomor-@mail.gmail.com>
	<loom.20110224T142616-389@post.gmane.org>
	<AANLkTikFk73n87XHbfVVT37mDBd-3jMSBg1j=SKQJr8_@mail.gmail.com>
	<AANLkTiktoL33cNPL8bF-p9iLSkFQmmCFJ1xK_1ydXyAD@mail.gmail.com>
	<AANLkTi=sHnBPDAR5fSeq-EjG4nhe1ibnvfgUbWfeBVeD@mail.gmail.com>
	<AANLkTinjZ8qiT5XpK5qXir3PNCi13CNObLE=x8DeHF2b@mail.gmail.com>
Date: Wed, 2 Mar 2011 20:46:07 +0100
Message-ID: <AANLkTim2QHkiVqdRjb9x-Wp2KC4n-FS0k4e69kOi8tXb@mail.gmail.com>
Subject: Re: omap3-isp: can't register subdev for new sensor driver mt9t001
From: Bastian Hecht <hechtb@googlemail.com>
To: =?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Cc: linux-media@vger.kernel.org, majordomo@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Loic,

in my last post, make sure you return a v4l2_mbus_framefmt structure
that contain yuv 720x480. Else the framework thinks your driver cannot
supply this format. I do not know the exact enums myself, try to grep
it in the linux kernel includes.
In my test driver I added a printk(KERN_ALERT "blabla"); to all subdev
calls to see when the framework calls which functions.

good luck,

Bastian



2011/3/2 Loïc Akue <akue.loic@gmail.com>:
> Hi Bastien,
>
> Me again =)
> Thank you for your previous reply. I added some code, so my saa7113 drivers
> could be compatible with the new media framework.
> But I still can get some video data, from my sub-device. I saw in a mailing
> list that you had a similar issue, could you please help me on this?
>
> root@cm-t35:~# ./media-ctl -r -l '"saa7115 3-0024":0->"OMAP3 ISP CCDC":0[1],
> "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
>
> My first problem appears when I try to configure my pads before trying to
> capture
>
> ************************************************************************************************
> root@cm-t35:~# ./media-ctl -f '"saa7115 3-0024":0[UYVY 720x480], "OMAP3 ISP
> CCDC":2[UYVY 720x480]'
>
> Setting up format UYVY 720x480 on pad saa7115 3-0024/0
> Format set: UYVY 720x480
> Setting up format UYVY 720x480 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG10 720x480
> Setting up format UYVY 720x480 on pad OMAP3 ISP CCDC/2
> Format set: SGRBG10 720x479
>
> Setting up format SGRBG10 720x479 on pad OMAP3 ISP AEWB/0
> Unable to set format: Invalid argument (-22)
> Setting up format SGRBG10 720x479 on pad OMAP3 ISP AF/0
> Unable to set format: Invalid argument (-22)
> Setting up format SGRBG10 720x479 on pad OMAP3 ISP histogram/0
> Unable to set format: Invalid argument (-22)
> ************************************************************************************************
> Then, when I run this yavta command :
> ************************************************************************************************
> root@cm-t35:~# ./yavta -f UYVY -s 720x480 -n 4 --capture=4 --skip 3 -F
> $(./media
> -ctl -e "OMAP3 ISP CCDC output")
>
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video format set: width: 720 height: 480 buffer size: 691200
> Video format: UYVY (59565955) 720x480
> 4 buffers requested.
> length: 691200 offset: 0
> Buffer 0 mapped at address 0x40306000.
> length: 691200 offset: 692224
> Buffer 1 mapped at address 0x40417000.
> length: 691200 offset: 1384448
> Buffer 2 mapped at address 0x404d1000.
> length: 691200 offset: 2076672
> Buffer 3 mapped at address 0x405ed000.
> Unable to start streaming: 22.
> ************************************************************************************************
> And the system hangs.
> Do you have any idea where to look?
>
> Regards
>
> Loïc
>
