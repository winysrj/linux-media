Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:58213 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0GHDbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 23:31:35 -0400
Date: Wed, 7 Jul 2010 22:31:34 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, jarod@redhat.com,
	corbet@lwn.net, rz@linux-m68k.org, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	laurent.pinchart@ideasonboard.com, eduardo.valentin@nokia.com,
	p.osciak@samsung.com, liplianin@tut.by, tobias.lorenz@gmx.net,
	hdegoede@redhat.com, u.kleine-koenig@pengutronix.de,
	abraham.manu@gmail.com, stoth@kernellabs.com, henrik@kurelid.se
Subject: Re: Status of the patches under review at LMML (60 patches)
In-Reply-To: <4C332A5F.4000706@redhat.com>
Message-ID: <alpine.DEB.1.10.1007072223310.14650@ivanova.isely.net>
References: <4C332A5F.4000706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Jul 2010, Mauro Carvalho Chehab wrote:

> This is the summary of the patches that are currently under review at 
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
> 
> P.S.: This email is c/c to the developers where some action is expected.
>       If you were copied, please review the patches, acking/nacking or
>       submitting an update.
> 

   [...]


> 		== Waiting for Mike Isely <isely@isely.net> review == 
> 
> Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960
> 

These are cx25840 patches and I'm not the maintainer of that module.  I 
can't really speak to the correctness of the changes.  Best I can do is 
to try the patch with a few pvrusb2-driven devices here that use the 
cx25840 module.  I've done that now (HVR-1950 and PVR-USB2 model 24012) 
and everything continues to work fine.  Note, this part of the patch:

 		int hw_fix = state->pvr150_workaround;
-
-		if (std == V4L2_STD_NTSC_M_JP) {
+			if (std == V4L2_STD_NTSC_M_JP) {
 			/* Japan uses EIAJ audio standard */
 			cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
 		} else if (std == V4L2_STD_NTSC_M_KR) {

is a whitespace-only change which introduces a bogus tab and messes up 
the indentation of that opening if-statement.  It should probably be 
removed from the patch.  Other than that, you have my ack:

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
