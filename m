Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364AbbD1Po0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/14] ngene: preventing dereferencing a NULL pointer
Date: Tue, 28 Apr 2015 12:43:43 -0300
Message-Id: <535fa114dd2139755ccabe44087bef1a220e8169.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/ngene/ngene-core.c:1529 init_channel() error: we previously assumed 'chan->fe' could be null (see line 1521)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index e29bc3af4baf..1b92d836a564 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1526,10 +1526,12 @@ static int init_channel(struct ngene_channel *chan)
 	if (chan->fe2) {
 		if (dvb_register_frontend(adapter, chan->fe2) < 0)
 			goto err;
-		chan->fe2->tuner_priv = chan->fe->tuner_priv;
-		memcpy(&chan->fe2->ops.tuner_ops,
-		       &chan->fe->ops.tuner_ops,
-		       sizeof(struct dvb_tuner_ops));
+		if (chan->fe) {
+			chan->fe2->tuner_priv = chan->fe->tuner_priv;
+			memcpy(&chan->fe2->ops.tuner_ops,
+			       &chan->fe->ops.tuner_ops,
+			       sizeof(struct dvb_tuner_ops));
+		}
 	}
 
 	if (chan->has_demux) {
-- 
2.1.0

