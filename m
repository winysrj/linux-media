Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1IEKAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 06:00:40 -0400
Date: Mon, 5 Sep 2011 12:00:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bastian Hecht <hechtb@googlemail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for
 the ov5642 camera driver
In-Reply-To: <CABYn4sxJQsoCZXcVtKg9N+oJBgf42JSKe6YXV+fCCtY919Suaw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109051153500.1112@axis700.grange>
References: <alpine.DEB.2.02.1108311420540.2154@ipanema>
 <201108311932.08252.laurent.pinchart@ideasonboard.com>
 <CABYn4sx25RbeKFDn8=cPuJETpornXW+osstrMEi9AjrtQAfSeA@mail.gmail.com>
 <201109051125.33829.laurent.pinchart@ideasonboard.com>
 <CABYn4sxJQsoCZXcVtKg9N+oJBgf42JSKe6YXV+fCCtY919Suaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Sep 2011, Bastian Hecht wrote:

[snip]

> And these ioctl calls go straight through to my driver? Or is there
> some intermediate work by the subdev architecture? I'm asking because
> I don't check the buffer type in g_fmt as well. If so, I have to
> change that too.

With soc-camera all ioctl()s first enter in soc_camera.c (check 
soc_camera_ioctl_ops), then they are typically dispatched to the camera 
host driver, which then calls respective subdev methods. Check respective 
ioctl() implementations for details.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
