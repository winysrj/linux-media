Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52038
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751473AbdFGMjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 08:39:05 -0400
Date: Wed, 7 Jun 2017 09:38:57 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] sir_ir: annotate hardware config module
 parameters
Message-ID: <20170607093857.6a3a5249@vento.lan>
In-Reply-To: <1496762299-29650-1-git-send-email-sean@mess.org>
References: <1496762299-29650-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  6 Jun 2017 16:18:19 +0100
Sean Young <sean@mess.org> escreveu:

> This module was merged after commit 5a8fc6a3cebb ("Annotate hardware
> config module parameters in drivers/media/"), so add add the missing
> hardware annotations.

This patch seems wrong:

drivers/media/rc/sir_ir.c:403:1: error: macro "module_param_hw" requires 4 arguments, but only 3 given
drivers/media/rc/sir_ir.c:406:1: error: macro "module_param_hw" requires 4 arguments, but only 3 given
drivers/media/tuners/r820t.c:2341 r820t_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/rc/sir_ir.c:403:30: error: macro "module_param_hw" requires 4 arguments, but only 3 given
 module_param_hw(io, int, 0444);
                              ^
drivers/media/rc/sir_ir.c:403:1: warning: data definition has no type or storage class
 module_param_hw(io, int, 0444);
 ^~~~~~~~~~~~~~~
drivers/media/rc/sir_ir.c:403:1: error: type defaults to 'int' in declaration of 'module_param_hw' [-Werror=implicit-int]
drivers/media/rc/sir_ir.c:406:31: error: macro "module_param_hw" requires 4 arguments, but only 3 given
 module_param_hw(irq, int, 0444);
                               ^
drivers/media/rc/sir_ir.c:406:1: warning: data definition has no type or storage class
 module_param_hw(irq, int, 0444);
 ^~~~~~~~~~~~~~~
drivers/media/rc/sir_ir.c:406:1: error: type defaults to 'int' in declaration of 'module_param_hw' [-Werror=implicit-int]

Please check.

Regards,
Mauro

Thanks,
Mauro
