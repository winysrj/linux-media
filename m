Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42413 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1LUCui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 21:50:38 -0500
Received: by wgbdr13 with SMTP id dr13so13493024wgb.1
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 18:50:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE9C7A1.8060303@matrix-vision.de>
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
	<4EE9A8B6.4040102@matrix-vision.de>
	<CAOy7-nPY_Nffgj_Ax=ziT9WYH-egvL8QnZfb50Xurn+AF4yWCQ@mail.gmail.com>
	<4EE9C7A1.8060303@matrix-vision.de>
Date: Wed, 21 Dec 2011 10:50:36 +0800
Message-ID: <CAOy7-nOc9U4_BRKYyagcVtDZyr2Z9ZEUAftmdBsfBrWVVLFGjA@mail.gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael & Laurent,

On Thu, Dec 15, 2011 at 6:10 PM, Michael Jones
<michael.jones@matrix-vision.de> wrote:
> Hi James,

> Laurent has a program 'media-ctl' to set up the pipeline (see
> http://git.ideasonboard.org/?p=media-ctl.git).  You will find many examples
> of its usage in the archives of this mailing list. It will look something
> like:
> media-ctl -r
> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]'
> media-ctl -l '"your-sensor-name":0 -> "OMAP3 ISP CCDC":0 [1]'
>
> you will also need to set the formats through the pipeline with 'media-ctl
> --set-format'.
>
> After you use media-ctl to set up the pipeline, you can use yavta to capture
> the data from the CCDC output (for me, this is /dev/video2).
>
>
> -Michael

I encountered some obstacles with the driver testing of my monochrome
sensor on top of Steve's 3.0-pm branch. An NXP SC16IS750 I2C-UART
bridge is used to 'transform' the sensor into a I2C device.

The PCLK, VSYNC, HSYNC (640x512, 30Hz, fixed output format) are free
running upon power-on the sensor unlike MT9V032 which uses the XCLKA
to 'power-on/off' it.

My steps,

1) media-ctl -r -l '"mono640":0->"OMAP3 ISP CCDC":0:[1], "OMAP3 ISP
CCDC":1->"OMAP3 ISP CCDC output":0[1]'

Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

2) media-ctl -f '"mono640":0[Y12 640x512]", "OMAP3 ISP CCDC":1[Y12 640x512]'

Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/0
Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/1

3) yavta -p -f Y12 -s 640x512 -n 4 --capture=61 --skip 1 -F `media-ctl
-e "OMAP3 ISP CCDC output"` --file=./DCIM/Y12

Unsupported video format 'Y12'

Did I missed something?
What parameters did you supplied to yavta to test the Y10/Y12

Many thanks in adv.
Sorry if duplicated emails received.

--
Regards,
James
