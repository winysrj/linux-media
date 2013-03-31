Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5267 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3CaLQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 07:16:48 -0400
Date: Sun, 31 Mar 2013 13:16:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH v2] [media] m920x: Fix uninitialized variable warning
Message-ID: <20130331131637.2775920f@endymion.delvare>
In-Reply-To: <20130331121226.0b0e9e26@endymion.delvare>
References: <20130331121226.0b0e9e26@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/m920x.c:91:6: warning: "ret" may be used uninitialized in this function [-Wuninitialized]
drivers/media/usb/dvb-usb/m920x.c:70:6: note: "ret" was declared here

This is real, if a remote control has an empty initialization sequence
we would get success or failure randomly.

OTOH the initialization of ret in m920x_init is needless, the function
returns with an error as soon as an error happens, so the last return
can only be a success and we can hard-code 0 there.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>
---
An even better and simpler fix, avoids a useless initialization in most
cases and is more consistent. And this is what gcc optimizes the code
to anyway.

 drivers/media/usb/dvb-usb/m920x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-3.9-rc4.orig/drivers/media/usb/dvb-usb/m920x.c	2013-03-31 12:03:26.473890149 +0200
+++ linux-3.9-rc4/drivers/media/usb/dvb-usb/m920x.c	2013-03-31 13:11:59.973117266 +0200
@@ -76,12 +76,12 @@ static inline int m920x_write_seq(struct
 		seq++;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 {
-	int ret = 0, i, epi, flags = 0;
+	int ret, i, epi, flags = 0;
 	int adap_enabled[M9206_MAX_ADAPTERS] = { 0 };
 
 	/* Remote controller init. */
@@ -124,7 +124,7 @@ static int m920x_init(struct dvb_usb_dev
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int m920x_init_ep(struct usb_interface *intf)

-- 
Jean Delvare
