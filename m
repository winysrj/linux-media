Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m432mc8B029462
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 22:48:38 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m432mREU000846
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 22:48:27 -0400
From: Andy Walls <awalls@radix.net>
To: ivtv-devel@ivtvdriver.org
In-Reply-To: <481B1027.1040002@linuxtv.org>
References: <481B1027.1040002@linuxtv.org>
Content-Type: multipart/mixed; boundary="=-PgDe57Bg0M2hzKC52DAk"
Date: Fri, 02 May 2008 22:43:27 -0400
Message-Id: <1209782607.27140.14.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] Fix potential cx18_cards[] entry leaks
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


--=-PgDe57Bg0M2hzKC52DAk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hans,

When investigating Mike Krufky's report of module reload problems, I ran
across problems with the management of the cx18_cards[] array.  They're
corner cases and not likely to be the cause of Mike problems though.

Upon error conditions in cx18_probe(), the code at the 'err:' label
could leak cx18_cards[] entries.  Not a big problem since there are 32
of them, but they could have caused a NULL pointer de-reference in
cx18_v4l2_open().

The attached patch fixes these and reworks the management of the
cx18_cards[] entries.  The cx18_active_cards variable is replaced with
cx18_highest_cards_index (because that's essentially what
cx18_active_cards_was doing +1), and cleanup of entries happens a little
more pedantically (obtaining the lock, and removing each entry on a pci
remove, instead of waiting until module unload).

The attached patch was made against the latest v4l-dvb hg repository.

Comments welcome.

Regards,
Andy

--=-PgDe57Bg0M2hzKC52DAk
Content-Disposition: attachment; filename=cx18-cards-leak2.patch
Content-Type: text/x-patch; name=cx18-cards-leak2.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Andy Walls <awalls@radix.net>
# Date 1209781272 14400
# Node ID cb8788a7039efb818fd8299d1fcbe8c8f20d3093
# Parent  4c4fd6b8755cc9918255876ff1010bc77374a310
Fix cx18_cards[] entry leak, and possible NULL dereference.


From: Andy Walls <awalls@radix.net>

The code at the err: label of cx18_probe() could leak cx18_card[] entries.
In cx18_v4l2_open() the leaked entries could cause NULL pointer derefernces.
Fixed these two problems and modified managment of the cx18_cards[] entries.
In the process, replaced the misnamed cx18_cards_active variable with a
cx18_highest_card_index variable, which was essentially the function of
cx18_cards_active anyway.


Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 4c4fd6b8755c -r cb8788a7039e linux/drivers/media/video/cx18/cx18-driver.c
--- a/linux/drivers/media/video/cx18/cx18-driver.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/video/cx18/cx18-driver.c	Fri May 02 22:21:12 2008 -0400
@@ -38,9 +38,6 @@
 #include <media/tveeprom.h>
 
 
-/* var to keep track of the number of array elements in use */
-int cx18_cards_active;
-
 /* If you have already X v4l cards, then set this to X. This way
    the device numbers stay matched. Example: you have a WinTV card
    without radio and a Compro H900 with. Normally this would give a
@@ -51,7 +48,10 @@ int cx18_first_minor;
 /* Master variable for all cx18 info */
 struct cx18 *cx18_cards[CX18_MAX_CARDS];
 
-/* Protects cx18_cards_active */
+/* Highest index used so far in cx18_cards[] */
+int cx18_highest_card_index = -1;
+
+/* Protects cx18_cards[] */
 DEFINE_SPINLOCK(cx18_cards_lock);
 
 /* add your revision and whatnot here */
@@ -594,20 +594,40 @@ static void cx18_load_and_init_modules(s
 	hw = cx->hw_flags;
 }
 
+static void cx18_cards_free_entry(struct cx18 *cx)
+{
+	int i = cx->num;
+
+	spin_lock(&cx18_cards_lock);
+
+	kfree(cx18_cards[i]); /* the passed in cx pointer is now invalid! */
+	cx18_cards[i] = NULL;
+
+	cx18_highest_card_index = -1;
+	for (i = 0; i < CX18_MAX_CARDS; i++)
+		if (cx18_cards[i] != NULL)
+			cx18_highest_card_index = i;
+
+	spin_unlock(&cx18_cards_lock);
+}
+
 static int __devinit cx18_probe(struct pci_dev *dev,
 				const struct pci_device_id *pci_id)
 {
 	int retval = 0;
 	int vbi_buf_size;
+	int i;
 	u32 devtype;
 	struct cx18 *cx;
 
 	spin_lock(&cx18_cards_lock);
 
 	/* Make sure we've got a place for this card */
-	if (cx18_cards_active == CX18_MAX_CARDS) {
-		printk(KERN_ERR "cx18:  Maximum number of cards detected (%d).\n",
-			      cx18_cards_active);
+	for (i = 0; i < CX18_MAX_CARDS && cx18_cards[i] != NULL; i++) {}
+
+	if (i == CX18_MAX_CARDS) {
+		printk(KERN_ERR
+		       "cx18:  Maximum number of cards detected (%d).\n", i);
 		spin_unlock(&cx18_cards_lock);
 		return -ENOMEM;
 	}
@@ -617,11 +637,15 @@ static int __devinit cx18_probe(struct p
 		spin_unlock(&cx18_cards_lock);
 		return -ENOMEM;
 	}
-	cx18_cards[cx18_cards_active] = cx;
+	cx18_cards[i] = cx;
 	cx->dev = dev;
-	cx->num = cx18_cards_active++;
+	cx->num = i;
 	snprintf(cx->name, sizeof(cx->name) - 1, "cx18-%d", cx->num);
 	CX18_INFO("Initializing card #%d\n", cx->num);
+
+	for (; i < CX18_MAX_CARDS; i++)
+		if (cx18_cards[i] != NULL)
+			cx18_highest_card_index = i;
 
 	spin_unlock(&cx18_cards_lock);
 
@@ -687,8 +711,6 @@ static int __devinit cx18_probe(struct p
 		CX18_ERR("Could not initialize i2c\n");
 		goto free_map;
 	}
-
-	CX18_DEBUG_INFO("Active card count: %d.\n", cx18_cards_active);
 
 	if (cx->card->hw_all & CX18_HW_TVEEPROM) {
 		/* Based on the model number the cardtype may be changed.
@@ -816,8 +838,7 @@ err:
 		retval = -ENODEV;
 	CX18_ERR("Error %d on initialization\n", retval);
 
-	kfree(cx18_cards[cx18_cards_active]);
-	cx18_cards[cx18_cards_active] = NULL;
+	cx18_cards_free_entry(cx);
 	return retval;
 }
 
@@ -918,6 +939,9 @@ static void cx18_remove(struct pci_dev *
 	pci_disable_device(cx->dev);
 
 	CX18_INFO("Removed %s, card #%d\n", cx->card_name, cx->num);
+
+	pci_set_drvdata(cx->dev, NULL);
+	cx18_cards_free_entry(cx);
 }
 
 /* define a pci_driver for card detection */
@@ -960,11 +984,15 @@ static void module_cleanup(void)
 
 	pci_unregister_driver(&cx18_pci_driver);
 
-	for (i = 0; i < cx18_cards_active; i++) {
+	spin_lock(&cx18_cards_lock);
+	for (i = 0; i <= cx18_highest_card_index; i++) {
 		if (cx18_cards[i] == NULL)
 			continue;
 		kfree(cx18_cards[i]);
-	}
+		cx18_cards[i] = NULL;
+	}
+	cx18_highest_card_index = -1;
+	spin_unlock(&cx18_cards_lock);
 }
 
 module_init(module_start);
diff -r 4c4fd6b8755c -r cb8788a7039e linux/drivers/media/video/cx18/cx18-driver.h
--- a/linux/drivers/media/video/cx18/cx18-driver.h	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/video/cx18/cx18-driver.h	Fri May 02 22:21:12 2008 -0400
@@ -449,7 +449,7 @@ struct cx18 {
 
 /* Globals */
 extern struct cx18 *cx18_cards[];
-extern int cx18_cards_active;
+extern int cx18_highest_card_index;
 extern int cx18_first_minor;
 extern spinlock_t cx18_cards_lock;
 
diff -r 4c4fd6b8755c -r cb8788a7039e linux/drivers/media/video/cx18/cx18-fileops.c
--- a/linux/drivers/media/video/cx18/cx18-fileops.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/video/cx18/cx18-fileops.c	Fri May 02 22:21:12 2008 -0400
@@ -694,7 +694,9 @@ int cx18_v4l2_open(struct inode *inode, 
 
 	/* Find which card this open was on */
 	spin_lock(&cx18_cards_lock);
-	for (x = 0; cx == NULL && x < cx18_cards_active; x++) {
+	for (x = 0; cx == NULL && x <= cx18_highest_card_index; x++) {
+		if (cx18_cards[x] == NULL)
+			continue;
 		/* find out which stream this open was on */
 		for (y = 0; y < CX18_MAX_STREAMS; y++) {
 			s = &cx18_cards[x]->streams[y];

--=-PgDe57Bg0M2hzKC52DAk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-PgDe57Bg0M2hzKC52DAk--
