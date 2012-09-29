Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46157 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab2I2BvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 21:51:17 -0400
Received: by wgbdr13 with SMTP id dr13so2318372wgb.1
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 18:51:16 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 19:51:16 -0600
Message-ID: <CAEULaV+D3c=FBTVNRRxgQMMM6Xc4uG-QoB9WEThrxHpNOuyu=A@mail.gmail.com>
Subject: Follow-up on resetting entire omap3isp to fix "CCDC Can't Stop" error
From: Neil Johnson <realdealneil@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linux-media,

We are using a DM3730 board and using linux-3.0 (and currently porting
to linux-3.4 and possibly newer).  We desire to hook up the omap3 isp
to mutliple cameras by using an FPGA to multiplex the parallel camera
interface pins.  We have proven the ability to capture from either of
two different cameras (they have different interface types, one is
YUV, the other is Bayer).  We use the media-controller interface to
set up the media pipeline, then we start streaming on one camera.
Then, we stop streaming, reset the media pipeline, set the pipeline
for the other camera, and do a stream_on, but that typically doesn't
work and we get a "CCDC can't stop" message that prints out after
closing the first stream.

We are guessing that the OMAP3 ISP is getting stuck after getting a
partial frame, and it appears, according to this:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg44111.html

that a fix would be implemented in the Linux-3.4 kernel that would
allow for a complete reset of the ISP whenever it got into this
hardware state:

"""

Various OMAP3 ISP blocks can't be stopped
before they have processed a complete frame once they have been started. The
work around is to reset the whole ISP, which we will do in v3.4, but that
won't solve the problem completely if one application uses the resizer in
memory-to-memory mode and another application uses the rest of the ISP. In
that case the driver won't be able to reset the ISP as long as the first
application uses it.


"""

Has such a change been implemented?  I struggle to find a patch that
implements this change or a note in the git logs about it.  We are
hoping this is the last piece to the puzzle for allowing us to switch
between cameras (one of which is free-running).

Neil Johnson
