Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60699 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbcFLIsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 04:48:16 -0400
Date: Sun, 12 Jun 2016 10:48:11 +0200
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
Message-ID: <20160612084811.GA27446@amd>
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

> > >Add userspace API definitions.
> > >
> > >Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >
> > >diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > >index b6a357a..23011cc 100644
> > >--- a/include/uapi/linux/v4l2-controls.h
> > >+++ b/include/uapi/linux/v4l2-controls.h
> > >@@ -974,4 +975,9 @@ enum v4l2_detect_md_mode {
> > >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
> > >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
> > >
> > >+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> > >+#define V4L2_CID_FOCUS_AD5820_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> 
> Please check V4L2_CID_USER_*_BASE. That's how custom controls are handled
> nowadays.

So something like this?

Thanks,
									Pavel

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 2efa5dc1..b04b471 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -40,6 +40,11 @@
 #define AD5820_RAMP_MODE_LINEAR		(0 << 3)
 #define AD5820_RAMP_MODE_64_16		(1 << 3)
 
+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
+#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_USER_AD5820_BASE+0)
+#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
+
+
 #define CODE_TO_RAMP_US(s)	((s) == 0 ? 0 : (1 << ((s) - 1)) * 50)
 #define RAMP_US_TO_CODE(c)	fls(((c) + ((c)>>1)) / 50)
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 23011cc..4b24546 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -181,6 +181,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
 
+/* The base for the ad5820 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_AD5820_BASE		(V4L2_CID_USER_BASE + 0x1090)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
@@ -986,9 +990,4 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_MODE_SENSITIVITY		(V4L2_CID_MODE_CLASS_BASE+6)
 #define V4L2_CID_MODE_OPSYSCLOCK		(V4L2_CID_MODE_CLASS_BASE+7)
 
-/* Control IDs specific to the AD5820 driver as defined by V4L2 */
-#define V4L2_CID_FOCUS_AD5820_BASE 		(V4L2_CTRL_CLASS_CAMERA | 0x10af)
-#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_FOCUS_AD5820_BASE+0)
-#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
-
 #endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
