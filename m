Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35727 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdEBWIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 18:08:15 -0400
Received: by mail-wm0-f50.google.com with SMTP id w64so127762289wma.0
        for <linux-media@vger.kernel.org>; Tue, 02 May 2017 15:08:14 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 3 May 2017 00:08:12 +0200
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>, hverkuil@xs4all.nl
Subject: Re: [PATCH] v4l2-async: add v4l2_async_match()
Message-ID: <20170502220812.GO1532@bigcity.dyn.berto.se>
References: <20170502165413.7559-1-niklas.soderlund+renesas@ragnatech.se>
 <e5639542-9eff-e6a0-5dbc-8ee439b64d5c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5639542-9eff-e6a0-5dbc-8ee439b64d5c@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Thanks for your feedback.

On 2017-05-02 23:23:47 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> Niklas Söderlund wrote:
> > For drivers registering notifiers with more then one subdevices it's
> > difficult to know exactly which one is being bound in each call to the
> > notifiers bound callback. Comparing OF nodes became harder after the
> > introduction of fwnode where the two following comparisons are not equal
> > but where so previous to fwnode.
> > 
> > asd.match.fwnode.fwnode == of_fwnode_handle(subdev->dev->of_node)
> > 
> > asd.match.fwnode.fwnode == of_fwnode_handle(subdev->of_node)
> > 
> > It's also not ideal to directly access the asd.match union without first
> > checking the match_type. So to make it easier for drivers to perform
> > this type of matching export the v4l2 async match helpers with a new
> > symbol v4l2_async_match(). This wold replace the comparisons above with:
> > 
> > v4l2_async_match(subdev, &asd)
> 
> Where do you need such a thing, i.e. what do you want to do? Do you have an
> example of where this is helpful?
> 
> The async framework has been designed to make it easy to store driver
> specific information to an async sub-device but I'm not sure if all drivers
> do this. Some do at least.

You are correct, there is no need for this patch. Please disregard it, 
and sorry for the noise.

Laurent also pointed this out to me and asked why I did not use the 
v4l2_async_subdev pointer provided to the notifier bound callback 
instead of the subdev->of_node to match. I now feel rather silly.. But 
with that modification my issue is solved without any v4l2 modifications 
and the code is more clear so I'm also happy.

> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com

-- 
Regards,
Niklas Söderlund
