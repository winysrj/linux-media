Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52712 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbaFTBx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 21:53:27 -0400
Date: Thu, 19 Jun 2014 21:53:21 -0400
From: Anthony DeStefano <adx@fastmail.fm>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] staging: solo6x10: fix for sparse warning message
Message-ID: <20140620015302.GA1543@pluto-arch.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define jpeg_dqt as static.

Signed-off-by: Anthony DeStefano <adx@fastmail.fm>
---
 drivers/staging/media/solo6x10/solo6x10-jpeg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
index c5218ce..9e41185 100644
--- a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
+++ b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
@@ -110,7 +110,7 @@ static const unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of the DQT */
 #define DQT_START	17
 #define DQT_LEN		138
-const unsigned char jpeg_dqt[4][DQT_LEN] = {
+static const unsigned char jpeg_dqt[4][DQT_LEN] = {
 	{
 		0xff, 0xdb, 0x00, 0x43, 0x00,
 		0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
-- 
2.0.0

