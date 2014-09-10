Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34106 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaIJNl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 09:41:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Isaac Nickaein <nickaein.i@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Framerate is consistently divided by 2.5
Date: Wed, 10 Sep 2014 16:41:28 +0300
Message-ID: <1918377.tBK2dPDOH0@avalon>
In-Reply-To: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com>
References: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Isaac,

On Saturday 06 September 2014 12:35:25 Isaac Nickaein wrote:
> Hi,
> 
> After patching the kernel, the rate that images are captured from the
> camera reduce by a factor of 2.5.

How have you patched the kernel ? If you have both a working and non-working 
version you could use git-bisect to find the commit that causes this breakage.

> Here are a list of frame rates I have tried followed by the resulted frame-
> rate:
> 
> 10 fps --> 4 fps
> 15 fps --> 6 fps
> 25 fps --> 10 fps
> 30 fps --> 12 fps
> 
> Note that all of the rates are consistently divided by 2.5. This seems
> to be a clocking issue to me. Is there any multipliers in V4L2 (or
> UVC?) code in framerate calculation which depends on the hardware and
> be cause of this?

-- 
Regards,

Laurent Pinchart

