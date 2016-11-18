Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34913 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753338AbcKRW1r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 17:27:47 -0500
Date: Fri, 18 Nov 2016 22:27:42 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH 08/35] [media] cx88: convert it to use pr_foo() macros
Message-ID: <20161118222742.GG26324@dell-m4800.home>
References: <cover.1479314177.git.mchehab@s-opensource.com>
 <cf30cb9b17879d4496c627501b35d85c34247084.1479314177.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf30cb9b17879d4496c627501b35d85c34247084.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 16, 2016 at 02:42:40PM -0200, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Instead of calling printk() directly, use pr_foo()
> macros, as suggested at the Kernel's coding style.
> 
> Please notice that a conversion to dev_foo() is not trivial,
> as several parts on this driver uses pr_cont().

Haven't followed closely the current discussion about line continuation,
so commenting on logical part is not up to me, at last I don't see
anything weird. So I will be an alignment-proofreading monkey :)

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Andrey Utkin <andrey_utkin@fastmail.com>

> --- a/drivers/media/pci/cx88/cx88-cards.c
> +++ b/drivers/media/pci/cx88/cx88-cards.c

> @@ -3646,8 +3626,8 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
>  		pci_write_config_byte(pci, CX88X_DEVCTRL, value);
>  	}
>  	if (UNSET != lat) {
> -		printk(KERN_INFO "%s: setting pci latency timer to %d\n",
> -		       name, latency);
> +		pr_info("setting pci latency timer to %d\n",
> +			latency);

Can fit single line.
This wasn't handled by checkpatch in next patch, so manual fix would be
nice.

> --- a/drivers/media/pci/cx88/cx88-core.c
> +++ b/drivers/media/pci/cx88/cx88-core.c

> @@ -60,10 +61,15 @@ static unsigned int nocomb;
>  module_param(nocomb,int,0644);
>  MODULE_PARM_DESC(nocomb,"disable comb filter");
>  
> -#define dprintk(level,fmt, arg...)	do {				\
> -	if (cx88_core_debug >= level)					\
> -		printk(KERN_DEBUG "%s: " fmt, core->name , ## arg);	\
> -	} while(0)
> +#define dprintk0(fmt, arg...)				\
> +	printk(KERN_DEBUG pr_fmt("%s: core:" fmt),	\
> +		__func__, ##arg)			\
> +

Could fit single line

> @@ -399,12 +405,12 @@ static int cx88_risc_decode(u32 risc)
>  	};
>  	int i;
>  
> -	printk(KERN_DEBUG "0x%08x [ %s", risc,
> +	dprintk0("0x%08x [ %s", risc,
>  	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");

Alignment got broken here and in quite some similar places :(
And checkpatch hasn't gone after it. What if you run it with --strict
--fix-inplace to make it check brace alignment and fix it at once?

And then make sure to run it again because it seems to fix one error at
a time.
