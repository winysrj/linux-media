Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q2EqW2006615
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:52 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q2ELui006641
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 6677B33CC5
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:14:20 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AODSlUasxKxv for <video4linux-list@redhat.com>;
	Wed, 26 Mar 2008 03:14:13 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <2c020dc87db5511e6cba.1206497256@bluegene.athome>
In-Reply-To: <patchbomb.1206497254@bluegene.athome>
Date: Wed, 26 Mar 2008 03:07:36 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Subject: [PATCH 2 of 3] cx88: fix stereo dematrix for A2 sound system
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1206488442 -3600
# Node ID 2c020dc87db5511e6cbaae05389e3bda225d4879
# Parent  54d0fc010ab0225fbed97df3267d26e91aa03a2a
cx88: fix stereo dematrix for A2 sound system

From: Marton Balint <cus@fazekas.hu>

Using A2 sound system, in stereo mode, the first sound channel is L+R, the
second channel is 2*R. So the dematrix control should be SUMR instead of
SUMDIFF. Let's use SUMR for stereo mode, and use SUMDIFF for everything
else, just like before.

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 54d0fc010ab0 -r 2c020dc87db5 linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Mar 26 00:30:00 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Mar 26 00:40:42 2008 +0100
@@ -632,7 +632,12 @@ static void set_audio_standard_A2(struct
 		break;
 	};
 
-	mode |= EN_FMRADIO_EN_RDS | EN_DMTRX_SUMDIFF;
+	mode |= EN_FMRADIO_EN_RDS;
+	if ((mode & 0x3f) == EN_A2_FORCE_STEREO)
+		mode |= EN_DMTRX_SUMR;
+	else
+		mode |= EN_DMTRX_SUMDIFF;
+
 	set_audio_finish(core, mode);
 }
 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
