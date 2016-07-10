Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbcGJPSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 11:18:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/3] [media] doc-rst: improve documentation for DTV_FREQUENCY
Date: Sun, 10 Jul 2016 12:18:15 -0300
Message-Id: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the note better formatted and documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/dvb/fe_property_parameters.rst      | 26 +++++++++++++---------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 47eb29350717..1b0b1171602d 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -39,20 +39,26 @@ effect hardware.
 DTV_FREQUENCY
 =============
 
-Central frequency of the channel.
+Frequency of the digital TV transponder/channel.
 
-Notes:
+.. note::
 
-1)For satellite delivery systems, it is measured in kHz. For the other
-ones, it is measured in Hz.
+  #. For satellite delivery systems, the frequency is in kHz.
 
-2)For ISDB-T, the channels are usually transmitted with an offset of
-143kHz. E.g. a valid frequency could be 474143 kHz. The stepping is
-bound to the bandwidth of the channel which is 6MHz.
+  #. For cable and terrestrial delivery systems, the frequency is in
+     Hz.
 
-3)As in ISDB-Tsb the channel consists of only one or three segments the
-frequency step is 429kHz, 3*429 respectively. As for ISDB-T the central
-frequency of the channel is expected.
+  #. On most delivery systems, the frequency is the center frequency
+     of the transponder/channel. The exception is for ISDB-T, where
+     the main carrier has a 1/7 offset from the center.
+
+  #. For ISDB-T, the channels are usually transmitted with an offset of
+     about 143kHz. E.g. a valid frequency could be 474,143 kHz. The
+     stepping is  bound to the bandwidth of the channel which is
+     typically 6MHz.
+
+  #. In ISDB-Tsb, the channel consists of only one or three segments the
+     frequency step is 429kHz, 3*429 respectively.
 
 
 .. _DTV-MODULATION:
-- 
2.7.4

