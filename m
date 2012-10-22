Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:51196 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2JVIRk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 04:17:40 -0400
Message-ID: <50850116.9060806@schinagl.nl>
Date: Mon, 22 Oct 2012 10:17:26 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Add chipid to fc2580.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index aff39ae..102d942 100644
I found a fellow Asus U3100+ user (mentioned him before with the 
firmware issue) that even when using the latest firmware, still see's 
0xff as the chipID.


--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -497,6 +497,7 @@ struct dvb_frontend *fc2580_attach(struct 
dvb_frontend *fe,
         switch (chip_id) {
         case 0x56:
         case 0x5a:
+       case 0xff:
                 break;
         default:
                 goto err;

