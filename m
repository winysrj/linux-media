Return-path: <mchehab@gaivota>
Received: from mailout2.samsung.com ([203.254.224.25]:16981 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0L1Br7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 20:47:59 -0500
Date: Tue, 28 Dec 2010 10:47:53 +0900
From: Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: RE: [PATCH] [media] s5p-fimc: update checking scaling ratio range
In-reply-to: <4D1870F4.60209@samsung.com>
To: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Message-id: <004301cba631$4094e820$c1beb860$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1293441471-23257-1-git-send-email-khw0178.kim@samsung.com>
 <4D1870F4.60209@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sylwester Nawrocki wrote:

> -----Original Message-----
> From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-soc-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Monday, December 27, 2010 7:57 PM
> To: Hyunwoong Kim
> Cc: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> Subject: Re: [PATCH] [media] s5p-fimc: update checking scaling ratio range
> 
> Hi Hyunwoong,
> 
> On 12/27/2010 10:17 AM, Hyunwoong Kim wrote:
> > Horizontal and vertical scaling range are according to the following
> equations.
> > If (SRC_Width >= 64 x DST_Width) { Exit(-1);  /* Out of Horizontal scale
> range}
> > If (SRC_Height >= 64 x DST_Height) { Exit(-1);  /* Out of Vertical scale
> range}

<snip>

> > -int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
> > +int fimc_check_scaler_ratio(struct v4l2_rect *s, struct v4l2_rect *d,
> int rot);
> 
> This function always compares 2 width/height pairs, don't you think it
> could
> be better to do something like:
> int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot);
> considering your changed usage?
> That could let us avoid copying arguments before each function call.

If we use the 5 parameters as you commented, we can avoid copying arguments.
However, according to ATPCS(The ARM-THUMB Procedure Call Standard), 
4 registers from r0 to r3 is used for function's parameters and return
value.
If the number of parameters is more than 4, e.g. 5 parameters.
Four of the parameters are passed by register from r0 to r3. and the fifth
parameter is pushed in stack.
That could affect system performance compared to the case that the number of
parameter is below 4.
So, I think it's the better way to use 3 parameters according to ATPCS.
If you don't agree with my opinion, 
I will send the second patch after modifying the definition of function as
you mentioned.

Thank you for your comment.

> Otherwise looks good to me.
> >  int fimc_set_scaler_info(struct fimc_ctx *ctx);
> >  int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
> >  int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
> 
> Regards,
> --
> Sylwester Nawrocki
> Samsung Poland R&D Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-
> soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

