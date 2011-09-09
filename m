Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45730 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1IINUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 09:20:47 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Date: Fri, 9 Sep 2011 18:50:39 +0530
Subject: RE: [PATCH v2 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware
 support module
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025743F3C0@dbde02.ent.ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
 <1314630439-1122-2-git-send-email-manjunath.hadli@ti.com>
 <4E5FEF75.8060704@gmail.com>
In-Reply-To: <4E5FEF75.8060704@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,
  Thank you for your comments.
My responses inline.

Thanks and Regards,
-Manju

On Fri, Sep 02, 2011 at 02:17:49, Sylwester Nawrocki wrote:
> Hi Manjunath,
> 
> A few comments below...
> 
> On 08/29/2011 05:07 PM, Manjunath Hadli wrote:
> > add support for dm3xx IPIPEIF hardware setup. This is the lowest 
> > software layer for the dm3x vpfe driver which directly accesses 
> > hardware. Add support for features like default pixel correction, dark 
> > frame substraction  and hardware setup.
> > 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> > Signed-off-by: Nagabhushana Netagunte<nagabhushana.netagunte@ti.com>
> > ---
> >   drivers/media/video/davinci/dm3xx_ipipeif.c |  317 +++++++++++++++++++++++++++
> >   drivers/media/video/davinci/dm3xx_ipipeif.h |  258 ++++++++++++++++++++++
> >   include/linux/dm3xx_ipipeif.h               |   64 ++++++
> >   3 files changed, 639 insertions(+), 0 deletions(-)
> >   create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
> >   create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.h
> >   create mode 100644 include/linux/dm3xx_ipipeif.h
> > 
> > diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.c 
> > b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > new file mode 100644
> > index 0000000..ebc8895
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > @@ -0,0 +1,317 @@
> ...
> > +
> > +static void ipipeif_config_dpc(struct ipipeif_dpc *dpc) {
> > +	u32 val;
> > +
> > +	/* Intialize val*/
> > +	val = 0;
> 
> s/Intialize/Initialize ? But this comment doesn't seem much helpful and could probably be removed. Also it might be better to just do:
> 
> 	u32 val = 0;
Done.
> 
> > +
> > +	if (dpc->en) {
> > +		val = (dpc->en&  1)<<  IPIPEIF_DPC2_EN_SHIFT;
> > +		val |= dpc->thr&  IPIPEIF_DPC2_THR_MASK;
> > +	}
> > +
> > +	regw_if(val, IPIPEIF_DPC2);
> > +}
> > +
> ...
> > +
> > +static int __devinit dm3xx_ipipeif_probe(struct platform_device 
> > +*pdev) {
> > +	static resource_size_t  res_len;
> > +	struct resource *res;
> > +	int status;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENOENT;
> > +
> > +	res_len = res->end - res->start + 1;
> 
> resource_size(res) macro could be used here
Done.
> 
> > +
> > +	res = request_mem_region(res->start, res_len, res->name);
> > +	if (!res)
> > +		return -EBUSY;
> > +
> > +	ipipeif_base_addr = ioremap_nocache(res->start, res_len);
> > +	if (!ipipeif_base_addr) {
> > +		status = -EBUSY;
> > +		goto fail;
> > +	}
> > +	return 0;
> > +
> > +fail:
> > +	release_mem_region(res->start, res_len);
> > +
> > +	return status;
> > +}
> > +
> > +static int dm3xx_ipipeif_remove(struct platform_device *pdev) {
> > +	struct resource *res;
> > +
> > +	iounmap(ipipeif_base_addr);
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (res)
> > +		release_mem_region(res->start, res->end - res->start + 1);
> 
> 	release_mem_region(res->start, resource_size(res));
Done.
> 
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver dm3xx_ipipeif_driver = {
> > +	.driver = {
> > +		.name   = "dm3xx_ipipeif",
> > +		.owner = THIS_MODULE,
> > +	},
> > +	.remove = __devexit_p(dm3xx_ipipeif_remove),
> > +	.probe = dm3xx_ipipeif_probe,
> > +};
> > +
> > +static int dm3xx_ipipeif_init(void)
> > +{
> > +	return platform_driver_register(&dm3xx_ipipeif_driver);
> > +}
> > +
> > +static void dm3xx_ipipeif_exit(void)
> > +{
> > +	platform_driver_unregister(&dm3xx_ipipeif_driver);
> > +}
> > +
> > +module_init(dm3xx_ipipeif_init);
> > +module_exit(dm3xx_ipipeif_exit);
> > +
> > +MODULE_LICENSE("GPL2");
> > diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.h 
> > b/drivers/media/video/davinci/dm3xx_ipipeif.h
> > new file mode 100644
> > index 0000000..f3289f0
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/dm3xx_ipipeif.h
> > @@ -0,0 +1,258 @@
> > +/*
> ...
> > +
> > +/* IPIPEIF Register Offsets from the base address */
> > +#define IPIPEIF_ENABLE			(0x00)
> > +#define IPIPEIF_CFG1			(0x04)
> > +#define IPIPEIF_PPLN			(0x08)
> > +#define IPIPEIF_LPFR			(0x0c)
> > +#define IPIPEIF_HNUM			(0x10)
> > +#define IPIPEIF_VNUM			(0x14)
> > +#define IPIPEIF_ADDRU			(0x18)
> > +#define IPIPEIF_ADDRL			(0x1c)
> > +#define IPIPEIF_ADOFS			(0x20)
> > +#define IPIPEIF_RSZ			(0x24)
> > +#define IPIPEIF_GAIN			(0x28)
> > +
> > +/* Below registers are available only on IPIPE 5.1 */
> > +#define IPIPEIF_DPCM			(0x2c)
> > +#define IPIPEIF_CFG2			(0x30)
> > +#define IPIPEIF_INIRSZ			(0x34)
> > +#define IPIPEIF_OCLIP			(0x38)
> > +#define IPIPEIF_DTUDF			(0x3c)
> > +#define IPIPEIF_CLKDIV			(0x40)
> > +#define IPIPEIF_DPC1			(0x44)
> > +#define IPIPEIF_DPC2			(0x48)
> > +#define IPIPEIF_DFSGVL			(0x4c)
> > +#define IPIPEIF_DFSGTH			(0x50)
> > +#define IPIPEIF_RSZ3A			(0x54)
> > +#define IPIPEIF_INIRSZ3A		(0x58)
> > +#define IPIPEIF_RSZ_MIN			(16)
> > +#define IPIPEIF_RSZ_MAX			(112)
> > +#define IPIPEIF_RSZ_CONST		(16)
> > +#define SETBIT(reg, bit)   (reg = ((reg) | ((0x00000001)<<(bit))))
> > +#define RESETBIT(reg, bit) (reg = ((reg)&  (~(0x00000001<<(bit)))))
> > +
> > +#define IPIPEIF_ADOFS_LSB_MASK		(0x1ff)
> > +#define IPIPEIF_ADOFS_LSB_SHIFT		(5)
> > +#define IPIPEIF_ADOFS_MSB_MASK		(0x200)
> > +#define IPIPEIF_ADDRU_MASK		(0x7ff)
> > +#define IPIPEIF_ADDRL_SHIFT		(5)
> > +#define IPIPEIF_ADDRL_MASK		(0xffff)
> > +#define IPIPEIF_ADDRU_SHIFT		(21)
> > +#define IPIPEIF_ADDRMSB_SHIFT		(31)
> > +#define IPIPEIF_ADDRMSB_LEFT_SHIFT	(10)
> > +
> > +/* CFG1 Masks and shifts */
> > +#define ONESHOT_SHIFT			(0)
> > +#define DECIM_SHIFT			(1)
> > +#define INPSRC_SHIFT			(2)
> > +#define CLKDIV_SHIFT			(4)
> > +#define AVGFILT_SHIFT			(7)
> > +#define PACK8IN_SHIFT			(8)
> > +#define IALAW_SHIFT			(9)
> > +#define CLKSEL_SHIFT			(10)
> > +#define DATASFT_SHIFT			(11)
> > +#define INPSRC1_SHIFT			(14)
> > +
> > +/* DPC2 */
> > +#define IPIPEIF_DPC2_EN_SHIFT		(12)
> > +#define IPIPEIF_DPC2_THR_MASK		(0xfff)
> > +/* Applicable for IPIPE 5.1 */
> > +#define IPIPEIF_DF_GAIN_EN_SHIFT	(10)
> > +#define IPIPEIF_DF_GAIN_MASK		(0x3ff)
> > +#define IPIPEIF_DF_GAIN_THR_MASK	(0xfff)
> > +/* DPCM */
> > +#define IPIPEIF_DPCM_BITS_SHIFT		(2)
> > +#define IPIPEIF_DPCM_PRED_SHIFT		(1)
> > +/* CFG2 */
> > +#define IPIPEIF_CFG2_HDPOL_SHIFT	(1)
> > +#define IPIPEIF_CFG2_VDPOL_SHIFT	(2)
> > +#define IPIPEIF_CFG2_YUV8_SHIFT		(6)
> > +#define	IPIPEIF_CFG2_YUV16_SHIFT	(3)
> > +#define	IPIPEIF_CFG2_YUV8P_SHIFT	(7)
> > +
> > +/* INIRSZ */
> > +#define IPIPEIF_INIRSZ_ALNSYNC_SHIFT	(13)
> > +#define IPIPEIF_INIRSZ_MASK		(0x1fff)
> 
> Is there any good reason to use parentheses around the numbers ? 
No. It was in the plan to remove them. Now it is taken care of.
> 
> 
> --
> Regards,
> Sylwester
> 

