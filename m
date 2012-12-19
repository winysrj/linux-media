Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:32809 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2LSP0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 10:26:41 -0500
MIME-Version: 1.0
In-Reply-To: <87pq26ay2z.fsf@intel.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1608840.IleINgrx5J@avalon>
	<87pq28hb72.fsf@intel.com>
	<1671267.x0lxGrFjjV@avalon>
	<87pq26ay2z.fsf@intel.com>
Date: Wed, 19 Dec 2012 09:26:40 -0600
Message-ID: <CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rob Clark <rob.clark@linaro.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 19, 2012 at 8:57 AM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
>
> Hi Laurent -
>
> On Tue, 18 Dec 2012, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Jani,
>>
>> On Monday 17 December 2012 18:53:37 Jani Nikula wrote:
>>> I can see the need for a framework for DSI panels and such (in fact Tomi
>>> and I have talked about it like 2-3 years ago already!) but what is the
>>> story for HDMI and DP? In particular, what's the relationship between
>>> DRM and CDF here? Is there a world domination plan to switch the DRM
>>> drivers to use this framework too? ;) Do you have some rough plans how
>>> DRM and CDF should work together in general?
>>
>> There's always a world domination plan, isn't there ? :-)
>>
>> I certainly want CDF to be used by DRM (or more accurately KMS). That's what
>> the C stands for, common refers to sharing panel and other display entity
>> drivers between FBDEV, KMS and V4L2.
>>
>> I currently have no plan to expose CDF internals to userspace through the KMS
>> API. We might have to do so later if the hardware complexity grows in such a
>> way that finer control than what KMS provides needs to be exposed to
>> userspace, but I don't think we're there yet. The CDF API will thus only be
>> used internally in the kernel by display controller drivers. The KMS core
>> might get functions to handle common display entity operations, but the bulk
>> of the work will be in the display controller drivers to start with. We will
>> then see what can be abstracted in KMS helper functions.
>>
>> Regarding HDMI and DP, I imagine HDMI and DP drivers that would use the CDF
>> API. That's just a thought for now, I haven't tried to implement them, but it
>> would be nice to handle HDMI screens and DPI/DBI/DSI panels in a generic way.
>>
>> Do you have thoughts to share on this topic ?
>
> It just seems to me that, at least from a DRM/KMS perspective, adding
> another layer (=CDF) for HDMI or DP (or legacy outputs) would be
> overengineering it. They are pretty well standardized, and I don't see
> there would be a need to write multiple display drivers for them. Each
> display controller has one, and can easily handle any chip specific
> requirements right there. It's my gut feeling that an additional
> framework would just get in the way. Perhaps there could be more common
> HDMI/DP helper style code in DRM to reduce overlap across KMS drivers,
> but that's another thing.
>
> So is the HDMI/DP drivers using CDF a more interesting idea from a
> non-DRM perspective? Or, put another way, is it more of an alternative
> to using DRM? Please enlighten me if there's some real benefit here that
> I fail to see!

fwiw, I think there are at least a couple cases where multiple SoC's
have the same HDMI IP block.

And, there are also external HDMI encoders (for example connected over
i2c) that can also be shared between boards.  So I think there will be
a number of cases where CDF is appropriate for HDMI drivers.  Although
trying to keep this all independent of DRM (as opposed to just
something similar to what drivers/gpu/i2c is today) seems a bit
overkill for me.  Being able to use the helpers in drm and avoiding an
extra layer of translation seems like the better option to me.  So my
vote would be drivers/gpu/cdf.

BR,
-R

> For DSI panels (or DSI-to-whatever bridges) it's of course another
> story. You typically need a panel specific driver. And here I see the
> main point of the whole CDF: decoupling display controllers and the
> panel drivers, and sharing panel (and converter chip) specific drivers
> across display controllers. Making it easy to write new drivers, as
> there would be a model to follow. I'm definitely in favour of coming up
> with some framework that would tackle that.
>
>
> BR,
> Jani.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
