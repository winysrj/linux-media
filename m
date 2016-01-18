Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54282 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbcARMhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:37:04 -0500
Date: Mon, 18 Jan 2016 13:36:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <20160118122119.GC3458@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1601181333180.9140@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
 <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
 <Pine.LNX.4.64.1601141159520.15949@axis700.grange>
 <20160114112914.GM576@valkosipuli.retiisi.org.uk>
 <Pine.LNX.4.64.1601181250000.9140@axis700.grange>
 <20160118122119.GC3458@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2016, Sakari Ailus wrote:

[snip]

> > > > > I wonder if the format should convey the information which one is right and
> > > > > which one is left, e.g. by adding "LR" to the name.
> > > > 
> > > > You mean to distinguish between LR and RL? Can do in principle, yes.
> > > 
> > > If we want the format to have an exact definition, we should have this as
> > > well.
> > > 
> > > I think the formats increasingly have little details such as this one which
> > > require adding many format variants but I'm not sure if it's even a problem.
> > > 
> > > I'd postfix the name with "LR" or at least document that this is the pixel
> > > order.
> > 
> > Don't think that's a good option ATM since the format is already in 
> > videodev2.h
> 
> Is it? I can't see it in my tree at least.

It is, and you signed off under it and submitted it;-)

https://patchwork.linuxtv.org/patch/31690/

> 14:16:48 vihersipuli sailus [~/scratch/git/linux]git grep -c V4L2_PIX_FMT_Y12I nclude/uapi/linux/videodev2.h
> 14:16:50 vihersipuli sailus [~/scratch/git/linux]
> 
> > 
> > > > > No need to mention RealSense specifically IMO.
> > > > 
> > > > Ok.
> > > > 
> > > > > > +
> > > > > > +<para>
> > > > > > +<programlisting>
> > > > > > +__u8 *buf;
> > > > > > +left0 = 0xfff &amp; *(__u16 *)buf;
> > > > > > +rirhgt0 = *(__u16 *)(buf + 1) >> 4;
> > > > > 
> > > > > "right"
> > > > 
> > > > [snip]
> > > > 
> > > > > > diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > > > > > new file mode 100644
> > > > > > index 0000000..fac3c68
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> > > > > > @@ -0,0 +1,79 @@
> > > > > > +<refentry id="V4L2-PIX-FMT-Z16">
> > > > > > +  <refmeta>
> > > > > > +    <refentrytitle>V4L2_PIX_FMT_Z16 ('Z16 ')</refentrytitle>
> > > > > > +    &manvol;
> > > > > > +  </refmeta>
> > > > > > +  <refnamediv>
> > > > > > +    <refname><constant>V4L2_PIX_FMT_Z16</constant></refname>
> > > > > > +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> > > > > > +  </refnamediv>
> > > > > > +  <refsect1>
> > > > > > +    <title>Description</title>
> > > > > > +
> > > > > > +    <para>This is a 16-bit format, representing depth data. Each pixel is a
> > > > > > +distance in mm to the respective point in the image coordinates. Each pixel is
> > > > > > +stored in a 16-bit word in the little endian byte order.</para>
> > > > > 
> > > > > The format itself looks quite generic but the unit might be specific to the
> > > > > device. It'd sound silly to add a new format if just the unit is different.
> > > > 
> > > > My understanding is, that each format must have a fixed meaning, i.e. a 
> > > > fixed depth unit too, although it would definitely help to be able to 
> > > > relax that requirement in this case.
> > > 
> > > Agreed.
> > > 
> > > > > How about re-purpose the colourspace field for depth formats and
> > > > > add a flag telling the colour space field contains the unit and the unit
> > > > > prefix.
> > > > 
> > > > Hmmm... Not sure I find this a proper use of the .colorspace field...
> > > 
> > > I think colour space doesn't make much sense in context of depth.
> > 
> > Agree, still I don't think it is a good idea to abuse it for a different 
> > purpose. If it doesn't make sense it simply shouldn't be used.
> 
> We are already using anonymous unions for this exact purpose already, albeit
> their use was planned in most cases at least. I don't see anything wrong
> with this, considering that existing applications dealing with the format
> wouldn't know what to do about it anyway.

Sure, I understand that it can be done using an anonymous union. I just 
don't want to specify this in this patch , it should be a separate change, 
I think.

Thanks
Guennadi
