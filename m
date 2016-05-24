Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34177 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbcEXPG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:06:26 -0400
Received: by mail-pf0-f182.google.com with SMTP id y69so7843787pfb.1
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 08:06:25 -0700 (PDT)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	ricardo.ribalda@gmail.com, p.zabel@pengutronix.de,
	wuchengli@chromium.org, shuahkh@osg.samsung.com,
	hans.verkuil@cisco.com, renesas@ideasonboard.com,
	guennadi.liakhovetski@intel.com, sakari.ailus@linux.intel.com,
	posciak@chromium.org, djkurtz@chromium.org,
	tiffany.lin@mediatek.com, pc.chen@mediatek.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] v4l2-ioctl: add VP9 format description.
Date: Tue, 24 May 2016 23:05:22 +0800
Message-Id: <1464102324-53965-3-git-send-email-wuchengli@chromium.org>
In-Reply-To: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
References: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VP9 is a video coding format and a successor to VP8.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 28e5be2..8f3e631 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1264,6 +1264,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
+		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
-- 
2.8.0.rc3.226.g39d4020

