Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55065 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755711Ab2EENPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 09:15:49 -0400
Message-ID: <4FA52803.3040206@iki.fi>
Date: Sat, 05 May 2012 16:15:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: linux-media@vger.kernel.org, t.stanislaws@samsung.com
Subject: Re: [RFC] V4L: Rename V4L2_SEL_TGT_*_ACTIVE to V4L2_SEL_TGT_*_ACTUAL
References: <1336221247-6543-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1336221247-6543-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> After introduction of the selection API on subdevs we have following sets
> of selection targets:
>
>      /dev/v4l-subdev?               |   /dev/video?
> -------------------------------------------------------------------------
> V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL    | V4L2_SEL_TGT_CROP_ACTIVE
> V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS    | V4L2_SEL_TGT_CROP_BOUNDS
>                                     | V4L2_SEL_TGT_CROP_DEFAULT
>                                     | V4L2_SEL_TGT_CROP_PADDED
> V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL | V4L2_SEL_TGT_COMPOSE_ACTIVE
> V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS | V4L2_SEL_TGT_COMPOSE_BOUNDS
>                                     | V4L2_SEL_TGT_COMPOSE_DEFAULT
>                                     | V4L2_SEL_TGT_COMPOSE_PADDED
>
> Although not exactly the same, the meaning of V4L2_SEL_TGT_*_ACTIVE
> and V4L2_SUBDEV_SEL_TGT_*_ACTUAL selection targets is logically the
> same. Different names add to confusion where both APIs are used in
> a single driver or an application.
> Then, rename the V4l2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
> V4l2_SEL_TGT_[CROP/COMPOSE]_ACTUAL to avoid the API inconsistencies.
> The selections API is experimental, so no any compatibility layer
> is added. The ABI remains unchanged.

I'm definitely for keeping the two sets of target as uniform as possible.

I have one question, though: how about dropping the ACTIVE / ACTUAL 
altogether? Then we'd have V4L2_SUBDEV_SEL_TGT_CROP and 
V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS etc. I feel that the ACTIVE or ACTUAL 
doesn't really say anything there, and don't think it's an issue that a 
target name is a part of another one.

What's your opinion?

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
