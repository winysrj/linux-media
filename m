Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47012 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1A2SxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 13:53:22 -0500
Received: by wwa36 with SMTP id 36so4508700wwa.1
        for <linux-media@vger.kernel.org>; Sat, 29 Jan 2011 10:53:21 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 29 Jan 2011 13:53:21 -0500
Message-ID: <AANLkTi=D4GOqJB+9CS1xZGAc4vs3WPM5S=GQwm8PK2Sa@mail.gmail.com>
Subject: HVR1255 svideo
From: Jon Goldberg <jond578@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

I've been trying to get the Svideo input on my HVR-1255 working.  From
the latest code in cx23885-cards.c, it seems that only DVB is
supported.  I have some experience writing Linux Kernel/Drivers so I'm
determined to get this working.

I copied the cx23885_boards[CX23885_BOARD_HAUPPAUGE_HVR1250] settings
and did get the V4L layer connected enough to get a /dev/video0,
albeit with only green video and no picture.  I then realized that was
probably a dumb thing to do (possibly damaging the GPIO), since the
eeprom is clearly different based on what I saw in tveeprom.c.

My question is, am I going down the right path to add this support?
Should I go ahead and install Windows (sigh) and get the output from
RegSpy?  Are there any developer git trees that are focused on this
area?

Regards,
Jon

- cx23885[0]: subsystem: 0070:2259, board: Hauppauge WinTV-HVR1255
[card=20,autodetected]
