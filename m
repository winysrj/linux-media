Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56818 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753405AbZCES4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 13:56:25 -0500
Date: Thu, 5 Mar 2009 19:56:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <20090304141715.0a1af14d@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Mar 2009, Mauro Carvalho Chehab wrote:

> Beside the fact that we don't need to strip support for legacy kernels, the
> advantage of using this method is that we can evolute to a new development
> model. As several developers already required, we should really use the
> standard -git tree as everybody's else. This will simplify a lot the way we
> work, and give us more agility to send patches upstream.
> 
> With this backport script, plus the current v4l-dvb building systems, and after
> having all backport rules properly mapped, we can generate a "test tree"
> based on -git drivers/media, for the users to test the drivers against their
> kernels, and still use a clean tree for development.

Sorry, switching to git is great, but just to make sure I understood you 
right: by "-git drivers/media" you don't mean it is going to be a git tree 
of only drivers/media, but it is going to be a normal complete Linux 
kernel tree, right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
