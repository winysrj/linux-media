Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44953 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZITKp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 06:45:29 -0400
Received: by ewy2 with SMTP id 2so239292ewy.17
        for <linux-media@vger.kernel.org>; Sun, 20 Sep 2009 03:45:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8fa437180909181822x48a1cf55x80dacff1af913a8@mail.gmail.com>
References: <8fa437180909181822x48a1cf55x80dacff1af913a8@mail.gmail.com>
Date: Sun, 20 Sep 2009 12:45:31 +0200
Message-ID: <62e5edd40909200345l4def6a7dnf6aca9fbd50eaf53@mail.gmail.com>
Subject: Re: BIOS date 12/02/2008 needs vflip fix on GX700 for gspca_m5602
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: John Katzmaier <johnkatz@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/19 John Katzmaier <johnkatz@gmail.com>:
> Hi,
>
> Here is the information you requested when filing a bug report:
>
> -Device: ALi (Bison) USB Webcam 5602 integrated into MSI GX700 notebook
>
> -Subsystem ID: I'm not sure how to find the subsystem ID in the lsusb
> -v output, but the Vendor ID is 0402 and the Product ID is 5602
>
> -Environment: Ubuntu 9.04 with kernel 2.6.29-02062904-generic, 64-bit
> on an MSI GX700 notebook
>
> -Using the v4l-dvb driver set, installed via hg on 09/18/2009
>
> -Dmesg output of modprobe: [ 1165.707826] gspca: main v2.7.0 registered
> [ 1165.710339] gspca: probing 0402:5602
> [ 1165.710345] ALi m5602: Probing for a po1030 sensor
> [ 1165.727361] ALi m5602: Probing for a mt9m111 sensor
> [ 1165.748111] ALi m5602: Probing for a s5k4aa sensor
> [ 1165.785596] ALi m5602: Detected a s5k4aa sensor
> [ 1165.819979] gspca: probe ok
> [ 1165.820067] usbcore: registered new interface driver ALi m5602
> [ 1165.820077] ALi m5602: registered
>
> -Using the NTSC TV standard
>
> -Steps to reproduce: Load the gspca_m5602 on an MSI GX700 notebook
> with a BIOS date of 12/02/2008 and notice that the image is
> vertically-flipped in V4L applications like Cheese
>
> -Bugfix: The BIOS date of 12/02/2008 needs to be added to
> linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c as indicated at
> http://linuxtv.org/hg/v4l-dvb/rev/1436152bd9db
>
> I worked around the issue by editing m5602_s5k4aa.c and changing
> 07/19/2007 to 12/02/2008 and re-compiling.
>
> I just wanted to submit this bug report so others with the same
> configuration won't have to edit the source and change it according to
> their BIOS date.
>
> -John Katzmaier

Thanks,
I've added another quirk for this BIOS date and will push it upstream shortly.

Regards,
Erik

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
