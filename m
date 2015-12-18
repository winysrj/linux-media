Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbbLRQ0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 11:26:42 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] [media] cx23885-dvb: move initialization of a8293_pdata
Date: Fri, 18 Dec 2015 14:26:17 -0200
Message-Id: <0df11a53b7100d93643483e9fcfaf4eb69b492a5.1450455971.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains about where the au8293_data is placed:

drivers/media/pci/cx23885/cx23885-dvb.c:2174 dvb_register() info: 'a8293_pdata' is not actually initialized (unreached code).

It is not actually expected to have such initialization at

switch {
	foo = bar;

	case:
...
}

Not really sure how gcc does that, but this is something that I would
expect that different compilers would do different things.

So, move the initialization outside the switch(), making smatch to
shut up one warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index adabb0bc21ad..80319bb73d94 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2168,10 +2168,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		port->i2c_client_tuner = client_tuner;
 		break;
-	case CX23885_BOARD_HAUPPAUGE_HVR5525:
-		switch (port->nr) {
+	case CX23885_BOARD_HAUPPAUGE_HVR5525: {
 		struct m88rs6000t_config m88rs6000t_config;
-		struct a8293_platform_data a8293_pdata = { 0 };
+		struct a8293_platform_data a8293_pdata = {};
+
+		switch (port->nr) {
 
 		/* port b - satellite */
 		case 1:
@@ -2267,6 +2268,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	}
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
-- 
2.5.0

