Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2AXOQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 09:16:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Csillag Kristof <csillag.kristof@gmail.com>
Subject: Re: 720p webcam providing VDPAU-compatible video stream?
Date: Tue, 24 Jan 2012 15:16:21 +0100
Cc: linux-media@vger.kernel.org
References: <4F1C0921.1060109@gmail.com> <201201231541.32049.laurent.pinchart@ideasonboard.com> <4F1D8B51.4020507@gmail.com>
In-Reply-To: <4F1D8B51.4020507@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241516.21919.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kristof,

On Monday 23 January 2012 17:31:13 Csillag Kristof wrote:
> At 2012-01-23 15:41, Laurent Pinchart wrote:
> > I think your best bet is still UVC + H.264, as that's what the market is
> > moving to. Any other compressed format (except for MJPEG) will likely be
> > proprietary.
> > 
> > As you correctly mention, H.264 support isn't available yet in the UVC
> > driver. Patches are welcome ;-)
> 
> So... do I understand it correctly that with the current hw/sw stack, my
> original requirements can not be satisfied?

Not that I'm aware of.

> In that case, let's try with reduced requirements. What if I give up HD
> resolution and H264?
> 
> Is there a camera that can provide a HW-compressed 480p video stream, in
> MPEG-2 or something like that?

I don't think so. Once again, unless you can work with MJPEG, your best bet is 
UVC and H.264. But you will need to write the code (or find someone who can 
write it).

-- 
Regards,

Laurent Pinchart
