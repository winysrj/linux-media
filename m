Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2GWHPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 03:15:53 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: RE: [PATCH v6 2/2] v4l2: add new pixel formats supported on dm365
Date: Mon, 23 Jul 2012 07:15:36 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CE166E@DBDE01.ent.ti.com>
References: <1342796290-18947-1-git-send-email-prabhakar.lad@ti.com>
 <1342796290-18947-3-git-send-email-prabhakar.lad@ti.com>
 <20120721075627.GF22859@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120721075627.GF22859@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sat, Jul 21, 2012 at 13:26:27, Sakari Ailus wrote:
> Hi Prabhakar,
> 
> Thanks for the patch.
> 
> On Fri, Jul 20, 2012 at 08:28:10PM +0530, Prabhakar Lad wrote:
> > From: Manjunath Hadli <manjunath.hadli@ti.com>
> > 
> > add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> > to represent Bayer format frames compressed by A-LAW algorithm,
> > add V4L2_PIX_FMT_UV8 to represent storage of CbCr data (UV interleaved)
> > only.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 ++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
> >  include/linux/videodev2.h                          |    8 +++
> >  4 files changed, 106 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > new file mode 100644
> > index 0000000..61cced5
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > @@ -0,0 +1,34 @@
> > +	<refentry>
> > +	  <refmeta>
> > +	    <refentrytitle>
> > +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> > +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
> > +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> > +	      V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'),
> 
> Could you use the same order as in Documentation/video4linux/4CCs.txt ? I
> know it's different in some existing documentation.
> 
  Ok.

Thx,
--Prabhakar Lad

> Regards,
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
> 

