Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39286 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2AWOl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:41:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Csillag Kristof <csillag.kristof@gmail.com>
Subject: Re: 720p webcam providing VDPAU-compatible video stream?
Date: Mon, 23 Jan 2012 15:41:31 +0100
Cc: linux-media@vger.kernel.org
References: <4F1C0921.1060109@gmail.com>
In-Reply-To: <4F1C0921.1060109@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231541.32049.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kristof,

On Sunday 22 January 2012 14:03:29 Csillag Kristof wrote:
> Dear linux-media users,
> 
> I have stopped following the advancements in Linux video
> (and video hw in general) a while ago, so I am no longer
> up to date with the current technologies,
> therefore I seek your advice.
> 
> I am looking for for a webcam that
>   - works properly under GNU/Linux (without proprietary drivers)
>   - connects via USB 2.0
>   - can capture 720p video at 25 or 30 FPS
>   - provides a video stream that
>     - is hardware compressed by the camera
>     - can be recorded to a file with minimal CPU requirements
>       (Bonus points if it's wrapped a nice container format,
>       so that I can simply record it by something like
>       cat /dev/video0 > capture.mpeg
>       - like old Hauppauge PVR-250 cards )
>     - can be decoded by VDPAU hw acceleration
> 
> I have tried to look into this, and it seems that the status for H264
> streams for UVC webcams is still problematic.

I think your best bet is still UVC + H.264, as that's what the market is 
moving to. Any other compressed format (except for MJPEG) will likely be 
proprietary.

As you correctly mention, H.264 support isn't available yet in the UVC driver. 
Patches are welcome ;-)

> However, I don't specifically need neither UVC nor H264; any driver,
> and any other VDPAU-supported format (like MPEG-2, VC-1, WMV9, etc)
> could be OK.
> 
> I am not interested in sykpe; I only want to capture the 720p video stream
> to files (with as low CPU usage as possible), and play it back
> using mplayer, on NVidia cards supporting VDPAU hw acceleration
>   - again, with as low CPU usage, as possible.
> 
> Could someone please recommend me a device that can do this?
> (Or tell me which device will likely get the required support soon?

-- 
Regards,

Laurent Pinchart
