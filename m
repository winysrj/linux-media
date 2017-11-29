Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50476 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdK2TIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:48 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 21/22] media: docs: add documentation for frontend attach info
Date: Wed, 29 Nov 2017 14:08:39 -0500
Message-Id: <6d1a568ee7eb73aff2953ec20a793b9234dbcd5a.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add to the media book the attachment kAPI for the DVB
frontend drivers that have already some kernel-doc markup.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/frontends.rst | 30 +++++++++++++++++++++++++++
 Documentation/media/dvb-drivers/index.rst     |  1 +
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/media/dvb-drivers/frontends.rst

diff --git a/Documentation/media/dvb-drivers/frontends.rst b/Documentation/media/dvb-drivers/frontends.rst
new file mode 100644
index 000000000000..1f5f57989196
--- /dev/null
+++ b/Documentation/media/dvb-drivers/frontends.rst
@@ -0,0 +1,30 @@
+****************
+Frontend drivers
+****************
+
+Frontend attach headers
+***********************
+
+.. Keep it on alphabetic order
+
+.. kernel-doc:: drivers/media/dvb-frontends/a8293.h
+.. kernel-doc:: drivers/media/dvb-frontends/af9013.h
+.. kernel-doc:: drivers/media/dvb-frontends/ascot2e.h
+.. kernel-doc:: drivers/media/dvb-frontends/cxd2820r.h
+.. kernel-doc:: drivers/media/dvb-frontends/drxk.h
+.. kernel-doc:: drivers/media/dvb-frontends/dvb-pll.h
+.. kernel-doc:: drivers/media/dvb-frontends/helene.h
+.. kernel-doc:: drivers/media/dvb-frontends/horus3a.h
+.. kernel-doc:: drivers/media/dvb-frontends/ix2505v.h
+.. kernel-doc:: drivers/media/dvb-frontends/m88ds3103.h
+.. kernel-doc:: drivers/media/dvb-frontends/mb86a20s.h
+.. kernel-doc:: drivers/media/dvb-frontends/mn88472.h
+.. kernel-doc:: drivers/media/dvb-frontends/rtl2830.h
+.. kernel-doc:: drivers/media/dvb-frontends/rtl2832.h
+.. kernel-doc:: drivers/media/dvb-frontends/rtl2832_sdr.h
+.. kernel-doc:: drivers/media/dvb-frontends/stb6000.h
+.. kernel-doc:: drivers/media/dvb-frontends/tda10071.h
+.. kernel-doc:: drivers/media/dvb-frontends/tda826x.h
+.. kernel-doc:: drivers/media/dvb-frontends/zd1301_demod.h
+.. kernel-doc:: drivers/media/dvb-frontends/zl10036.h
+
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 376141143ae9..314e127d82e3 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -41,4 +41,5 @@ For more details see the file COPYING in the source distribution of Linux.
 	technisat
 	ttusb-dec
 	udev
+	frontends
 	contributors
-- 
2.14.3
