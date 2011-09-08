Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51027 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1IHX2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 19:28:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] v4l: Remove experimental note from ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS
Date: Thu, 8 Sep 2011 18:22:02 +0200
Cc: linux-media@vger.kernel.org
References: <1315002508-11651-1-git-send-email-sakari.ailus@iki.fi> <20110903072612.GG13242@valkosipuli.localdomain>
In-Reply-To: <20110903072612.GG13242@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081822.02491.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 03 September 2011 09:26:12 Sakari Ailus wrote:
> On Sat, Sep 03, 2011 at 01:28:28AM +0300, Sakari Ailus wrote:
> > VIDIOC_ENUM_FRAMESIZES and VIDIOC_FRAME_INTERVALS have existed for quite
> > some time, are widely supported by various drivers and are being used by
> > applications. Thus they no longer can be considered experimental.
> 
> I mostly intended to send this as RFC/PATCH (but forgot to give right
> options to git format-patch) to provoke a little bit discussion on how we
> should remove the experimental tags from features. These two ioctls are
> such that I'm aware are relatively widely used. No idea about the rest.

I agree with the removal of the experimental note. Those ioctls are widely 
used by webcam (and other) applications and have been available for quite some 
time now.

This being said, I'm not sure if I would design them the same way today. They 
have clear UVC roots, and I would likely merge V4L2_FRMSIZE_TYPE_CONTINUOUS 
and V4L2_FRMSIZE_TYPE_STEPWISE in a single type for instance. Howevern given 
the wide user base, I don't think it would be a good idea to break the API and 
ABI, even though both ioctls are currently experimental.

> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/compat.xml         |    4 ----
> >  .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |    7 -------
> >  2 files changed, 0 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/compat.xml
> > b/Documentation/DocBook/media/v4l/compat.xml index ce1004a..a6261c1
> > 100644
> > --- a/Documentation/DocBook/media/v4l/compat.xml
> > +++ b/Documentation/DocBook/media/v4l/compat.xml
> > @@ -2458,10 +2458,6 @@ and may change in the future.</para>
> > 
> >  &VIDIOC-QUERYCAP; ioctl, <xref linkend="device-capabilities" />.</para>
> >  
> >          </listitem>
> >          <listitem>
> > 
> > -	  <para>&VIDIOC-ENUM-FRAMESIZES; and
> > -&VIDIOC-ENUM-FRAMEINTERVALS; ioctls.</para>
> > -        </listitem>
> > -        <listitem>
> > 
> >  	  <para>&VIDIOC-G-ENC-INDEX; ioctl.</para>
> >  	  
> >          </listitem>
> >          <listitem>
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> > b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml index
> > f77a13f..a78454b 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> > @@ -50,13 +50,6 @@ and pixel format and receives a frame width and
> > height.</para>
> > 
> >    <refsect1>
> >    
> >      <title>Description</title>
> > 
> > -    <note>
> > -      <title>Experimental</title>
> > -
> > -      <para>This is an <link linkend="experimental">experimental</link>
> > -interface and may change in the future.</para>
> > -    </note>
> > -
> > 
> >      <para>This ioctl allows applications to enumerate all frame sizes
> >  
> >  (&ie; width and height in pixels) that the device supports for the
> >  given pixel format.</para>

-- 
Regards,

Laurent Pinchart
