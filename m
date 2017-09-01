Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46930
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752063AbdIANY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 11/27] media: fe_property_parameters.rst: better document bandwidth
Date: Fri,  1 Sep 2017 10:24:33 -0300
Message-Id: <ae15a35c0501062b6a75d5e2e414c1ca3e6afdcc.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a table to document the supported bandwidths. That makes
it clearer to readers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/dvb/fe_property_parameters.rst      | 44 +++++++++++++---------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index e085e84fef38..49470f7dda02 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -116,30 +116,38 @@ Should be set only for terrestrial delivery systems.
 Possible values: ``1712000``, ``5000000``, ``6000000``, ``7000000``,
 ``8000000``, ``10000000``.
 
+======================= =======================================================
+Terrestrial Standard	Possible values for bandwidth
+======================= =======================================================
+ATSC (version 1)	No need to set. It is always 6MHz.
+DMTB			No need to set. It is always 8MHz.
+DVB-T			6MHz, 7MHz and 8MHz.
+DVB-T2			1.172 MHz, 5MHz, 6MHz, 7MHz, 8MHz and 10MHz
+ISDB-T			5MHz, 6MHz, 7MHz and 8MHz, although most places
+			use 6MHz.
+======================= =======================================================
+
+
 .. note::
 
-  #. DVB-T supports 6, 7 and 8MHz.
 
-  #. DVB-T2 supports 1.172, 5, 6, 7, 8 and 10MHz.
+  #. For ISDB-Tsb, the bandwidth can vary depending on the number of
+     connected segments.
 
-  #. ISDB-T supports 5MHz, 6MHz, 7MHz and 8MHz, although most
-     places use 6MHz.
-
-  #. On DVB-C and DVB-S/S2, the bandwidth depends on the symbol rate.
-     So, the Kernel will silently ignore setting :ref:`DTV-BANDWIDTH-HZ`.
-
-  #. For DVB-C and DVB-S/S2, the Kernel will return an estimation of the
-     bandwidth, calculated from :ref:`DTV-SYMBOL-RATE` and from
-     the rolloff, with is fixed for DVB-C and DVB-S.
-
-  #. For DVB-S2, the bandwidth estimation will use :ref:`DTV-ROLLOFF`.
-
-  #. For ISDB-Tsb, it can vary depending on the number of connected
-     segments.
-
-  #. Bandwidth in ISDB-Tsb can be easily derived from other parameters
+     It can be easily derived from other parameters
      (DTV_ISDBT_SB_SEGMENT_IDX, DTV_ISDBT_SB_SEGMENT_COUNT).
 
+  #. On Satellite and Cable delivery systems, the bandwidth depends on
+     the symbol rate. So, the Kernel will silently ignore any setting
+     :ref:`DTV-BANDWIDTH-HZ`. I will however fill it back with a
+     bandwidth estimation.
+
+     Such bandwidth estimation takes into account the symbol rate set with
+     :ref:`DTV-SYMBOL-RATE`, and the rolloff factor, with is fixed for
+     DVB-C and DVB-S.
+
+     For DVB-S2, the rolloff should also be set via :ref:`DTV-ROLLOFF`.
+
 
 .. _DTV-INVERSION:
 
-- 
2.13.5
