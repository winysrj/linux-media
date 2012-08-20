Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2HTLk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 07:40:58 -0400
Received: by bkwj10 with SMTP id j10so1821004bkw.19
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 04:40:57 -0700 (PDT)
Message-ID: <5032225A.9080305@googlemail.com>
Date: Mon, 20 Aug 2012 13:41:14 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@infradead.org, hdegoede@redhat.com
Subject: How to add support for the em2765 webcam Speedlink VAD Laplace to
 the kernel ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

after a break of 2 1/2 kernel releases (sorry, I was busy with another
project), I would like to bring up again the question how to add support
for this device to the kernel.
See
http://www.mail-archive.com/linux-media@vger.kernel.org/msg44417.html
("Move em27xx/em28xx webcams to a gspca subdriver ?") for the previous
discussion.

Current status is, that I've reverse-engineered the Windows driver and
written a new gspca-subdriver for testing, which is feature complete and
working stable (will send a patch shortly !).
 
The device uses an em2765-bridge, so my first idea was of course to
modify/extend the em28xx-driver.
But during the reverse-engineering-process, it turned out that writing a
new gspca-subdriver was much easier than modifying the em28xx-driver.

The device has the following special characteristics:
- supports only bulk transfers (em28xx driver supports ISOC only)
- uses "proprietary" read/write procedures for the sensor
- uses 16bit eeprom
- em25xx-eeprom with different layout
- sensor OV2640
- different frame processing
- 3 buttons (snapshot, mute, light) which need special treatment
(GPIO-polling, status-reseting, ...)

Another important point to mention: you can see from the USB-logs
(sensor probing) that there must be at least 3 other webcam devices.

Some pros and cons for both solutions:

em28xx:
+ one driver for all 25xx/26xx/27xx/28xx devices
+ no duplicate code (bridge register defines, bridge read/write fcns)
+ other devices COULD benefit from the new functions/code
- big task/lots of work
- code gets bloated with stuff, which is only needed by a few special
devices

gspca:
+ driver already exists (see patch)
+ default driver for webcams
+ much easier to understand and extend
+ same or even less amount of new code lines
+ keeps em28xx-code "simple"
- code duplication
- support for em28xx-webcams spread over to 2 different drivers

I have no strong opinion whether support for this device should finally
be added to em28xx or gspca and
I'm willing to continue working on both solutions as much as my time
permits and as long as I'm having fun (I'm doing this as a hobby !).
Anyway, the em28xx driver is very complex and I really think it would
take several further kernel releases to get the job done...
I would also be willing to spend some time for moving the em28xx-webcam
code to a gspca subdriver, but I don't have any of these devices for
testing.

What do you think ?


Regards,
Frank Schäfer

