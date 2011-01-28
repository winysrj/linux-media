Return-path: <mchehab@pedra>
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:46342 "EHLO
	homiemail-a19.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751278Ab1A1Wud (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 17:50:33 -0500
Received: from homiemail-a19.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a19.g.dreamhost.com (Postfix) with ESMTP id 9ADB4604069
	for <linux-media@vger.kernel.org>; Fri, 28 Jan 2011 14:50:32 -0800 (PST)
Received: from [10.0.1.35] (s64-180-61-141.bc.hsia.telus.net [64.180.61.141])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neil@gumstix.com)
	by homiemail-a19.g.dreamhost.com (Postfix) with ESMTPSA id 71A72604014
	for <linux-media@vger.kernel.org>; Fri, 28 Jan 2011 14:50:32 -0800 (PST)
Message-ID: <4D4347E5.7050408@gumstix.com>
Date: Fri, 28 Jan 2011 14:49:09 -0800
From: Neil MacMunn <neil@gumstix.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Re: omap3-isp segfault
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> A few questions that would help to diagnose problems:
> What version of the ISP drivers and the MT9V032 driver are you using? Kernel version?

I'm using the ISP drivers and MT9V032 driver from 
git://linuxtv.org/pinchartl/media.git head=media-0006-sensors. My kernel 
is 2.6.36.

> You could try to force the format on the gst-launch command, as a further test, although I don't know why it's not matching up to the YUVY format you configured in the pipeline.
>
> Eino-Ville Talvala
> Stanford University
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html

This is my setup script:

    #!/bin/sh

    ./media-ctl -r;
    ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]';
    ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]';
    ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]';
    ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]';
    ./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480]';
    ./media-ctl -f '"OMAP3 ISP CCDC":2[SGRBG10 752x480]';
    ./media-ctl -f '"OMAP3 ISP preview":0[SGRBG10 752x480]';
    ./media-ctl -f '"OMAP3 ISP preview":1[YUYV 752x480]';
    ./media-ctl -f '"OMAP3 ISP resizer":1[YUYV 1024x768]';

Which gives me:

    # ./config_camera
    Resetting all links to inactive
    Setting up link 16:0 -> 5:0 [1]
    Setting up link 5:2 -> 7:0 [1]
    Setting up link 7:1 -> 10:0 [1]
    Setting up link 10:1 -> 12:0 [1]
    Setting up format SGRBG10 752x480 on pad mt9v032 3-005c/0
    Format set: SGRBG10 752x480
    Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/0
    Format set: SGRBG10 752x480
    Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/2
    Format set: SGRBG10 752x479
    Setting up format SGRBG10 752x479 on pad OMAP3 ISP preview/0
    Format set: SGRBG10 752x479
    Setting up format SGRBG10 752x479 on pad OMAP3 ISP AEWB/0
    Unable to set format: Invalid argument (-22)
    Setting up format SGRBG10 752x479 on pad OMAP3 ISP AF/0
    Unable to set format: Invalid argument (-22)
    Setting up format SGRBG10 752x479 on pad OMAP3 ISP histogram/0
    Unable to set format: Invalid argument (-22)
    Setting up format SGRBG10 752x480 on pad OMAP3 ISP preview/0
    Format set: SGRBG10 752x480
    Setting up format YUYV 752x480 on pad OMAP3 ISP preview/1
    Format set: YUYV 734x472
    Setting up format YUYV 734x472 on pad OMAP3 ISP resizer/0
    Format set: YUYV 734x472
    Setting up format YUYV 1024x768 on pad OMAP3 ISP resizer/1
    Format set: YUYV 1024x768

And herein lies the problem:

    root@overo:~# ./yavta --enum-formats /dev/video2
    Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
    - Available formats:
    Video format:  (00000000) 0x0

    root@overo:~# ./yavta --enum-formats /dev/video4
    Device /dev/video4 opened: OMAP3 ISP preview output (media).
    - Available formats:
    Video format:  (00000000) 0x0

    root@overo:~# ./yavta --enum-formats /dev/video6
    Device /dev/video6 opened: OMAP3 ISP resizer output (media).
    - Available formats:
    Video format:  (00000000) 0x0


Not sure whether this is a driver problem or...
