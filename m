Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33459 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbdBHNNM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 08:13:12 -0500
Subject: [PATCH v2] staging: davinci_vpfe: fix multiline comment style
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com
References: <31df68a2-87f4-a7ad-d7c6-2f481b3b6d42@gmail.com>
 <20170208125756.GB27478@kroah.com>
Cc: aryasaatvik@gmail.com, devel@driverdev.osuosl.org,
        janani.rvchndrn@gmail.com, arnd@arndb.de, thaissa.falbo@gmail.com,
        linux-kernel@vger.kernel.org, gnudevliz@gmail.com,
        linux-media@vger.kernel.org
From: Avraham Shukron <avraham.shukron@gmail.com>
In-Reply-To: <20170208125756.GB27478@kroah.com>
Message-ID: <92502a0b-afe7-12eb-026c-fbbcd7dd528c@gmail.com>
Date: Wed, 8 Feb 2017 15:11:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aligned asterisks in multi-line comment.

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>

---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 5fbc2d4..857b0e8 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1133,9 +1133,9 @@ void vpfe_resizer_buffer_isr(struct vpfe_resizer_device *resizer)
                }
        } else if (fid == 0) {
                /*
-               * out of sync. Recover from any hardware out-of-sync.
-               * May loose one frame
-               */
+                * out of sync. Recover from any hardware out-of-sync.
+                * May loose one frame
+                */
                video_out->field_id = fid;
        }
 }
-- 
2.7.4
