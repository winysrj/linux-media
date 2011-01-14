Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41579 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab1ANQ0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 11:26:17 -0500
Received: by iyj18 with SMTP id 18so2647481iyj.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 08:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295019772718638500@masin.eu>
References: <1295019772718638500@masin.eu>
From: Paulo Assis <pj.assis@gmail.com>
Date: Fri, 14 Jan 2011 16:25:54 +0000
Message-ID: <AANLkTimHrFHUEntJipdKs6yurMV0iWHN5VS=eiDSo5Zu@mail.gmail.com>
Subject: Re: [Linux-uvc-devel] Logitech C910 driver problem
To: =?ISO-8859-2?Q?Radek_Ma=B9=EDn?= <radek@masin.eu>
Cc: Linux-uvc-devel@lists.berlios.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Radek,
Please attach the full dmesg output when starting video capture with
the second camera.
Also increase log verbosity first:

something like this:
rmmod uvcvideo
modprobe uvcvideo trace=65535

You should also refer your capture settings (if I remember MJPG
640x480@24 fps) and that if you use one c910 and one c600 everything
works fine.

Note: Cc linux-media since you also posted this thread there.

Regards,
Paulo

2011/1/14 Radek Mašín <radek@masin.eu>:
> Hello,
> I'm trying to get working two Logitech C910 cameras in one computer and I'm unable to
> do it. I connect both cameras to one USB controller and first camera is starting capture
> without problem, but when I try to start second camera during first camera is running,
> I get message in log "uvcvideo: Failed to submit URB 0" and capturing fails.
> I have discussed this problem on quickcamteam forum and it seems, that there is problem
> with uvcvideo driver for this camera.
> Cameras have been tested in two different systems (SuSe 11.2 and Ubuntu 10.10) and on
> both systems I get same behavior.
>
> Thank you
> Radek Masin
> _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/linux-uvc-devel
>
