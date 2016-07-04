Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 34/51] Documentation: fe_property_parameters.rst: improve descriptions
Date: Mon,  4 Jul 2016 08:46:55 -0300
Message-Id: <e01cc42ff9cb8887d7eae1af08bbf1edfd5bc573.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The asterisks cause parsing warnings with Sphinx:
	Documentation/linux_tv/media/dvb/fe_property_parameters.rst:954: WARNING: Inline substitution_reference start-string without end-string.
	/devel/v4l/patchwork/Documentation/linux_tv/media/dvb/fe_property_parameters.rst:993: WARNING: Inline emphasis start-string without end-string.

On the first warning, the ISDB-T layer enabled description is a
kind of ackward. Improve it.

For the second one, IMHO, it is clearer to use [A-C], as it
shows what are the real possibilities, than using asterisk.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/fe_property_parameters.rst  | 34 +++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
index cf8514d79a20..788dbfef0061 100644
--- a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
+++ b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
@@ -918,8 +918,8 @@ Note: This value cannot be determined by an automatic channel search.
 
 .. _isdb-hierq-layers:
 
-DTV-ISDBT-LAYER* parameters
-===========================
+DTV-ISDBT-LAYER[A-C] parameters
+===============================
 
 ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
 ISDB-T hierarchical layers can be decoded simultaneously. For that
@@ -951,21 +951,21 @@ In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb according
 to ``DTV_ISDBT_PARTIAL_RECEPTION``. ``SEGMENT_COUNT`` must be filled
 accordingly.
 
-Possible values: 0x1, 0x2, 0x4 (|-able)
+Only the values of the first 3 bits are used. Other bits will be silently ignored:
 
-``DTV_ISDBT_LAYER_ENABLED[0:0]`` - layer A
+``DTV_ISDBT_LAYER_ENABLED`` bit 0: layer A enabled
 
-``DTV_ISDBT_LAYER_ENABLED[1:1]`` - layer B
+``DTV_ISDBT_LAYER_ENABLED`` bit 1: layer B enabled
 
-``DTV_ISDBT_LAYER_ENABLED[2:2]`` - layer C
+``DTV_ISDBT_LAYER_ENABLED`` bit 2: layer C enabled
 
-``DTV_ISDBT_LAYER_ENABLED[31:3]`` unused
+``DTV_ISDBT_LAYER_ENABLED`` bits 3-31: unused
 
 
 .. _DTV-ISDBT-LAYER-FEC:
 
-DTV_ISDBT_LAYER*_FEC
---------------------
+DTV_ISDBT_LAYER[A-C]_FEC
+------------------------
 
 Possible values: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
 ``FEC_5_6``, ``FEC_7_8``
@@ -973,8 +973,8 @@ Possible values: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
 
 .. _DTV-ISDBT-LAYER-MODULATION:
 
-DTV_ISDBT_LAYER*_MODULATION
----------------------------
+DTV_ISDBT_LAYER[A-C]_MODULATION
+-------------------------------
 
 Possible values: ``QAM_AUTO``, QP\ ``SK, QAM_16``, ``QAM_64``, ``DQPSK``
 
@@ -985,13 +985,13 @@ Note: If layer C is ``DQPSK`` layer B has to be ``DQPSK``. If layer B is
 
 .. _DTV-ISDBT-LAYER-SEGMENT-COUNT:
 
-DTV_ISDBT_LAYER*_SEGMENT_COUNT
-------------------------------
+DTV_ISDBT_LAYER[A-C]_SEGMENT_COUNT
+----------------------------------
 
 Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)
 
 Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
-``DTV_ISDBT_PARTIAL_RECEPTION`` and ``LAYER`` *_SEGMENT_COUNT
+``DTV_ISDBT_PARTIAL_RECEPTION`` and ``LAYER[A-C]_SEGMENT_COUNT``
 
 
 .. _isdbt-layer_seg-cnt-table:
@@ -1075,8 +1075,8 @@ Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
 
 .. _DTV-ISDBT-LAYER-TIME-INTERLEAVING:
 
-DTV_ISDBT_LAYER*_TIME_INTERLEAVING
-----------------------------------
+DTV_ISDBT_LAYER[A-C]_TIME_INTERLEAVING
+--------------------------------------
 
 Valid values: 0, 1, 2, 4, -1 (AUTO)
 
@@ -1096,7 +1096,7 @@ TMCC-structure, as shown in the table below.
 
     -  .. row 1
 
-       -  DTV_ISDBT_LAYER*_TIME_INTERLEAVING
+       -  ``DTV_ISDBT_LAYER[A-C]_TIME_INTERLEAVING``
 
        -  Mode 1 (2K FFT)
 
-- 
2.7.4


