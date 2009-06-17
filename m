Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751934AbZFQNF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:05:28 -0400
Date: Wed, 17 Jun 2009 15:05:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: soc-camera: status, roadmap
In-Reply-To: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
Message-ID: <Pine.LNX.4.64.0906171458380.4218@axis700.grange>
References: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Guennadi Liakhovetski wrote:

> 2. The above means, I'll have to maintain and update my patches for a 
> whole 2.6.31 development cycle. In this time I'll try to update and upload 
> them as a quilt patch series and announce it on the list a couple of 
> times.

As promised, I just uploaded my current tree snapshot at 
http://download.open-technology.de/soc-camera/20090617/
This is nothing remarkable, just my current patch-stack for those working 
with the soc-camera framework. It is still based on a linux-next snapshot 
of 07.05.2009 "history" branch. The exact commit on which the stack is 
based is, as usual, in 0000-base. This is still based off 2.6.30-rc4, and 
I expect to upgrade next time after 2.6.31-rc1.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
