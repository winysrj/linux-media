Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46054 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2GXOwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 10:52:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RESEND] ov9640: fix missing break
To: linux-media@vger.kernel.org, akpm@linux-foundation.org
Date: Tue, 24 Jul 2012 16:50:49 +0100
Message-ID: <20120724155032.4082.19950.stgit@bluebook>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Without this rev2 ends up behaving as rev3

Reported-by: dcb314@hotmail.com
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44081
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/ov9640.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 23412de..9ed4ba4 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -605,6 +605,7 @@ static int ov9640_video_probe(struct i2c_client *client)
 		devname		= "ov9640";
 		priv->model	= V4L2_IDENT_OV9640;
 		priv->revision	= 2;
+		break;
 	case OV9640_V3:
 		devname		= "ov9640";
 		priv->model	= V4L2_IDENT_OV9640;

