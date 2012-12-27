Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51867 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2L0QKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 11:10:13 -0500
MIME-Version: 1.0
In-Reply-To: <9229594.Uy6ivYUL5t@avalon>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<87pq26ay2z.fsf@intel.com>
	<CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
	<9229594.Uy6ivYUL5t@avalon>
Date: Thu, 27 Dec 2012 10:10:11 -0600
Message-ID: <CAF6AEGv4uk-ymjcaHo5B_7vdPO0Fa=V6WMiPFeMiz6ftVP54_g@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rob Clark <rob.clark@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 24, 2012 at 11:35 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 19 December 2012 09:26:40 Rob Clark wrote:
>> And, there are also external HDMI encoders (for example connected over
>> i2c) that can also be shared between boards.  So I think there will be
>> a number of cases where CDF is appropriate for HDMI drivers.  Although
>> trying to keep this all independent of DRM (as opposed to just
>> something similar to what drivers/gpu/i2c is today) seems a bit
>> overkill for me.  Being able to use the helpers in drm and avoiding an
>> extra layer of translation seems like the better option to me.  So my
>> vote would be drivers/gpu/cdf.
>
> I don't think there will be any need for translation (except perhaps between
> the DRM mode structures and the common video mode structure that is being
> discussed). Add a drm_ prefix to the existing CDF functions and structures,
> and there you go :-)

well, and translation for any properties that we'd want to expose to
userspace, etc, etc.. I see there being a big potential for a lot of
needless glue

BR,
-R

> The reason why I'd like to keep CDF separate from DRM (or at least not
> requiring a drm_device) is that HDMI/DP encoders can be used by pure V4L2
> drivers.
>
>> > For DSI panels (or DSI-to-whatever bridges) it's of course another
>> > story. You typically need a panel specific driver. And here I see the
>> > main point of the whole CDF: decoupling display controllers and the
>> > panel drivers, and sharing panel (and converter chip) specific drivers
>> > across display controllers. Making it easy to write new drivers, as
>> > there would be a model to follow. I'm definitely in favour of coming up
>> > with some framework that would tackle that.
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
