Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31547 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbAGMIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 07:08:18 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: 'Jacek Anaszewski' <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, kgene@kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, robh+dt@kernel.org, mark.rutland@arm.com,
	bhushan.r@samsung.com
References: <1418801229-7532-1-git-send-email-tony.kn@samsung.com>
 <54919010.8020507@samsung.com> <001801d01b3d$2cb181d0$86148570$@samsung.com>
 <54AD0033.1020103@samsung.com>
In-reply-to: <54AD0033.1020103@samsung.com>
Subject: RE: [PATCH] [media] s5p-jpeg: Adding Exynos7 Jpeg variant support
Date: Wed, 07 Jan 2015 17:38:17 +0530
Message-id: <000a01d02a72$bc6e06b0$354a1410$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Jacek,

On Wednesday, January 07, 2015 3:15 PM Jacek Anaszewski wrote,

> Hi Tony,
> 
> Sorry for late response, just got back from vacation.
> 
> On 12/19/2014 04:37 AM, Tony K Nadackal wrote:
> > Hi Jacek,
> >
> > On Wednesday, December 17, 2014 7:46 PM Jacek Anaszewski wrote,
> >> Hi Tony,
> >>
> >> Thanks for the patches.
> >>
> >
> > Thanks for the review.
> >
> >> Please process them with scripts/checkpatch.pl as you will be
> >> submitting the
> > next
> >> version - they contain many coding style related issues.
> >>
> >
> > I ran checkpatch before posting. Do you find any checkpatch related
> > issues in the patch?
> 
> There was a problem on my side, sorry for making confusion.
> 
> >> My remaining comments below.
> >>
> >
> > [snip]
> >
> >>> +		if (ctx->jpeg->variant->version == SJPEG_EXYNOS7) {
> >>> +			exynos4_jpeg_set_interrupt(jpeg->regs,
> >> SJPEG_EXYNOS7);
> >>> +			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
> >>> +					ctx->subsampling,
> >> EXYNOS7_ENC_FMT_MASK);
> >>> +			exynos4_jpeg_set_img_fmt(jpeg->regs,
> >>> +					ctx->out_q.fmt->fourcc,
> >>> +					EXYNOS7_SWAP_CHROMA_SHIFT);
> >>> +		} else {
> >>> +			exynos4_jpeg_set_interrupt(jpeg->regs,
> >> SJPEG_EXYNOS4);
> >>> +			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
> >>> +					ctx->subsampling,
> >> EXYNOS4_ENC_FMT_MASK);
> >>> +			exynos4_jpeg_set_img_fmt(jpeg->regs,
> >>> +					ctx->out_q.fmt->fourcc,
> >>> +					EXYNOS4_SWAP_CHROMA_SHIFT);
> >>> +		}
> >>> +
> >>
> >> I'd implement it this way:
> >>
> >> exynos4_jpeg_set_interrupt(jpeg->regs, ctx->jpeg->variant->version);
> >> exynos4_jpeg_set_enc_out_fmt(jpeg->regs, ctx->subsampling,
> >> 			(ctx->jpeg->variant->version == SJPEG_EXYNOS4) ?
> >> 				EXYNOS4_ENC_FMT_MASK :
> >> 				EXYNOS7_ENC_FMT_MASK);
> >> exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->out_q.fmt->fourcc,
> >> 			(ctx->jpeg->variant->version == SJPEG_EXYNOS4) ?
> >> 				EXYNOS4_SWAP_CHROMA_SHIFT :
> >> 				EXYNOS7_SWAP_CHROMA_SHIFT);
> >>
> >
> > OK. Looks goods to me. Thanks for the suggestion.
> >
> >>>    		exynos4_jpeg_set_img_addr(ctx);
> >>>    		exynos4_jpeg_set_jpeg_addr(ctx);
> >>>    		exynos4_jpeg_set_encode_hoff_cnt(jpeg->regs,
> >>>
ctx->out_q.fmt->fourcc);
> >>>    	} else {
> >>>    		exynos4_jpeg_sw_reset(jpeg->regs);
> >>> -		exynos4_jpeg_set_interrupt(jpeg->regs);
> >>>    		exynos4_jpeg_set_img_addr(ctx);
> >>>    		exynos4_jpeg_set_jpeg_addr(ctx);
> >>> -		exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->cap_q.fmt-
> >>> fourcc);
> >>>
> >>> -		bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
> >>> +		if (ctx->jpeg->variant->version == SJPEG_EXYNOS7) {
> >>> +			exynos4_jpeg_set_interrupt(jpeg->regs,
> >> SJPEG_EXYNOS7);
> >>> +			exynos4_jpeg_set_huff_tbl(jpeg->regs);
> >>> +			exynos4_jpeg_set_huf_table_enable(jpeg->regs, 1);
> >>> +
> >>> +			/*
> >>> +			 * JPEG IP allows storing 4 quantization tables
> >>> +			 * We fill table 0 for luma and table 1 for chroma
> >>> +			 */
> >>> +			exynos4_jpeg_set_qtbl_lum(jpeg->regs,
> >>> +							ctx->compr_quality);
> >>> +			exynos4_jpeg_set_qtbl_chr(jpeg->regs,
> >>> +							ctx->compr_quality);
> >>
> >> Is it really required to setup quantization tables for encoding?
> >>
> >
> > Without setting up the quantization tables, encoder is working fine.
> > But, as per Exynos7 User Manual setting up the quantization tables are
> > required for encoding also.
> 

Sorry I also got it mixed up.
*Decoder* works fine without setting up the quantization tables. But this step
is mentioned in User Manual.

> Actually I intended to ask if setting the quantization tables is required for
> *decoding*, as you set it also in decoding path, whereas for Exynos4 it is not
> required. I looks strange for me as quantization tables are usually required
only
> for encoding raw images.
> The same is related to huffman tables.

Huffman table is required for Exynos7 decoding.
User Manual says about  Update_Huf_Tbl [bit 19 of PEG_CNTL], "User/Host should
mandatory program this Bit as "1" for every decoder operation. SFR
"HUFF_TBL_ENT" and SFR "HUFF_CNT" should be programmed accordingly for every
encoder/decoder operation."

> 
> >>> +			exynos4_jpeg_set_stream_size(jpeg->regs, ctx-
> >>> cap_q.w,
> >>> +					ctx->cap_q.h);
> >>
> >> For exynos4 this function writes the number of samples per line and
> >> number lines of the resulting JPEG image and is used only during
> >> encoding. Is the semantics of the related register different in case of
Exynos7?
> >>
> >
> > Yes. In case of Exynos7 Encoding, This step is required.
> 
> Ack.

I will request Kukjin or any Samsung colleagues who has access to Exynos7 Manual
to give ack or tested by.

> 
> > [snip]
> >
> >>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
> >>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
> >>> @@ -71,6 +71,7 @@
> >>>    #define SJPEG_S5P		1
> >>>    #define SJPEG_EXYNOS3250	2
> >>>    #define SJPEG_EXYNOS4		3
> >>> +#define SJPEG_EXYNOS7		4
> >>
> >> As you adding a new variant I propose to turn these macros into enum.
> >>
> >
> > Ok. I will make this change in my next version.
> 
> Thanks.
> 
> > [snip]
> >
> >>> -void exynos4_jpeg_set_interrupt(void __iomem *base)
> >>> +void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int
> >>> +version)
> >>>    {
> >>> -	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
> >>> +	unsigned int reg;
> >>> +
> >>> +	reg = readl(base + EXYNOS4_INT_EN_REG) &
> >> ~EXYNOS4_INT_EN_MASK(version);
> >>> +	writel(EXYNOS4_INT_EN_ALL(version), base + EXYNOS4_INT_EN_REG);
> >>>    }
> >>
> >> I believe that adding readl is a fix. I'd enclose it into separate
> >> patch and
> > explain its
> >> merit.
> >>
> >
> > Thanks for the suggestion.  I will make a separate patch for this bug fix.
> 
> Great.
> 
> --
> Best Regards,
> Jacek Anaszewski

Thanks and Regards,
Tony

