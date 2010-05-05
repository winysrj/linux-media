Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53378 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0EEK4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 06:56:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gijo Prems <gijoprems@gmail.com>
Subject: Re: UVC Webcam
Date: Wed, 5 May 2010 12:56:35 +0200
Cc: linux-media@vger.kernel.org
References: <o2g75026db31004290354u8fc403a0n47115d96ea55c3e5@mail.gmail.com>
In-Reply-To: <o2g75026db31004290354u8fc403a0n47115d96ea55c3e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051256.36580.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gijo,

On Thursday 29 April 2010 12:54:16 Gijo Prems wrote:
> Hello,
> 
> I have some queries related to linux uvc client driver(uvcvideo) and
> general uvc webcam functionality.
> 
> 1. There is a wDelay (during probe-commit) parameter which camera
> exposes to the host signifying the delay (Latency) inside the camera.
> Does the UVC driver on Linux Host expose this parameter to the
> application if they require it?

No it doesn't.

> And what would be the use case of this parameter?

I don't know, and that's exactly why the parameter isn't exposed :-)

> 2. How the audio and video sync (lipsync) would happen on host side?

There's no sync at the moment. UVC supports timestamping the packets sent to 
the host, but the driver ignores the timestamps.

> 3. How buffers are allocated on the host side?
> Which parameter from camera needs to be set to signify the correct
> buffer allocation?

There are two sets of buffers, the USB buffers and the V4L2 buffers.

The uvcvideo driver allocates one USB buffer per URB (the number of URBs is 
hardcoded to 5). The USB buffer size is set to the payload size returned by 
the device, bounded to a maximum value of 32 times the endpoint max packet 
size.

For V4L2 buffers, the uvcvideo driver uses the V4L2 MMAP streaming mode. 
Applications are supposed to first set the format (VIDIOC_S_FMT), and then ask 
the driver to allocate buffers (VIDIOC_REQBUFS).

> 4. Are there any parameters in USB audio class which allocate the
> buffers and handles the latency at host?

I don't know much about the USB audio class, sorry.

> It would be great if someone could put some thoughts on these.

-- 
Regards,

Laurent Pinchart
