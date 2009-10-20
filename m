Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1261 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZJTWPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 18:15:36 -0400
Message-ID: <dddd6ede1d034513603028f90a8c0395.squirrel@webmail.xs4all.nl>
In-Reply-To: <20091020011210.623421213@ideasonboard.com>
References: <20091020011210.623421213@ideasonboard.com>
Date: Wed, 21 Oct 2009 00:15:37 +0200
Subject: Re: [RFC/PATCH 00/14] Media controller update based on Hans'
 v4l-dvb-mc tree
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> Hi everybody,
>
> here's a set of patches to clean up and extend Hans' initial media
> controller
> implementation.
>
> Patches prefixed by v4l deal with the v4l core code and update existing
> drivers when required by an API change. The core now offers two functions
> to
> deal with entities and links:
>
> - v4l2_entity_init() will initialize an entity. For subdevices the
> v4l2_subdev_init() performs part of the entity initialization as well,
> which
> leads me to believe that the API is currently ill-defined.
>
> - v4l2_entity_connect() creates a link between two entities. All possible
> links should be created using that function before the subdevice is
> registered.
>
> As I don't own any ivtv hardware the media controller code was difficult
> to
> test so I've implemented media controller support in the UVC driver for
> testing purpose. The code can be found in patches prefixed by uvc.
>
> This is mostly playground code. There are known and unknown bugs
> (especially
> in the ivtv driver as I haven't been able to test that code;
> v4l2_entity_connect is definitely called with bad parameters in there) as
> well
> as design issues. There's a lot of code missing. I'm mostly interested in
> getting feedback on the changes, especially the new v4l2_entity_pad and
> v4l2_entity_link objects. Feel free to comment on the public userspace API
> too, I realized after changing it to mimic the new kernel API that the way
> the previous API exposed "local" and "remote" pads instead of pads and
> links
> is probably more space efficient.
>
> I'll keep playing with the code and I'll start porting the OMAP3 camera
> driver
> to the in-progress media controller API. I'll discover problems (and
> hopefully solutions) along the way so another round of patches can be
> expected
> later, maybe in a week. Of course I'll appreciate comments before that, as
> the earlier I get feedback the easier it will be to incorporate it in the
> code. No pressure though, I know that a few developers have left for the
> kernel summit in Japan.

While I haven't been able to do an in-depth review it is clear to me that
the switch to 'pads' is definitely the right direction. That leads to much
cleaner code.

With regards to the code kernel API to set up all these relationships: I
expect we'll end up with a few generic core functions that do all the hard
work, and a bunch of static inline convenience functions on top of that.
That tends to work quite well.

One tip: it might be useful to have a tree ready with just a single driver
that is converted to use mc, links and pads (e.g. uvc). That makes it easy
to experiment with different data structures and APIs. It's much harder to
do this if you have a lot of dependencies on your code.

Keep up the good work! I'm so pleased to see so much activity from so many
people after the v4l-dvb mini-summit!

Regards,

        Hans

