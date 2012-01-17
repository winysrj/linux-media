Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48965 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2AQTfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 14:35:51 -0500
Date: Tue, 17 Jan 2012 21:35:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 09/23] v4l: Add DPCM compressed formats
Message-ID: <20120117193546.GC13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <1326317220-15339-9-git-send-email-sakari.ailus@iki.fi>
 <201201161501.51287.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201161501.51287.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Mon, Jan 16, 2012 at 03:01:50PM +0100, Laurent Pinchart wrote:
> On Wednesday 11 January 2012 22:26:46 Sakari Ailus wrote:
> > Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
> >  .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29
> > ++++++++++++++++++++ Documentation/DocBook/media/v4l/pixfmt.xml         | 
> >   1 +
> >  include/linux/videodev2.h                          |    3 ++
> >  4 files changed, 34 insertions(+), 1 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml index
> > 7b27409..c1c62a9 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> > @@ -1,4 +1,4 @@
> > -    <refentry>
> > +    <refentry id="pixfmt-srggb10">
> >        <refmeta>
> >  	<refentrytitle>V4L2_PIX_FMT_SRGGB10 ('RG10'),
> >  	 V4L2_PIX_FMT_SGRBG10 ('BA10'),
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml new file mode
> > 100644
> > index 0000000..985440c
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> > @@ -0,0 +1,29 @@
> > +    <refentry>
> > +      <refmeta>
> > +	<refentrytitle>
> > +	 V4L2_PIX_FMT_SRGGB10DPCM8 ('bBA8'),
> > +	 V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'),
> > +	 V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'),
> > +	 V4L2_PIX_FMT_SBGGR10DPCM8 ('bRA8'),
> 
> Could you briefly explain the rationale behind the FOURCCs in the patch commit 
> message ? Manjunath needs similar FOURCCs for A-law compression, what should 
> he use ?

Sure; I'll do that.

> > +	 </refentrytitle>
> > +	&manvol;
> > +      </refmeta>
> > +      <refnamediv>
> > +	<refname
> > id="V4L2-PIX-FMT-SRGGB10DPCM8"><constant>V4L2_PIX_FMT_SRGGB10DPCM8</consta
> > nt></refname> +	<refname
> > id="V4L2-PIX-FMT-SGRBG10DPCM8"><constant>V4L2_PIX_FMT_SGRBG10DPCM8</consta
> > nt></refname> +	<refname
> > id="V4L2-PIX-FMT-SGBRG10DPCM8"><constant>V4L2_PIX_FMT_SGBRG10DPCM8</consta
> > nt></refname> +	<refname
> > id="V4L2-PIX-FMT-SBGGR10DPCM8"><constant>V4L2_PIX_FMT_SBGGR10DPCM8</consta
> > nt></refname> +	<refpurpose>10-bit Bayer formats compressed to 8
> > bits</refpurpose> +      </refnamediv>
> > +      <refsect1>
> > +	<title>Description</title>
> > +
> > +	<para>The following four pixel formats are raw sRGB / Bayer
> > +	formats with 10 bits per colour compressed to 8 bits each,
> > +	using the DPCM. DPCM, differential pulse-code modulation, is
> 
> s/the DPCM/DPCM/ ?

Fixed. It's now s/the DPCM/DPCM compression/.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
