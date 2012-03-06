Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:43680 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab2CFL7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:59:48 -0500
Date: Tue, 6 Mar 2012 13:59:39 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v3 2/2] v4l2: add new pixel formats supported on dm365
Message-ID: <20120306115939.GC1075@valkosipuli.localdomain>
References: <1328609114-5487-1-git-send-email-manjunath.hadli@ti.com>
 <1328609114-5487-3-git-send-email-manjunath.hadli@ti.com>
 <20120304151935.GA879@valkosipuli.localdomain>
 <E99FAA59F8D8D34D8A118DD37F7C8F7531759F0A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F7531759F0A@DBDE01.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Mon, Mar 05, 2012 at 07:45:18AM +0000, Hadli, Manjunath wrote:
> On Sun, Mar 04, 2012 at 20:49:36, Sakari Ailus wrote:
> > On Tue, Feb 07, 2012 at 03:35:14PM +0530, Manjunath Hadli wrote:
> > > add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats to 
> > > represent Bayer format frames compressed by A-LAW algorithm, add 
> > > V4L2_PIX_FMT_UV8 to represent storage of C data (UV interleaved) only.
> > > 
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
> > >  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 ++++++++++++++++++++
> > >  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
> > >  include/linux/videodev2.h                          |    9 +++
> > >  4 files changed, 107 insertions(+), 0 deletions(-)  create mode 
> > > 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml 
> > > b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > > new file mode 100644
> > > index 0000000..b20f525
> > > --- /dev/null
> > > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > > @@ -0,0 +1,34 @@
> > > +	<refentry>
> > > +	  <refmeta>
> > > +	    <refentrytitle>
> > > +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> > > +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> > > +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
> > > +	      V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'),
> > > +	    </refentrytitle>
> > > +	    &manvol;
> > > +	  </refmeta>
> > > +	  <refnamediv>
> > > +	    <refname id="V4L2-PIX-FMT-SRGGB10ALAW8">
> > > +	      <constant>V4L2_PIX_FMT_SRGGB10ALAW8</constant>
> > > +	    </refname>
> > > +	    <refname id="V4L2-PIX-FMT-SGRBG10ALAW8">
> > > +	      <constant>V4L2_PIX_FMT_SGRBG10ALAW8</constant>
> > > +	    </refname>
> > > +	    <refname id="V4L2-PIX-FMT-SGBRG10ALAW8">
> > > +	      <constant>V4L2_PIX_FMT_SGBRG10ALAW8</constant>
> > > +	    </refname>
> > 
> > The order here is different than earlier.
>   I had taken a reference from your v3 patch series (v4l: Add DPCM compressed formats). Do you want me to change it?

It certainly shouldn't be that way. I'll fix it for the next version.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
