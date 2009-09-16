Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44362 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZIPWNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 18:13:11 -0400
Subject: Re: RFCv2: Media controller proposal
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <200909162334.08807.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <200909162121.16606.hverkuil@xs4all.nl>
	 <20090916175043.0d462a18@pedra.chehab.org>
	 <200909162334.08807.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 18:15:23 -0400
Message-Id: <1253139323.3158.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-09-16 at 23:34 +0200, Hans Verkuil wrote:
> On Wednesday 16 September 2009 22:50:43 Mauro Carvalho Chehab wrote:
> > Em Wed, 16 Sep 2009 21:21:16 +0200

> C) in all other cases you only get it if a kernel config option is on. And since
> any advanced controls are still exposed in sysfs you can still change those even
> if the config option was off.

That is a user interface and support annoyance.  Either decide to have a
node for a subdevice or don't.  If a distribution wants to supress them,
udev rules could suffice - right?  Changing udev rules is
(theoretically) easier than rebuilding the kernel for most end users.

Regards,
Andy


> What do you think about that? I would certainly like to hear what people think
> about this.
> 
> Regards,
> 
> 	Hans


