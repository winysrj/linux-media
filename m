Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32362 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756519AbdJJRh4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 13:37:56 -0400
Date: Tue, 10 Oct 2017 12:36:37 -0500
From: Tom Saeger <tom.saeger@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Tom Saeger <tom.saeger@oracle.com>, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Documentation: fix media related doc refs
Message-ID: <c687ab26caad079174767ea2f4650678b00d70ba.1507653970.git.tom.saeger@oracle.com>
References: <cover.1507653969.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507653969.git.tom.saeger@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make media doc refs valid.

Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 Documentation/admin-guide/kernel-parameters.txt    | 4 ++--
 Documentation/media/dvb-drivers/bt8xx.rst          | 8 ++++----
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    | 2 +-
 Documentation/media/uapi/v4l/extended-controls.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   | 2 +-
 Documentation/media/v4l-drivers/max2175.rst        | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 411b41127eee..cbfae6b1c644 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -439,7 +439,7 @@
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
-	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
+	bttv.pll=	See Documentation/media/v4l-drivers/bttv.rst
 	bttv.tuner=
 
 	bulk_remove=off	[PPC]  This parameter disables the use of the pSeries
@@ -2251,7 +2251,7 @@
 			See Documentation/admin-guide/pm/sleep-states.rst.
 
 	meye.*=		[HW] Set MotionEye Camera parameters
-			See Documentation/video4linux/meye.txt.
+			See Documentation/media/v4l-drivers/meye.rst.
 
 	mfgpt_irq=	[IA-32] Specify the IRQ to use for the
 			Multi-Function General Purpose Timers on AMD Geode
diff --git a/Documentation/media/dvb-drivers/bt8xx.rst b/Documentation/media/dvb-drivers/bt8xx.rst
index b43958b7340c..e3e387bdf498 100644
--- a/Documentation/media/dvb-drivers/bt8xx.rst
+++ b/Documentation/media/dvb-drivers/bt8xx.rst
@@ -18,7 +18,7 @@ General information
 
 This class of cards has a bt878a as the PCI interface, and require the bttv driver
 for accessing the i2c bus and the gpio pins of the bt8xx chipset.
-Please see Documentation/dvb/cards.txt => o Cards based on the Conexant Bt8xx PCI bridge:
+Please see Documentation/media/dvb-drivers/cards.rst => o Cards based on the Conexant Bt8xx PCI bridge:
 
 Compiling kernel please enable:
 
@@ -45,7 +45,7 @@ Loading Modules
 Regular case: If the bttv driver detects a bt8xx-based DVB card, all frontend and backend modules will be loaded automatically.
 Exceptions are:
 - Old TwinHan DST cards or clones with or without CA slot and not containing an Eeprom.
-People running udev please see Documentation/dvb/udev.txt.
+People running udev please see Documentation/media/dvb-drivers/udev.rst.
 
 In the following cases overriding the PCI type detection for dvb-bt8xx might be necessary:
 
@@ -72,7 +72,7 @@ Useful parameters for verbosity level and debugging the dst module:
 The autodetected values are determined by the cards' "response string".
 In your logs see f. ex.: dst_get_device_id: Recognize [DSTMCI].
 For bug reports please send in a complete log with verbose=4 activated.
-Please also see Documentation/dvb/ci.txt.
+Please also see Documentation/media/dvb-drivers/ci.rst.
 
 Running multiple cards
 ~~~~~~~~~~~~~~~~~~~~~~
@@ -100,7 +100,7 @@ Examples of card ID's:
 
 	$ modprobe bttv card=113 card=135
 
-For a full list of card ID's please see Documentation/video4linux/CARDLIST.bttv.
+For a full list of card ID's please see Documentation/media/v4l-drivers/bttv-cardlist.rst.
 In case of further problems please subscribe and send questions to the mailing list: linux-dvb@linuxtv.org.
 
 Probing the cards with broken PCI subsystem ID
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 9d6c860271cb..d311a6866b3b 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -431,7 +431,7 @@ MPEG stream.
 *Historical context*: This format specification originates from a
 custom, embedded, sliced VBI data format used by the ``ivtv`` driver.
 This format has already been informally specified in the kernel sources
-in the file ``Documentation/video4linux/cx2341x/README.vbi`` . The
+in the file ``Documentation/media/v4l-drivers/cx2341x.rst`` . The
 maximum size of the payload and other aspects of this format are driven
 by the CX23415 MPEG decoder's capabilities and limitations with respect
 to extracting, decoding, and displaying sliced VBI data embedded within
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index a3e81c1d276b..dfe49ae57e78 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -284,7 +284,7 @@ enum v4l2_mpeg_stream_vbi_fmt -
     * - ``V4L2_MPEG_STREAM_VBI_FMT_IVTV``
       - VBI in private packets, IVTV format (documented in the kernel
 	sources in the file
-	``Documentation/video4linux/cx2341x/README.vbi``)
+	``Documentation/media/v4l-drivers/cx2341x.rst``)
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 521adb795535..38af1472a4b4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -52,7 +52,7 @@ please make a proposal on the linux-media mailing list.
 	`http://www.ivtvdriver.org/ <http://www.ivtvdriver.org/>`__
 
 	The format is documented in the kernel sources in the file
-	``Documentation/video4linux/cx2341x/README.hm12``
+	``Documentation/media/v4l-drivers/cx2341x.rst``
     * .. _V4L2-PIX-FMT-CPIA1:
 
       - ``V4L2_PIX_FMT_CPIA1``
diff --git a/Documentation/media/v4l-drivers/max2175.rst b/Documentation/media/v4l-drivers/max2175.rst
index 04478c25d57a..b1a4c89fd869 100644
--- a/Documentation/media/v4l-drivers/max2175.rst
+++ b/Documentation/media/v4l-drivers/max2175.rst
@@ -7,7 +7,7 @@ The MAX2175 driver implements the following driver-specific controls:
 -------------------------------
     Enable/Disable I2S output of the tuner. This is a private control
     that can be accessed only using the subdev interface.
-    Refer to Documentation/media/kapi/v4l2-controls for more details.
+    Refer to Documentation/media/kapi/v4l2-controls.rst for more details.
 
 .. flat-table::
     :header-rows:  0
-- 
2.14.2
