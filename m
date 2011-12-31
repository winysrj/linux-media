Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab1LaNcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 08:32:09 -0500
Message-ID: <4EFF0ED3.6050107@redhat.com>
Date: Sat, 31 Dec 2011 11:32:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for 3.2 URGENT] gspca: Fix falling back to lower isoc alt
 settings
References: <1325318280-13222-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1325318280-13222-2-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current gspca core code has a regression where it no longer properly
falls back to lower alt settings when there is not enough bandwidth.

This causes many iso based usb-1 cameras to not work when plugged
into a usb2 hub or a sandybridge chipset motherboard!

This patch fixes this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/gspca/gspca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 7fb90ae..c27dc09 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -988,7 +988,7 @@ retry:
 				ret = -EIO;
 				goto out;
 			}
-			alt = ep_tb[--alt_idx].alt;
+			gspca_dev->alt = ep_tb[--alt_idx].alt;
 		}
 	}
 out:
-- 
1.7.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
