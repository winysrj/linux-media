Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbcGJPSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 11:18:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/3] [media] doc-rst: improve DTV_BANDWIDTH_HZ notes
Date: Sun, 10 Jul 2016 12:18:16 -0300
Message-Id: <fed7b888f69f70fc35c184677b2e8f59cb3945cb.1468163257.git.mchehab@s-opensource.com>
In-Reply-To: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
References: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
In-Reply-To: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
References: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several notes for this DTV property. Some are
outdated, so take some care of it, making it updated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/dvb/fe_property_parameters.rst      | 28 +++++++++++++---------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 1b0b1171602d..f776d62523da 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -219,23 +219,29 @@ Bandwidth for the channel, in HZ.
 Possible values: ``1712000``, ``5000000``, ``6000000``, ``7000000``,
 ``8000000``, ``10000000``.
 
-Notes:
+.. note::
 
-1) For ISDB-T it should be always 6000000Hz (6MHz)
+  #. DVB-T supports 6, 7 and 8MHz.
 
-2) For ISDB-Tsb it can vary depending on the number of connected
-segments
+  #. DVB-T2 supports 1.172, 5, 6, 7, 8 and 10MHz.
 
-3) Bandwidth doesn't apply for DVB-C transmissions, as the bandwidth for
-DVB-C depends on the symbol rate
+  #. ISDB-T supports 5MHz, 6MHz, 7MHz and 8MHz, although most
+     places use 6MHz.
 
-4) Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
-other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
-DTV_ISDBT_SB_SEGMENT_COUNT).
+  #. On DVB-C and DVB-S/S2, the bandwidth depends on the symbol rate.
+     So, the Kernel will silently ignore setting :ref:`DTV-BANDWIDTH-HZ`.
 
-5) DVB-T supports 6, 7 and 8MHz.
+  #. For DVB-C and DVB-S/S2, the Kernel will return an estimation of the
+     bandwidth, calculated from :ref:`DTV-SYMBOL-RATE` and from
+     the rolloff, with is fixed for DVB-C and DVB-S.
 
-6) In addition, DVB-T2 supports 1.172, 5 and 10MHz.
+  #. For DVB-S2, the bandwidth estimation will use :ref:`DTV-ROLLOFF`.
+
+  #. For ISDB-Tsb, it can vary depending on the number of connected
+     segments.
+
+  #. Bandwidth in ISDB-Tsb can be easily derived from other parameters
+     (DTV_ISDBT_SB_SEGMENT_IDX, DTV_ISDBT_SB_SEGMENT_COUNT).
 
 
 .. _DTV-INVERSION:
-- 
2.7.4

