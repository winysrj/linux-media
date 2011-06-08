Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1FHUZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:13 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPC7j015836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:12 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uh024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:12 -0400
Date: Wed, 8 Jun 2011 17:23:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/13] [media] dvb/audio.h: Remove definition for
 AUDIO_GET_PTS
Message-ID: <20110608172302.3e2294af@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While this ioctl is defined inside dvb/audio.h, it is not docummented
at the API specs, nor implemented on any driver inside the Linux Kernel.
So, it doesn't make sense to keep it here.

As this is not used anywere, removing it is not a regression. So,
there's no need to use the normal features-to-be-removed process.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
index d47bccd..c1b3555 100644
--- a/include/linux/dvb/audio.h
+++ b/include/linux/dvb/audio.h
@@ -118,18 +118,6 @@ typedef __u16 audio_attributes_t;
 #define AUDIO_SET_ATTRIBUTES       _IOW('o', 17, audio_attributes_t)
 #define AUDIO_SET_KARAOKE          _IOW('o', 18, audio_karaoke_t)
 
-/**
- * AUDIO_GET_PTS
- *
- * Read the 33 bit presentation time stamp as defined
- * in ITU T-REC-H.222.0 / ISO/IEC 13818-1.
- *
- * The PTS should belong to the currently played
- * frame if possible, but may also be a value close to it
- * like the PTS of the last decoded frame or the last PTS
- * extracted by the PES parser.
- */
-#define AUDIO_GET_PTS              _IOR('o', 19, __u64)
 #define AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
 
 #endif /* _DVBAUDIO_H_ */
-- 
1.7.1


