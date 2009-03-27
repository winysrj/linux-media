Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112AbZC0BEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 21:04:55 -0400
Received: from 200.220.139.66.nipcable.com ([200.220.139.66] helo=pedra.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Ln0VB-000645-Rc
	for linux-media@vger.kernel.org; Fri, 27 Mar 2009 01:04:54 +0000
Date: Thu, 26 Mar 2009 22:04:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] firedtv: wrong types in printk
Message-ID: <20090326220449.7ad106be@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Forwarded message:

Date: Thu, 26 Mar 2009 21:41:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] firedtv: wrong types in printk


size_t is not int...

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/dvb/firewire/firedtv-avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index b55d9cc..424ed5d 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -150,7 +150,7 @@ static void debug_fcp(const u8 *data, size_t length)
 		subunit_type = data[1] >> 3;
 		subunit_id = data[1] & 7;
 		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
-		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
+		printk(KERN_INFO "%ssu=%x.%x l=%Zd: %-8s - %s\n",
 		       prefix, subunit_type, subunit_id, length,
 		       debug_fcp_ctype(data[0]),
 		       debug_fcp_opcode(op, data, length));





Cheers,
Mauro
