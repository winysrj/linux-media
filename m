Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62203 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbcARLzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 06:55:33 -0500
Date: Mon, 18 Jan 2016 12:55:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <20160114112914.GM576@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1601181250000.9140@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
 <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
 <Pine.LNX.4.64.1601141159520.15949@axis700.grange>
 <20160114112914.GM576@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 Jan 2016, Sakari Ailus wrote:

> Hi Guennadi,
> 
> On Thu, Jan 14, 2016 at 12:12:08PM +0100, Guennadi Liakhovetski wrote:
> > Hi Sakari,
> > 
> > Thanks for a review! I'll fix all the cosmetic issues, thanks. As for 
> > other comments:
> > 
> > On Wed, 13 Jan 2016, Sakari Ailus wrote:
> > 
> > [snip]
> > 
> > > > --- /dev/null
> > > > +++ b/Documentation/DocBook/media/v4l/pixfmt-y12i.xml
> > > > @@ -0,0 +1,49 @@
> > > > +<refentry id="V4L2-PIX-FMT-Y12I">
> > > > +  <refmeta>
> > > > +    <refentrytitle>V4L2_PIX_FMT_Y12I ('Y12I ')</refentrytitle>
> > > 
> > > Extra space after 4cc.                        ^
> > > 
> > > > +    &manvol;
> > > > +  </refmeta>
> > > > +  <refnamediv>
> > > > +    <refname><constant>V4L2_PIX_FMT_Y12I</constant></refname>
> > > > +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> > > > +  </refnamediv>
> > > > +  <refsect1>
> > > > +    <title>Description</title>
> > > > +
> > > > +    <para>This is a grey-scale image with a depth of 12 bits per pixel, but with
> > > > +pixels from 2 sources interleaved and bit-packed. Each pixel is stored in a
> > > > +24-bit word. E.g. data, stored by a R200 RealSense camera on a little-endian
> > > > +machine can be deinterlaced using</para>
> > > 
> > > I think we should precisely define the format, either big or little. Is the
> > > endianness of the format affected by the machine endianness? (I'd guess no,
> > > but that's just a guess.)
> > 
> > Ok, since this works on a LE machine:
> > 
> > left0 = 0xfff & *(__u16 *)buf;
> > 
> > I think we can call data LE in the buffer. But specifying left-right order 
> > cannot be done in terms of endianness, so, I provided that code snippet.
> 
> I meant that the the format definition should clearly say which one is the
> order.
> 
> > 
> > > I wonder if the format should convey the information which one is right and
> > > which one is left, e.g. by adding "LR" to the name.
> > 
> > You mean to distinguish between LR and RL? Can do in principle, yes.
> 
> If we want the format to have an exact definition, we should have this as
> well.
> 
> I think the formats increasingly have little details such as this one which
> require adding many format variants but I'm not sure if it's even a problem.
> 
> I'd postfix the name with "LR" or at least document that this is the pixel
> order.

Don't think that's a good option ATM since the format is already in 
videodev2.h

> > > No need to mention RealSense specifically IMO.
> > 
> > Ok.
> > 
> > > > +
> > > > +<para>
> > > > +<programlisting>
> > > > +__u8 *buf;
> > > > +left0 = 0xfff &amp; *(__u16 *)buf;
> > > > +rirhgt0 = *(__u16 *)(buf + 1) >> 4;
> > > 
> > > "right"
> > 
> > [snip]
> > 
> > > > diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > > > new file mode 100644
> > > > index 0000000..fac3c68
> > > > --- /dev/null
> > > > +++ b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > > > @@ -0,0 +1,79 @@
> > > > +<refentry id="V4L2-PIX-FMT-Z16">
> > > > +  <refmeta>
> > > > +    <refentrytitle>V4L2_PIX_FMT_Z16 ('Z16 ')</refentrytitle>
> > > > +    &manvol;
> > > > +  </refmeta>
> > > > +  <refnamediv>
> > > > +    <refname><constant>V4L2_PIX_FMT_Z16</constant></refname>
> > > > +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> > > > +  </refnamediv>
> > > > +  <refsect1>
> > > > +    <title>Description</title>
> > > > +
> > > > +    <para>This is a 16-bit format, representing depth data. Each pixel is a
> > > > +distance in mm to the respective point in the image coordinates. Each pixel is
> > > > +stored in a 16-bit word in the little endian byte order.</para>
> > > 
> > > The format itself looks quite generic but the unit might be specific to the
> > > device. It'd sound silly to add a new format if just the unit is different.
> > 
> > My understanding is, that each format must have a fixed meaning, i.e. a 
> > fixed depth unit too, although it would definitely help to be able to 
> > relax that requirement in this case.
> 
> Agreed.
> 
> > > How about re-purpose the colourspace field for depth formats and
> > > add a flag telling the colour space field contains the unit and the unit
> > > prefix.
> > 
> > Hmmm... Not sure I find this a proper use of the .colorspace field...
> 
> I think colour space doesn't make much sense in context of depth.

Agree, still I don't think it is a good idea to abuse it for a different 
purpose. If it doesn't make sense it simply shouldn't be used.

Thanks
Guennadi

> > > Not something to have in this patch nor patchset though: controls
> > > should gain that as well.
> > 
> > Sorry, didn't get this - how can a control tell you what units a specific 
> > format uses? What if your camera can output depth in multiple units?
> 
> Controls do not have units at the moment. The specification often suggests a
> unit but using the unit suggested by the spec isn't always possible, thus
> it'd be useful to have this available through VIDIOC_QUERYCTRL.
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
> 
