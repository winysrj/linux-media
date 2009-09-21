Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:52421 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZIUQUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 12:20:04 -0400
Date: Mon, 21 Sep 2009 11:20:07 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Mike Isely <isely@isely.net>
Subject: [PATCH] bttv: Fix reversed polarity error when switching video
 standard
Message-ID: <alpine.DEB.1.10.0909211116110.28335@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro:

You can also directly pull this from: 
http://linuxtv.org/hg/~mcisely/bttv-patches/

Again, another longer-than usual commit description here.  Same reason 
as before.  This bug is a little less subtle than the other one - and 
the patch is even smaller (one character).

  -Mike


# HG changeset patch
# User Mike Isely <isely@pobox.com>
# Date 1253547742 18000
# Node ID e349075171ddf939381fad432c23c1269abc4899
# Parent  760a8bc4028014493ccbbe85d0c9e8c91873fc23
bttv: Fix reversed polarity error when switching video standard

From: Mike Isely <isely@pobox.com>

The bttv driver function which handles switching of the video standard
(set_tvnorm() in bttv-driver.c) includes a check which can optionally
also reset the cropping configuration to a default value.  It is
"optional" based on a comparison of the cropcap parameters of the
previous vs the newly requested video standard.  The comparison is
being done with a memcmp(), a function which only returns a true value
if the comparison actually fails.

This if-statement appears to have been written to assume wrong
memcmp() semantics.  That is, it was re-initializing the cropping
configuration only if the new video standard did NOT have different
cropcap values.  That doesn't make any sense.  One definitely should
reset things if the cropcap parameters are different - if there's any
comparison to made at all.

The effect of this problem was that a transition from, say, PAL to
NTSC would leave in place old cropping setup that made sense for the
PAL geometry but not for NTSC.  If the application doesn't care about
cropping it also won't try to reset the cropping configuration,
resulting in an improperly cropped video frame.  In the case I was
testing this actually caused black video frames to be displayed.

Another interesting effect of this bug is that if one does something
which does NOT change the video standard and this function is run,
then the cropping setup gets reset anyway - again because of the
backwards comparison.  It turns out that just running anything which
merely opens and closes the video device node (e.g. v4l-info) will
cause this to happen.  One can argue that simply opening the device
node and not doing anything to it should not mess with any of its
state - but because of this behavior, any TV app which does such
things (e.g. xawtv) probably therefore doesn't see the problem.

The solution is to fix the sense of the if-statement.  It's easy to
see how this mistake could have been made given how memcmp() works.
The patch is therefore removal of a single "!" character from the
if-statement in set_tvnorm in bttv-driver.c.

Priority: high

Signed-off-by: Mike Isely <isely@pobox.com>

diff -r 760a8bc40280 -r e349075171dd linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Mon Sep 21 10:09:08 2009 -0500
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Mon Sep 21 10:42:22 2009 -0500
@@ -1322,7 +1322,7 @@
 
 	tvnorm = &bttv_tvnorms[norm];
 
-	if (!memcmp(&bttv_tvnorms[btv->tvnorm].cropcap, &tvnorm->cropcap,
+	if (memcmp(&bttv_tvnorms[btv->tvnorm].cropcap, &tvnorm->cropcap,
 		    sizeof (tvnorm->cropcap))) {
 		bttv_crop_reset(&btv->crop[0], norm);
 		btv->crop[1] = btv->crop[0]; /* current = default */

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
