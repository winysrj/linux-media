Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55931 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdGXEws (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 00:52:48 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170724045246epoutp02f690420bc9ab9d0f23be00901f6cdbcc~UKxn0DYn-2392223922epoutp02v
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 04:52:46 +0000 (GMT)
Subject: Re: [Patch v5 05/12] [media] videodev2.h: Add v4l2 definition for
 HEVC
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <56ed9e37-36a6-0c2e-e416-00b068d7fefc@xs4all.nl>
Date: Mon, 24 Jul 2017 09:59:11 +0530
Message-ID: <1500870551.16819.1818.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052505epcas5p33a78ee709263cc9ae33cd9383794ca06@epcas5p3.samsung.com>
        <1497849055-26583-6-git-send-email-smitha.t@samsung.com>
        <56ed9e37-36a6-0c2e-e416-00b068d7fefc@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-20 at 15:07 +0200, Hans Verkuil wrote:
> On 19/06/17 07:10, Smitha T Murthy wrote:
> > Add V4L2 definition for HEVC compressed format
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > ---
> >  include/uapi/linux/videodev2.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 2b8feb8..488de3d 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -629,6 +629,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
> >  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
> >  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> > +#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC */
> 
> Change the comment to: /* HEVC aka H.265 */
> 
> After that you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans
> 
I will make the change. Thanks for the review.

Regards,
Smitha
> >  
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> > 
> 
> 
> 
