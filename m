Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43811 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbZJTIOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:37 -0400
Message-Id: <20091020011210.623421213@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:10 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl
Subject: [RFC/PATCH 00/14] Media controller update based on Hans' v4l-dvb-mc tree
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

here's a set of patches to clean up and extend Hans' initial media controller
implementation.

Patches prefixed by v4l deal with the v4l core code and update existing
drivers when required by an API change. The core now offers two functions to
deal with entities and links:

- v4l2_entity_init() will initialize an entity. For subdevices the
v4l2_subdev_init() performs part of the entity initialization as well, which
leads me to believe that the API is currently ill-defined.

- v4l2_entity_connect() creates a link between two entities. All possible
links should be created using that function before the subdevice is
registered.

As I don't own any ivtv hardware the media controller code was difficult to
test so I've implemented media controller support in the UVC driver for
testing purpose. The code can be found in patches prefixed by uvc.

This is mostly playground code. There are known and unknown bugs (especially
in the ivtv driver as I haven't been able to test that code;
v4l2_entity_connect is definitely called with bad parameters in there) as well
as design issues. There's a lot of code missing. I'm mostly interested in
getting feedback on the changes, especially the new v4l2_entity_pad and
v4l2_entity_link objects. Feel free to comment on the public userspace API
too, I realized after changing it to mimic the new kernel API that the way
the previous API exposed "local" and "remote" pads instead of pads and links
is probably more space efficient.

I'll keep playing with the code and I'll start porting the OMAP3 camera driver
to the in-progress media controller API. I'll discover problems (and
hopefully solutions) along the way so another round of patches can be expected
later, maybe in a week. Of course I'll appreciate comments before that, as
the earlier I get feedback the easier it will be to incorporate it in the
code. No pressure though, I know that a few developers have left for the
kernel summit in Japan.

--
Regards,

Laurent Pinchart

