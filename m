Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53390 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0GZQTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:19:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 01/10] media: Media device node support
Date: Mon, 26 Jul 2010 18:19:47 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007241359.11584.hverkuil@xs4all.nl> <201007261107.16043.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007261107.16043.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261819.49506.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 26 July 2010 11:07:14 Laurent Pinchart wrote:
> Hi Hans,
> On Saturday 24 July 2010 13:59:11 Hans Verkuil wrote:
> > On Wednesday 21 July 2010 16:35:26 Laurent Pinchart wrote:
> > > The media_devnode structure provides support for registering and
> > > unregistering character devices using a dynamic major number. Reference
> > > counting is handled internally, making device drivers easier to write
> > > without having to solve the open/disconnect race condition issue over
> > > and over again.
> > > 
> > > The code is based on video/v4l2-dev.c.

[snip]

> > > +	mdev->dev.class = &media_class;
> > > +	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
> > > +	mdev->dev.release = media_devnode_release;
> > > +	if (mdev->parent)
> > > +		mdev->dev.parent = mdev->parent;
> > > +	dev_set_name(&mdev->dev, "media%d", mdev->minor);
> > 
> > Wouldn't mediactlX be a better name? Just plain 'media' is awfully
> > general.
> 
> Good question.

Oops, I forgot to elaborate on that :-)

Plain "media" is indeed very generic. "mediactl" would be more specific, but 
I've never really liked the term "media controller". If you look at the media 
framework documentation, there's no reference to "controller" :-) I think it's 
"just" a media device.

-- 
Regards,

Laurent Pinchart
