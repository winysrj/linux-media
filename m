Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43225 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754920AbcHSNFO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 09/15] [media] fe_property_parameters.rst: Adjust column sizes
Date: Fri, 19 Aug 2016 10:04:59 -0300
Message-Id: <38d5c4ffde8d6899b7cb35307d82f6df429b9b42.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add position hints for some tables, in order for them to be
shown properly on LaTeX output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/fe_property_parameters.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index f776d62523da..d7acc72ebbdf 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -1234,6 +1234,7 @@ Reed Solomon (RS) frame mode.
 
 Possible values are:
 
+.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
 .. _atscmh-rs-frame-mode:
 
@@ -1395,6 +1396,7 @@ Series Concatenated Convolutional Code Block Mode.
 
 Possible values are:
 
+.. tabularcolumns:: |p{4.5cm}|p{13.0cm}|
 
 .. _atscmh-sccc-block-mode:
 
@@ -1687,6 +1689,7 @@ on OFTM-based standards, e. g. DVB-T/T2, ISDB-T, DTMB
 enum fe_transmit_mode: Number of carriers per channel
 -----------------------------------------------------
 
+.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
 .. _fe-transmit-mode:
 
-- 
2.7.4


