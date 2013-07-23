Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57395 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757667Ab3GWRSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 13:18:09 -0400
Date: Tue, 23 Jul 2013 20:17:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [BRAINSTORM] Controls, matrices and properties
Message-ID: <20130723171733.GA12281@valkosipuli.retiisi.org.uk>
References: <201307081306.56324.hverkuil@xs4all.nl>
 <51DDD26D.4060304@iki.fi>
 <1462134.bc1z0qkCPU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462134.bc1z0qkCPU@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jul 18, 2013 at 03:07:26AM +0200, Laurent Pinchart wrote:
...
> > An unrelated thing, which is out of scope for now, but something to think
> > about: when passing around large amounts of (configuration) data the number
> > of times the data is copied really counts. Especially on embedded systems.
> > 
> > Memory mapping helps avoiding problems --- what would happen is that the
> > driver would access memory mapped to the device directly and the driver
> > would then get the address to pass to the device as the configuration. Like
> > video buffers, but for control, not data.
> 
> Would you map that memory to userspace as well ?

Yes --- that's the very intent. This way all unnecessary memory copies in
the kernel can be avoided. Say, if you're providing (and copying) the device
a new LSC table of 128 kiB for every frame while recording video, it will
show up in the energy consumption of the system.

It does let the user space to do wrong things, too. But the same is equally
true for video buffers as well.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
