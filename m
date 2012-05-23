Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60248 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2EWAhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 20:37:21 -0400
Received: by vbbff1 with SMTP id ff1so4254634vbb.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 17:37:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:37:20 -0400
Message-ID: <CAAWAx7gYvY1r96cfND+B-wHt0D9281ag+PefU7ONaR_uHHiUZw@mail.gmail.com>
Subject: V4L2 error with HVR-1600 TV Tuner
From: Stephane Boileau <boileau.steph@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Summary:

TV tuner was tested with mplayer, xawtv, and Mythtv.  None of them worked.
mplayer and xawtv both report an ioctl error originating from V4l2.

Hardware and Driver Details:

Platform:  Debian 6.0.5 on AMD64 with kernel 2.6.32
TV tuner:  Hauppauge HVR 1600 identified with a TCL M30WTP-4N-E chip.  The
code labelled on the tuner matches that one.
Driver:  Debian contained an outdated driver (cx18 couldn't identify id
168, which is the chip described above).  Installing the latest driver from
linuxtv.org fixed that problem.

Symptoms and Testing:

-v4l2-ctl works.  I'm able to set frequencies, standard (e.g.:  ntsc-m), and
input (e.g.:  S-video).
-mplayer /dev/video0 works when tuner properties are set properly (i.e.:
appropriate frequency, standard, and input)
-mplayer tv:// ... crashes with an V4L2 ioctl error.  Setting driver=v4l
didn't produce the same error, but that didn't work either due to some
incompatibility.  mplayer tv:// didn't crash when setting driver=dummy.
-xawtv also crashes with a V4L2 ioctl error.

Please advise whether additional information (e.g.:  dmesg, lspci outputs)
is needed to identify and/or correct the problem.

Steph
