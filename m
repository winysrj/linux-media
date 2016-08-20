Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcHTMwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 08:52:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] docs-rst: v4l2-drivers book: adjust column margins
Date: Sat, 20 Aug 2016 09:51:54 -0300
Message-Id: <764886c15c215a3a4d0596bad4c12b4d03e0dfae.1471697421.git.mchehab@s-opensource.com>
In-Reply-To: <4b05049d2020b3ec4c6ececf232bc035a598126f.1471697421.git.mchehab@s-opensource.com>
References: <4b05049d2020b3ec4c6ececf232bc035a598126f.1471697421.git.mchehab@s-opensource.com>
In-Reply-To: <4b05049d2020b3ec4c6ececf232bc035a598126f.1471697421.git.mchehab@s-opensource.com>
References: <4b05049d2020b3ec4c6ececf232bc035a598126f.1471697421.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few tables are not properly output on LaTeX format.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cpia2.rst  |   3 +
 Documentation/media/v4l-drivers/si476x.rst | 116 +++++++++++++++--------------
 2 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/Documentation/media/v4l-drivers/cpia2.rst b/Documentation/media/v4l-drivers/cpia2.rst
index 763705c1f50f..b5125016cfcb 100644
--- a/Documentation/media/v4l-drivers/cpia2.rst
+++ b/Documentation/media/v4l-drivers/cpia2.rst
@@ -55,6 +55,9 @@ may be done automatically by your distribution.
 Driver options
 ~~~~~~~~~~~~~~
 
+.. tabularcolumns:: |p{13ex}|L|
+
+
 ==============  ========================================================
 Option		Description
 ==============  ========================================================
diff --git a/Documentation/media/v4l-drivers/si476x.rst b/Documentation/media/v4l-drivers/si476x.rst
index d5c07bb7524d..677512566f15 100644
--- a/Documentation/media/v4l-drivers/si476x.rst
+++ b/Documentation/media/v4l-drivers/si476x.rst
@@ -31,31 +31,33 @@ The drivers exposes following files:
   information. The contents of the file is binary data of the
   following layout:
 
+  .. tabularcolumns:: |p{7ex}|p{12ex}|L|
+
   =============  ==============   ====================================
-  Offset	  Name		  Description
+  Offset	 Name		  Description
   =============  ==============   ====================================
-  0x00		  blend_int	  Flag, set when stereo separation has
+  0x00		 blend_int	  Flag, set when stereo separation has
 				  crossed below the blend threshold
-  0x01		  hblend_int	  Flag, set when HiBlend cutoff
+  0x01		 hblend_int	  Flag, set when HiBlend cutoff
 				  frequency is lower than threshold
-  0x02		  hicut_int	  Flag, set when HiCut cutoff
+  0x02		 hicut_int	  Flag, set when HiCut cutoff
 				  frequency is lower than threshold
-  0x03		  chbw_int	  Flag, set when channel filter
+  0x03		 chbw_int	  Flag, set when channel filter
 				  bandwidth is less than threshold
-  0x04		  softmute_int	  Flag indicating that softmute
+  0x04		 softmute_int	  Flag indicating that softmute
 				  attenuation has increased above
 				  softmute threshold
   0x05		 smute		  0 - Audio is not soft muted
 				  1 - Audio is soft muted
-  0x06		  smattn	  Soft mute attenuation level in dB
-  0x07		  chbw		  Channel filter bandwidth in kHz
-  0x08		  hicut		  HiCut cutoff frequency in units of
+  0x06		 smattn		  Soft mute attenuation level in dB
+  0x07		 chbw		  Channel filter bandwidth in kHz
+  0x08		 hicut		  HiCut cutoff frequency in units of
 				  100Hz
-  0x09		  hiblend	  HiBlend cutoff frequency in units
+  0x09		 hiblend	  HiBlend cutoff frequency in units
 				  of 100 Hz
-  0x10		  pilot		  0 - Stereo pilot is not present
+  0x10		 pilot		  0 - Stereo pilot is not present
 				  1 - Stereo pilot is present
-  0x11		  stblend	  Stereo blend in %
+  0x11		 stblend	  Stereo blend in %
   =============  ==============   ====================================
 
 
@@ -63,12 +65,14 @@ The drivers exposes following files:
   This file contains statistics about RDS receptions. It's binary data
   has the following layout:
 
+  .. tabularcolumns:: |p{7ex}|p{12ex}|L|
+
   =============  ==============   ====================================
-  Offset	  Name		  Description
+  Offset	 Name		  Description
   =============  ==============   ====================================
-  0x00		  expected	  Number of expected RDS blocks
-  0x02		  received	  Number of received RDS blocks
-  0x04		  uncorrectable	  Number of uncorrectable RDS blocks
+  0x00		 expected	  Number of expected RDS blocks
+  0x02		 received	  Number of received RDS blocks
+  0x04		 uncorrectable	  Number of uncorrectable RDS blocks
   =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/agc
@@ -77,21 +81,23 @@ The drivers exposes following files:
 
   The layout is:
 
+  .. tabularcolumns:: |p{7ex}|p{12ex}|L|
+
   =============  ==============   ====================================
-  Offset	  Name		  Description
+  Offset	 Name		  Description
   =============  ==============   ====================================
-  0x00		  mxhi		  0 - FM Mixer PD high threshold is
+  0x00		 mxhi		  0 - FM Mixer PD high threshold is
 				  not tripped
 				  1 - FM Mixer PD high threshold is
 				  tripped
-  0x01		  mxlo		  ditto for FM Mixer PD low
-  0x02		  lnahi		  ditto for FM LNA PD high
-  0x03		  lnalo		  ditto for FM LNA PD low
-  0x04		  fmagc1	  FMAGC1 attenuator resistance
+  0x01		 mxlo		  ditto for FM Mixer PD low
+  0x02		 lnahi		  ditto for FM LNA PD high
+  0x03		 lnalo		  ditto for FM LNA PD low
+  0x04		 fmagc1		  FMAGC1 attenuator resistance
 				  (see datasheet for more detail)
-  0x05		  fmagc2	  ditto for FMAGC2
-  0x06		  pgagain	  PGA gain in dB
-  0x07		  fmwblang	  FM/WB LNA Gain in dB
+  0x05		 fmagc2		  ditto for FMAGC2
+  0x06		 pgagain	  PGA gain in dB
+  0x07		 fmwblang	  FM/WB LNA Gain in dB
   =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/rsq
@@ -100,48 +106,50 @@ The drivers exposes following files:
 
   The layout is:
 
+  .. tabularcolumns:: |p{7ex}|p{12ex}|p{60ex}|
+
   =============  ==============   ====================================
-  Offset	  Name		  Description
+  Offset	 Name		  Description
   =============  ==============   ====================================
-  0x00		  multhint	  0 - multipath value has not crossed
+  0x00		 multhint	  0 - multipath value has not crossed
 				  the Multipath high threshold
 				  1 - multipath value has crossed
 				  the Multipath high threshold
-  0x01		  multlint	  ditto for Multipath low threshold
-  0x02		  snrhint	  0 - received signal's SNR has not
+  0x01		 multlint	  ditto for Multipath low threshold
+  0x02		 snrhint	  0 - received signal's SNR has not
 				  crossed high threshold
 				  1 - received signal's SNR has
 				  crossed high threshold
-  0x03		  snrlint	  ditto for low threshold
-  0x04		  rssihint	  ditto for RSSI high threshold
-  0x05		  rssilint	  ditto for RSSI low threshold
-  0x06		  bltf		  Flag indicating if seek command
+  0x03		 snrlint	  ditto for low threshold
+  0x04		 rssihint	  ditto for RSSI high threshold
+  0x05		 rssilint	  ditto for RSSI low threshold
+  0x06		 bltf		  Flag indicating if seek command
 				  reached/wrapped seek band limit
-  0x07		  snr_ready	  Indicates that SNR metrics is ready
-  0x08		  rssiready	  ditto for RSSI metrics
-  0x09		  injside	  0 - Low-side injection is being used
+  0x07		 snr_ready	  Indicates that SNR metrics is ready
+  0x08		 rssiready	  ditto for RSSI metrics
+  0x09		 injside	  0 - Low-side injection is being used
 				  1 - High-side injection is used
-  0x10		  afcrl		  Flag indicating if AFC rails
-  0x11		  valid		  Flag indicating if channel is valid
-  0x12		  readfreq	  Current tuned frequency
-  0x14		  freqoff	  Signed frequency offset in units of
+  0x10		 afcrl		  Flag indicating if AFC rails
+  0x11		 valid		  Flag indicating if channel is valid
+  0x12		 readfreq	  Current tuned frequency
+  0x14		 freqoff	  Signed frequency offset in units of
 				  2ppm
-  0x15		  rssi		  Signed value of RSSI in dBuV
-  0x16		  snr		  Signed RF SNR in dB
-  0x17		  issi		  Signed Image Strength Signal
+  0x15		 rssi		  Signed value of RSSI in dBuV
+  0x16		 snr		  Signed RF SNR in dB
+  0x17		 issi		  Signed Image Strength Signal
 				  indicator
-  0x18		  lassi		  Signed Low side adjacent Channel
+  0x18		 lassi		  Signed Low side adjacent Channel
 				  Strength indicator
-  0x19		  hassi		  ditto fpr High side
-  0x20		  mult		  Multipath indicator
-  0x21		  dev		  Frequency deviation
-  0x24		  assi		  Adjacent channel SSI
-  0x25		  usn		  Ultrasonic noise indicator
-  0x26		  pilotdev	  Pilot deviation in units of 100 Hz
-  0x27		  rdsdev	  ditto for RDS
-  0x28		  assidev	  ditto for ASSI
-  0x29		  strongdev	  Frequency deviation
-  0x30		  rdspi		  RDS PI code
+  0x19		 hassi		  ditto fpr High side
+  0x20		 mult		  Multipath indicator
+  0x21		 dev		  Frequency deviation
+  0x24		 assi		  Adjacent channel SSI
+  0x25		 usn		  Ultrasonic noise indicator
+  0x26		 pilotdev	  Pilot deviation in units of 100 Hz
+  0x27		 rdsdev		  ditto for RDS
+  0x28		 assidev	  ditto for ASSI
+  0x29		 strongdev	  Frequency deviation
+  0x30		 rdspi		  RDS PI code
   =============  ==============   ====================================
 
 * /sys/kernel/debug/<device-name>/rsq_primary
-- 
2.7.4

