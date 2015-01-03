Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbACUJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 15:09:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] cx231xx: create DVB graph
Date: Sat,  3 Jan 2015 18:09:39 -0200
Message-Id: <71a8f51828fe6fdeec3093b750328e0e413f53de.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx231xx is simple with regards to DVB: all boards have just one
DVB adapter. So, we can use the default DVB helper function to
create the DVB media graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 1c0d082fc4ef..3b37324c7613 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -538,6 +538,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	/* register network adapter */
 	dvb->net.mdev = dev->media_dev;
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
+	dvb_create_media_graph(dev->media_dev);
 	return 0;
 
 fail_fe_conn:
-- 
2.1.0

