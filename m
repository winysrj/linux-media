Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q2EqK5006617
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:52 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q2EL5t006643
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 33ACD33CC8
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:14:20 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UBKxDKTDUvDc for <video4linux-list@redhat.com>;
	Wed, 26 Mar 2008 03:14:13 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <54d0fc010ab0225fbed9.1206497255@bluegene.athome>
In-Reply-To: <patchbomb.1206497254@bluegene.athome>
Date: Wed, 26 Mar 2008 03:07:35 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Subject: [PATCH 1 of 3] cx88: fix oops on module removal caused by IR worker
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
# Date 1206487800 -3600
# Node ID 54d0fc010ab0225fbed97df3267d26e91aa03a2a
# Parent  cc6c65fe4ce0543e14afdd2b850c991081f7b9ac
cx88: fix oops on module removal caused by IR worker

From: Marton Balint <cus@fazekas.hu>

If the IR worker is not stopped before the removal of the cx88xx module,
an OOPS may occur, because the worker function cx88_ir_work gets called.
So stop the ir worker.


Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r cc6c65fe4ce0 -r 54d0fc010ab0 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Tue Mar 25 14:33:20 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Wed Mar 26 00:30:00 2008 +0100
@@ -2221,6 +2221,9 @@ static void __devexit cx8800_finidev(str
 		core->kthread = NULL;
 	}
 
+	if (core->ir)
+		cx88_ir_stop(core, core->ir);
+
 	cx88_shutdown(core); /* FIXME */
 	pci_disable_device(pci_dev);
 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
