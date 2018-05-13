Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:46831 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751217AbeEMJrr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:47:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/4] v4l2-ioctl: clear fields in s_parm
Date: Sun, 13 May 2018 11:47:40 +0200
Message-Id: <20180513094741.25096-4-hverkuil@xs4all.nl>
In-Reply-To: <20180513094741.25096-1-hverkuil@xs4all.nl>
References: <20180513094741.25096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Zero the reserved capture/output array.

Zero the extendedmode (it is never used in drivers).

Clear all flags in capture/outputmode except for V4L2_MODE_HIGHQUALITY,
as that is the only valid flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index a40dbec271f1..212aac1d22c1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1952,7 +1952,22 @@ static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_streamparm *p = arg;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_s_parm(file, fh, p);
+	if (ret)
+		return ret;
+
+	/* Note: extendedmode is never used in drivers */
+	if (V4L2_TYPE_IS_OUTPUT(p->type)) {
+		memset(p->parm.output.reserved, 0,
+		       sizeof(p->parm.output.reserved));
+		p->parm.output.extendedmode = 0;
+		p->parm.output.outputmode &= V4L2_MODE_HIGHQUALITY;
+	} else {
+		memset(p->parm.capture.reserved, 0,
+		       sizeof(p->parm.capture.reserved));
+		p->parm.capture.extendedmode = 0;
+		p->parm.capture.capturemode &= V4L2_MODE_HIGHQUALITY;
+	}
+	return ops->vidioc_s_parm(file, fh, p);
 }
 
 static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
-- 
2.17.0
