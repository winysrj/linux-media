Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:60527 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdGXEwR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 00:52:17 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20170724045215epoutp03e76fde58ef07dc711e9a6429d192923a~UKxLaMTrx2838328383epoutp03V
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 04:52:15 +0000 (GMT)
Subject: Re: [Patch v5 06/12] [media] v4l2-ioctl: add HEVC format
 description
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <e6e75cae-f195-af56-652e-37c3e51ad70f@xs4all.nl>
Date: Mon, 24 Jul 2017 09:58:45 +0530
Message-ID: <1500870525.16819.1817.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052507epcas1p406fa9f6d84baa9c11050b1998021788a@epcas1p4.samsung.com>
        <1497849055-26583-7-git-send-email-smitha.t@samsung.com>
        <e6e75cae-f195-af56-652e-37c3e51ad70f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-20 at 15:07 +0200, Hans Verkuil wrote:
> On 19/06/17 07:10, Smitha T Murthy wrote:
> > HEVC is a video coding format
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index e5a2187..4f6f8d9 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1257,6 +1257,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> >  		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
> >  		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
> >  		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> > +		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break;
> 
> Add a little comment at the end of the line: /* aka H.265 */
> 
> After that you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans
> 
Ok I will make the change. Thanks for the review.

Regards,
Smitha

> >  		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
> >  		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
> >  		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
> > 
> 
> 
> 
