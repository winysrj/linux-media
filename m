Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43226 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbEFCHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 22:07:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Time for a v4l-utils 1.8.0 release
Date: Wed, 06 May 2015 05:07:19 +0300
Message-ID: <1597461.hFCejjGnu0@avalon>
In-Reply-To: <20150505172235.4bef50eb@recife.lan>
References: <55491541.1040709@googlemail.com> <20150505172235.4bef50eb@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 05 May 2015 17:22:35 Mauro Carvalho Chehab wrote:
> Em Tue, 05 May 2015 21:08:49 +0200 Gregor Jasny escreveu:
> > Hello,
> > 
> > It's already more than half a year since the last v4l-utils release. Do
> > you have any pending commits or objections? If no one vetos I'd like to
> > release this weekend.
> 
> There is are a additions I'd like to add to v4l-utils:
> 
> 1) on DVB, ioctls may fail with -EAGAIN. Some parts of the libdvbv5 don't
> handle it well. I made one quick hack for it, but didn't have time to
> add a timeout to avoid an endless loop. The patch is simple. I just need
> some time to do that;
> 
> 2) The Media Controller control util (media-ctl) doesn't support DVB.
> 
> The patchset adding DVB support on media-ctl is ready, and I'm merging
> right now, and matches what's there at Kernel version 4.1-rc1 and upper.
> 
> Yet, Laurent and Sakari want to do some changes at the Kernel API, before
> setting it into a stone at Kernel v 4.1 release.

I think Hans wants changes too.

> This has to happen on the next 4 weeks.

We'll try to, but depending on how review goes this might take more time.

In the meantime I suggest moving the media-ctl changes to a separate branch 
and go with the v1.8.0 release as planned.

> So, I suggest to postpone the release of 1.8.0 until the end of this month.

-- 
Regards,

Laurent Pinchart

