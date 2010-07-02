Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0GBDiL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 23:38:11 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o623cAtn005974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:10 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o623c902015002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:10 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o623c9fC027509
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:09 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o623c9J6027507
	for linux-media@vger.kernel.org; Thu, 1 Jul 2010 23:38:09 -0400
Date: Thu, 1 Jul 2010 23:38:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 1/2] IR: add tx callbacks to ir-core
Message-ID: <20100702033809.GB27368@redhat.com>
References: <20100702033702.GA27368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702033702.GA27368@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: incoming IR buffer now an int pointer, and not fed from userspace.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 include/media/ir-core.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index ad1303f..513e60d 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -47,15 +47,21 @@ enum rc_driver_type {
  *	is opened.
  * @close: callback to allow drivers to disable polling/irq when IR input device
  *	is opened.
+ * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
+ * @s_tx_carrier: set transmit carrier frequency
+ * @tx_ir: transmit IR
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
 	unsigned long		allowed_protos;
 	u32			scanmask;
-	void 			*priv;
+	void			*priv;
 	int			(*change_protocol)(void *priv, u64 ir_type);
 	int			(*open)(void *priv);
 	void			(*close)(void *priv);
+	int			(*s_tx_mask)(void *priv, u32 mask);
+	int			(*s_tx_carrier)(void *priv, u32 carrier);
+	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
 };
 
 struct ir_input_dev {
-- 
1.7.0.1


-- 
Jarod Wilson
jarod@redhat.com

