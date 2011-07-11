Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:62356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab1GKB7n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:43 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xgwg023461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:42 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKZ030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:42 -0400
Date: Sun, 10 Jul 2011 22:58:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/21] [media] drxk: Avoid OOPSes if firmware is corrupted
Message-ID: <20110710225855.3d7534e8@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Don't read paste the buffer, if the firmware is corrupted.
Instead, print an error message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index c4b35a5..89db378 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1388,6 +1388,12 @@ static int DownloadMicrocode(struct drxk_state *state,
 		BlockCRC = (pSrc[0] << 8) | pSrc[1];
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
+
+		if (offset + BlockSize > Length) {
+			printk(KERN_ERR "drxk: Firmware is corrupted.\n");
+			return -EINVAL;
+		}
+
 		status = write_block(state, Address, BlockSize, pSrc);
 		if (status < 0)
 			break;
-- 
1.7.1


