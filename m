Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52874 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776Ab2DPMlU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 08:41:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Subject: Re: UVC frame interval inconsistency
Date: Mon, 16 Apr 2012 14:40:53 +0200
Message-ID: <1689657.5vs7Qpi9BC@avalon>
In-Reply-To: <c29fa93d58ec0a2289435bc92ac63e46@chewa.net>
References: <c29fa93d58ec0a2289435bc92ac63e46@chewa.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rémi,

On Wednesday 11 April 2012 12:27:08 Rémi Denis-Courmont wrote:
>    Hello guys,
> 
> I have been reworking the V4L2 input in VLC and I hit what looks like a
> weird bug in the UVC driver. I am using a Logitech HD Pro C920 webcam.
> 
> By default, VLC tries to find the highest possible frame rate (actually
> smallest frame interval in V4L2), then the largest possible resolution at
> that frame rate.
> 
> When enumerating the frame sizes and intervals on the device, the winner
> is 800x600 at 30 f/s. But when setting 30 f/s with VIDIOC_S_PARM, the
> system call returns 24 f/s. Does anyone know why it is so? Is this a
> firmware bug or what?

The frame sizes and intervals returned by the uvcvideo driver during 
enumeration come directly from the values advertised by the device. When you 
set a frame rate using VIDIOC_S_PARM, the driver then negotiates the value 
with the device, and returns the frame rate it received from the device to the 
application. The device is free to adjust the frame rate (based on current 
lightning conditions for instance, if auto-exposure is turned on).

-- 
Regards,

Laurent Pinchart

