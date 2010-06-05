Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f223.google.com ([209.85.219.223]:36079 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab0FEMGP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jun 2010 08:06:15 -0400
Received: by ewy23 with SMTP id 23so15329ewy.1
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 05:06:13 -0700 (PDT)
Date: Sat, 5 Jun 2010 14:05:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Abylay Ospan <aospan@netup.ru>,
	Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: [patch] V4L/DVB: cx23885: reversed condition in dvb_register()
Message-ID: <20100605120529.GK5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_dvb_register_bus() returns negative error codes on failure.  This
was introduced in e4425eab6b2: "V4L/DVB: cx23885: Check register errors".

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have the hardware to test this, but it looks reversed.

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 0a199d7..bf7c328 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -991,7 +991,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
 					&dev->pci->dev, adapter_nr, 0,
 					cx23885_dvb_fe_ioctl_override);
-	if (!ret)
+	if (ret < 0)
 		return ret;
 
 	/* init CI & MAC */
