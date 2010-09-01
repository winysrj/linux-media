Return-path: <mchehab@localhost>
Received: from perceval.irobotique.be ([92.243.18.41]:39524 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0IANvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Sep 2010 09:51:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 02/11] media: Media device
Date: Wed, 1 Sep 2010 15:51:32 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-3-git-send-email-laurent.pinchart@ideasonboard.com> <201008281226.15619.hverkuil@xs4all.nl>
In-Reply-To: <201008281226.15619.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009011551.33190.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Hans,

On Saturday 28 August 2010 12:26:15 Hans Verkuil wrote:
> On Friday, August 20, 2010 17:29:04 Laurent Pinchart wrote:

[snip]

> > +struct media_device {
> > +	/* dev->driver_data points to this struct. */
> > +	struct device *dev;
> > +	struct media_devnode devnode;
> > +
> > +	u8 model[32];
> > +	u8 serial[32];
> > +	u8 bus_info[32];
> > +	u32 device_version;
> 
> I prefer hw_revision or possibly hw_device_revision. 'device' is too
> ambiguous. And 'revision' is more applicable to hardware than 'version'
> IMHO.

Agreed.

-- 
Regards,

Laurent Pinchart
