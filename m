Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:36013 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2L0QEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 11:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <2286035.iP368aB6Vk@avalon>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1671267.x0lxGrFjjV@avalon>
	<87pq26ay2z.fsf@intel.com>
	<2286035.iP368aB6Vk@avalon>
Date: Thu, 27 Dec 2012 10:04:22 -0600
Message-ID: <CAF6AEGth+rriTf7X3AXytN+YXxjx4XqMB1ow6ZE2QUro-hqYgw@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rob Clark <rob.clark@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 24, 2012 at 11:27 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 19 December 2012 16:57:56 Jani Nikula wrote:
>> It just seems to me that, at least from a DRM/KMS perspective, adding
>> another layer (=CDF) for HDMI or DP (or legacy outputs) would be
>> overengineering it. They are pretty well standardized, and I don't see there
>> would be a need to write multiple display drivers for them. Each display
>> controller has one, and can easily handle any chip specific requirements
>> right there. It's my gut feeling that an additional framework would just get
>> in the way. Perhaps there could be more common HDMI/DP helper style code in
>> DRM to reduce overlap across KMS drivers, but that's another thing.
>>
>> So is the HDMI/DP drivers using CDF a more interesting idea from a non-DRM
>> perspective? Or, put another way, is it more of an alternative to using DRM?
>> Please enlighten me if there's some real benefit here that I fail to see!
>
> As Rob pointed out, you can have external HDMI/DP encoders, and even internal
> HDMI/DP encoder IPs can be shared between SoCs and SoC vendors. CDF aims at
> sharing a single driver between SoCs and boards for a given HDMI/DP encoder.

just fwiw, drm already has something a bit like this.. the i2c
encoder-slave.  With support for a couple external i2c encoders which
could in theory be shared between devices.

BR,
-R
