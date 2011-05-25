Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38979 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1EYUGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 16:06:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jerry Geis <geisj@messagenetsystems.com>
Subject: Re: h.264 web cam
Date: Wed, 25 May 2011 22:06:38 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <4DDD5C3B.6060706@MessageNetSystems.com>
In-Reply-To: <4DDD5C3B.6060706@MessageNetSystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105252206.39243.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jerry,

On Wednesday 25 May 2011 21:44:59 Jerry Geis wrote:
> I am trying to find the code for h.264 mentioned
>  http://www.spinics.net/lists/linux-media/msg29129.html
> 
> I downloaded the linux-media-2011-05.24 and it is not part of uvc_driver.c
> 
> Where can I get the code?

That code only exists in the patches you've found. They haven't been applied 
to the uvcvideo driver, because we haven't decided yet how H.264 should be 
exposed to applications by the V4L2 API.

We now have a better understanding of H.264. Hans, could you review the H.264 
patch at the link above and tell me what you now think about the new fourcc ?

-- 
Regards,

Laurent Pinchart
