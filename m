Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49327 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2LRFJh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 00:09:37 -0500
MIME-Version: 1.0
In-Reply-To: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Tue, 18 Dec 2012 15:04:02 +1000
Message-ID: <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Dave Airlie <airlied@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Many developers showed interest in the first RFC, and I've had the opportunity
> to discuss it with most of them. I would like to thank (in no particular
> order) Tomi Valkeinen for all the time he spend helping me to draft v2, Marcus
> Lorentzon for his useful input during Linaro Connect Q4 2012, and Linaro for
> inviting me to Connect and providing a venue to discuss this topic.
>

So this might be a bit off topic but this whole CDF triggered me
looking at stuff I generally avoid:

The biggest problem I'm having currently with the whole ARM graphics
and output world is the proliferation of platform drivers for every
little thing. The whole ordering of operations with respect to things
like suspend/resume or dynamic power management is going to be a real
nightmare if there are dependencies between the drivers. How do you
enforce ordering of s/r operations between all the various components?

The other thing I'd like you guys to do is kill the idea of fbdev and
v4l drivers that are "shared" with the drm codebase, really just
implement fbdev and v4l on top of the drm layer, some people might
think this is some sort of maintainer thing, but really nothing else
makes sense, and having these shared display frameworks just to avoid
having using drm/kms drivers seems totally pointless. Fix the drm
fbdev emulation if an fbdev interface is needed. But creating a fourth
framework because our previous 3 frameworks didn't work out doesn't
seem like a situation I want to get behind too much.

Dave.
