Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64336 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1DCReg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 13:34:36 -0400
Received: by vxi39 with SMTP id 39so3687120vxi.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 10:34:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 3 Apr 2011 10:34:15 -0700
Message-ID: <BANLkTimGCJRv2Hd6ejgewPpRd4ZK=thPxA@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] V4L: new ioctl()s to support multi-sized video-buffers
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Fri, Apr 1, 2011 at 01:12, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi all
>
> As discussed at the last V4L2 meeting in Warsaw, one of the prerequisites
> to support fast switching between different image formats is an ability to
> preallocate buffers of different sizes and handle them over to the driver
> in advance. This avoids the need to allocate buffers at the time of
> switching. This patch series is a first implementation of these ioctl()s,
> implemented for the sh_mobile_ceu_camera soc-camera host driver. Tested on
> an sh7722 migor SuperH platform. Yes, I know, documentation is missing
> yet;-)
>

I will have to wait for documentation before doing a full review, it's
hard to comment without it. Also, please mention how the new ioctls
influence the state machine. Some questions and doubts I'm having:
- Can you call CREATE more than once, before/after REQBUFS, for all
streaming states? What about reading/writing?
- Can driver decline CREATE if it is not supported? What if the format
is not supported?
- If we fail allocating in CREATE, should the whole queue be freed (as
it is done in your patch I believe)?
- I'm assuming REQBUFS(0) is to free buffers allocated with CREATE too?
- Are we allowing DESTROY to free arbitrary span of buffers (i.e.
those created with REQBUFS as well)?
- Are "holes" in buffer indexes allowed? I don't like the ability to
free an arbitrary span of buffers in the queue, it complicates checks
in many places and I don't think is worth it...
- I understand SUBMIT is optional?
- Could you give an example of how this could be used in an application?

-- 
Best regards,
Pawel Osciak
