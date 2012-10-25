Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53806 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab2JYOh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 10:37:56 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q9PF9tSj006921
	for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 16:10:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] v4l2: sn9c102 incorrectly blocks FMT_SN9C10X
To: linux-media@vger.kernel.org
Date: Thu, 25 Oct 2012 15:39:33 +0100
Message-ID: <20121025143921.17364.86233.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Missing break

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/usb/sn9c102/sn9c102_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
index 5bfc8e2..7360586 100644
--- a/drivers/media/usb/sn9c102/sn9c102_core.c
+++ b/drivers/media/usb/sn9c102/sn9c102_core.c
@@ -2481,11 +2481,13 @@ sn9c102_vidioc_enum_framesizes(struct sn9c102_device* cam, void __user * arg)
 		if (frmsize.pixel_format != V4L2_PIX_FMT_SN9C10X &&
 		    frmsize.pixel_format != V4L2_PIX_FMT_SBGGR8)
 			return -EINVAL;
+		break;
 	case BRIDGE_SN9C105:
 	case BRIDGE_SN9C120:
 		if (frmsize.pixel_format != V4L2_PIX_FMT_JPEG &&
 		    frmsize.pixel_format != V4L2_PIX_FMT_SBGGR8)
 			return -EINVAL;
+		break;
 	}
 
 	frmsize.type = V4L2_FRMSIZE_TYPE_STEPWISE;

