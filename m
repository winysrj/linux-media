Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZIKUAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:07 -0400
Date: Fri, 11 Sep 2009 16:59:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911165937.776a638d@caramujo.chehab.org>
In-Reply-To: <200909112123.44778.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<19F8576C6E063C45BE387C64729E73940436BA524F@dbde02.ent.ti.com>
	<20090911155217.0e0f01bd@caramujo.chehab.org>
	<200909112123.44778.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2009 21:23:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > In the case of resizer, I don't see why this can't be implemented as an ioctl
> > over /dev/video device.
> 
> Well, no. Not in general. There are two problems. The first problem occurs if
> you have multiple instances of a resizer (OK, not likely, but you *can* have
> multiple video encoders or decoders or sensors). If all you have is the
> streaming device node, then you cannot select to which resizer (or video
> encoder) the ioctl should go. The media controller allows you to select the
> recipient of the ioctl explicitly. Thus providing the control that these
> applications need.

This case doesn't apply, since, if you have multiple encoders and/or decoders,
you'll also have multiple /dev/video instances. All you need is to call it at
the right device you need to control. Am I missing something here?

> The second problem is that this will pollute the 'namespace' of a v4l device
> node. Device drivers need to pass all those private ioctls to the right
> sub-device. But they shouldn't have to care about that. If someone wants to
> tweak the resizer (e.g. scaling coefficients), then pass it straight to the
> resizer component.

Sorry, I missed your point here



Cheers,
Mauro
