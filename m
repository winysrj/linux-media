Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59871 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZFSPZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 11:25:13 -0400
Received: by gxk10 with SMTP id 10so2931265gxk.13
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 08:25:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 10:52:06 -0400
Message-ID: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
Subject: v4l-dvb compile broken with stock Ubuntu Karmic build
	(firedtv-ieee1394.c errors)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that attempting to compile the current v4l-dvb against a
stock Karmic Koala build fails.  I suspect this has to do with the
fact that 2.6.30 is built with ieee1394 enabled, which causes
firedtv-ieee1394.c to get compiled, and that file references #include
files that do not exist.  As far as I can tell, IEEE1394 is not
enabled in my 2.6.27 build, which is why I was not seeing it before.

Other users reported this issue on the #linuxtv irc a few days ago,
and I though it was just something weird about their environment.

I'm not familiar with the firedtv driver, so if someone who is wants
to chime in, I would appreciate it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
