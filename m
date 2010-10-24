Return-path: <mchehab@pedra>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:60148 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab0JXQd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 12:33:59 -0400
Date: Sun, 24 Oct 2010 18:31:43 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media/video/gspca: fix error check
Message-ID: <20101024183143.6b38d977@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It looks to me like it was intended to check the return value
at this point.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/media/video/gspca/cpia1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/cpia1.c b/drivers/media/video/gspca/cpia1.c
index 9b12168..58325db 100644
--- a/drivers/media/video/gspca/cpia1.c
+++ b/drivers/media/video/gspca/cpia1.c
@@ -829,7 +829,7 @@ static int goto_low_power(struct gspca_dev *gspca_dev)
 	if (ret)
 		return ret;
 
-	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
+	ret = do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 	if (ret)
 		return ret;
 
-- 
1.7.2.2
