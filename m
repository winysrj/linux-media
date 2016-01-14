Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54495 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbcANLMW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 06:12:22 -0500
Date: Thu, 14 Jan 2016 12:12:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1601141159520.15949@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
 <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for a review! I'll fix all the cosmetic issues, thanks. As for 
other comments:

On Wed, 13 Jan 2016, Sakari Ailus wrote:

[snip]

> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-y12i.xml
> > @@ -0,0 +1,49 @@
> > +<refentry id="V4L2-PIX-FMT-Y12I">
> > +  <refmeta>
> > +    <refentrytitle>V4L2_PIX_FMT_Y12I ('Y12I ')</refentrytitle>
> 
> Extra space after 4cc.                        ^
> 
> > +    &manvol;
> > +  </refmeta>
> > +  <refnamediv>
> > +    <refname><constant>V4L2_PIX_FMT_Y12I</constant></refname>
> > +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> > +  </refnamediv>
> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>This is a grey-scale image with a depth of 12 bits per pixel, but with
> > +pixels from 2 sources interleaved and bit-packed. Each pixel is stored in a
> > +24-bit word. E.g. data, stored by a R200 RealSense camera on a little-endian
> > +machine can be deinterlaced using</para>
> 
> I think we should precisely define the format, either big or little. Is the
> endianness of the format affected by the machine endianness? (I'd guess no,
> but that's just a guess.)

Ok, since this works on a LE machine:

left0 = 0xfff & *(__u16 *)buf;

I think we can call data LE in the buffer. But specifying left-right order 
cannot be done in terms of endianness, so, I provided that code snippet.

> I wonder if the format should convey the information which one is right and
> which one is left, e.g. by adding "LR" to the name.

You mean to distinguish between LR and RL? Can do in principle, yes.

> No need to mention RealSense specifically IMO.

Ok.

> > +
> > +<para>
> > +<programlisting>
> > +__u8 *buf;
> > +left0 = 0xfff &amp; *(__u16 *)buf;
> > +rirhgt0 = *(__u16 *)(buf + 1) >> 4;
> 
> "right"

[snip]

> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > new file mode 100644
> > index 0000000..fac3c68
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > @@ -0,0 +1,79 @@
> > +<refentry id="V4L2-PIX-FMT-Z16">
> > +  <refmeta>
> > +    <refentrytitle>V4L2_PIX_FMT_Z16 ('Z16 ')</refentrytitle>
> > +    &manvol;
> > +  </refmeta>
> > +  <refnamediv>
> > +    <refname><constant>V4L2_PIX_FMT_Z16</constant></refname>
> > +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> > +  </refnamediv>
> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>This is a 16-bit format, representing depth data. Each pixel is a
> > +distance in mm to the respective point in the image coordinates. Each pixel is
> > +stored in a 16-bit word in the little endian byte order.</para>
> 
> The format itself looks quite generic but the unit might be specific to the
> device. It'd sound silly to add a new format if just the unit is different.

My understanding is, that each format must have a fixed meaning, i.e. a 
fixed depth unit too, although it would definitely help to be able to 
relax that requirement in this case.

> How about re-purpose the colourspace field for depth formats and
> add a flag telling the colour space field contains the unit and the unit
> prefix.

Hmmm... Not sure I find this a proper use of the .colorspace field...

> Not something to have in this patch nor patchset though: controls
> should gain that as well.

Sorry, didn't get this - how can a control tell you what units a specific 
format uses? What if your camera can output depth in multiple units?

Thanks
Guennadi
