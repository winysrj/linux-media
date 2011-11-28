Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37940 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1K1Khr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 05:37:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hendrik Sattler <post@hendrik-sattler.de>
Subject: Re: Problem with linux-3.1.3
Date: Mon, 28 Nov 2011 11:37:52 +0100
Cc: linux-media@vger.kernel.org
References: <201111271404.02435.post@hendrik-sattler.de>
In-Reply-To: <201111271404.02435.post@hendrik-sattler.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281137.53063.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hendrik,

On Sunday 27 November 2011 14:04:02 Hendrik Sattler wrote:
> Hi,
> 
> I just updated by self-built kernel-from v3.1 to v3.1.3.
> With the new version, my built-in webcam[1] does not work anymore but it
> did with v3.1.
> $ luvcview
> luvcview 0.2.6
> 
> SDL information:
>   Video driver: x11
>   A window manager is available
> Device information:
>   Device path:  /dev/video0
> Stream settings:
>   Frame format: MJPG
>   Frame size:   640x480
>   Frame rate:   30 fps
> libv4l2: error turning on stream: No space left on device
> Unable to start capture: No space left on device
> Error grabbing
> Cleanup done. Exiting ...
> 
> The following kernel message pop up with those tries:
> uvcvideo: UVC non compliance - GET_MIN/MAX(PROBE) incorrectly supported.
> Enabling workaround.

That can usually be safely ignored. Let's try to fix the second issue first.

> uvcvideo: Failed to submit URB 0 (-28).
> 
> 
> Same for using e.g. Google+ Hangouts which worked fine using v3.1.
> 
> Any ideas what might be wrong?

I'm tempted to blame http://git.kernel.org/?p=linux/kernel/git/stable/linux-
stable.git;a=commit;h=f0cc710a6dec5b808a6f13f1f8853c094fce5f12. Could you 
please try reverting that patch and see if it fixes your issue ?

-- 
Regards,

Laurent Pinchart
