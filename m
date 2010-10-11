Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50955 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0JKNoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 09:44:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=EUC-KR
Date: Mon, 11 Oct 2010 15:44:26 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/5 v4] V4L/DVB: s5p-fimc: Register definition cleanup
In-reply-to: <000701cb6902$8449ef00$8cddcd00$%park@samsung.com>
To: =?EUC-KR?B?udq8vL/u?= <seuni.park@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <4CB314BA.7070803@samsung.com>
References: <1286527837-4980-1-git-send-email-s.nawrocki@samsung.com>
 <1286527837-4980-2-git-send-email-s.nawrocki@samsung.com>
 <000701cb6902$8449ef00$8cddcd00$%park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Seuni,

thanks for you review!

On 10/11/2010 07:09 AM, ¹Ú¼¼¿î wrote:
> Sewoon Park wrote:
> 
>> Add MIPI CSI format definitions, prepare DMA address
>> definitions for interlaced input frame mode.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/s5p-fimc/fimc-reg.c  |    6 +-
>>  drivers/media/video/s5p-fimc/regs-fimc.h |   61 ++++++++++++-------------
> -
>> ---
>>  2 files changed, 28 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c
>> b/drivers/media/video/s5p-fimc/fimc-reg.c
>> index 5570f1c..70f29c5 100644
>> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
>> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
>> @@ -507,9 +507,9 @@ void fimc_hw_set_input_addr(struct fimc_dev *dev,
>> struct fimc_addr *paddr)
>>  	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DIS;
>>  	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
>>
>> -	writel(paddr->y, dev->regs + S5P_CIIYSA0);
>> -	writel(paddr->cb, dev->regs + S5P_CIICBSA0);
>> -	writel(paddr->cr, dev->regs + S5P_CIICRSA0);
>> +	writel(paddr->y, dev->regs + S5P_CIIYSA(0));
>> +	writel(paddr->cb, dev->regs + S5P_CIICBSA(0));
>> +	writel(paddr->cr, dev->regs + S5P_CIICRSA(0));
>>
>>  	cfg &= ~S5P_CIREAL_ISIZE_ADDR_CH_DIS;
>>  	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
>> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h
>> b/drivers/media/video/s5p-fimc/regs-fimc.h
>> index a3cfe82..9e83315 100644
>> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
>> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
>> @@ -11,10 +11,6 @@
>>  #ifndef REGS_FIMC_H_
>>  #define REGS_FIMC_H_
>>
>> -#define S5P_CIOYSA(__x)			(0x18 + (__x) * 4)
>> -#define S5P_CIOCBSA(__x)		(0x28 + (__x) * 4)
>> -#define S5P_CIOCRSA(__x)		(0x38 + (__x) * 4)
>> -
>>  /* Input source format */
>>  #define S5P_CISRCFMT			0x00
>>  #define S5P_CISRCFMT_ITU601_8BIT	(1 << 31)
>> @@ -28,22 +24,21 @@
>>
>>  /* Window offset */
>>  #define S5P_CIWDOFST			0x04
>> -#define S5P_CIWDOFST_WINOFSEN		(1 << 31)
>> +#define S5P_CIWDOFST_OFF_EN		(1 << 31)
>>  #define S5P_CIWDOFST_CLROVFIY		(1 << 30)
>>  #define S5P_CIWDOFST_CLROVRLB		(1 << 29)
>> -#define S5P_CIWDOFST_WINHOROFST_MASK	(0x7ff << 16)
>> +#define S5P_CIWDOFST_HOROFF_MASK	(0x7ff << 16)
>>  #define S5P_CIWDOFST_CLROVFICB		(1 << 15)
>>  #define S5P_CIWDOFST_CLROVFICR		(1 << 14)
>> -#define S5P_CIWDOFST_WINHOROFST(x)	((x) << 16)
>> -#define S5P_CIWDOFST_WINVEROFST(x)	((x) << 0)
>> -#define S5P_CIWDOFST_WINVEROFST_MASK	(0xfff << 0)
>> +#define S5P_CIWDOFST_HOROFF(x)		((x) << 16)
>> +#define S5P_CIWDOFST_VEROFF(x)		((x) << 0)
>> +#define S5P_CIWDOFST_VEROFF_MASK	(0xfff << 0)
>>
>>  /* Global control */
>>  #define S5P_CIGCTRL			0x08
>>  #define S5P_CIGCTRL_SWRST		(1 << 31)
>>  #define S5P_CIGCTRL_CAMRST_A		(1 << 30)
>>  #define S5P_CIGCTRL_SELCAM_ITU_A	(1 << 29)
>> -#define S5P_CIGCTRL_SELCAM_ITU_MASK	(1 << 29)
>>  #define S5P_CIGCTRL_TESTPAT_NORMAL	(0 << 27)
>>  #define S5P_CIGCTRL_TESTPAT_COLOR_BAR	(1 << 27)
>>  #define S5P_CIGCTRL_TESTPAT_HOR_INC	(2 << 27)
>> @@ -61,6 +56,8 @@
>>  #define S5P_CIGCTRL_SHDW_DISABLE	(1 << 12)
>>  #define S5P_CIGCTRL_SELCAM_MIPI_A	(1 << 7)
>>  #define S5P_CIGCTRL_CAMIF_SELWB		(1 << 6)
>> +/* 0 - ITU601; 1 - ITU709 */
>> +#define S5P_CIGCTRL_CSC_ITU601_709	(1 << 5)
>>  #define S5P_CIGCTRL_INVPOLHSYNC		(1 << 4)
>>  #define S5P_CIGCTRL_SELCAM_MIPI		(1 << 3)
>>  #define S5P_CIGCTRL_INTERLACE		(1 << 0)
>> @@ -72,23 +69,10 @@
>>  #define S5P_CIWDOFST2_HOROFF(x)		((x) << 16)
>>  #define S5P_CIWDOFST2_VEROFF(x)		((x) << 0)
>>
>> -/* Output DMA Y plane start address */
>> -#define S5P_CIOYSA1			0x18
>> -#define S5P_CIOYSA2			0x1c
>> -#define S5P_CIOYSA3			0x20
>> -#define S5P_CIOYSA4			0x24
>> -
>> -/* Output DMA Cb plane start address */
>> -#define S5P_CIOCBSA1			0x28
>> -#define S5P_CIOCBSA2			0x2c
>> -#define S5P_CIOCBSA3			0x30
>> -#define S5P_CIOCBSA4			0x34
>> -
>> -/* Output DMA Cr plane start address */
>> -#define S5P_CIOCRSA1			0x38
>> -#define S5P_CIOCRSA2			0x3c
>> -#define S5P_CIOCRSA3			0x40
>> -#define S5P_CIOCRSA4			0x44
>> +/* Output DMA Y/Cb/Cr plane start addresses */
>> +#define S5P_CIOYSA(n)			(0x18 + (n) * 4)
>> +#define S5P_CIOCBSA(n)			(0x28 + (n) * 4)
>> +#define S5P_CIOCRSA(n)			(0x38 + (n) * 4)
>>
> As you know, S5P series have S5PC210 also.
> Then,
> Why don't you add S5PC210's 32 registers for Output DMA start address some
> other time?
> For the next, the better approach would be to do something like:
> 
> #define S5P_CIOYSA1	0x18	/* Y 1st frame start address for output DMA
> */
> #define S5P_CIOYSA5 0x200 /* Y 5th frame start address for output DMA */
> #define S5P_CIOYSA(n) \
>         (((n) < 4) ?     \
>          (S5P_CIOYSA1  + (n) * 4) : (S5P_CIOYSA5  + ((n) - 4) * 4))

Thanks for pointing this out. I was aware of that and was going to handle
S5PC210 (S5PV310) wariant in another separate patch.
Your proposal looks OK but I am still working on how to use the extended
capabilities of S5PC210 and for now I decided to just mask out the additional
registers at offset 0x200 and above. This is for backward compatibility
and also I do not see much advantage from using all 32 registers just
an overhead of setting them up. So for now let us leave the CIO*SA(n)
definition as is and after I work out a relevant output DMA usage scheme
I will change it, possibly in the way you suggested.

Regards,
Sylwester

> 
[snip]
> 
> 
> I will review another patches soon.

> Thanks.
> 
> Best regards,
> Seuni.
> --
> Sewoon Park <seuni.park@samsung.com>, Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
