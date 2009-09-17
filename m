Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4151 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZIQGgW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 02:36:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: RFCv2: Media controller proposal
Date: Thu, 17 Sep 2009 08:35:57 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909162334.08807.hverkuil@xs4all.nl> <1253139323.3158.28.camel@palomino.walls.org>
In-Reply-To: <1253139323.3158.28.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909170835.57106.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 September 2009 00:15:23 Andy Walls wrote:
> On Wed, 2009-09-16 at 23:34 +0200, Hans Verkuil wrote:
> > On Wednesday 16 September 2009 22:50:43 Mauro Carvalho Chehab wrote:
> > > Em Wed, 16 Sep 2009 21:21:16 +0200
> 
> > C) in all other cases you only get it if a kernel config option is on. And since
> > any advanced controls are still exposed in sysfs you can still change those even
> > if the config option was off.
> 
> That is a user interface and support annoyance.  Either decide to have a
> node for a subdevice or don't.  If a distribution wants to supress them,
> udev rules could suffice - right?  Changing udev rules is
> (theoretically) easier than rebuilding the kernel for most end users.

Good point.

	Hans

> 
> Regards,
> Andy
> 
> 
> > What do you think about that? I would certainly like to hear what people think
> > about this.
> > 
> > Regards,
> > 
> > 	Hans
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
