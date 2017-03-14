Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37681 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdCNLgk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 07:36:40 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OMS02FP8YX2XR70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Mar 2017 20:36:38 +0900 (KST)
Subject: Re: [Patch v2 07/11] Documentation: v4l: Documentation for HEVC v4l2
 definition
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        kamil@wypas.org, krzk@kernel.org, jtp.park@samsung.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, m.szyprowski@samsung.com
In-reply-to: <bcc5e437-917a-3593-3047-67fc06dfde9c@samsung.com>
Date: Tue, 14 Mar 2017 17:08:39 +0530
Message-id: <1489491519.27807.139.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090459epcas5p4498e5a633739ef3829ba1fccd79f6821@epcas5p4.samsung.com>
 <1488532036-13044-8-git-send-email-smitha.t@samsung.com>
 <bcc5e437-917a-3593-3047-67fc06dfde9c@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-07 at 09:39 +0100, Andrzej Hajda wrote: 
> On 03.03.2017 10:07, Smitha T Murthy wrote:
> > Add V4L2 definition for HEVC compressed format
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> 
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> 
> 
Thank you for the review.
Regards,
Smitha T Murthy 
> 
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-013.rst |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
> > index 728d7ed..ff4cac2 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> > @@ -90,3 +90,8 @@ Compressed Formats
> >        - ``V4L2_PIX_FMT_VP9``
> >        - 'VP90'
> >        - VP9 video elementary stream.
> > +    * .. _V4L2-PIX-FMT-HEVC:
> > +
> > +      - ``V4L2_PIX_FMT_HEVC``
> > +      - 'HEVC'
> > +      - HEVC video elementary stream.
> > 
> 
> 
