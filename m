Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61Ckk7i005108
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:46:46 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61CkY7O021891
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:46:34 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2164461rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 05:46:33 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 01 Jul 2008 21:46:48 +0900
Message-Id: <20080701124648.30446.87596.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
Cc: linux-sh@vger.kernel.org, akpm@linux-foundation.org, lethal@linux-sh.org,
	mchehab@infradead.org
Subject: [PATCH 01/07] soc_camera: Remove default spinlock operations
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

This patch removes the default spinlock_alloc() and spinlock_free()
functions. The pxa_camera.c driver is providing it's own spinlock
callbacks anyway. With this patch spinlock callbacks are required
when registering the host.

This is ground work for the next per-host videobuf queue patch.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/soc_camera.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

--- 0001/drivers/media/video/soc_camera.c
+++ work/drivers/media/video/soc_camera.c	2008-06-12 14:05:36.000000000 +0900
@@ -776,27 +776,13 @@ static void dummy_release(struct device 
 {
 }
 
-static spinlock_t *spinlock_alloc(struct soc_camera_file *icf)
-{
-	spinlock_t *lock = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
-
-	if (lock)
-		spin_lock_init(lock);
-
-	return lock;
-}
-
-static void spinlock_free(spinlock_t *lock)
-{
-	kfree(lock);
-}
-
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	int ret;
 	struct soc_camera_host *ix;
 
-	if (!ici->vbq_ops || !ici->ops->add || !ici->ops->remove)
+	if (!ici->vbq_ops || !ici->ops->add || !ici->ops->remove
+	    || !ici->ops->spinlock_alloc)
 		return -EINVAL;
 
 	/* Number might be equal to the platform device ID */
@@ -821,11 +807,6 @@ int soc_camera_host_register(struct soc_
 	if (ret)
 		goto edevr;
 
-	if (!ici->ops->spinlock_alloc) {
-		ici->ops->spinlock_alloc = spinlock_alloc;
-		ici->ops->spinlock_free = spinlock_free;
-	}
-
 	scan_add_host(ici);
 
 	return 0;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
