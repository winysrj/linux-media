Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:35717 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZC2DDa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 23:03:30 -0400
Received: by qyk16 with SMTP id 16so2830190qyk.33
        for <linux-media@vger.kernel.org>; Sat, 28 Mar 2009 20:03:28 -0700 (PDT)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: linux-media@vger.kernel.org
Subject: Kworld ATSC 120 audio capture bug
Date: Sat, 28 Mar 2009 22:03:25 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282203.25789.vanessaezekowitz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While setting up to rip an old movie from a video tape (one which is not available on any other media), I ran into a bug in the cx88 driver..

As in the past, I can initialize the card into analog mode after a reboot, and view video feeds from over-the-air analog TV (what little remains anyway), composite video in, and svideo in just fine.  Audio for the TV also works fine via the cx88-alsa driver, as usual.

However, for some reason, switching to either composite or svideo input does *not* switch the audio input to the two RCA jacks on the harness like it should.  Instead, when I switch to composite mode I get the TV audio from the last channel I tuned to, plus a little crackling or static (probably feedback from the VCR I have connected to that input), and plain white noise when I switch to Svideo mode.

Just to be sure it wasn't an outdated driver, I cleaned up my kernel configuration, fetched a fresh copy of the v4l-dvb repository, and built/installed it, then rebooted and tried again.

Using `xawtv -noxv` for video and sox for the audio stream, as usual for these kinds of tests.

I could swear that this used to work some time back, but I can't make even a rough guess as to when it quit working.

-- 
"There are some things in life worth obsessing over.  Most
things aren't, and when you learn that, life improves."
http://starbase.globalpc.net/~vanessa/
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
