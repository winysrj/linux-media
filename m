Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35086 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751891Ab2HYI4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 04:56:00 -0400
Date: Sat, 25 Aug 2012 11:55:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC API] Renumber subdev ioctls
Message-ID: <20120825085555.GN721@valkosipuli.retiisi.org.uk>
References: <201208201030.30590.hverkuil@xs4all.nl>
 <201208210839.53924.hverkuil@xs4all.nl>
 <20120821104415.GF721@valkosipuli.retiisi.org.uk>
 <201208221052.02338.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208221052.02338.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Aug 22, 2012 at 10:52:02AM +0200, Hans Verkuil wrote:
> On Tue August 21 2012 12:44:15 Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Tue, Aug 21, 2012 at 08:39:53AM +0200, Hans Verkuil wrote:
...
> > > Currently I've chosen ioctl numbers that are not used by V4L2 (there are a
> > > number of 'holes' in the ioctl list).
> > > 
> > > If people think it is not worth the effort, then so be it. But if we do want
> > > to do this, then we can't wait any longer.
> > 
> > One option would be to start using a new type for the new IOCTLs but leave
> > the existing ones as they are. The end result would be less elegant since
> > the subdev IOCTLs would use two different types but OTOH the V4L2 IOCTLs are
> > being used on subdevs as-is, too. This would at least prevent future clashes
> > in IOCTL codes between V4L2 and subdev interfaces.
> 
> I don't really like that idea.
> 
> I thought that Laurent's proposal of creating SUBDEV aliases of reused V4L2
> ioctls had merit. That way v4l2-subdev.h would give a nice overview of
> which V4L2 ioctls are supported by the subdev API. Currently no such overview
> exists to my knowledge.

We do --- it's the big switch in v4lw-ioctl.c. If that is to be improved
that should be done IMO to the official Linux media infrastructure API spec.

> With regards to adding pad fields to the existing control structs: that won't
> work with queryctrl: the reserved fields are output fields only, there is no
> requirement that apps have to zero them, so you can't use them to enumerate
> controls for a particular pad.
> 
> A new queryctrl ioctl would have to be created for that. So if we need this
> functionality, then I believe it is better to combine that with a new
> queryctrl ioctl.

Ack.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
