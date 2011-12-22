Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38018 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1LVKRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 05:17:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input (Y12) is truncated to Y10 at the CCDC output?
Date: Thu, 22 Dec 2011 11:17:20 +0100
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com> <201112211155.36565.laurent.pinchart@ideasonboard.com> <CAOy7-nMhQ6qB2iy+230Gg7yRMV3MtmF6mHAvTtqWR0rAN1DMmw@mail.gmail.com>
In-Reply-To: <CAOy7-nMhQ6qB2iy+230Gg7yRMV3MtmF6mHAvTtqWR0rAN1DMmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112221117.20939.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Thursday 22 December 2011 07:23:56 James wrote:
>
> Tried the new yavta but encountered a different situation.
> 
> yavta -p -f Y12 -s 640x512 -n 2 --capture=10 --skip 5 -F `media-ctl -e
> "OMAP3 ISP CCDC output"` --file=./DCIM/Y12
> 
> yavta will hang for infinite time and only Ctrl+C will break out of
> the wait and a new error message appears.
> 
> yavta: video_do_capture:  calling ioctl..
> ^C
> omap3isp omap3isp: CCDC stop timeout!
> 
> I placed some debugging printf() and yavta wait at
> 
> ret = ioctl(dev->fd, VIDIOC_DQBUF, &buf);
> 
> Attached is the logfile (mono640.yavta-y12.1.log)
> 
> What should be the remedies?

The pipeline seems to be configured correctly. My guess would be that the 
sensor doesn't send what the ISP expects. You should check the sensor 
configuration, and maybe verify the pixel clock, hsync and vsync signals with 
a scope.

-- 
Regards,

Laurent Pinchart
