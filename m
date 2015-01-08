Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43122 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbAHDPi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jan 2015 22:15:38 -0500
Date: Thu, 8 Jan 2015 01:15:27 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 03/20] cx231xx: add media controller support
Message-ID: <20150108011527.7fe81beb@concha.lan>
In-Reply-To: <CAKocOOO7CFkEYKJs3YpyX7gvWv8NMLhwdzF1tv-P+-rc8jxrFA@mail.gmail.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
	<fa927b6207391e52a106c170939968b3a0a885ab.1420578087.git.mchehab@osg.samsung.com>
	<CAKocOOO7CFkEYKJs3YpyX7gvWv8NMLhwdzF1tv-P+-rc8jxrFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Em Wed, 7 Jan 2015 18:44:26 -0700
Shuah Khan <shuahkhan@gmail.com> escreveu:

> > +
> >         /* Create v4l2 device */
> > +       dev->v4l2_dev.mdev = dev->media_dev;
> 
> When media_device_register(mdev) fails in cx231xx_media_device_register(),
> media_dev is null? The above will simply assign null to dev->v4l2_dev.mdev
> Is that correct?

Yes, this is intentional. If the media controls fail to register, everything 
will keep working, except for the media controller itself. That sounds better,
IMHO, than to have a complete failure.

Cheers,
Mauro
