Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:61695 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0EVU7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 16:59:30 -0400
Date: Sat, 22 May 2010 22:59:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] video/saa7134: potential null dereferences in debug
 code
Message-ID: <20100522225921.585b2d72@hyperion.delvare>
In-Reply-To: <20100522201535.GI22515@bicker>
References: <20100522201535.GI22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Sat, 22 May 2010 22:15:35 +0200, Dan Carpenter wrote:
> I modified the dprintk and i2cdprintk macros to handle null dev and ir
> pointers.  There are two couple places that call dprintk() when "dev" is
> null.  One is in get_key_msi_tvanywhere_plus() and the other is in
> get_key_flydvb_trio(). 
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
> index e5565e2..e14f2f8 100644
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -61,9 +61,9 @@ MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
>      "alternative remotes from other manufacturers");
>  
>  #define dprintk(fmt, arg...)	if (ir_debug) \
> -	printk(KERN_DEBUG "%s/ir: " fmt, dev->name , ## arg)
> +	printk(KERN_DEBUG "%s/ir: " fmt, dev ? dev->name : "<null>", ## arg)
>  #define i2cdprintk(fmt, arg...)    if (ir_debug) \
> -	printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg)
> +	printk(KERN_DEBUG "%s/ir: " fmt, ir ? ir->name : "<null>", ## arg)
>  
>  /* Helper functions for RC5 and NEC decoding at GPIO16 or GPIO18 */
>  static int saa7134_rc5_irq(struct saa7134_dev *dev);

I would have used "(null)" instead of "<null>" for consistency with
lib/vsprintf.c:string().

But more importantly, I suspect that a better fix would be to not call
these macros when dev or ir, respectively, is NULL. The faulty dprintk
calls in get_key_msi_tvanywhere_plus() and get_key_flydvb_trio() could
be replaced with i2cdprintk (which is misnamed IMHO, BTW.)

-- 
Jean Delvare
