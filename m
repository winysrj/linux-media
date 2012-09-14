Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43253 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752713Ab2INUXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 16:23:39 -0400
Message-ID: <5053929D.4050902@iki.fi>
Date: Fri, 14 Sep 2012 23:25:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <573d42b4b775afd8beeadc7a903cc2190a6f430a.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <573d42b4b775afd8beeadc7a903cc2190a6f430a.1347619766.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

Hans Verkuil wrote:
...
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -290,6 +290,7 @@ struct v4l2_capability {
>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
>
> +#define V4L2_CAP_MONOTONIC_TS           0x40000000  /* uses monotonic timestamps */
>   #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */

I have to say I'm still not a big fan of this new capability flag.

I had a quick discussion with Laurent, and what he suggested was to use 
the kernel version to figure out the type of the timestamp. The drivers 
that use the monotonic time right now wouldn't be affected by the new 
flag on older kernels. If we've decided we're going to switch to 
monotonic time anyway, why not just change all the drivers now and 
forget the capability flag.

Instead of a capability flag, the applications would know the type of 
the timestamp based on the kernel version. In the end we wouldn't be 
left with a useless flag that every single driver would have to set.

It's true that there are some 70 such drivers that need to be converted 
but it's still a trivial, mechanical task. It would be even easier to 
implement a helper function called e.g. v4l2_buffer_timestamp() so that 
every user wouldn't have to convert timespec to timeval.

As a result we'd also have a very short transition period to the 
timestamps we prefer.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
