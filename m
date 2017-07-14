Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58476 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753486AbdGNKnG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 06:43:06 -0400
Date: Fri, 14 Jul 2017 13:43:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH v5 1/1] i2c: Add Omnivision OV5670 5M sensor support
Message-ID: <20170714104301.bbzd2xqgymhkwocr@valkosipuli.retiisi.org.uk>
References: <1497404348-16255-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <2b5e2ec73d2a5976a3c56dd35d90ca681f803ce0.1499996475.git.chiranjeevi.rapolu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b5e2ec73d2a5976a3c56dd35d90ca681f803ce0.1499996475.git.chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Thu, Jul 13, 2017 at 06:51:27PM -0700, Chiranjeevi Rapolu wrote:
> Provides single source pad with up to 2592x1944 pixels at 10-bit raw
> bayer format over MIPI CSI2 two lanes at 840Mbps/lane.
> The driver supports following features:
> - up to  30fps at 5M pixels
> - manual exposure
> - digital/analog gain
> - V-blank/H-blank
> - test pattern
> - media controller
> - runtime pm
> 
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>

Thanks, applied with the following change:

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 909095ac90a2..7de80645dd6f 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2060,7 +2060,8 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 						   &ov5670_ctrl_ops,
 						   V4L2_CID_LINK_FREQ,
 						   0, 0, link_freq_menu_items);
-	ov5670->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ov5670->link_freq)
+		ov5670->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* By default, V4L2_CID_PIXEL_RATE is read only */
 	ov5670->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops,

v4l2_ctrl_new_std() may return NULL, you always need to check for that if
you're using the returned result.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
