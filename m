Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:23725 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbZFPAxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 20:53:55 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1228631fgg.17
        for <linux-media@vger.kernel.org>; Mon, 15 Jun 2009 17:53:57 -0700 (PDT)
Date: Tue, 16 Jun 2009 10:55:23 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] FM1216MK5 FM radio patch
Message-ID: <20090616105523.0d03862c@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+Yz3JX0bgCVWi4_sBYGW73v"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/+Yz3JX0bgCVWi4_sBYGW73v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Next code for implement Philips FM1216MK5.

1. Implement get_stereo function.
2. Add correct data byte for FM radio mode.

diff -r bff77ec33116 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Thu Jun 11 18:44:23 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jun 16 05:27:52 2009 +1000
@@ -145,6 +145,8 @@
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_TCL_MF02GIP_5N:
 		return ((status & TUNER_SIGNAL) == TUNER_STEREO_MK3);
+	case TUNER_PHILIPS_FM1216MK5:
+		return status | TUNER_STEREO;
 	default:
 		return status & TUNER_STEREO;
 	}
@@ -514,6 +516,10 @@
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_TCL_MF02GIP_5N:
 		buffer[3] = 0x19;
+		break;
+	case TUNER_PHILIPS_FM1216MK5:
+		buffer[2] = 0x88;
+		buffer[3] = 0x09;
 		break;
 	case TUNER_TNF_5335MF:
 		buffer[3] = 0x11;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/+Yz3JX0bgCVWi4_sBYGW73v
Content-Type: text/x-patch; name=behold_mk5_fm.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk5_fm.patch

diff -r bff77ec33116 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Thu Jun 11 18:44:23 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jun 16 05:27:52 2009 +1000
@@ -145,6 +145,8 @@
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_TCL_MF02GIP_5N:
 		return ((status & TUNER_SIGNAL) == TUNER_STEREO_MK3);
+	case TUNER_PHILIPS_FM1216MK5:
+		return status | TUNER_STEREO;
 	default:
 		return status & TUNER_STEREO;
 	}
@@ -514,6 +516,10 @@
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_TCL_MF02GIP_5N:
 		buffer[3] = 0x19;
+		break;
+	case TUNER_PHILIPS_FM1216MK5:
+		buffer[2] = 0x88;
+		buffer[3] = 0x09;
 		break;
 	case TUNER_TNF_5335MF:
 		buffer[3] = 0x11;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/+Yz3JX0bgCVWi4_sBYGW73v--
