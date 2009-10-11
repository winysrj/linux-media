Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59416 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbZJKQum (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 12:50:42 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mx1cS-0006c2-EW
	for linux-media@vger.kernel.org; Sun, 11 Oct 2009 18:50:04 +0200
Received: from host82-46-dynamic.51-82-r.retail.telecomitalia.it ([82.51.46.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2009 18:50:04 +0200
Received: from gborzi by host82-46-dynamic.51-82-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2009 18:50:04 +0200
To: linux-media@vger.kernel.org
From: Giuseppe Borzi <gborzi@gmail.com>
Subject: Dazzle TV Hybrid USB and em28xx
Date: Sun, 11 Oct 2009 16:38:54 +0000 (UTC)
Message-ID: <loom.20091011T180513-771@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello to everyone,
I bought a Dazzle TV Hybrid USB stick some years ago (2006 maybe?) and until
now I've used out of kernel drivers from M. Rechberger. Here's a webpage about
the stick

http://www.lelong.com.my/Auc/List/2009-10DeStd44780009_AUCTION_-#
Dazzle-TV-Hybrid-USB-stick-Watch-TV-without-Internet-BID-Now.htm
(this line has been breaked at the sharp # sign)

The usbid is eb1a:2881.
The Linux distribution I'm using, Archlinux, has updated the kernel to 2.6.31.3
and I've failed to patch the out of kernel drivers again, so I've tried the in
kernel em28xx modules.
These are the results: when I plug the stick em28xx and em28xx-dvb get loaded
by the kernel, I think the stick is recognized as card=53 (Pinnacle Hybrid
Pro), and the /dev/videoX, /dev/dspX, /dev/vbiX and /dev/dvb/adapterX devices
are created. But analog TV has no audio (I've tried sox/arecord-aplay),
teletext doesn't work (mtt segfaults) and DVB doesn't work too. With me-tv I
get an error message like "Failed to tune to channel" and sometimes a
"timeout".
Searching this mailing list I've found a way to get at least DVB working
(thanks to Emanuele Deiola)
1) remove em28xx-dvb and em28xx modules if these are already loaded;
2) plug the stick (the kernel loads em28xx and em28xx-dvb);
3) remove em28xx-dvb and em28xx modules
# modprobe -r em28xx-dvb
# modprobe -r em28xx
4) load em28xx with card=11
# modprobe em28xx card=11
and DVB works, i.e. me-tv, vlc, w_scan work as expected. Analog TV is still
without audio, video is OK.
I've tried to add the option card=11 in modprobe.conf but the result is that
the /dev/dvb/adapterX directory is not created.
I hope this is helpful for other people with this stick and to the developers
to enhance support for the stick. Please developers let me know if you need
more info.

