Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:59886 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933296AbdKOTb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 14:31:29 -0500
Subject: Re: camss: camera controls missing on vfe interfaces
From: Daniel Mack <daniel@zonque.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
Message-ID: <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
Date: Wed, 15 Nov 2017 20:31:27 +0100
MIME-Version: 1.0
In-Reply-To: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Todor et all,

Any hint on how to tackle this?

I can contribute patches, but I'd like to understand what the idea is.


Thanks,
Daniel


On Thursday, October 26, 2017 06:11 PM, Daniel Mack wrote:
> Hi Todor,
> 
> When using the camss driver trough one of its /dev/videoX device nodes,
> applications are currently unable to see the video controls the camera
> sensor exposes.
> 
> Same goes for other ioctls such as VIDIOC_ENUM_FMT, so the only valid
> resolution setting for applications to use is the one that was
> previously set through the media controller layer. Applications usually
> query the available formats and then pick one using the standard V4L2
> APIs, and many can't easily be forced to use a specific one.
> 
> If I'm getting this right, could you explain what's the rationale here?
> Is that simply a missing feature or was that approach chosen on purpose?
> 
> 
> Thanks,
> Daniel
> 
