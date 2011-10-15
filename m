Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:32881 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:55:14 -0400
Message-ID: <4E99F32F.6070101@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:55:11 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 6/7] staging/as102: cleanup - get rid of editor comments
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl>
In-Reply-To: <4E999733.2010802@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging/as102: cleanup - get rid of editor comments

Cleanup code: Delete vim formatting comments.

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>



diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_drv.c linux.as102.06-editor/drivers/staging/as102/as102_drv.c
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_drv.c	2011-10-14 23:20:05.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_drv.c	2011-10-14 23:42:30.000000000 +0200
@@ -356,5 +356,3 @@
  MODULE_DESCRIPTION(DRIVER_FULL_NAME);
  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Pierrick Hascoet<pierrick.hascoet@abilis.com>");
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_drv.h linux.as102.06-editor/drivers/staging/as102/as102_drv.h
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_drv.h	2011-10-14 22:21:58.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_drv.h	2011-10-14 23:42:40.000000000 +0200
@@ -143,5 +143,3 @@
  int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
  int as102_dvb_unregister_fe(struct dvb_frontend *dev);
  #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_fe.c linux.as102.06-editor/drivers/staging/as102/as102_fe.c
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_fe.c	2011-10-14 23:21:51.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_fe.c	2011-10-14 23:42:47.000000000 +0200
@@ -671,5 +671,3 @@
  	}
  }
  #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_fw.c linux.as102.06-editor/drivers/staging/as102/as102_fw.c
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_fw.c	2011-10-14 23:22:33.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_fw.c	2011-10-14 23:42:54.000000000 +0200
@@ -247,5 +247,3 @@
  	return errno;
  }
  #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_fw.h linux.as102.06-editor/drivers/staging/as102/as102_fw.h
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_fw.h	2011-10-14 23:38:24.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_fw.h	2011-10-14 23:43:00.000000000 +0200
@@ -36,5 +36,3 @@
  #ifdef __KERNEL__
  int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
  #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_usb_drv.c linux.as102.06-editor/drivers/staging/as102/as102_usb_drv.c
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_usb_drv.c	2011-10-14 23:23:14.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_usb_drv.c	2011-10-14 23:43:07.000000000 +0200
@@ -482,5 +482,3 @@
  }

  MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as102_usb_drv.h linux.as102.06-editor/drivers/staging/as102/as102_usb_drv.h
--- linux.as102.05-pragmapack/drivers/staging/as102/as102_usb_drv.h	2011-10-14 22:22:15.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as102_usb_drv.h	2011-10-14 23:43:13.000000000 +0200
@@ -61,4 +61,3 @@
  	struct as10x_cmd_t r;
  };
  #endif
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.as102.05-pragmapack/drivers/staging/as102/as10x_cmd.h linux.as102.06-editor/drivers/staging/as102/as10x_cmd.h
--- linux.as102.05-pragmapack/drivers/staging/as102/as10x_cmd.h	2011-10-14 23:39:06.000000000 +0200
+++ linux.as102.06-editor/drivers/staging/as102/as10x_cmd.h	2011-10-14 23:43:20.000000000 +0200
@@ -534,4 +534,3 @@
  }
  #endif
  #endif
-/* EOF - vim: set textwidth=80 ts=3 sw=3 sts=3 et: */





