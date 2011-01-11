Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1AKMka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 07:40:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] [media] v4l2-ctrls: Add V4L2_CID_NIGHT_MODE control to support night mode
Date: Tue, 11 Jan 2011 13:41:19 +0100
Cc: Roberto Rodriguez Alcala <rralcala@gmail.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1294697907-1714-1-git-send-email-rralcala@gmail.com> <1294697907-1714-2-git-send-email-rralcala@gmail.com> <201101102334.36968.hverkuil@xs4all.nl>
In-Reply-To: <201101102334.36968.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111341.19880.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Monday 10 January 2011 23:34:36 Hans Verkuil wrote:
> On Monday, January 10, 2011 23:18:26 Roberto Rodriguez Alcala wrote:

[snip]

> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 5f6f470..0df8a9f 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1300,6 +1300,8 @@ enum  v4l2_exposure_auto_type {
> > 
> >  #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
> >  #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
> > 
> > +#define V4L2_CID_NIGHT_MODE                    
> > (V4L2_CID_CAMERA_CLASS_BASE+19) +
> > 
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> >  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> 
> This control also needs to be documented in
> Documentation/DocBook/v4l/controls.xml.
> 
> However, reading up a bit on this I wonder whether this shouldn't be a
> 'Camera Mode' menu control since there can be a lot of different modes:
> 
> http://www.digital-photography-school.com/digital-camera-modes
> 
> Also, how does this relate to controls like EXPOSURE_AUTO? Will selecting
> manual exposure automatically turn off Night Mode? Or the inverse, will
> selecting Night Mode automatically turn on autoexposure?

I'm in favor of a Camera Mode menu control, but we need to define the 
semantics of modes properly, and especially how they relate to other controls. 
Modes tend to be high-level controls that are usually implemented in software, 
so they will definitely have an influence on many low-level controls.

-- 
Regards,

Laurent Pinchart
