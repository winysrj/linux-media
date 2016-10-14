Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcJNRrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 15/25] [media] dvb-core: move dvb_filter out of the DVB core
Date: Fri, 14 Oct 2016 14:45:53 -0300
Message-Id: <cd32628310bbfe5254528ce1ff323148972696c6.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_filter.c can hardly be considered as part of the DVB
core. More than half of the code there is commented out by
av7110 and ttusb_dec.

On the latter, just two small helper functions and a struct
definition is used.

Being part of the core means that it would require an
amount of work to fix issues in it, like bad printk's
on it, and to document it on some future, like other kAPI
headers. It simply not worth the effort for something that
seems to be deprecated, as no new drivers use it.

So, move it out of the core, by moving it to pci/ttpci
directory, where av7110 driver is kept, and copy the two
routines used by ttyusb_dec directly into its code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/b2c2/flexcop-common.h         |  1 -
 drivers/media/dvb-core/Makefile                    |  2 +-
 drivers/media/pci/ttpci/Makefile                   |  2 +-
 drivers/media/{dvb-core => pci/ttpci}/dvb_filter.c |  3 --
 drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h |  0
 drivers/media/usb/ttusb-dec/ttusb_dec.c            | 58 +++++++++++++++++++++-
 6 files changed, 59 insertions(+), 7 deletions(-)
 rename drivers/media/{dvb-core => pci/ttpci}/dvb_filter.c (99%)
 rename drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h (100%)

diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
index 2b2460e9e6b4..2533574c0cf4 100644
--- a/drivers/media/common/b2c2/flexcop-common.h
+++ b/drivers/media/common/b2c2/flexcop-common.h
@@ -14,7 +14,6 @@
 
 #include "dmxdev.h"
 #include "dvb_demux.h"
-#include "dvb_filter.h"
 #include "dvb_net.h"
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index 8f22bcd7c1f9..281bc89576e6 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -4,7 +4,7 @@
 
 dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
 
-dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
+dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o		 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
 		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
 
diff --git a/drivers/media/pci/ttpci/Makefile b/drivers/media/pci/ttpci/Makefile
index 49f71b1eaf14..3cf617737f7c 100644
--- a/drivers/media/pci/ttpci/Makefile
+++ b/drivers/media/pci/ttpci/Makefile
@@ -3,7 +3,7 @@
 # and the AV7110 DVB device driver
 #
 
-dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o
+dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o dvb_filter.o
 
 ifdef CONFIG_DVB_AV7110_IR
 dvb-ttpci-objs += av7110_ir.o
diff --git a/drivers/media/dvb-core/dvb_filter.c b/drivers/media/pci/ttpci/dvb_filter.c
similarity index 99%
rename from drivers/media/dvb-core/dvb_filter.c
rename to drivers/media/pci/ttpci/dvb_filter.c
index 772003fb1821..6395812ed1f1 100644
--- a/drivers/media/dvb-core/dvb_filter.c
+++ b/drivers/media/pci/ttpci/dvb_filter.c
@@ -390,7 +390,6 @@ int dvb_filter_get_ac3info(u8 *mbuf, int count, struct dvb_audio_info *ai, int p
 
 	return 0;
 }
-EXPORT_SYMBOL(dvb_filter_get_ac3info);
 
 
 #if 0
@@ -565,7 +564,6 @@ void dvb_filter_pes2ts_init(struct dvb_filter_pes2ts *p2ts, unsigned short pid,
 	p2ts->cb=cb;
 	p2ts->priv=priv;
 }
-EXPORT_SYMBOL(dvb_filter_pes2ts_init);
 
 int dvb_filter_pes2ts(struct dvb_filter_pes2ts *p2ts, unsigned char *pes,
 		      int len, int payload_start)
@@ -600,4 +598,3 @@ int dvb_filter_pes2ts(struct dvb_filter_pes2ts *p2ts, unsigned char *pes,
 	memcpy(buf+5+rest, pes, len);
 	return p2ts->cb(p2ts->priv, buf);
 }
-EXPORT_SYMBOL(dvb_filter_pes2ts);
diff --git a/drivers/media/dvb-core/dvb_filter.h b/drivers/media/pci/ttpci/dvb_filter.h
similarity index 100%
rename from drivers/media/dvb-core/dvb_filter.h
rename to drivers/media/pci/ttpci/dvb_filter.h
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 4e7671a3a1e4..35d5003ff809 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -36,7 +36,6 @@
 
 #include "dmxdev.h"
 #include "dvb_demux.h"
-#include "dvb_filter.h"
 #include "dvb_frontend.h"
 #include "dvb_net.h"
 #include "ttusbdecfe.h"
@@ -92,6 +91,15 @@ enum ttusb_dec_interface {
 	TTUSB_DEC_INTERFACE_OUT
 };
 
+typedef int (dvb_filter_pes2ts_cb_t) (void *, unsigned char *);
+
+struct dvb_filter_pes2ts {
+	unsigned char buf[188];
+	unsigned char cc;
+	dvb_filter_pes2ts_cb_t *cb;
+	void *priv;
+};
+
 struct ttusb_dec {
 	enum ttusb_dec_model		model;
 	char				*model_name;
@@ -201,6 +209,54 @@ static u16 rc_keys[] = {
 	KEY_RADIO
 };
 
+static void dvb_filter_pes2ts_init(struct dvb_filter_pes2ts *p2ts,
+				   unsigned short pid,
+				   dvb_filter_pes2ts_cb_t *cb, void *priv)
+{
+	unsigned char *buf=p2ts->buf;
+
+	buf[0]=0x47;
+	buf[1]=(pid>>8);
+	buf[2]=pid&0xff;
+	p2ts->cc=0;
+	p2ts->cb=cb;
+	p2ts->priv=priv;
+}
+
+static int dvb_filter_pes2ts(struct dvb_filter_pes2ts *p2ts,
+			     unsigned char *pes, int len, int payload_start)
+{
+	unsigned char *buf=p2ts->buf;
+	int ret=0, rest;
+
+	//len=6+((pes[4]<<8)|pes[5]);
+
+	if (payload_start)
+		buf[1]|=0x40;
+	else
+		buf[1]&=~0x40;
+	while (len>=184) {
+		buf[3]=0x10|((p2ts->cc++)&0x0f);
+		memcpy(buf+4, pes, 184);
+		if ((ret=p2ts->cb(p2ts->priv, buf)))
+			return ret;
+		len-=184; pes+=184;
+		buf[1]&=~0x40;
+	}
+	if (!len)
+		return 0;
+	buf[3]=0x30|((p2ts->cc++)&0x0f);
+	rest=183-len;
+	if (rest) {
+		buf[5]=0x00;
+		if (rest-1)
+			memset(buf+6, 0xff, rest-1);
+	}
+	buf[4]=rest;
+	memcpy(buf+5+rest, pes, len);
+	return p2ts->cb(p2ts->priv, buf);
+}
+
 static void ttusb_dec_set_model(struct ttusb_dec *dec,
 				enum ttusb_dec_model model);
 
-- 
2.7.4


