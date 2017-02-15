Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34537 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdBORzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 12:55:43 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/6] [media] ivtv: improve subscribe_event handling
Date: Wed, 15 Feb 2017 15:55:29 -0200
Message-Id: <20170215175533.6384-2-gustavo@padovan.org>
In-Reply-To: <20170215175533.6384-1-gustavo@padovan.org>
References: <20170215175533.6384-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Simplify logic and call v4l2_ctrl_subscribe_event() directly instead
of copying its content over to ivtv_subscribe_event().

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index f956188..670462d 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1506,10 +1506,8 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, const struct v4l2_event_subs
 	case V4L2_EVENT_VSYNC:
 	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
-	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
 	default:
-		return -EINVAL;
+		return v4l2_ctrl_subscribe_event(fh, sub);
 	}
 }
 
-- 
2.9.3
