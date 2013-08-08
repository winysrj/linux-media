Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab3HHQWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 12:22:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] mt9v032: Use the common clock framework
Date: Thu, 08 Aug 2013 18:23:52 +0200
Message-ID: <2829265.mTVFKFEsCP@avalon>
In-Reply-To: <520261B6.1080407@samsung.com>
References: <1373021725-14006-1-git-send-email-laurent.pinchart@ideasonboard.com> <1684528.NgmHp9Ak4m@avalon> <520261B6.1080407@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 07 August 2013 17:03:18 Sylwester Nawrocki wrote:
> On 07/26/2013 05:55 PM, Laurent Pinchart wrote:
> > On Friday 26 July 2013 15:36:22 Sylwester Nawrocki wrote:
> >> On 07/26/2013 03:15 PM, Laurent Pinchart wrote:
> >>> On Friday 26 July 2013 15:11:08 Sylwester Nawrocki wrote:
> >>>> On 07/05/2013 12:55 PM, Laurent Pinchart wrote:
> >>>>> Configure the device external clock using the common clock framework
> >>>>> instead of a board code callback function.
> >>>>> 
> >>>>> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> >>>>> ---
> >>>>>    drivers/media/i2c/mt9v032.c | 16 ++++++++++------
> >>>>>    include/media/mt9v032.h     |  4 ----
> >>>>>    2 files changed, 10 insertions(+), 10 deletions(-)

[snip]

> >> Do you rely on the fact that __clk_get()/__clk_put() doesn't get
> >> reference on the clock supplier module (to avoid locking modules in
> >> memory) ? I was planning on adding module_get()/module_put() inside
> >> __clk_get()/__clk_out() for the common clock API implementation.
> > 
> > I'm currently relying on that, but I'm aware it's not a good idea. We need
> > to find a solution to fix the problem in the context of the v4l2-async
> > framework.
>
> There are few possible options I can see could be a resolution for that:
> 
> 1. making the common clock API not getting reference on the clock supplier
>    module; then dynamic clock deregistration needs to be handled, which has
>    its own share of problems;
> 
> 2. using sysfs unbind attribute of the subdev and/or the host drivers to
>    release the circular references or create some additional sysfs entry
>    for this - however requiring additional actions from user space to do
>    something that worked before without them can be simply considered as
>    an regression;

Well, we've never had working DT support for those systems, so that's hardly a 
regression :-)

> 3. not keeping reference to a clock all times only when it is actively
>    used, e.g. in subdev's s_power handler; this is in practice what
>    v4l2-clk does, just would be coded using standard clk API calls;
> 
> Any of these options isn't ideal but 3) seems to me most reasonable of them.

For now it might be, but I'm not sure whether it would scale. We will likely 
have similar issues with other kind of resources in the future. I would be 
enclined to investigate the second option.

> I thought it would be better than using the v4l2-clk API, which is supposed
> to be a temporary measure only, for platforms that already have the common
> clock API support.
> 
> I was wondering whether you don't need to also set the clock's frequency in
> this patch. I guess the sensor driver should at least call clk_get_rate() to
> see if current frequency is suitable for the device ?

Yes indeed. I'm not sure how I've missed that. I'll fix it.

-- 
Regards,

Laurent Pinchart

