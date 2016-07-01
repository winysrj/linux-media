Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43271 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcGATkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 15:40:14 -0400
Date: Fri, 1 Jul 2016 21:40:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	laurent.pinchart@ideasonboard.com
Cc: Sebastian Reichel <sre@kernel.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: square-only image on Nokia N900 camera -- pipeline setup in
 python (was Re: [RFC PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160701194010.GA30452@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
 <20160617171214.GA5830@amd>
 <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
 <20160701073146.GA21405@amd>
 <20160701085025.GA30653@amd>
 <20160701110154.GA26056@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160701110154.GA26056@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2016-07-01 13:01:54, Pavel Machek wrote:
> On Fri 2016-07-01 10:50:25, Pavel Machek wrote:
> > Hi!
> > 
> > > On gitlab is the latest version of pipeline setup if python. I also
> > > got fcam to work (slowly) on the camera, with autofocus and
> > > autogain. Capturing from preview modes works fine, but image quality
> > > is not good, as expected. Capturing raw GRBG10 images works, but
> > > images are square, with values being outside square being 0.
> > > 
> > > Same problem is there with yavta and fcam-dev capture, so I suspect
> > > there's something in kernel. If you have an idea what could be wrong /
> > > what to try, let me know. If omap3isp works for you in v4.6, and
> > > produces expected rectangular images, that would be useful to know,
> > > too.
> > > 
> > > Python capture script is at
> > > 
> > > https://gitlab.com/tui/tui/commit/266b6eb302dcf1481e3e90a05bf98180e5759168
> > 
> > I switched to the front camera (vs6555 pixel array 2-0010 + vs6555
> > binner 2-0010) and got same effect: preview image works fine, raw
> > image is square. Still kernel v4.6.
> 
> Same issue with kernel v4.7-rc5.

And this seems to fix it. Now image fills whole frame.

But I still can't get 5MP format to work, it fails with:

[  497.929016] check_format checking px 808534338 808534338, h 1968
1968, w 2592 2592, bpline 5184 5184, size 10202112 10202112 field 1 1
[  497.929107] configuring for 2592(5184)x1968
[  497.936248] stream on success
[  498.020233] omap3isp 480bc000.isp: CCDC won't become idle!
[  525.563476] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC


commit 5268a954cd6af4853ad8e05f32ff4741c245e65e
Author: Pavel <pavel@ucw.cz>
Date:   Fri Jul 1 21:34:35 2016 +0200

    This seems to fix stuff for me -- now square limitation of images is gone.

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 5c52ae8..0e052e6 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1185,7 +1185,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
 	 * histogram modules are still fed with lens shading corrected data.
 	 */
-	syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+//	syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+	syn_mode |= ISPCCDC_SYN_MODE_VP2SDR;
 
 	if (ccdc->output & CCDC_OUTPUT_MEMORY)
 		syn_mode |= ISPCCDC_SYN_MODE_WEN;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
