Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:48847 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933676AbZIPXjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 19:39:20 -0400
Date: Wed, 16 Sep 2009 19:32:37 -0400
From: James Blanford <jimmybgood9@yahoo.com>
To: linux-media@vger.kernel.org
Subject: fix G_STD and G_PARM default handler - breaks bttv radio
Message-ID: <20090916193237.3a9ed7a3@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy folks,

I have a Winfast 2000xp analog tuner card with a stereo radio.  It
stopped working on the upgrade from 2.6.30 to 2.6.31.  I identified the
above patch to v4l2-ioctl.c as the culprit.  It seems to have an
identifier of V4L/DVB (12429).  Git commit:
9bedc7f7fe803c17d26b5fcf5786b50a7cf40def

I'll be happy to test patches.

   -  Jim

-- 
There are two kinds of people.  The innocent and the living.
