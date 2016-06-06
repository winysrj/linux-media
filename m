Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56860 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcFFHVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 03:21:08 -0400
Date: Mon, 6 Jun 2016 09:21:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com,
	sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] userspace API definitions for auto-focus coil
Message-ID: <20160606072103.GA7445@amd>
References: <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
 <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
 <20160605190716.GA11321@amd>
 <575512E5.5030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <575512E5.5030000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> On  5.06.2016 22:07, Pavel Machek wrote:
> >Add userspace API definitions.
> >
> >Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >
> >diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> >index b6a357a..23011cc 100644
> >--- a/include/uapi/linux/v4l2-controls.h
> >+++ b/include/uapi/linux/v4l2-controls.h
> >@@ -974,4 +975,9 @@ enum v4l2_detect_md_mode {
> >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
> >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
> >
> >+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> >+#define V4L2_CID_FOCUS_AD5820_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> >+#define V4L2_CID_FOCUS_AD5820_RAMP_TIME	(V4L2_CID_FOCUS_AD5820_BASE+0)
> >+#define V4L2_CID_FOCUS_AD5820_RAMP_MODE	(V4L2_CID_FOCUS_AD5820_BASE+1)
> >+
> >  #endif
> >
> 
> Sakari, what about adding those as standard camera controls? It seems ad5820
> is not the only VCM driver to implement "antiringing" controls, http://rohmfs.rohm.com/en/products/databook/datasheet/ic/motor/mobile_module/bu64241gwz-e.pdf
> is another example I found by quick search.

Well, standartized API may be good idea... but I'd really like the
driver to go in, and it looks like camera application needs to know
quite a lot of details about the autofocus subsystem. 

> 
> What about:
> 
> #define V4L2_CID_FOCUS_STEP_MODE xxx
> enum v4l2_cid_focus_step_mode {
> V4L2_CID_FOCUS_STEP_MODE_DIRECT,
> V4L2_CID_FOCUS_STEP_MODE_LINEAR,
> V4L2_CID_FOCUS_STEP_MODE_AUTO
> };
> #define V4L2_CID_FOCUS_STEP_TIME xxx+1
> 
> Also, how the userspace(or the kernel) is notified by v4l that there is an
> event? The point is - I think it is a good idea to notify when VCM has
> completed its movement, we can start a timer based on the current
> position,

Why? Look at how fcam-dev/ works. It is not interested when movement
is "done". It sets the focus to one distance, then says it to slowly
refocus to another distance, and watches the stream for
sharpness. When it is sharp, it computes likely lens position at the
time of sharpness, and asks hardware to go back there.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
