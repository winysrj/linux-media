Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:56057 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdEBUX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 16:23:59 -0400
Subject: Re: [PATCH] v4l2-async: add v4l2_async_match()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>, hverkuil@xs4all.nl
References: <20170502165413.7559-1-niklas.soderlund+renesas@ragnatech.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <e5639542-9eff-e6a0-5dbc-8ee439b64d5c@linux.intel.com>
Date: Tue, 2 May 2017 23:23:47 +0300
MIME-Version: 1.0
In-Reply-To: <20170502165413.7559-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Niklas Söderlund wrote:
> For drivers registering notifiers with more then one subdevices it's
> difficult to know exactly which one is being bound in each call to the
> notifiers bound callback. Comparing OF nodes became harder after the
> introduction of fwnode where the two following comparisons are not equal
> but where so previous to fwnode.
>
> asd.match.fwnode.fwnode == of_fwnode_handle(subdev->dev->of_node)
>
> asd.match.fwnode.fwnode == of_fwnode_handle(subdev->of_node)
>
> It's also not ideal to directly access the asd.match union without first
> checking the match_type. So to make it easier for drivers to perform
> this type of matching export the v4l2 async match helpers with a new
> symbol v4l2_async_match(). This wold replace the comparisons above with:
>
> v4l2_async_match(subdev, &asd)

Where do you need such a thing, i.e. what do you want to do? Do you have 
an example of where this is helpful?

The async framework has been designed to make it easy to store driver 
specific information to an async sub-device but I'm not sure if all 
drivers do this. Some do at least.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
