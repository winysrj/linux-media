Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46278 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaDJWRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:17:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 5/9] Allow passing file descriptors to yavta
Date: Fri, 11 Apr 2014 00:17:38 +0200
Message-ID: <2768738.vMSoLa2vmM@avalon>
In-Reply-To: <5346E797.5070503@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <349099482.s11F5mBja6@avalon> <5346E797.5070503@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 10 April 2014 21:48:55 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the comments.
> 
> Laurent Pinchart wrote:
> ...
> 
> >> @@ -196,6 +192,16 @@ static int video_open(struct device *dev, const char
> >> *devname, int no_query)
> >> 
> >>   	printf("Device %s opened.\n", devname);
> >> 
> >> +	dev->opened = 1;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int video_querycap(struct device *dev, int no_query) {
> >> +	struct v4l2_capability cap;
> >> +	unsigned int capabilities;
> >> +	int ret;
> >> +
> > 
> > video_querycap ends up setting the dev->type field, which isn't really the
> > job of a query function. Would there be a clean way to pass the fd to the
> > video_open() function instead ? Maybe video_open() could be split and/or
> > renamed to video_init() ?
> 
> Agreed. I'll separate queue type selection from querycap. As the
> querycap needs to be done after opening the device, I'll put it into
> another function. I'm ok with video_init(), but what would you think
> about e.g. video_set_queue_type() as the function does nothing else.

Just thinking out loud, we need to

- initialize the device structure,
- open the device or use an externally provided fd,
- optionally query the device capabilities,
- optionally override the queue type.

Initializing the device structure must be performed unconditionally, I would 
create a video_init() function for that.

Opening the device or using an externally provided fd are exclusive 
operations, I would create two functions (that wouldn't do much).

Querying the device capabilities is also optional, I would create one function 
for that.

Finally, overriding the queue type is of course optional and should be 
implemented in its own function. We should probably return an error if the 
user tries to set a queue type not reported by QUERYCAP (assuming QUERYCAP has 
been called).

Ideally I'd also like to make the --no-query argument non-mandatory when 
operating on subdev nodes. It has been introduced because QUERYCAP isn't 
supported by subdev nodes, and it would be nice if we could detect somehow 
that the device node corresponds to a subdev and automatically skip QUERYCAP 
in that case.

-- 
Regards,

Laurent Pinchart

