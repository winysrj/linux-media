Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:32782 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933110AbcJLN0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 09:26:51 -0400
Received: by mail-vk0-f67.google.com with SMTP id 83so1091578vkd.0
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2016 06:26:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161007215216.GB9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de> <20161007160107.5074-3-p.zabel@pengutronix.de>
 <20161007215216.GB9460@valkosipuli.retiisi.org.uk>
From: Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 12 Oct 2016 15:26:48 +0200
Message-ID: <CA+gwMcft-E2n-hMre70Uj3u=PFPYpCbOYo9uOaCayve1ec1m-A@mail.gmail.com>
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add further
 subdevices to the notifier waiting list
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 7, 2016 at 11:52 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Philipp,
>
> On Fri, Oct 07, 2016 at 06:00:47PM +0200, Philipp Zabel wrote:
>> Currently the v4l2_async_notifier needs to be given a list of matches
>> for all expected subdevices on creation. When chaining subdevices that
>> are asynchronously probed via device tree, the bridge device that sets
>> up the notifier does not know the complete list of subdevices, as it
>> can only parse its own device tree node to obtain information about
>> the nearest neighbor subdevices.
>> To support indirectly connected subdevices, we need to support amending
>> the existing notifier waiting list with newly found neighbor subdevices
>> with each registered subdevice.
>
> Could you elaborate a little what's the exact use case for this? What kind
> of a device?

On i.MX6 there's a

DW MIPI CSI2 host -> Mux -> IPU/CSI

path and all three are asynchronous subdevices in my patchset and only
the last one is directly known to the media device from the device
tree, since each driver should only parse its own device tree node an
can not follow the of_graph over multiple steps.
Another use case I have seen in the wild are external GPIO controlled
multiplexers or LVDS serializer/deserializer pairs between a parallel
camera and parallel capture interface. In each case the bridge node
can only determine its closest neighbor from the device tree (the mux,
the LVDS deserializer) but does not know about the indirectly
connected device nodes further upstream.

regards
Philipp
