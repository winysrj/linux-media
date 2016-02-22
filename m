Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbcBVTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 7/9] [media] av7110: remove a bogus smatch warning
Date: Mon, 22 Feb 2016 16:09:21 -0300
Message-Id: <511a46afa33c8dfaf755fb4e4c03ae6f31215034.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove this bogus smatch warning:
	drivers/media/pci/ttpci/av7110.c:2211 frontend_init() warn: missing break? reassigning 'av7110->fe'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/ttpci/av7110.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 18d229fa65cf..382caf200ba1 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2198,13 +2198,18 @@ static int frontend_init(struct av7110 *av7110)
 			break;
 
 		case 0x0001: // Hauppauge/TT Nexus-T premium rev1.X
+		{
+			struct dvb_frontend *fe;
+
 			// try ALPS TDLB7 first, then Grundig 29504-401
-			av7110->fe = dvb_attach(sp8870_attach, &alps_tdlb7_config, &av7110->i2c_adap);
-			if (av7110->fe) {
-				av7110->fe->ops.tuner_ops.set_params = alps_tdlb7_tuner_set_params;
+			fe = dvb_attach(sp8870_attach, &alps_tdlb7_config, &av7110->i2c_adap);
+			if (fe) {
+				fe->ops.tuner_ops.set_params = alps_tdlb7_tuner_set_params;
+				av7110->fe = fe;
 				break;
 			}
-			/* fall-thru */
+		}
+		/* fall-thru */
 
 		case 0x0008: // Hauppauge/TT DVB-T
 			// Grundig 29504-401
-- 
2.5.0

