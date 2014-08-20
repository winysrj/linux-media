Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4738 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/29] bcm3510: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:20 +0200
Message-Id: <1408575568-20562-22-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/bcm3510.c:646:24: warning: cast to restricted __le16
drivers/media/dvb-frontends/bcm3510.c:647:24: warning: cast to restricted __le16

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/bcm3510.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 39a29dd..998d150 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -643,8 +643,8 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 
 	b = fw->data;
 	for (i = 0; i < fw->size;) {
-		addr = le16_to_cpu( *( (u16 *)&b[i] ) );
-		len  = le16_to_cpu( *( (u16 *)&b[i+2] ) );
+		addr = le16_to_cpu(*((__le16 *)&b[i]));
+		len  = le16_to_cpu(*((__le16 *)&b[i+2]));
 		deb_info("firmware chunk, addr: 0x%04x, len: 0x%04x, total length: 0x%04zx\n",addr,len,fw->size);
 		if ((ret = bcm3510_write_ram(st,addr,&b[i+4],len)) < 0) {
 			err("firmware download failed: %d\n",ret);
-- 
2.1.0.rc1

