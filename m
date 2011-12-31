Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1LaH5B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 02:57:01 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH for 3.2 URGENT] gspca: Fix falling back to lower isoc alt settings
Date: Sat, 31 Dec 2011 08:58:00 +0100
Message-Id: <1325318280-13222-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1325318280-13222-1-git-send-email-hdegoede@redhat.com>
References: <1325318280-13222-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current gspca core code has a regression where it no longer properly
falls back to lower alt settings when there is not enough bandwidth.

This causes many iso based usb-1 cameras to not work when plugged
into a usb2 hub or a sandybridge chipset motherboard!

This patch fixes this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

