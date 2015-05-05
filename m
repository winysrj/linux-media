Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41382 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbbEEUWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 16:22:42 -0400
Date: Tue, 5 May 2015 17:22:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Time for a v4l-utils 1.8.0 release
Message-ID: <20150505172235.4bef50eb@recife.lan>
In-Reply-To: <55491541.1040709@googlemail.com>
References: <55491541.1040709@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 05 May 2015 21:08:49 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> It's already more than half a year since the last v4l-utils release. Do
> you have any pending commits or objections? If no one vetos I'd like to
> release this weekend.

There is are a additions I'd like to add to v4l-utils: 

1) on DVB, ioctls may fail with -EAGAIN. Some parts of the libdvbv5 don't
handle it well. I made one quick hack for it, but didn't have time to
add a timeout to avoid an endless loop. The patch is simple. I just need
some time to do that;

2) The Media Controller control util (media-ctl) doesn't support DVB.

The patchset adding DVB support on media-ctl is ready, and I'm merging
right now, and matches what's there at Kernel version 4.1-rc1 and upper.

Yet, Laurent and Sakari want to do some changes at the Kernel API, before
setting it into a stone at Kernel v 4.1 release.

This has to happen on the next 4 weeks.

So, I suggest to postpone the release of 1.8.0 until the end of this month.

Regards,
Mauro
