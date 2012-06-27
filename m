Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50010 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab2F0Kwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:52:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 19/34] v4l2-dev.c: add debug sysfs entry.
Date: Wed, 27 Jun 2012 12:52:34 +0200
Message-ID: <21286481.7Pjdm1koZj@avalon>
In-Reply-To: <201206271238.54332.hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <2029394.km7RaaeAMe@avalon> <201206271238.54332.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 27 June 2012 12:38:54 Hans Verkuil wrote:
> On Wed 27 June 2012 11:54:40 Laurent Pinchart wrote:
> > On Friday 22 June 2012 14:21:13 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Since this could theoretically change the debug value while in the
> > > middle of v4l2-ioctl.c, we make a copy of vfd->debug to ensure
> > > consistent debug behavior.
> > 
> > In my review of RFCv1, I wrote that this could introduce a race condition:
> > 
> > "You test the debug value several times in the __video_do_ioctl()
> > function. I haven't checked in details whether changing the value between
> > the two tests could for instance lead to a KERN_CONT print without a
> > previous non-KERN_CONT message. That won't crash the machine  but it
> > should still be avoided."
> > 
> > Have you verified whether that problem can occur ?
> 
> Yes, this problem can occur. Which is why I've changed the code accordingly.

I've missed that. My bad, sorry.

-- 
Regards,

Laurent Pinchart

