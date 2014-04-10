Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44256 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753800AbaDJWad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:30:33 -0400
Message-ID: <53471B87.20000@iki.fi>
Date: Fri, 11 Apr 2014 01:30:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 5/9] Allow passing file descriptors to yavta
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <349099482.s11F5mBja6@avalon> <5346E797.5070503@iki.fi> <2768738.vMSoLa2vmM@avalon>
In-Reply-To: <2768738.vMSoLa2vmM@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Just thinking out loud, we need to
>
> - initialize the device structure,
> - open the device or use an externally provided fd,
> - optionally query the device capabilities,
> - optionally override the queue type.
>
> Initializing the device structure must be performed unconditionally, I would
> create a video_init() function for that.

This is now performed in the beginning of main(). video_open() no longer 
initialises anything.

> Opening the device or using an externally provided fd are exclusive
> operations, I would create two functions (that wouldn't do much).

Currently this is a few lines in main().

> Querying the device capabilities is also optional, I would create one function
> for that.

Patch 4/9.

> Finally, overriding the queue type is of course optional and should be
> implemented in its own function. We should probably return an error if the
> user tries to set a queue type not reported by QUERYCAP (assuming QUERYCAP has
> been called).

The same check already done in the driver, and an error is returned if 
it's wrong. I'm leaning towards thinking this isn't necessary in yavta.

> Ideally I'd also like to make the --no-query argument non-mandatory when
> operating on subdev nodes. It has been introduced because QUERYCAP isn't
> supported by subdev nodes, and it would be nice if we could detect somehow
> that the device node corresponds to a subdev and automatically skip QUERYCAP
> in that case.

It's already non-mandatory. We don't try to rocognise sub-device nodes, 
but failing querycap is a non-error already without this patchset.

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
