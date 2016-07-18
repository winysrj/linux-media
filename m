Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcGRB4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 30/36] [media] doc-rst: add documentation for si476x
Date: Sun, 17 Jul 2016 22:56:13 -0300
Message-Id: <f1668f1d132ad08e3cccd10f34cfbe8434ffe81d.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst  |   2 +
 Documentation/media/v4l-drivers/si476x.rst | 229 ++++++++++++-----------------
 2 files changed, 96 insertions(+), 135 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 5a582438b2c4..3ff127195fd3 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -36,4 +36,6 @@ License".
 	saa7134
 	sh_mobile_ceu_camera
 	si470x
+	si4713
+	si476x
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/si476x.rst b/Documentation/media/v4l-drivers/si476x.rst
index 616607955aaf..01a8d44425aa 100644
--- a/Documentation/media/v4l-drivers/si476x.rst
+++ b/Documentation/media/v4l-drivers/si476x.rst
@@ -27,159 +27,118 @@ The drivers exposes following files:
   information. The contents of the file is binary data of the
   following layout:
 
-  Offset	| Name		| Description
-  ====================================================================
-  0x00		| blend_int	| Flag, set when stereo separation has
-  		|  		| crossed below the blend threshold
-  --------------------------------------------------------------------
-  0x01		| hblend_int	| Flag, set when HiBlend cutoff
-  		| 		| frequency is lower than threshold
-  --------------------------------------------------------------------
-  0x02		| hicut_int	| Flag, set when HiCut cutoff
-  		| 		| frequency is lower than threshold
-  --------------------------------------------------------------------
-  0x03		| chbw_int	| Flag, set when channel filter
-  		| 		| bandwidth is less than threshold
-  --------------------------------------------------------------------
-  0x04		| softmute_int	| Flag indicating that softmute
-  		| 		| attenuation has increased above
-		|		| softmute threshold
-  --------------------------------------------------------------------
-  0x05		| smute		| 0 - Audio is not soft muted
-  		| 		| 1 - Audio is soft muted
-  --------------------------------------------------------------------
-  0x06		| smattn	| Soft mute attenuation level in dB
-  --------------------------------------------------------------------
-  0x07		| chbw		| Channel filter bandwidth in kHz
-  --------------------------------------------------------------------
-  0x08		| hicut		| HiCut cutoff frequency in units of
-  		| 		| 100Hz
-  --------------------------------------------------------------------
-  0x09		| hiblend	| HiBlend cutoff frequency in units
-  		| 		| of 100 Hz
-  --------------------------------------------------------------------
-  0x10		| pilot		| 0 - Stereo pilot is not present
-  		| 		| 1 - Stereo pilot is present
-  --------------------------------------------------------------------
-  0x11		| stblend	| Stereo blend in %
-  --------------------------------------------------------------------
+  =============  ==============   ====================================
+  Offset	  Name		  Description
+  =============  ==============   ====================================
+  0x00		  blend_int	  Flag, set when stereo separation has
+				  crossed below the blend threshold
+  0x01		  hblend_int	  Flag, set when HiBlend cutoff
+				  frequency is lower than threshold
+  0x02		  hicut_int	  Flag, set when HiCut cutoff
+				  frequency is lower than threshold
+  0x03		  chbw_int	  Flag, set when channel filter
+				  bandwidth is less than threshold
+  0x04		  softmute_int	  Flag indicating that softmute
+				  attenuation has increased above
+				  softmute threshold
+  0x05		 smute		  0 - Audio is not soft muted
+				  1 - Audio is soft muted
+  0x06		  smattn	  Soft mute attenuation level in dB
+  0x07		  chbw		  Channel filter bandwidth in kHz
+  0x08		  hicut		  HiCut cutoff frequency in units of
+				  100Hz
+  0x09		  hiblend	  HiBlend cutoff frequency in units
+				  of 100 Hz
+  0x10		  pilot		  0 - Stereo pilot is not present
+				  1 - Stereo pilot is present
+  0x11		  stblend	  Stereo blend in %
+  =============  ==============   ====================================
 
 
 * /sys/kernel/debug/<device-name>/rds_blckcnt
   This file contains statistics about RDS receptions. It's binary data
   has the following layout:
 
-  Offset	| Name		| Description
-  ====================================================================
-  0x00		| expected	| Number of expected RDS blocks
-  --------------------------------------------------------------------
-  0x02		| received	| Number of received RDS blocks
-  --------------------------------------------------------------------
-  0x04		| uncorrectable	| Number of uncorrectable RDS blocks
-  --------------------------------------------------------------------
+  =============  ==============   ====================================
+  Offset	  Name		  Description
+  =============  ==============   ====================================
+  0x00		  expected	  Number of expected RDS blocks
+  0x02		  received	  Number of received RDS blocks
+  0x04		  uncorrectable	  Number of uncorrectable RDS blocks
+  =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/agc
   This file contains information about parameters pertaining to
   AGC(Automatic Gain Control)
 
   The layout is:
-  Offset	| Name		| Description
-  ====================================================================
-  0x00		| mxhi		| 0 - FM Mixer PD high threshold is
-  		| 		| not tripped
-		|		| 1 - FM Mixer PD high threshold is
-		|		| tripped
-  --------------------------------------------------------------------
-  0x01		| mxlo		| ditto for FM Mixer PD low
-  --------------------------------------------------------------------
-  0x02		| lnahi		| ditto for FM LNA PD high
-  --------------------------------------------------------------------
-  0x03		| lnalo		| ditto for FM LNA PD low
-  --------------------------------------------------------------------
-  0x04		| fmagc1	| FMAGC1 attenuator resistance
-  		| 		| (see datasheet for more detail)
-  --------------------------------------------------------------------
-  0x05		| fmagc2	| ditto for FMAGC2
-  --------------------------------------------------------------------
-  0x06		| pgagain	| PGA gain in dB
-  --------------------------------------------------------------------
-  0x07		| fmwblang	| FM/WB LNA Gain in dB
-  --------------------------------------------------------------------
+
+  =============  ==============   ====================================
+  Offset	  Name		  Description
+  =============  ==============   ====================================
+  0x00		  mxhi		  0 - FM Mixer PD high threshold is
+				  not tripped
+				  1 - FM Mixer PD high threshold is
+				  tripped
+  0x01		  mxlo		  ditto for FM Mixer PD low
+  0x02		  lnahi		  ditto for FM LNA PD high
+  0x03		  lnalo		  ditto for FM LNA PD low
+  0x04		  fmagc1	  FMAGC1 attenuator resistance
+				  (see datasheet for more detail)
+  0x05		  fmagc2	  ditto for FMAGC2
+  0x06		  pgagain	  PGA gain in dB
+  0x07		  fmwblang	  FM/WB LNA Gain in dB
+  =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/rsq
   This file contains information about parameters pertaining to
   RSQ(Received Signal Quality)
 
   The layout is:
-  Offset	| Name		| Description
-  ====================================================================
-  0x00		| multhint	| 0 - multipath value has not crossed
-  		| 		| the Multipath high threshold
-		|		| 1 - multipath value has crossed
-  		| 		| the Multipath high threshold
-  --------------------------------------------------------------------
-  0x01		| multlint	| ditto for Multipath low threshold
-  --------------------------------------------------------------------
-  0x02		| snrhint	| 0 - received signal's SNR has not
-  		| 		| crossed high threshold
-		|		| 1 - received signal's SNR has
-  		| 		| crossed high threshold
-  --------------------------------------------------------------------
-  0x03		| snrlint	| ditto for low threshold
-  --------------------------------------------------------------------
-  0x04		| rssihint	| ditto for RSSI high threshold
-  --------------------------------------------------------------------
-  0x05		| rssilint	| ditto for RSSI low threshold
-  --------------------------------------------------------------------
-  0x06		| bltf		| Flag indicating if seek command
-  		| 		| reached/wrapped seek band limit
-  --------------------------------------------------------------------
-  0x07		| snr_ready	| Indicates that SNR metrics is ready
-  --------------------------------------------------------------------
-  0x08		| rssiready	| ditto for RSSI metrics
-  --------------------------------------------------------------------
-  0x09		| injside	| 0 - Low-side injection is being used
-  		| 		| 1 - High-side injection is used
-  --------------------------------------------------------------------
-  0x10		| afcrl		| Flag indicating if AFC rails
-  --------------------------------------------------------------------
-  0x11		| valid		| Flag indicating if channel is valid
-  --------------------------------------------------------------------
-  0x12		| readfreq	| Current tuned frequency
-  --------------------------------------------------------------------
-  0x14		| freqoff	| Signed frequency offset in units of
-  		| 		| 2ppm
-  --------------------------------------------------------------------
-  0x15		| rssi		| Signed value of RSSI in dBuV
-  --------------------------------------------------------------------
-  0x16		| snr		| Signed RF SNR in dB
-  --------------------------------------------------------------------
-  0x17		| issi		| Signed Image Strength Signal
-  		| 		| indicator
-  --------------------------------------------------------------------
-  0x18		| lassi		| Signed Low side adjacent Channel
-  		| 		| Strength indicator
-  --------------------------------------------------------------------
-  0x19		| hassi		| ditto fpr High side
-  --------------------------------------------------------------------
-  0x20		| mult		| Multipath indicator
-  --------------------------------------------------------------------
-  0x21		| dev		| Frequency deviation
-  --------------------------------------------------------------------
-  0x24		| assi		| Adjacent channel SSI
-  --------------------------------------------------------------------
-  0x25		| usn		| Ultrasonic noise indicator
-  --------------------------------------------------------------------
-  0x26		| pilotdev	| Pilot deviation in units of 100 Hz
-  --------------------------------------------------------------------
-  0x27		| rdsdev	| ditto for RDS
-  --------------------------------------------------------------------
-  0x28		| assidev	| ditto for ASSI
-  --------------------------------------------------------------------
-  0x29		| strongdev	| Frequency deviation
-  --------------------------------------------------------------------
-  0x30		| rdspi		| RDS PI code
-  --------------------------------------------------------------------
+
+  =============  ==============   ====================================
+  Offset	  Name		  Description
+  =============  ==============   ====================================
+  0x00		  multhint	  0 - multipath value has not crossed
+				  the Multipath high threshold
+				  1 - multipath value has crossed
+				  the Multipath high threshold
+  0x01		  multlint	  ditto for Multipath low threshold
+  0x02		  snrhint	  0 - received signal's SNR has not
+				  crossed high threshold
+				  1 - received signal's SNR has
+				  crossed high threshold
+  0x03		  snrlint	  ditto for low threshold
+  0x04		  rssihint	  ditto for RSSI high threshold
+  0x05		  rssilint	  ditto for RSSI low threshold
+  0x06		  bltf		  Flag indicating if seek command
+				  reached/wrapped seek band limit
+  0x07		  snr_ready	  Indicates that SNR metrics is ready
+  0x08		  rssiready	  ditto for RSSI metrics
+  0x09		  injside	  0 - Low-side injection is being used
+				  1 - High-side injection is used
+  0x10		  afcrl		  Flag indicating if AFC rails
+  0x11		  valid		  Flag indicating if channel is valid
+  0x12		  readfreq	  Current tuned frequency
+  0x14		  freqoff	  Signed frequency offset in units of
+				  2ppm
+  0x15		  rssi		  Signed value of RSSI in dBuV
+  0x16		  snr		  Signed RF SNR in dB
+  0x17		  issi		  Signed Image Strength Signal
+				  indicator
+  0x18		  lassi		  Signed Low side adjacent Channel
+				  Strength indicator
+  0x19		  hassi		  ditto fpr High side
+  0x20		  mult		  Multipath indicator
+  0x21		  dev		  Frequency deviation
+  0x24		  assi		  Adjacent channel SSI
+  0x25		  usn		  Ultrasonic noise indicator
+  0x26		  pilotdev	  Pilot deviation in units of 100 Hz
+  0x27		  rdsdev	  ditto for RDS
+  0x28		  assidev	  ditto for ASSI
+  0x29		  strongdev	  Frequency deviation
+  0x30		  rdspi		  RDS PI code
+  =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/rsq_primary
   This file contains information about parameters pertaining to
-- 
2.7.4

