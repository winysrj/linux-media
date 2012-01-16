Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3557 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2APNKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/10] radio/Kconfig: cleanup.
Date: Mon, 16 Jan 2012 14:10:06 +0100
Message-Id: <345a807126e72f58acd59c5e13c5292eafc7350f.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
References: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index c31bd76..b074d4a 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -178,14 +178,6 @@ config RADIO_CADET
 	  Choose Y here if you have one of these AM/FM radio cards, and then
 	  fill in the port address below.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  Further documentation on this driver can be found on the WWW at
-	  <http://linux.blackhawke.net/cadet/>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-cadet.
 
@@ -314,11 +306,6 @@ config RADIO_MIROPCM20
 	  sound card driver "Miro miroSOUND PCM1pro/PCM12/PCM20radio" as this
 	  is required for the radio-miropcm20.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-miropcm20.
 
@@ -328,11 +315,6 @@ config RADIO_SF16FMI
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-sf16fmi.
 
@@ -342,11 +324,6 @@ config RADIO_SF16FMR2
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found on the WWW at
-	  <http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-sf16fmr2.
 
-- 
1.7.7.3

