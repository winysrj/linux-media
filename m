Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50106 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbeABLah (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 06:30:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: tian.shu.qiu@intel.com, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] yavta: Add support for intel ipu3 specific raw formats
Date: Tue, 02 Jan 2018 13:30:56 +0200
Message-ID: <2845745.NrvWgOXSWb@avalon>
In-Reply-To: <20180102111138.ohptdsm5nh3oihyu@valkosipuli.retiisi.org.uk>
References: <1514862157-4584-1-git-send-email-tian.shu.qiu@intel.com> <20180102111138.ohptdsm5nh3oihyu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, 2 January 2018 13:11:39 EET Sakari Ailus wrote:
> On Tue, Jan 02, 2018 at 11:02:37AM +0800, tian.shu.qiu@intel.com wrote:
> > From: Tianshu Qiu <tian.shu.qiu@intel.com>
> > 
> > Add support for these pixel formats:
> > 
> > V4L2_PIX_FMT_IPU3_SBGGR10
> > V4L2_PIX_FMT_IPU3_SGBRG10
> > V4L2_PIX_FMT_IPU3_SGRBG10
> > V4L2_PIX_FMT_IPU3_SRGGB10
> > 
> > Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> > ---
> > 
> >  include/linux/videodev2.h | 5 +++++
> >  yavta.c                   | 4 ++++
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index b1e36ee553da..6f7cd9622ea8 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -659,6 +659,11 @@ struct v4l2_pix_format {
> > 
> >  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek
> >  compressed block mode  */ #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I',
> >  'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */> 
> > +#define V4L2_PIX_FMT_IPU3_SBGGR10   v4l2_fourcc('i', 'p', '3', 'b') /*
> > IPU3 packed 10-bit BGGR bayer */ +#define V4L2_PIX_FMT_IPU3_SGBRG10  
> > v4l2_fourcc('i', 'p', '3', 'g') /* IPU3 packed 10-bit GBRG bayer */
> > +#define V4L2_PIX_FMT_IPU3_SGRBG10   v4l2_fourcc('i', 'p', '3', 'G') /*
> > IPU3 packed 10-bit GRBG bayer */ +#define V4L2_PIX_FMT_IPU3_SRGGB10  
> > v4l2_fourcc('i', 'p', '3', 'r') /* IPU3 packed 10-bit RGGB bayer */ +
> 
> Could you update the kernel headers in a separate patch? This should
> include all headers as they're produced by make headers_install .

I was going to mention that :-)

Take the most recent upstream kernel that contains the above formats (it can 
be an -rc release if they're not in a stable kernel yet, but it has to come 
from Linus' tree), run make headers_install, and update all the headers in 
include/linux/. Then commit the result with a message similar to

commit 2fb40d5f40e95e792f6d9f6fd57856697c9091c0
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Mon Oct 24 15:59:44 2016 +0300

    Update headers from upstream kernel
    
    Upstream commit 3907fae86ebabd622bd8265285d5b612d5958948
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> >  /* SDR formats - used only for Software Defined Radio devices */
> >  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ
> >  u8 */ #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6')
> >  /* IQ u16le */> 
> > diff --git a/yavta.c b/yavta.c
> > index afe96331a520..524e549efd08 100644
> > --- a/yavta.c
> > +++ b/yavta.c
> > @@ -220,6 +220,10 @@ static struct v4l2_format_info {
> >  	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
> >  	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
> >  	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
> > +	{ "IPU3_GRBG10", V4L2_PIX_FMT_IPU3_SGRBG10, 1 },
> > +	{ "IPU3_RGGB10", V4L2_PIX_FMT_IPU3_SRGGB10, 1 },
> > +	{ "IPU3_BGGR10", V4L2_PIX_FMT_IPU3_SBGGR10, 1 },
> > +	{ "IPU3_GBRG10", V4L2_PIX_FMT_IPU3_SGBRG10, 1 },
> >  	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
> >  	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
> >  	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },

-- 
Regards,

Laurent Pinchart
