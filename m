Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1220 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZHMUXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 16:23:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
Date: Thu, 13 Aug 2009 22:23:09 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com> <A24693684029E5489D1D202277BE89444A7839CC@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444A7839CC@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908132223.09322.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 13 August 2009 20:58:59 Aguirre Rodriguez, Sergio Alberto wrote:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
> > Sent: Thursday, August 13, 2009 1:51 PM
> > To: linux-media@vger.kernel.org
> > Subject: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
> > 
> > From: Sergio Aguirre <saaguirre@ti.com>
> > 
> > This helps clarifying different pattern orders for RAW Bayer 10 bit
> > cases.
> 
> My intention with this patch is to help sensor drivers letting know the userspace (or a v4l2_device master) the exact order of components a sensor is outputting...
> 
> Please share your comments/thoughts/kicks :)

Adding new pixel formats require that the v4l2-spec is also updated, otherwise
it will fail to build.

It may be a good idea anyway to document these formats there.

Regards,

	Hans

> 
> Regards,
> Sergio
> > 
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  include/linux/videodev2.h |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 9e66c50..8aa6255 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -327,6 +327,9 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')
> >  /* 10bit raw bayer DPCM compressed to 8 bits */
> >  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> > +#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0')
> > +#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0')
> > +#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0')
> >  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16
> > BGBG.. GRGR.. */
> > 
> >  /* compressed formats */
> > --
> > 1.6.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
