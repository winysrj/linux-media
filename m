Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:47286 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbdJTVuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:32 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 03/17] [media] v4l: use v4l2_subscribe_event_v4l2() on drivers
Date: Fri, 20 Oct 2017 19:49:58 -0200
Message-Id: <20171020215012.20646-4-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Driver that implement their own .vidioc_subscribe_event function should
be using v4l2_subscribe_event_v4l2() instead of
v4l2_ctrl_subscribe_event().

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                | 2 +-
 drivers/media/pci/tw5864/tw5864-video.c            | 2 +-
 drivers/media/platform/coda/coda-common.c          | 2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 2 +-
 drivers/media/platform/qcom/venus/vdec.c           | 4 +---
 drivers/media/platform/rcar-vin/rcar-v4l2.c        | 2 +-
 drivers/media/platform/vivid/vivid-vid-out.c       | 2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             | 2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 2 +-
 10 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index def4a3b37084..7b79daa09416 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1071,7 +1071,7 @@ static int cobalt_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_event_subscribe(fh, sub, 4, NULL);
 	}
-	return v4l2_ctrl_subscribe_event(fh, sub);
+	return v4l2_subscribe_event_v4l2(fh, sub);
 }
 
 static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 670462d195b5..4d76a433fcf3 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1507,7 +1507,7 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, const struct v4l2_event_subs
 	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index e7bd2b8484e3..67fa883bed3c 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -671,7 +671,7 @@ static int tw5864_subscribe_event(struct v4l2_fh *fh,
 		 */
 		return v4l2_event_subscribe(fh, sub, 30, NULL);
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15eb5dc4dff9..897c6939ab0f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1085,7 +1085,7 @@ static int coda_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 843510979ad8..a9f80db14b47 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -629,7 +629,7 @@ static int vidioc_vdec_subscribe_evt(struct v4l2_fh *fh,
 	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_src_change_event_subscribe(fh, sub);
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index da611a5eb670..ccf9b778dcf9 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -459,10 +459,8 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 		return v4l2_event_subscribe(fh, sub, 2, NULL);
 	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_src_change_event_subscribe(fh, sub);
-	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subscribe_event(fh, sub);
 	default:
-		return -EINVAL;
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index dd37ea811680..153622e0d42f 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -542,7 +542,7 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_event_subscribe(fh, sub, 4, NULL);
 	}
-	return v4l2_ctrl_subscribe_event(fh, sub);
+	return v4l2_subscribe_event_v4l2(fh, sub);
 }
 
 static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 0b1b6218ede8..f420e9c9d1f6 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1183,7 +1183,7 @@ int vidioc_subscribe_event(struct v4l2_fh *fh,
 			return v4l2_src_change_event_subscribe(fh, sub);
 		break;
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 	return -EINVAL;
 }
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 98cd57eaf36a..a0343a4b4dbc 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -797,7 +797,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 		 * stored. */
 		return v4l2_event_subscribe(fh, sub, 30, NULL);
 	default:
-		return v4l2_ctrl_subscribe_event(fh, sub);
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..943c6bb5548b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1240,7 +1240,7 @@ static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_CTRL:
 		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
 	default:
-		return -EINVAL;
+		return v4l2_subscribe_event_v4l2(fh, sub);
 	}
 }
 
-- 
2.13.6
