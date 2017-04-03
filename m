Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55015 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbdDCMSh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 08:18:37 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ONU02TXR26U9TB0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Apr 2017 21:18:30 +0900 (KST)
Subject: Re: [Patch v3 07/11] Documentation: v4l: Documentation for HEVC v4l2
 definition
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <9a2018ba-7080-4dfc-24a5-c83384bd611d@xs4all.nl>
Date: Mon, 03 Apr 2017 17:50:35 +0530
Message-id: <1491222035.8493.108.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090444epcas5p43f44be426728ea22d0b13f64f5cf05bd@epcas5p4.samsung.com>
 <1490951200-32070-8-git-send-email-smitha.t@samsung.com>
 <3bad0b4f-0f0e-c67a-f9f7-135f5b8411c4@xs4all.nl>
 <1491221557.8493.98.camel@smitha-fedora>
 <9a2018ba-7080-4dfc-24a5-c83384bd611d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-04-03 at 14:12 +0200, Hans Verkuil wrote:
> On 04/03/2017 02:12 PM, Smitha T Murthy wrote:
> > On Mon, 2017-04-03 at 10:10 +0200, Hans Verkuil wrote:
> >> On 03/31/2017 11:06 AM, Smitha T Murthy wrote:
> >>> Add V4L2 definition for HEVC compressed format
> >>>
> >>> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> >>> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> >>> ---
> >>>  Documentation/media/uapi/v4l/pixfmt-013.rst | 5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>> diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
> >>> index 728d7ed..ff4cac2 100644
> >>> --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> >>> +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> >>> @@ -90,3 +90,8 @@ Compressed Formats
> >>>        - ``V4L2_PIX_FMT_VP9``
> >>>        - 'VP90'
> >>>        - VP9 video elementary stream.
> >>> +    * .. _V4L2-PIX-FMT-HEVC:
> >>> +
> >>> +      - ``V4L2_PIX_FMT_HEVC``
> >>> +      - 'HEVC'
> >>> +      - HEVC video elementary stream.
> >>>
> >>
> >> You should mention here that HEVC == H.265.
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> > Do you mean change to "HEVC/H.265 video elementary stream" ?
> 
> Yes, that should do it.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Thank you for the review.
> > Regards,
> > Smitha
> >>
> > 
> > 
> 
Ok I will change it accordingly.

Thank you,
Smitha
> 
> 
