Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:41395 "EHLO
        epoutp02.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752072AbdDCMMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 08:12:36 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by epoutp02.samsung.com (KnoxPortal) with ESMTP id 20170403121234epoutp02bb179700d43f77cb6bf923cb65bade5d~x4hpd9_nY0768907689epoutp02i
        for <linux-media@vger.kernel.org>; Mon,  3 Apr 2017 12:12:34 +0000 (GMT)
Subject: Re: [Patch v3 06/11] [media] s5p-mfc: Add support for HEVC decoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <ebabf38b-4da9-abf8-774a-2e63796fba19@xs4all.nl>
Date: Mon, 03 Apr 2017 17:44:40 +0530
Message-ID: <1491221680.8493.101.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
        <CGME20170331090441epcas1p491fae79e00000335ea163eb4c15fc16d@epcas1p4.samsung.com>
        <1490951200-32070-7-git-send-email-smitha.t@samsung.com>
        <ebabf38b-4da9-abf8-774a-2e63796fba19@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-04-03 at 10:13 +0200, Hans Verkuil wrote:
> On 03/31/2017 11:06 AM, Smitha T Murthy wrote:
> > Add support for codec definition and corresponding buffer
> > requirements for HEVC decoder.
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > ---
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |  1 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |  3 +++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  8 ++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 17 +++++++++++++++--
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |  3 +++
> >  6 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > index 3f0dab3..953a073 100644
> > --- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > @@ -33,6 +33,7 @@
> >  #define MFC_NUM_PORTS_V10	1
> >  
> >  /* MFCv10 codec defines*/
> > +#define S5P_FIMV_CODEC_HEVC_DEC		17
> >  #define S5P_FIMV_CODEC_HEVC_ENC         26
> >  
> >  /* Encoder buffer size for MFC v10.0 */
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > index b1b1491..76eca67 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > @@ -101,6 +101,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
> >  	case S5P_MFC_CODEC_VP8_DEC:
> >  		codec_type = S5P_FIMV_CODEC_VP8_DEC_V6;
> >  		break;
> > +	case S5P_MFC_CODEC_HEVC_DEC:
> > +		codec_type = S5P_FIMV_CODEC_HEVC_DEC;
> > +		break;
> >  	case S5P_MFC_CODEC_H264_ENC:
> >  		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
> >  		break;
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > index 8368d5c2..f49fa34 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > @@ -79,6 +79,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
> >  #define S5P_MFC_CODEC_H263_DEC		5
> >  #define S5P_MFC_CODEC_VC1RCV_DEC	6
> >  #define S5P_MFC_CODEC_VP8_DEC		7
> > +#define S5P_MFC_CODEC_HEVC_DEC		17
> >  
> >  #define S5P_MFC_CODEC_H264_ENC		20
> >  #define S5P_MFC_CODEC_H264_MVC_ENC	21
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > index db6d9fa..4fdaec2 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > @@ -144,6 +144,14 @@ static struct s5p_mfc_fmt formats[] = {
> >  		.num_planes	= 1,
> >  		.versions	= MFC_V6PLUS_BITS,
> >  	},
> > +	{
> > +		.name		= "HEVC Encoded Stream",
> > +		.fourcc		= V4L2_PIX_FMT_HEVC,
> > +		.codec_mode	= S5P_FIMV_CODEC_HEVC_DEC,
> > +		.type		= MFC_FMT_DEC,
> > +		.num_planes	= 1,
> > +		.versions	= MFC_V10_BIT,
> > +	},
> >  };
> 
> The '.name' should probably be removed completely in this driver. The name is now filled
> in by v4l_fill_fmtdesc() in v4l2-ioctl.c, so there is no longer any need to set it in a
> driver.
> 
> This can be done in a separate patch before this patch is applied.
> 
> Doing this in v4l2-ioctl.c ensures consistent format naming across drivers.
> 
> Regards,
> 
> 	Hans
> 
> 
I will remove the ".name" field in the next patch version. Also I will
create a separate patch for adding it in v4l_fill_fmtdesc().
Thank you for the review.
Regards,
Smitha
