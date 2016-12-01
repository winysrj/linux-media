Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933146AbcLAMdd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 07:33:33 -0500
Subject: [PATCH 29/39] Annotate hardware config module parameters in
 drivers/staging/media/
From: David Howells <dhowells@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gnomes@lxorguk.ukuu.org.uk,
        minyard@acm.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Thu, 01 Dec 2016 12:33:30 +0000
Message-ID: <148059561006.31612.6396069416948435055.stgit@warthog.procyon.org.uk>
In-Reply-To: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
References: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the kernel is running in secure boot mode, we lock down the kernel to
prevent userspace from modifying the running kernel image.  Whilst this
includes prohibiting access to things like /dev/mem, it must also prevent
access by means of configuring driver modules in such a way as to cause a
device to access or modify the kernel image.

To this end, annotate module_param* statements that refer to hardware
configuration and indicate for future reference what type of parameter they
specify.  The parameter parser in the core sees this information and can
skip such parameters with an error message if the kernel is locked down.
The module initialisation then runs as normal, but just sees whatever the
default values for those parameters is.

Note that we do still need to do the module initialisation because some
drivers have viable defaults set in case parameters aren't specified and
some drivers support automatic configuration (e.g. PNP or PCI) in addition
to manually coded parameters.

This patch annotates drivers in drivers/staging/media/.

Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mauro Carvalho Chehab <mchehab@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-media@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/staging/media/lirc/lirc_parallel.c |    4 ++--
 drivers/staging/media/lirc/lirc_serial.c   |   10 +++++-----
 drivers/staging/media/lirc/lirc_sir.c      |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index bfb76a45bfbf..65530e0a6d99 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -725,10 +725,10 @@ MODULE_DESCRIPTION("Infrared receiver driver for parallel ports.");
 MODULE_AUTHOR("Christoph Bartelmus");
 MODULE_LICENSE("GPL");
 
-module_param(io, int, S_IRUGO);
+module_param_hw(io, int, ioport, S_IRUGO);
 MODULE_PARM_DESC(io, "I/O address base (0x3bc, 0x378 or 0x278)");
 
-module_param(irq, int, S_IRUGO);
+module_param_hw(irq, int, irq, S_IRUGO);
 MODULE_PARM_DESC(irq, "Interrupt (7 or 5)");
 
 module_param(tx_mask, int, S_IRUGO);
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index b798b311d32c..ea3f735a196d 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1094,11 +1094,11 @@ MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,"
 		 " 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,"
 		 " 5 = NSLU2 RX:CTS2/TX:GreenLED)");
 
-module_param(io, int, S_IRUGO);
+module_param_hw(io, int, ioport, S_IRUGO);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
 /* some architectures (e.g. intel xscale) have memory mapped registers */
-module_param(iommap, bool, S_IRUGO);
+module_param_hw(iommap, bool, other, S_IRUGO);
 MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
 		" (0 = no memory mapped io)");
 
@@ -1107,13 +1107,13 @@ MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
  * on 32bit word boundaries.
  * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
  */
-module_param(ioshift, int, S_IRUGO);
+module_param_hw(ioshift, int, other, S_IRUGO);
 MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
 
-module_param(irq, int, S_IRUGO);
+module_param_hw(irq, int, irq, S_IRUGO);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
-module_param(share_irq, bool, S_IRUGO);
+module_param_hw (share_irq, bool, other, S_IRUGO);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
 module_param(sense, int, S_IRUGO);
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 4f326e97ad75..e27842e01fba 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -986,10 +986,10 @@ MODULE_AUTHOR("Milan Pikula");
 #endif
 MODULE_LICENSE("GPL");
 
-module_param(io, int, S_IRUGO);
+module_param_hw(io, int, ioport, S_IRUGO);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
-module_param(irq, int, S_IRUGO);
+module_param_hw(irq, int, irq, S_IRUGO);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
 module_param(threshold, int, S_IRUGO);

