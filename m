Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754933Ab0F3SxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 14:53:08 -0400
Date: Wed, 30 Jun 2010 20:53:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Query] How to preserve soc_camera and still use a sensor for
 media controller?
In-Reply-To: <A24693684029E5489D1D202277BE89445638FD0E@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1006302048310.17489@axis700.grange>
References: <A24693684029E5489D1D202277BE89445638FD0E@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

On Wed, 30 Jun 2010, Aguirre, Sergio wrote:

> Hi all,
> 
> Is it possible to keep a sensor chip driver compatible with 2 interfaces?
> 
> I'm particularly interested in mt9t112 sensor.
> 
> Has this been done before with other driver?

You can try looking at this thread: 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/16311 
and remembering our discussions at the mini-summit;) You can also look at 
Hans' report of summit's results. A few people know, what has to be done, 
but noone has done it yet... The world is still looking for a hero to do 
the job:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
