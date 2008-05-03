Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m43DcfcE002736
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 09:38:41 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m43Dc8Dc012373
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 09:38:08 -0400
From: Andy Walls <awalls@radix.net>
To: ivtv-devel@ivtvdriver.org
In-Reply-To: <1209782607.27140.14.camel@palomino.walls.org>
References: <481B1027.1040002@linuxtv.org>
	<1209782607.27140.14.camel@palomino.walls.org>
Content-Type: multipart/mixed; boundary="=-jNysbVFJd2P30SoL5lI9"
Date: Sat, 03 May 2008 09:33:05 -0400
Message-Id: <1209821585.12959.10.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] 2nd try: Fix potential cx18_cards[] entry leaks
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


--=-jNysbVFJd2P30SoL5lI9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2008-05-02 at 22:43 -0400, Andy Walls wrote:
> Hans,
> 
> When investigating Mike Krufky's report of module reload problems, I ran
> across problems with the management of the cx18_cards[] array.  They're
> corner cases and not likely to be the cause of Mike problems though.


> The attached patch was made against the latest v4l-dvb hg repository.

This is a new version of the patch.  The previous version would change
card minor number ordering upon errors, which is not what users with a
number of cards and multiple video sources wired up would want to
happen.

This new patch is almost a minimal set of changes to fix the
cx18_cards[] leak and possible bad pointers being left in cx18_cards[]
on error.  It does include some additional lines to obtain the
cx18_cards_lock when accessing cx18_cards[] and not just
cx18_cards_active.

Regards,
Andy

--=-jNysbVFJd2P30SoL5lI9
Content-Disposition: attachment; filename=cx18-cards-leak3.patch
Content-Type: text/x-patch; name=cx18-cards-leak3.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Andy Walls <awalls@radix.net>
# Date 1209820624 14400
# Node ID 2f883fedfb85c1979d9352ffdcf97a2d901dfbeb
# Parent  4c4fd6b8755cc9918255876ff1010bc77374a310
Prevent cx18_cards[] leak and possible bad pointer dereference

From: Andy Walls <awalls@radix.net>

The code at label 'err:' in cx18_probe() would try and free the wrong
cx18_cards[] entry on error exit, and leave a bad pointer in place.

cx18_v4l2_open() could have derefernced this bad pointer or NULL pointer
after the fix, so fixed that as well.

Obtained spin lock in all places where cx18_cards[] is accessed, not just where
cx18_cards_active is accessed.


Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 4c4fd6b8755c -r 2f883fedfb85 linux/drivers/media/video/cx18/cx18-driver.c
--- a/linux/drivers/media/video/cx18/cx18-driver.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/video/cx18/cx18-driver.c	Sat May 03 09:17:04 2008 -0400
@@ -598,6 +598,7 @@ static int __devinit cx18_probe(struct p
 				const struct pci_device_id *pci_id)
 {
 	int retval = 0;
+	int i;
 	int vbi_buf_size;
 	u32 devtype;
 	struct cx18 *cx;
@@ -816,8 +817,11 @@ err:
 		retval = -ENODEV;
 	CX18_ERR("Error %d on initialization\n", retval);
 
-	kfree(cx18_cards[cx18_cards_active]);
-	cx18_cards[cx18_cards_active] = NULL;
+	spin_lock(&cx18_cards_lock);
+	i = cx->num;
+	kfree(cx18_cards[i]);
+	cx18_cards[i] = NULL;
+	spin_unlock(&cx18_cards_lock);
 	return retval;
 }
 
@@ -960,11 +964,14 @@ static void module_cleanup(void)
 
 	pci_unregister_driver(&cx18_pci_driver);
 
+	spin_lock(&cx18_cards_lock);
 	for (i = 0; i < cx18_cards_active; i++) {
 		if (cx18_cards[i] == NULL)
 			continue;
 		kfree(cx18_cards[i]);
-	}
+		cx18_cards[i] = NULL;
+	}
+	spin_unlock(&cx18_cards_lock);
 }
 
 module_init(module_start);
diff -r 4c4fd6b8755c -r 2f883fedfb85 linux/drivers/media/video/cx18/cx18-fileops.c
--- a/linux/drivers/media/video/cx18/cx18-fileops.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/video/cx18/cx18-fileops.c	Sat May 03 09:17:04 2008 -0400
@@ -695,6 +695,8 @@ int cx18_v4l2_open(struct inode *inode, 
 	/* Find which card this open was on */
 	spin_lock(&cx18_cards_lock);
 	for (x = 0; cx == NULL && x < cx18_cards_active; x++) {
+		if (cx18_cards[x] == NULL)
+			continue;
 		/* find out which stream this open was on */
 		for (y = 0; y < CX18_MAX_STREAMS; y++) {
 			s = &cx18_cards[x]->streams[y];

--=-jNysbVFJd2P30SoL5lI9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-jNysbVFJd2P30SoL5lI9--
