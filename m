Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9NLhEH000352
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:21:43 -0500
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9NLUNg004098
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:21:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <e9f7514f435ad89666cd.1226272761@roadrunner.athome>
In-Reply-To: <patchbomb.1226272760@roadrunner.athome>
Date: Mon, 10 Nov 2008 00:19:21 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Cc: mchehab@infradead.org
Subject: [PATCH 1 of 2] cx88: disable audio thread
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
# Date 1217451009 -7200
# Node ID e9f7514f435ad89666cd12e8384d88114c21b5ee
# Parent  46604f47fca16225c854ad69c3d8a335c94d5448
cx88: disable audio thread

From: Marton Balint <cus@fazekas.hu>

The audio thread in the cx88 code is totally useless, because cx88_get_stereo
is not implemented correctly. Because of this, the audio thread occaisonally
sets the audio to MONO after starting a TV application. This patch disables the
audio thread by ifdefing out the relevant lines.

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 46604f47fca1 -r e9f7514f435a linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Jul 30 22:50:09 2008 +0200
@@ -970,7 +970,7 @@
 	}
 	return;
 }
-
+#if 0
 int cx88_audio_thread(void *data)
 {
 	struct cx88_core *core = data;
@@ -1008,6 +1008,7 @@
 	dprintk("cx88: tvaudio thread exiting\n");
 	return 0;
 }
+#endif
 
 /* ----------------------------------------------------------- */
 
@@ -1015,7 +1016,9 @@
 EXPORT_SYMBOL(cx88_newstation);
 EXPORT_SYMBOL(cx88_set_stereo);
 EXPORT_SYMBOL(cx88_get_stereo);
+#if 0
 EXPORT_SYMBOL(cx88_audio_thread);
+#endif
 
 /*
  * Local variables:
diff -r 46604f47fca1 -r e9f7514f435a linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Wed Jul 30 22:50:09 2008 +0200
@@ -2229,6 +2229,7 @@
 	cx88_video_mux(core,0);
 	mutex_unlock(&core->lock);
 
+	#if 0
 	/* start tvaudio thread */
 	if (core->board.tuner_type != TUNER_ABSENT) {
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
@@ -2238,6 +2239,7 @@
 			       core->name, err);
 		}
 	}
+	#endif
 	return 0;
 
 fail_unreg:
@@ -2255,12 +2257,13 @@
 	struct cx8800_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
 
+#if 0
 	/* stop thread */
 	if (core->kthread) {
 		kthread_stop(core->kthread);
 		core->kthread = NULL;
 	}
-
+#endif
 	if (core->ir)
 		cx88_ir_stop(core, core->ir);
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
