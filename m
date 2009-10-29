Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46196 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbZJ2Nyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 09:54:54 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"'Mauro Carvalho Chehab'" <mchehab@infradead.org>
Date: Thu, 29 Oct 2009 08:54:50 -0500
Subject: RE: [PATCH V2] Davinci VPFE Capture: Add support for Control ioctls
Message-ID: <A69FA2915331DC488A831521EAE36FE40155714F14@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1256799064-25031-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1256799064-25031-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by Muralidharan Karicheri <m-karicheri2@ti.com>

Mauro, could you please merge this to your v4l-dvb tree?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of hvaibhav@ti.com
>Sent: Thursday, October 29, 2009 2:51 AM
>To: linux-media@vger.kernel.org
>Cc: Hiremath, Vaibhav
>Subject: [PATCH V2] Davinci VPFE Capture: Add support for Control ioctls
>
>From: Vaibhav Hiremath <hvaibhav@ti.com>
>
>Added support for Control IOCTL,
>	- s_ctrl
>	- g_ctrl
>	- queryctrl
>
>Change from last patch:
>	- added room for error return in queryctrl function.
>
>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>---
> drivers/media/video/davinci/vpfe_capture.c |   43
>++++++++++++++++++++++++++++
> 1 files changed, 43 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>b/drivers/media/video/davinci/vpfe_capture.c
>index abe21e4..8275d02 100644
>--- a/drivers/media/video/davinci/vpfe_capture.c
>+++ b/drivers/media/video/davinci/vpfe_capture.c
>@@ -1368,6 +1368,46 @@ static int vpfe_g_std(struct file *file, void *priv,
>v4l2_std_id *std_id)
> 	return 0;
> }
>
>+static int vpfe_queryctrl(struct file *file, void *priv,
>+		struct v4l2_queryctrl *qctrl)
>+{
>+	struct vpfe_device *vpfe_dev = video_drvdata(file);
>+	struct vpfe_subdev_info *sdinfo;
>+	int ret = 0;
>+
>+	sdinfo = vpfe_dev->current_subdev;
>+
>+	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
>+					 core, queryctrl, qctrl);
>+
>+	if (ret)
>+		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
>+
>+	return ret;
>+}
>+
>+static int vpfe_g_ctrl(struct file *file, void *priv, struct v4l2_control
>*ctrl)
>+{
>+	struct vpfe_device *vpfe_dev = video_drvdata(file);
>+	struct vpfe_subdev_info *sdinfo;
>+
>+	sdinfo = vpfe_dev->current_subdev;
>+
>+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
>+					 core, g_ctrl, ctrl);
>+}
>+
>+static int vpfe_s_ctrl(struct file *file, void *priv, struct v4l2_control
>*ctrl)
>+{
>+	struct vpfe_device *vpfe_dev = video_drvdata(file);
>+	struct vpfe_subdev_info *sdinfo;
>+
>+	sdinfo = vpfe_dev->current_subdev;
>+
>+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
>+					 core, s_ctrl, ctrl);
>+}
>+
> /*
>  *  Videobuf operations
>  */
>@@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
> 	.vidioc_querystd	 = vpfe_querystd,
> 	.vidioc_s_std		 = vpfe_s_std,
> 	.vidioc_g_std		 = vpfe_g_std,
>+	.vidioc_queryctrl	 = vpfe_queryctrl,
>+	.vidioc_g_ctrl		 = vpfe_g_ctrl,
>+	.vidioc_s_ctrl		 = vpfe_s_ctrl,
> 	.vidioc_reqbufs		 = vpfe_reqbufs,
> 	.vidioc_querybuf	 = vpfe_querybuf,
> 	.vidioc_qbuf		 = vpfe_qbuf,
>--
>1.6.2.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

