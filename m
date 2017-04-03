Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52046 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdDCMLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 08:11:24 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ONU02N411UP3JD0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Apr 2017 21:11:13 +0900 (KST)
Subject: Re: [Patch v3 05/11] [media] videodev2.h: Add v4l2 definition for HEVC
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <70bc6abe-b944-d2bc-5f31-af760ce44c15@xs4all.nl>
Date: Mon, 03 Apr 2017 17:43:19 +0530
Message-id: <1491221599.8493.99.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090438epcas1p4152c9aaa9ea69f30d264bcd532d79e75@epcas1p4.samsung.com>
 <1490951200-32070-6-git-send-email-smitha.t@samsung.com>
 <70bc6abe-b944-d2bc-5f31-af760ce44c15@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-04-03 at 10:11 +0200, Hans Verkuil wrote:
> On 03/31/2017 11:06 AM, Smitha T Murthy wrote:
> > Add V4L2 definition for HEVC compressed format
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > ---
> >  include/uapi/linux/videodev2.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 45184a2..38cf5f1 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -629,6 +629,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
> >  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
> >  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> > +#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC */
> >  
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> > 
> 
> You also need to update v4l2-ioctl.c, v4l_fill_fmtdesc().
> 
> Regards,
> 
> 	Hans
> 
Ok I will add it in the v4l_fill_fmtdesc() function.

Thank you for the review.
Regards,
Smitha
> 
