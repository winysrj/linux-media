Return-path: <linux-media-owner@vger.kernel.org>
Received: from aybabtu.com ([69.60.117.155]:40123 "EHLO aybabtu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZCGVKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 16:10:12 -0500
Date: Sat, 7 Mar 2009 21:48:39 +0100
From: Robert Millan <rmh@aybabtu.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Subject: [PATCH] Conceptronic CTVFMI2 PCI Id
Message-ID: <20090307204839.GA16591@thorin>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi,

My BTTV_BOARD_CONCEPTRONIC_CTVFMI2 card wasn't auto-detected, here's a patch
that adds its PCI id.

lspci -nnv output:

05:06.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
05:06.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)

-- 
Robert Millan

  The DRM opt-in fallacy: "Your data belongs to us. We will decide when (and
  how) you may access your data; but nobody's threatening your freedom: we
  still allow you to remove your data and not access it at all."

--ibTvN161/egqYuK8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="bttv_conceptronic.diff"

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index d24dcc0..2ddda54 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -289,6 +289,8 @@ static struct CARD {
 	/* Duplicate PCI ID, reconfigure for this board during the eeprom read.
 	* { 0x13eb0070, BTTV_BOARD_HAUPPAUGE_IMPACTVCB,  "Hauppauge ImpactVCB" }, */
 
+	{ 0x109e036e, BTTV_BOARD_CONCEPTRONIC_CTVFMI2,	"Conceptronic CTVFMi v2"},
+
 	/* DVB cards (using pci function .1 for mpeg data xfer) */
 	{ 0x001c11bd, BTTV_BOARD_PINNACLESAT,   "Pinnacle PCTV Sat" },
 	{ 0x01010071, BTTV_BOARD_NEBULA_DIGITV, "Nebula Electronics DigiTV" },

--ibTvN161/egqYuK8--
