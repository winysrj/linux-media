Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33481 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1FMU6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 16:58:15 -0400
Received: by pzk9 with SMTP id 9so2306432pzk.19
        for <linux-media@vger.kernel.org>; Mon, 13 Jun 2011 13:58:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jun 2011 21:58:15 +0100
Message-ID: <BANLkTiksjC8SyYGdfLbF4eSYhR2c9qEzsw@mail.gmail.com>
Subject: Latest media-tree results in system hang, an no IR.
From: JD <jdg8tb@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the latest media-tree, any access to my TV card (using tvtime and
mplayer to watch through composite) results in my Arch Linux (2.6.39)
system freezing. Here is the relavent part of my dmesg upon the
freeze:

http://codepad.org/q5MxDqAI

I compiled the latest media-tree in order to, finally, get my infrared
receiver working, however it still does not.
An entry is made in /proc/bus/input/devices which points to
/dev/input/event5; however. the /dev/lirc device node is not present,
and using "irw" does not seem to recognise any input.

Is anyone else experiencing such issues, and has anyone managed to get
IR actually working on the HVR-1120.

Thanks.
