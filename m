Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51298 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3JaOGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 10:06:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Denis Carikli <denis@eukrea.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Patch v2][ 04/37] [media] v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
Date: Thu, 31 Oct 2013 15:06:45 +0100
Message-ID: <27124564.ioQJs5F4eu@avalon>
In-Reply-To: <20131031111806.72b6856b@samsung.com>
References: <1382022155-21954-1-git-send-email-denis@eukrea.com> <1382022155-21954-5-git-send-email-denis@eukrea.com> <20131031111806.72b6856b@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 31 October 2013 11:18:06 Mauro Carvalho Chehab wrote:
> Em Thu, 17 Oct 2013 17:02:02 +0200
> 
> Denis Carikli <denis@eukrea.com> escreveu:
> > That new macro is needed by the imx_drm staging driver
> > 
> >   for supporting the QVGA display of the eukrea-cpuimx51 board.
> > 
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > Cc: devicetree@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: driverdev-devel@linuxdriverproject.org
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: linux-media@vger.kernel.org
> > Cc: Sascha Hauer <kernel@pengutronix.de>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: Eric Bénard <eric@eukrea.com>
> > Signed-off-by: Denis Carikli <denis@eukrea.com>
> 
> It seems better to apply this one together with the other DRM patches via
> DRM tree. So:
> 	Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Actually, if I might, I'd like to nak this patch, as adding new pixel formats 
requires updating the documentation as well (see 
Documentation/DocBook/media/v4l/pixfmt*.xml).

> > ---
> > 
> >  include/uapi/linux/videodev2.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 437f1b0..e8ff410 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -294,6 +294,7 @@ struct v4l2_pix_format {
> > 
> >  #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16 
> >  RGB-5-5-5 BE  */ #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B',
> >  'R') /* 16  RGB-5-6-5 BE  */ #define V4L2_PIX_FMT_BGR666 
> >  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */> 
> > +#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18 
> > RGB-6-6-6	  */> 
> >  #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24 
> >  BGR-8-8-8     */ #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B',
> >  '3') /* 24  RGB-8-8-8     */ #define V4L2_PIX_FMT_BGR32  
> >  v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-- 
Regards,

Laurent Pinchart

