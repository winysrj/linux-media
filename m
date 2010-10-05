Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34779 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0JEPP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 11:15:57 -0400
Received: by ewy23 with SMTP id 23so2515588ewy.19
        for <linux-media@vger.kernel.org>; Tue, 05 Oct 2010 08:15:56 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Krastanov <krastanov.stefan@gmail.com>
Date: Tue, 5 Oct 2010 17:15:36 +0200
Message-ID: <AANLkTindEhdWzvh_f+2Yps--JSyTw3uz0nWUnjxDLYQN@mail.gmail.com>
Subject: exposure bug in gspca for webcam with SN9C201 + MI0360/MT9V011 or MI0360SOC/MT9V111
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

The v4l2 controls for my cam give the interval 0-6000 for exposure,
but anything over 4000 gives black screen.

The automatic exposure control (software, the cam has no hardware exp
control) starts as usual at something low, if there is not enough
light the exp control pumps up the exposure a little - just as it
should be, but the when exposure gets over 4000 the screen gets black
and exp control pumps it all the way to 6000 (which is black as well).

The workaround is to start v4l2ucp, to turn off auto exposure, then
set exposure to 3999. But that is still a bit dark, so I set the gain
at 6 or 8 and that gives video of good quality.

The driver at http://groups.google.com/group/microdia worked well. The
problems started when I switched to gspca (the driver at that google
group was merged in gspca).

I have some experience with C, but have never done any serious source
diving. Can someone guide me trough. Maybe a personal exchange of
mails will be better suited until a patch is ready.

Cheers
Stefan Krastanov
