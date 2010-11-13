Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:44007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0KMOe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 09:34:29 -0500
Message-ID: <4CDEA1EF.407@infradead.org>
Date: Sat, 13 Nov 2010 12:34:23 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Michael Hunold <michael@mihu.de>
Subject: Re: [PATCH 2/3] i2c: Drivers shouldn't include <linux/i2c-id.h>
References: <20101105210753.4d1a03bc@endymion.delvare>
In-Reply-To: <20101105210753.4d1a03bc@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-11-2010 18:07, Jean Delvare escreveu:
> Drivers don't need to include <linux/i2c-id.h>, especially not when
> they don't use anything that header file provides.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Michael Hunold <michael@mihu.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

I suspect that you want to include it via your tree, so:
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/media/common/saa7146_i2c.c    |    1 -
>  drivers/media/video/ir-kbd-i2c.c      |    1 -
>  drivers/staging/olpc_dcon/olpc_dcon.c |    1 -
>  3 files changed, 3 deletions(-)
> 
> --- linux-2.6.37-rc1.orig/drivers/media/common/saa7146_i2c.c	2010-11-02 09:19:35.000000000 +0100
> +++ linux-2.6.37-rc1/drivers/media/common/saa7146_i2c.c	2010-11-05 15:34:25.000000000 +0100
> @@ -391,7 +391,6 @@ static int saa7146_i2c_xfer(struct i2c_a
>  
>  /*****************************************************************************/
>  /* i2c-adapter helper functions                                              */
> -#include <linux/i2c-id.h>
>  
>  /* exported algorithm data */
>  static struct i2c_algorithm saa7146_algo = {
> --- linux-2.6.37-rc1.orig/drivers/media/video/ir-kbd-i2c.c	2010-11-02 09:19:35.000000000 +0100
> +++ linux-2.6.37-rc1/drivers/media/video/ir-kbd-i2c.c	2010-11-05 15:34:18.000000000 +0100
> @@ -44,7 +44,6 @@
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
> -#include <linux/i2c-id.h>
>  #include <linux/workqueue.h>
>  
>  #include <media/ir-core.h>
> --- linux-2.6.37-rc1.orig/drivers/staging/olpc_dcon/olpc_dcon.c	2010-11-02 09:19:37.000000000 +0100
> +++ linux-2.6.37-rc1/drivers/staging/olpc_dcon/olpc_dcon.c	2010-11-05 15:34:14.000000000 +0100
> @@ -17,7 +17,6 @@
>  #include <linux/console.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_device.h>
> -#include <linux/i2c-id.h>
>  #include <linux/pci.h>
>  #include <linux/pci_ids.h>
>  #include <linux/interrupt.h>
> 
> 

