Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54603 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdFGSF3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 14:05:29 -0400
Date: Wed, 7 Jun 2017 19:05:27 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] sir_ir: annotate hardware config module
 parameters
Message-ID: <20170607180527.GA14891@gofer.mess.org>
References: <1496762299-29650-1-git-send-email-sean@mess.org>
 <20170607093857.6a3a5249@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607093857.6a3a5249@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 07, 2017 at 09:38:57AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue,  6 Jun 2017 16:18:19 +0100
> Sean Young <sean@mess.org> escreveu:
> 
> > This module was merged after commit 5a8fc6a3cebb ("Annotate hardware
> > config module parameters in drivers/media/"), so add add the missing
> > hardware annotations.
> 
> This patch seems wrong:
> 
> drivers/media/rc/sir_ir.c:403:1: error: macro "module_param_hw" requires 4 arguments, but only 3 given
> drivers/media/rc/sir_ir.c:406:1: error: macro "module_param_hw" requires 4 arguments, but only 3 given
> drivers/media/tuners/r820t.c:2341 r820t_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
> drivers/media/rc/sir_ir.c:403:30: error: macro "module_param_hw" requires 4 arguments, but only 3 given
>  module_param_hw(io, int, 0444);
>                               ^
> drivers/media/rc/sir_ir.c:403:1: warning: data definition has no type or storage class
>  module_param_hw(io, int, 0444);
>  ^~~~~~~~~~~~~~~
> drivers/media/rc/sir_ir.c:403:1: error: type defaults to 'int' in declaration of 'module_param_hw' [-Werror=implicit-int]
> drivers/media/rc/sir_ir.c:406:31: error: macro "module_param_hw" requires 4 arguments, but only 3 given
>  module_param_hw(irq, int, 0444);
>                                ^
> drivers/media/rc/sir_ir.c:406:1: warning: data definition has no type or storage class
>  module_param_hw(irq, int, 0444);
>  ^~~~~~~~~~~~~~~
> drivers/media/rc/sir_ir.c:406:1: error: type defaults to 'int' in declaration of 'module_param_hw' [-Werror=implicit-int]
> 
> Please check.

Oh dear, that's embarrassing. :(

Sean

From: Sean Young <sean@mess.org>
Subject: [PATCH] [media] sir_ir: annotate hardware config module parameters

This module was merged after commit 5a8fc6a3cebb ("Annotate hardware
config module parameters in drivers/media/"), so add add the missing
hardware annotations.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 5ee3a23..20234ba 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -400,10 +400,10 @@ MODULE_DESCRIPTION("Infrared receiver driver for SIR type serial ports");
 MODULE_AUTHOR("Milan Pikula");
 MODULE_LICENSE("GPL");
 
-module_param(io, int, 0444);
+module_param_hw(io, int, ioport, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
-module_param(irq, int, 0444);
+module_param_hw(irq, int, irq, 0444);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
 module_param(threshold, int, 0444);
-- 
2.9.4
