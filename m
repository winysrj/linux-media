Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37817 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1LKUZL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 15:25:11 -0500
Received: by lagp5 with SMTP id p5so1690560lag.19
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 12:25:09 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 11 Dec 2011 21:25:09 +0100
Message-ID: <CABiSWBhYe6QL41mCvDyrZekzn0YjG3F9Lx70Tix0j=Hzsy4rYw@mail.gmail.com>
Subject: I2C and mt9p031 on Overo
From: =?ISO-8859-1?Q?Robert_=C5kerblom=2DAndersson?=
	<robert.nr1@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I trying to get the mt9p031 to work on the Overo board.

So far I have it working in the Beagleboard xM, and now I have sort of
ported/used the same files to get it to work with Overo. My problem
now is that when I probe the camera board (LI-5M03 with an adapter
board in between providing extra voltage levels) it seams fine.

OMAP3ISP loads without any bigger error but the mt9p031 driver can't
find the device, but it does not seam to be a driver problem rather a
board problem. I think this since I've been debugging with "i2cdetect
-y -r 3" to scan the bus for the camera. Most of the times I get
nothing, but a couple of times (out of hundreds or more, I used a
while loop with i2cdetect and then a sleep 1) it showed up with it's
address. I think it happens when I just inserted the board but I'm
sure or if I get it into some "weird" state just adding it. It could
be a contact error but I have a felling it is something else I have
missed. Some pin configuration or something that stops it from
working.

Do you have any tips on how to debug further or on what might the my
problem? I have tried to lower the i2c speed to 100 KHz but it did not
seam to make any difference.

dmesg: http://pastebin.com/MG7G7v8h
board-overo-camera.c: http://pastebin.com/wvTmKk89
board-overo.c: http://pastebin.com/1cc9PkGE
Output from i2cdetect: http://tinypic.com/r/huh8bb/5

--
Regards, Robert Åkerblom-Andersson
