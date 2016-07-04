Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 05/51] Documentation: linux_tv/index.rst: add xrefs for document divisions
Date: Mon,  4 Jul 2016 08:46:26 -0300
Message-Id: <580eb42cab578bf0ca7b7d8b312b001352b6ce4e.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make easier to navigate at the media document by adding the
links to each of the parts of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index b0389cbfb1aa..edb7d56e9b8f 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -39,19 +39,19 @@ A typical media device hardware is shown at
 The media infrastructure API was designed to control such devices. It is
 divided into four parts.
 
-The first part covers radio, video capture and output,
+The :Ref:`first part <v4l2spec>` covers radio, video capture and output,
 cameras, analog TV devices and codecs.
 
-The second part covers the API used for digital TV and Internet
-reception via one of the several digital tv standards. While it is
-called as DVB API, in fact it covers several different video standards
-including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S, DTMB, etc.
-The complete list of supported standards can be found at
+The :Ref:`second part <dvbapi>` covers the API used for digital TV and
+Internet reception via one of the several digital tv standards. While it
+is called as DVB API, in fact it covers several different video
+standards including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S,
+DTMB, etc. The complete list of supported standards can be found at
 :ref:`fe-delivery-system-t`.
 
-The third part covers the Remote Controller API.
+The :Ref:`third part <remote_controllers>` covers the Remote Controller API.
 
-The fourth part covers the Media Controller API.
+The :Ref:`fourth part <media_controller>` covers the Media Controller API.
 
 It should also be noted that a media device may also have audio
 components, like mixers, PCM capture, PCM playback, etc, which are
-- 
2.7.4


