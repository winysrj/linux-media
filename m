Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IFMkel001603
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 11:22:46 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IFMYXS014022
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 11:22:35 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KJrmz-0002nt-Vz
	for video4linux-list@redhat.com; Fri, 18 Jul 2008 15:22:33 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 15:22:33 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 15:22:33 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Fri, 18 Jul 2008 18:22:25 +0300
Message-ID: <g5qcfh$clp$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [PATCH] videobuf-vmallloc: cleanup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0418579546=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--===============0418579546==
Content-Type: text/x-patch;
 name="videobuf-vmalloc_cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="videobuf-vmalloc_cleanup.patch"

videobuf-vmalloc cleanup:
- remove not used MAGIC_DMABUF define
- remove not needed return;
- remove dead code (#if 0 and etc.)
- remove editor settings
- reorganize __videobuf_mmap_free()

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Index: linux-2.6/drivers/media/video/videobuf-vmalloc.c
===================================================================
--- linux-2.6.orig/drivers/media/video/videobuf-vmalloc.c
+++ linux-2.6/drivers/media/video/videobuf-vmalloc.c
@@ -27,7 +27,6 @@
 
 #include <media/videobuf-vmalloc.h>
 
-#define MAGIC_DMABUF   0x17760309
 #define MAGIC_VMAL_MEM 0x18221223
 
 #define MAGIC_CHECK(is,should)	if (unlikely((is) != (should))) \
@@ -46,8 +45,7 @@ MODULE_LICENSE("GPL");
 
 /***************************************************************************/
 
-static void
-videobuf_vm_open(struct vm_area_struct *vma)
+static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 
@@ -112,8 +110,6 @@ static void videobuf_vm_close(struct vm_
 
 		mutex_unlock(&q->vb_lock);
 	}
-
-	return;
 }
 
 static struct vm_operations_struct videobuf_vm_ops =
@@ -175,12 +171,10 @@ static int __videobuf_iolock (struct vid
 
 		dprintk(1, "%s memory method USERPTR\n", __func__);
 
-#if 1
 		if (vb->baddr) {
 			printk(KERN_ERR "USERPTR is currently not supported\n");
 			return -EINVAL;
 		}
-#endif
 
 		/* The only USERPTR currently supported is the one needed for
 		   read() method.
@@ -194,25 +188,6 @@ static int __videobuf_iolock (struct vid
 		dprintk(1, "vmalloc is at addr %p (%d pages)\n",
 			mem->vmalloc, pages);
 
-#if 0
-		int rc;
-		/* Kernel userptr is used also by read() method. In this case,
-		   there's no need to remap, since data will be copied to user
-		 */
-		if (!vb->baddr)
-			return 0;
-
-		/* FIXME: to properly support USERPTR, remap should occur.
-		   The code bellow won't work, since mem->vma = NULL
-		 */
-		/* Try to remap memory */
-		rc = remap_vmalloc_range(mem->vma, (void *)vb->baddr, 0);
-		if (rc < 0) {
-			printk(KERN_ERR "mmap: remap failed with error %d. ", rc);
-			return -ENOMEM;
-		}
-#endif
-
 		break;
 	case V4L2_MEMORY_OVERLAY:
 	default:
@@ -237,12 +212,9 @@ static int __videobuf_mmap_free(struct v
 	unsigned int i;
 
 	dprintk(1, "%s\n", __func__);
-	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (q->bufs[i]) {
-			if (q->bufs[i]->map)
-				return -EBUSY;
-		}
-	}
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		if (q->bufs[i] && q->bufs[i]->map)
+			return -EBUSY;
 
 	return 0;
 }
@@ -435,13 +407,5 @@ void videobuf_vmalloc_free (struct video
 
 	vfree(mem->vmalloc);
 	mem->vmalloc = NULL;
-
-	return;
 }
 EXPORT_SYMBOL_GPL(videobuf_vmalloc_free);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */

--===============0418579546==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0418579546==--
