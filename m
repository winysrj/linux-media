Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2709 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1E0Jgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 05:36:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: h.264 web cam
Date: Fri, 27 May 2011 11:35:28 +0200
Cc: Jerry Geis <geisj@messagenetsystems.com>,
	linux-media@vger.kernel.org
References: <4DDD5C3B.6060706@MessageNetSystems.com> <201105252206.39243.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105252206.39243.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271135.28965.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, May 25, 2011 22:06:38 Laurent Pinchart wrote:
> Hi Jerry,
> 
> On Wednesday 25 May 2011 21:44:59 Jerry Geis wrote:
> > I am trying to find the code for h.264 mentioned
> >  http://www.spinics.net/lists/linux-media/msg29129.html
> > 
> > I downloaded the linux-media-2011-05.24 and it is not part of uvc_driver.c
> > 
> > Where can I get the code?
> 
> That code only exists in the patches you've found. They haven't been applied 
> to the uvcvideo driver, because we haven't decided yet how H.264 should be 
> exposed to applications by the V4L2 API.
> 
> We now have a better understanding of H.264. Hans, could you review the H.264 
> patch at the link above and tell me what you now think about the new fourcc ?

Yes, that's fine. It matches the proposals from Kamil Debski, so this can go ahead.

Regards,

	Hans
