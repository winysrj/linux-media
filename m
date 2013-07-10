Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43909 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJX2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 19:28:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
Date: Thu, 11 Jul 2013 01:28:47 +0200
Message-ID: <1480951.mKR9bzbARV@avalon>
In-Reply-To: <51DDDDF7.1010005@iki.fi>
References: <201306241054.11604.hverkuil@xs4all.nl> <51D88318.70904@gmail.com> <51DDDDF7.1010005@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 11 July 2013 01:19:35 Sakari Ailus wrote:
> Hi Sylwester and Laurent,
> 
> Sylwester Nawrocki wrote:
> > Hi Laurent,
> 
> ...
> 
> >> We need an ioctl to report additional information about media entities
> >> (it's been on my to-do list for wayyyyyyyyy too long). It could be used
> >> to report bus information as well.
> > 
> > Yes, that sounds much more interesting than using just subdev name to
> > sqeeze all the information in. Why we don't have such an ioctl yet anyway
> > ? Were there some arguments against it, or its been just a low priority
> > issue ?
> 
> I think it's just been left unaddressed until now since there have been
> even more important things to work on. :-) I'm all for that, btw.;
> associating bus information to the media device instead of entities was
> always a little odd (feel free to blame me, too...).
> 
> Perhaps we could steal some bytes from the union in struct
> media_entity_desc? :-)

I've thought about that as well, but we will eventually need to pass more 
entity information to userspace, so a new ioctl would in my opinion be better, 
given the potentially large size of the bus information string.

-- 
Regards,

Laurent Pinchart

