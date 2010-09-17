Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0IQOzZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 10:55:25 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8HEtOJI002840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 17 Sep 2010 10:55:24 -0400
Message-ID: <4C938158.9020604@redhat.com>
Date: Fri, 17 Sep 2010 11:55:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH -hg] Warn user that driver is backported and might not work
 as expected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since the migration to -git, less developers are using the -hg tree. Also, some
changes are happening upstream that would require much more than just compiling
the tree with an older version, to be sure that the backport won't break anything,
like the removal of BKL.

As normal users might not be aware of those issues, and bug reports may be sent
based on a backported tree, add some messages to warn about the usage of a
backported experimental (unsupported) tree.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r 60edc4bd92b7 linux/drivers/media/dvb/dvb-core/dvbdev.c
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.c	Sun Jun 27 17:17:06 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c	Fri Sep 17 11:49:02 2010 -0300
@@ -521,6 +521,12 @@
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 31)
 	dvb_class->devnode = dvb_devnode;
 #endif
+#ifdef EXPERIMENTAL_TREE
+	printk(KERN_ERR "WARNING: You're using an experimental version of the DVB stack. As the driver\n"
+			"         is backported to an older kernel, it doesn't offer enough quality for\n"
+			"         its usage in production.\n"
+			"         Use it with care.\n");
+#endif
 	return 0;
 
 error:
diff -r 60edc4bd92b7 linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c	Sun Jun 27 17:17:06 2010 -0300
+++ b/linux/drivers/media/video/v4l2-dev.c	Fri Sep 17 11:49:02 2010 -0300
@@ -686,6 +686,12 @@
 	int ret;
 
 	printk(KERN_INFO "Linux video capture interface: v2.00\n");
+#ifdef EXPERIMENTAL_TREE
+	printk(KERN_ERR "WARNING: You're using an experimental version of the V4L stack. As the driver\n"
+			"         is backported to an older kernel, it doesn't offer enough quality for\n"
+			"         its usage in production.\n"
+			"         Use it with care.\n");
+#endif
 	ret = register_chrdev_region(dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
 	if (ret < 0) {
 		printk(KERN_WARNING "videodev: unable to get major %d\n",
diff -r 60edc4bd92b7 v4l/compat.h
--- a/v4l/compat.h	Sun Jun 27 17:17:06 2010 -0300
+++ b/v4l/compat.h	Fri Sep 17 11:49:02 2010 -0300
@@ -14,6 +14,8 @@
 #define INIT_DELAYED_WORK(a,b,c)	INIT_WORK(a,b,c)
 #endif
 
+#define EXPERIMENTAL_TREE
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 35)
 #define usb_buffer_alloc(dev, size, mem_flags, dma) usb_alloc_coherent(dev, size, mem_flags, dma)
 #define usb_buffer_free(dev, size, addr, dma) usb_free_coherent(dev, size, addr, dma)
diff -r 60edc4bd92b7 v4l/scripts/make_kconfig.pl
--- a/v4l/scripts/make_kconfig.pl	Sun Jun 27 17:17:06 2010 -0300
+++ b/v4l/scripts/make_kconfig.pl	Fri Sep 17 11:49:02 2010 -0300
@@ -671,4 +671,13 @@
 
 EOF2
 	}
+print << "EOF3";
+WARNING: This is the V4L/DVB backport tree, with experimental drivers
+	 backported to run on legacy kernels from the development tree at:
+		http://git.linuxtv.org/media-tree.git.
+	 It is generally safe to use it for testing a new driver or
+	 feature, but its usage on production environments is risky.
+	 Don't use it at production. You've being warned.
+EOF3
+	sleep 5;
 }
