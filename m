Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24417 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHTKR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 06:17:57 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Andrzej Hajda' <a.hajda@samsung.com>,
	'Seung-Woo Kim' <sw0312.kim@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	mchehab@osg.samsung.com
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com
References: <1431501925-16905-1-git-send-email-sw0312.kim@samsung.com>
 <55D333CF.9000504@samsung.com>
In-reply-to: <55D333CF.9000504@samsung.com>
Subject: RE: [PATCH] s5p-mfc: fix state check from encoder queue_setup
Date: Thu, 20 Aug 2015 12:17:53 +0200
Message-id: <001a01d0db31$7a636880$6f2a3980$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: Tuesday, August 18, 2015 3:32 PM
> 
> On 05/13/2015 09:25 AM, Seung-Woo Kim wrote:
> > MFCINST_GOT_INST state is set to encoder context with set_format only
> > for catpure buffer. In queue_setup of encoder called during reqbufs,
> > it is checked MFCINST_GOT_INST state for both capture and output
> > buffer. So this patch fixes to encoder to check MFCINST_GOT_INST state
> > only for capture buffer from queue_setup.
> >
> > Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> 
> Looks OK.
> 
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> 
> Regards
> Andrzej

Best wishes,
Kamil Debski

> 
> 
> > ---
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    9 +++++----
> >  1 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > index e65993f..2e57e9f 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > @@ -1819,11 +1819,12 @@ static int s5p_mfc_queue_setup(struct
> vb2_queue *vq,
> >  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
> >  	struct s5p_mfc_dev *dev = ctx->dev;
> >
> > -	if (ctx->state != MFCINST_GOT_INST) {
> > -		mfc_err("inavlid state: %d\n", ctx->state);
> > -		return -EINVAL;
> > -	}
> >  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		if (ctx->state != MFCINST_GOT_INST) {
> > +			mfc_err("inavlid state: %d\n", ctx->state);
> > +			return -EINVAL;
> > +		}
> > +
> >  		if (ctx->dst_fmt)
> >  			*plane_count = ctx->dst_fmt->num_planes;
> >  		else
> >

