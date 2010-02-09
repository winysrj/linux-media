Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.crc.dk ([130.226.184.8]:38814 "EHLO mail.crc.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0BIMNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 07:13:55 -0500
Message-ID: <4B71517A.5040100@lemo.dk>
Date: Tue, 09 Feb 2010 13:13:46 +0100
From: Mogens Kjaer <mk@lemo.dk>
MIME-Version: 1.0
To: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: Compiling saa7134 on a CentOS 5 machine
References: <4B7149E0.80607@lemo.dk>
In-Reply-To: <4B7149E0.80607@lemo.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2010 12:41 PM, Mogens Kjaer wrote:
...
> ir_core: Unknown symbol ir_unregister_class

Hm, the following patch "fixes" the problem:

cd linux/drivers/media/IR
$ diff -urN ir-sysfs.c.orig ir-sysfs.c
--- ir-sysfs.c.orig     2010-02-09 13:08:06.000000000 +0100
+++ ir-sysfs.c  2010-02-09 13:05:04.000000000 +0100
@@ -223,4 +223,8 @@

  module_init(ir_core_init);
  module_exit(ir_core_exit);
+#else
+void ir_unregister_class(struct input_dev *input_dev)
+{
+}
  #endif

I guess this is not the right way to do it - but
the machine boots and the modules load!

Mogens

-- 
Mogens Kjaer, mk@lemo.dk
http://www.lemo.dk
