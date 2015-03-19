Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48500 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbbCSQK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 12:10:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Oliver Lehmann <lehmann@ans-netz.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: capture high resolution images from webcam
Date: Thu, 19 Mar 2015 18:10:39 +0200
Message-ID: <1715183.7doEMqzC1N@avalon>
In-Reply-To: <Pine.LNX.4.64.1503182220410.15761@axis700.grange>
References: <20150317223529.Horde.S4cQ0yA7NJaIix7vWKABGA9@avocado.salatschuessel.net> <Pine.LNX.4.64.1503182220410.15761@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 18 March 2015 22:49:07 Guennadi Liakhovetski wrote:
> On Tue, 17 Mar 2015, Oliver Lehmann wrote:
> > Hi,
> > 
> > I'm using v4l2 on FreeBSD but I hope this doesn't matter that much.
> > I got a new MS LifeCam Studio HD which makes quite good pictures
> > because of its focus possibilites.
> > 
> > When I use the original software provided by MS the "autofocus"
> > feature works damn good. With v4l2, autofocus is enabled but it
> > just does not focus. Disabling autofocus and setting focus manually
> > does work (and in my case this is sufficient)
> > 
> > Another point is, that this cam can record pictures with 8 megapixel
> > which results in 3840x2160 image files. This "8MP mode" and the 1080p
> > mode is only available for snapshot pictures. The highest resolution
> > supported for videos is 720p.
> 
> I'm not sure I can help, at least definitely not until I know details. But
> in either case I'd be interested to know details of this camera. Can you
> find out what driver is serving it, what standard it is? Looking at the
> Microsoft so veeeery "technical" data sheet it says, it is compatible with
> Android. So, it hints at it being a UVC camera.
> 
> As for the actual question, I have no idea how they implement still
> images: the UVC standard defines two methods for higher-resolution still
> image capture: either using the "still image trigger control" or a
> dedicated bulk pipeline (and a hardware button if there is one on your
> camera?) FWIW, in either case I'm not sure whether the driver supports any
> of those methods. I think bulk pipe support has been added to it at some
> point, but what concerns switching... Not sure really, sorry.

Still image capture isn't implemented in the uvcvideo driver. Part of the 
reason is that I never managed to get my hands on a device that implements it 
(but I haven't tried very hard either).

> But if you just try to be opportunistic and try cheese - it has a separate
> setting for still images, so, maybe I'm way behind the time and everything
> is working already?
> 
> Thanks
> Guennadi
> 
> > All I want is recording snapshot images and I do not need the video
> > capability at all.
> > 
> > I wonder how I can capture those big 8MP images? With mplayer I'm
> > only able toe capture 720p at max. I guess because mplayer just
> > accesses the video mode and takes a single frame.
> > 
> > mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=1280:height=720
> > -frames 1 -vo jpeg
> > 
> > I wonder if there is a possibility to access the cam in the
> > I-call-it-snapshot-mode to take single pictures with higher resolutions?

-- 
Regards,

Laurent Pinchart

