Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcFLHyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 03:54:22 -0400
Date: Sun, 12 Jun 2016 09:54:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] userspace API definitions for auto-focus coil
Message-ID: <20160612075416.GA1160@amd>
References: <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
 <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
 <20160605190716.GA11321@amd>
 <575512E5.5030000@gmail.com>
 <20160611220654.GC26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160611220654.GC26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > >@@ -974,4 +975,9 @@ enum v4l2_detect_md_mode {
> > >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
> > >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
> > >
> > >+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> > >+#define V4L2_CID_FOCUS_AD5820_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> 
> Please check V4L2_CID_USER_*_BASE. That's how custom controls are handled
> nowadays.

Let me see...

> Now that I think about this, the original implementation in N900 very likely
> did not use either of the two controls; the device driver was still written
> to provide access to full capabilities of the chip. And that one had no
> continuous AF.

I'm not sure about the original implementation, but fcam-dev library
(which is our best chance for usable camera) does use both:

pavel@duo:~/g/fcam-dev$ grep -ri RAMP_TIME .
./.svn/pristine/05/0574680922f59e07bd49e16a951d69421690a323.svn-base:
int val = ioctlSet(V4L2_CID_FOCUS_AD5820_RAMP_TIME,
1000000.0f/diopterRateToTickRate(speed));
./src/N900/Lens.cpp:    int val =
ioctlSet(V4L2_CID_FOCUS_AD5820_RAMP_TIME,
1000000.0f/diopterRateToTickRate(speed));
pavel@duo:~/g/fcam-dev$ grep -ri RAMP_MODE .
./.svn/pristine/05/0574680922f59e07bd49e16a951d69421690a323.svn-base:
ioctlSet(V4L2_CID_FOCUS_AD5820_RAMP_MODE, 0);
./src/N900/Lens.cpp:    ioctlSet(V4L2_CID_FOCUS_AD5820_RAMP_MODE, 0);
pavel@duo:~/g/fcam-dev$

> I might as well drop the two controls, up to you. If someone ever needs them
> they can always be reintroduced. I'd be happy to get a new patch, the
> current driver patch does not compile (just tried) as the definitions of
> these controls are missing.

I'd prefer to keep the controls, as we have userspace using them. I
got it to compile but have yet to get it to work (subdevs split, so it
needs some modifications).

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
