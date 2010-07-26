Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47358 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0GZJIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 05:08:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 02/10] media: Media device
Date: Mon, 26 Jul 2010 11:08:52 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-3-git-send-email-laurent.pinchart@ideasonboard.com> <201007241402.50974.hverkuil@xs4all.nl>
In-Reply-To: <201007241402.50974.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261108.52766.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 24 July 2010 14:02:50 Hans Verkuil wrote:
> On Wednesday 21 July 2010 16:35:27 Laurent Pinchart wrote:
> > The media_device structure abstracts functions common to all kind of
> > media devices (v4l2, dvb, alsa, ...). It manages media entities and
> > offers a userspace API to discover and configure the media device
> > internal topology.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  Documentation/media-framework.txt |   68
> >  ++++++++++++++++++++++++++++++++ drivers/media/Makefile            |   
> >  2 +-
> >  drivers/media/media-device.c      |   77
> >  +++++++++++++++++++++++++++++++++++++ include/media/media-device.h     
> >  |   53 +++++++++++++++++++++++++ 4 files changed, 199 insertions(+), 1
> >  deletions(-)
> >  create mode 100644 Documentation/media-framework.txt
> >  create mode 100644 drivers/media/media-device.c
> >  create mode 100644 include/media/media-device.h
> 
> <snip>
> 
> As discussed on IRC: I would merge media-device and media-devnode. I see no
> benefit in separating them at this time.

I'm not too sure about it. I still think the separation gives us cleaner, 
easier to understand code. My opinion on it isn't that strong, so I could be 
convinced to merge the two, but Sakari seemed to think they shouldn't be 
merged last time I talked to him about it. I'll let him answer.

-- 
Regards,

Laurent Pinchart
