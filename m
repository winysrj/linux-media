Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49529 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZHQFq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 01:46:59 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Mon, 17 Aug 2009 11:16:49 +0530
Subject: RE: [PATCH v1 - 4/5] V4L : vpif updates for DM6467 vpif capture
 driver
Message-ID: <19F8576C6E063C45BE387C64729E73940432B7A88D@dbde02.ent.ti.com>
References: <1250283745-5671-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1250283745-5671-1-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quick review comments below -

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
> Sent: Saturday, August 15, 2009 2:32 AM
> To: linux-media@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com;
> hverkuil@xs4all.nl; Karicheri, Muralidharan
> Subject: [PATCH v1 - 4/5] V4L : vpif updates for DM6467 vpif capture
> driver
> 
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Following changes done for vpif driver to support vpif capture:-
> 	1) Current version of display driver defined vpif register
> 	   space as part for vpif display platform driver resource
> 	   This is not correct since vpif is common across capture
> 	   and display drivers. So the resource iomap function is
> 	   moved to this module
> 	2) Since there are common registers, a spinlock is added for
> 	   mutual exclusion.
> 
> This has incorporated comments against version v0 of the patch
> series
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to V4L-DVB linux-next repository
>  drivers/media/video/davinci/vpif.c |   76
> ++++++++++++++++++++++++++++++++---
>  drivers/media/video/davinci/vpif.h |   48 ++++++++++++++---------
>  2 files changed, 98 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif.c
> b/drivers/media/video/davinci/vpif.c
> index aa77126..3b8eac3 100644
> --- a/drivers/media/video/davinci/vpif.c
> +++ b/drivers/media/video/davinci/vpif.c
> @@ -19,7 +19,11 @@
> 
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
>  #include <linux/kernel.h>
> +#include <linux/io.h>
[Hiremath, Vaibhav] You may want to put one line gap here.
> +#include <mach/hardware.h>
> 
>  #include "vpif.h"
> 
> @@ -31,6 +35,12 @@ MODULE_LICENSE("GPL");
>  #define VPIF_CH2_MAX_MODES	(15)
>  #define VPIF_CH3_MAX_MODES	(02)
> 
> +static resource_size_t	res_len;
> +static struct resource	*res;
[Hiremath, Vaibhav] Do we really require this to be static variable?
I think we can manage it to be local variable.

> +spinlock_t vpif_lock;
> +
> +void __iomem *vpif_base;
> +
>  static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
>  {
>  	if (val)
> @@ -151,17 +161,17 @@ static void config_vpif_params(struct
> vpif_params *vpifparams,
>  		else if (config->capture_format) {
>  			/* Set the polarity of various pins */
>  			vpif_wr_bit(reg, VPIF_CH_FID_POLARITY_BIT,
> -					vpifparams-
> >params.raw_params.fid_pol);
> +					vpifparams->iface.fid_pol);
>  			vpif_wr_bit(reg, VPIF_CH_V_VALID_POLARITY_BIT,
> -					vpifparams->params.raw_params.vd_pol);
> +					vpifparams->iface.vd_pol);
>  			vpif_wr_bit(reg, VPIF_CH_H_VALID_POLARITY_BIT,
> -					vpifparams->params.raw_params.hd_pol);
> +					vpifparams->iface.hd_pol);
> 
>  			value = regr(reg);
>  			/* Set data width */
>  			value &= ((~(unsigned int)(0x3)) <<
>  					VPIF_CH_DATA_WIDTH_BIT);
> -			value |= ((vpifparams->params.raw_params.data_sz)
> <<
> +			value |= ((vpifparams->params.data_sz) <<
>  						     VPIF_CH_DATA_WIDTH_BIT);
>  			regw(value, reg);
>  		}
> @@ -227,8 +237,60 @@ int vpif_channel_getfid(u8 channel_id)
>  }
>  EXPORT_SYMBOL(vpif_channel_getfid);
> 
> -void vpif_base_addr_init(void __iomem *base)
> +static int __init vpif_probe(struct platform_device *pdev)
> +{
> +	int status = 0;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	res_len = res->end - res->start + 1;
> +
> +	res = request_mem_region(res->start, res_len, res->name);
> +	if (!res)
> +		return -EBUSY;
> +
> +	vpif_base = ioremap(res->start, res_len);
> +	if (!vpif_base) {
> +		status = -EBUSY;
> +		goto fail;
> +	}
> +
> +	spin_lock_init(&vpif_lock);
> +	dev_info(&pdev->dev, "vpif probe success\n");
> +	return 0;
> +
> +fail:
> +	release_mem_region(res->start, res_len);
> +	return status;
> +}
> +
> +static int vpif_remove(struct platform_device *pdev)
>  {
> -	vpif_base = base;
> +	iounmap(vpif_base);
> +	release_mem_region(res->start, res_len);
> +	return 0;
>  }
> -EXPORT_SYMBOL(vpif_base_addr_init);
> +
> +static struct platform_driver vpif_driver = {
> +	.driver = {
> +		.name	= "vpif",
> +		.owner = THIS_MODULE,
> +	},
> +	.remove = __devexit_p(vpif_remove),
> +	.probe = vpif_probe,
> +};
> +
> +static void vpif_exit(void)
> +{
> +	platform_driver_unregister(&vpif_driver);
> +}
> +
> +static int __init vpif_init(void)
> +{
> +	return platform_driver_register(&vpif_driver);
> +}
> +subsys_initcall(vpif_init);
> +module_exit(vpif_exit);
> +
> diff --git a/drivers/media/video/davinci/vpif.h
> b/drivers/media/video/davinci/vpif.h
> index fca26dc..188841b 100644
> --- a/drivers/media/video/davinci/vpif.h
> +++ b/drivers/media/video/davinci/vpif.h
> @@ -19,6 +19,7 @@
>  #include <linux/io.h>
>  #include <linux/videodev2.h>
[Hiremath, Vaibhav] one line gap here.
>  #include <mach/hardware.h>
> +#include <mach/dm646x.h>
> 
>  /* Maximum channel allowed */
>  #define VPIF_NUM_CHANNELS		(4)
> @@ -26,7 +27,9 @@
>  #define VPIF_DISPLAY_NUM_CHANNELS	(2)
> 
>  /* Macros to read/write registers */
> -static void __iomem *vpif_base;
> +extern void __iomem *vpif_base;
> +extern spinlock_t vpif_lock;
[Hiremath, Vaibhav] I think I would want to check compete driver. How these extern variables have been used.

> +
>  #define regr(reg)               readl((reg) + vpif_base)
>  #define regw(value, reg)        writel(value, (reg + vpif_base))
> 
> @@ -280,6 +283,10 @@ static inline void enable_channel1(int enable)
>  /* inline function to enable interrupt for channel0 */
>  static inline void channel0_intr_enable(int enable)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpif_lock, flags);
> +
>  	if (enable) {
>  		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
>  		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> @@ -292,11 +299,16 @@ static inline void channel0_intr_enable(int
> enable)
>  		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH0),
>  							VPIF_INTEN_SET);
>  	}
> +	spin_unlock_irqrestore(&vpif_lock, flags);
>  }
> 
>  /* inline function to enable interrupt for channel1 */
>  static inline void channel1_intr_enable(int enable)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpif_lock, flags);
> +
>  	if (enable) {
>  		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
>  		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> @@ -309,6 +321,7 @@ static inline void channel1_intr_enable(int
> enable)
>  		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH1),
>  							VPIF_INTEN_SET);
>  	}
> +	spin_unlock_irqrestore(&vpif_lock, flags);
>  }
> 
>  /* inline function to set buffer addresses in case of Y/C non mux
> mode */
> @@ -431,6 +444,10 @@ static inline void enable_channel3(int enable)
>  /* inline function to enable interrupt for channel2 */
>  static inline void channel2_intr_enable(int enable)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpif_lock, flags);
> +
>  	if (enable) {
>  		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
>  		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> @@ -442,11 +459,16 @@ static inline void channel2_intr_enable(int
> enable)
>  		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH2),
>  							VPIF_INTEN_SET);
>  	}
> +	spin_unlock_irqrestore(&vpif_lock, flags);
>  }
> 
>  /* inline function to enable interrupt for channel3 */
>  static inline void channel3_intr_enable(int enable)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpif_lock, flags);
> +
>  	if (enable) {
>  		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
>  		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> @@ -459,6 +481,7 @@ static inline void channel3_intr_enable(int
> enable)
>  		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH3),
>  							VPIF_INTEN_SET);
>  	}
> +	spin_unlock_irqrestore(&vpif_lock, flags);
>  }
> 
>  /* inline function to enable raw vbi data for channel2 */
> @@ -571,7 +594,7 @@ struct vpif_channel_config_params {
>  	v4l2_std_id stdid;
>  };
> 
> -struct vpif_interface;
> +struct vpif_video_params;
>  struct vpif_params;
>  struct vpif_vbi_params;
> 
> @@ -579,13 +602,6 @@ int vpif_set_video_params(struct vpif_params
> *vpifparams, u8 channel_id);
>  void vpif_set_vbi_display_params(struct vpif_vbi_params *vbiparams,
>  							u8 channel_id);
>  int vpif_channel_getfid(u8 channel_id);
> -void vpif_base_addr_init(void __iomem *base);
> -
> -/* Enumerated data types */
> -enum vpif_capture_pinpol {
> -	VPIF_CAPTURE_PINPOL_SAME	= 0,
> -	VPIF_CAPTURE_PINPOL_INVERT	= 1
> -};
> 
>  enum data_size {
>  	_8BITS = 0,
> @@ -593,13 +609,6 @@ enum data_size {
>  	_12BITS,
>  };
> 
> -struct vpif_capture_params_raw {
> -	enum data_size data_sz;
> -	enum vpif_capture_pinpol fid_pol;
> -	enum vpif_capture_pinpol vd_pol;
> -	enum vpif_capture_pinpol hd_pol;
> -};
> -
>  /* Structure for vpif parameters for raw vbi data */
>  struct vpif_vbi_params {
>  	__u32 hstart0;  /* Horizontal start of raw vbi data for first
> field */
> @@ -613,18 +622,19 @@ struct vpif_vbi_params {
>  };
> 
>  /* structure for vpif parameters */
> -struct vpif_interface {
> +struct vpif_video_params {
>  	__u8 storage_mode;	/* Indicates field or frame mode */
>  	unsigned long hpitch;
>  	v4l2_std_id stdid;
>  };
> 
>  struct vpif_params {
> -	struct vpif_interface video_params;
> +	struct vpif_interface iface;
> +	struct vpif_video_params video_params;
>  	struct vpif_channel_config_params std_info;
>  	union param {
>  		struct vpif_vbi_params	vbi_params;
> -		struct vpif_capture_params_raw	raw_params;
> +		enum data_size data_sz;
>  	} params;
>  };
> 
> --
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

