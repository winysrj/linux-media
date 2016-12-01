Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57660
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757357AbcLAOy3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 09:54:29 -0500
Date: Thu, 1 Dec 2016 12:54:20 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gnomes@lxorguk.ukuu.org.uk, minyard@acm.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 29/39] Annotate hardware config module parameters in
 drivers/staging/media/
Message-ID: <20161201125420.5b397933@vento.lan>
In-Reply-To: <148059561006.31612.6396069416948435055.stgit@warthog.procyon.org.uk>
References: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
        <148059561006.31612.6396069416948435055.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 01 Dec 2016 12:33:30 +0000
David Howells <dhowells@redhat.com> escreveu:

> When the kernel is running in secure boot mode, we lock down the kernel to
> prevent userspace from modifying the running kernel image.  Whilst this
> includes prohibiting access to things like /dev/mem, it must also prevent
> access by means of configuring driver modules in such a way as to cause a
> device to access or modify the kernel image.
> 
> To this end, annotate module_param* statements that refer to hardware
> configuration and indicate for future reference what type of parameter they
> specify.  The parameter parser in the core sees this information and can
> skip such parameters with an error message if the kernel is locked down.
> The module initialisation then runs as normal, but just sees whatever the
> default values for those parameters is.
> 
> Note that we do still need to do the module initialisation because some
> drivers have viable defaults set in case parameters aren't specified and
> some drivers support automatic configuration (e.g. PNP or PCI) in addition
> to manually coded parameters.
> 
> This patch annotates drivers in drivers/staging/media/.
> 
> Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-media@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Tried to apply here, but got some errors:


drivers/staging/media/lirc/lirc_parallel.c:728:19: error: Expected ) in function declarator
drivers/staging/media/lirc/lirc_parallel.c:728:19: error: got ,
drivers/staging/media/lirc/lirc_parallel.c:731:20: error: Expected ) in function declarator
drivers/staging/media/lirc/lirc_parallel.c:731:20: error: got ,
drivers/staging/media/lirc/lirc_sir.c:989:19: error: Expected ) in function declarator
drivers/staging/media/lirc/lirc_sir.c:989:19: error: got ,
drivers/staging/media/lirc/lirc_sir.c:992:20: error: Expected ) in function declarator
drivers/staging/media/lirc/lirc_sir.c:992:20: error: got ,
drivers/staging/media/lirc/lirc_sir.c:989:21: error: expected ')' before 'int'
 module_param_hw(io, int, ioport, S_IRUGO);
                     ^~~
drivers/staging/media/lirc/lirc_sir.c:992:22: error: expected ')' before 'int'
 module_param_hw(irq, int, irq, S_IRUGO);
                      ^~~
scripts/Makefile.build:293: recipe for target 'drivers/staging/media/lirc/lirc_sir.o' failed
make[2]: *** [drivers/staging/media/lirc/lirc_sir.o] Error 1
make[2]: *** Waiting for unfinished jobs....
drivers/staging/media/lirc/lirc_parallel.c:728:21: error: expected ')' before 'int'
 module_param_hw(io, int, ioport, S_IRUGO);
                     ^~~
drivers/staging/media/lirc/lirc_parallel.c:731:22: error: expected ')' before 'int'
 module_param_hw(irq, int, irq, S_IRUGO);
                      ^~~
scripts/Makefile.build:293: recipe for target 'drivers/staging/media/lirc/lirc_parallel.o' failed
make[2]: *** [drivers/staging/media/lirc/lirc_parallel.o] Error 1
scripts/Makefile.build:544: recipe for target 'drivers/staging/media/lirc' failed
make[1]: *** [drivers/staging/media/lirc] Error 2
Makefile:1485: recipe for target '_module_drivers/staging/media' failed
make: *** [_module_drivers/staging/media] Error 2



> ---
> 
>  drivers/staging/media/lirc/lirc_parallel.c |    4 ++--
>  drivers/staging/media/lirc/lirc_serial.c   |   10 +++++-----

Btw, this got moved to another place, and had some patch getting rid
of those really ugly S_IRUGO & friend macros.

I rebased it to apply over the top of the media tree, but I suspect
it requires some other patch to be applied adding the new macro.

I'm enclosing the rebased patch as reference.

Regards,
Mauro

[PATCH] [media] Annotate hardware config module parameters in drivers/staging/media/

From: David Howells <dhowells@redhat.com>

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

[mchehab@s-opensource.com: fixed merge conflicts at serial_ir.c]
Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 436bd58b5f05..b7e44461de4a 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -811,11 +811,11 @@ MODULE_LICENSE("GPL");
 module_param(type, int, 0444);
 MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo, 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug");
 
-module_param(io, int, 0444);
+module_param_hw(io, int, ioport, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
 /* some architectures (e.g. intel xscale) have memory mapped registers */
-module_param(iommap, bool, 0444);
+module_param_hw(iommap, bool, other, 0444);
 MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
 
 /*
@@ -823,13 +823,13 @@ MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory map
  * on 32bit word boundaries.
  * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
  */
-module_param(ioshift, int, 0444);
+module_param_hw(ioshift, int, other, 0444);
 MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
 
-module_param(irq, int, 0444);
+module_param_hw(irq, int, irq, 0444);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
-module_param(share_irq, bool, 0444);
+module_param_hw (share_irq, bool, other, 0444);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
 module_param(sense, int, 0444);
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





Thanks,
Mauro
