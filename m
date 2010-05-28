Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36674 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754694Ab0E1KHw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 06:07:52 -0400
Date: Fri, 28 May 2010 12:07:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rob Clark <rob@ti.com>
cc: linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
In-Reply-To: <4BFED8B0.8010504@ti.com>
Message-ID: <Pine.LNX.4.64.1005280851000.32352@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
 <AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
 <Pine.LNX.4.64.1005270809110.2293@axis700.grange> <4BFED8B0.8010504@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(re-adding lists to CC)

On Thu, 27 May 2010, Rob Clark wrote:

> Hi Guennadi,
> 
> Sounds like an interesting idea... but how about the inverse?  A v4l2
> interface on top of fbdev.  If v4l2 was more widely available as an output
> device, perhaps more userspace software would utilize it.

Don't see any advantage in doing this apart from "attracting user-space 
developers to develop for v4l2 output interface," which doesn't seem like 
a worthy goal in itself. Whereas with my translation you get access to 
existing user-space applications and to a powerful in-kernel API, and 
achieve a better interoperability with video-input streams.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
