Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:33620 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbeLCWQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 17:16:35 -0500
Date: Tue, 4 Dec 2018 00:16:29 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 00/30] v4l: add support for multiplexed streams
Message-ID: <20181203221628.rzb7sz5purso4uak@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Nov 02, 2018 at 12:31:14AM +0100, Niklas Söderlund wrote:
> Hi all,
> 
> This series adds support for multiplexed streams within a media device
> link. The use-case addressed in this series covers CSI-2 Virtual
> Channels on the Renesas R-Car Gen3 platforms. The v4l2 changes have been
> a joint effort between Sakari and Laurent and floating around for some
> time [1].
> 
> I have added driver support for the devices used on the Renesas Gen3
> platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
> changes I can control which of the analog inputs of the ADV7482 the
> video source is captured from and on which CSI-2 virtual channel the
> video is transmitted on to the R-Car CSI-2 receiver.
> 
> The series adds two new subdev IOCTLs [GS]_ROUTING which allows
> user-space to get and set routes inside a subdevice. I have added RFC
> support for these to v4l-utils [2] which can be used to test this
> series, example:
> 
>     Check the internal routing of the adv748x csi-2 transmitter:
>     v4l2-ctl -d /dev/v4l-subdev24 --get-routing
>     0/0 -> 1/0 [ENABLED]
>     0/0 -> 1/1 []
>     0/0 -> 1/2 []
>     0/0 -> 1/3 []
> 
> 
>     Select that video should be outputed on VC 2 and check the result:
>     $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'
> 
>     $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
>     0/0 -> 1/0 []
>     0/0 -> 1/1 []
>     0/0 -> 1/2 [ENABLED]
>     0/0 -> 1/3 []
> 
> This series is tested on R-Car M3-N and for your testing needs this
> series is available at
> 
>     git://git.ragnatech.se/linux v4l2/mux
> 
> * Changes since v1
> - Rebased on latest media-tree.
> - Incorporated changes to patch 'v4l: subdev: compat: Implement handling 
>   for VIDIOC_SUBDEV_[GS]_ROUTING' by Sakari.
> - Added review tags.

I was looking at the patches and they seem very nice to me. It's not that
I've written most of them, but I still. X-)

I noticed that the new [GS]_ROUTING interface has no documentation
currently. Could you write it?

Also what I'd like to see is the media graph of a device that is driven by
these drivers. That'd help to better understand the use case also for those
who haven't worked with the patches.

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
