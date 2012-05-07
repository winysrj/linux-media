Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2EGTUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 23/23] gspca_gl860: Add a present check to sd_stop0
Date: Mon,  7 May 2012 21:01:34 +0200
Message-Id: <1336417294-4566-24-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor specific dev_post_unset_alt functions all try to write to the
bridge, and none free any memory, so they should be skipped if stop0
is called on disconnection.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gl860/gl860.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/gspca/gl860/gl860.c b/drivers/media/video/gspca/gl860/gl860.c
index c84e260..c549574 100644
--- a/drivers/media/video/gspca/gl860/gl860.c
+++ b/drivers/media/video/gspca/gl860/gl860.c
@@ -405,6 +405,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	if (!sd->gspca_dev.present)
+		return;
+
 	return sd->dev_post_unset_alt(gspca_dev);
 }
 
-- 
1.7.10

