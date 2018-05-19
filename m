Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57096 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750743AbeESFw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 01:52:28 -0400
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers
 initialization
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
 <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <2067414a-8260-e249-62b2-9435e842608c@zonque.org>
Date: Sat, 19 May 2018 07:52:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Saturday, May 19, 2018 04:42 AM, Sam Bobrowicz wrote:
> This set of patches is also not working for my MIPI platform (mine has
> a 12 MHz external clock). I am pretty sure is isn't working because it
> does not include the following, which my tests have found to be
> necessary:
> 
> 1) Setting pclk period reg in order to correct DPHY timing.
> 2) Disabling of MIPI lanes when streaming not enabled.
> 3) setting mipi_div to 1 when the scaler is disabled
> 4) Doubling ADC clock on faster resolutions.
> 
> I will run some more tests to see if anything else is broken and come
> back with some suggestions.
> 
> I should mention that the upstream driver has never worked with my
> platform. I suspect that the driver only ever worked previously with
> MIPI platforms that have loose DPHY timing requirements and a specific
> xclk (24MHz maybe?). Out of the interest of collecting more data, can
> you provide the following info on your platform?
> 
> a) External clock frequency

Mine has a 24MHz oscillator.

> b) List of resolutions (including framerates) that are working with
> these patches (and your fix) applied

I have a somewhat limited support in userspace which is currently 
hard-coded to 1920x1080@30fps. I haven't tested any other resolution, 
but this one is not working with this patch set.

> c) List of resolutions that were working prior to the regression you
> experienced with the set_timings function

The one mentioned above did work before, except for one things: I need a 
patch on top that adds a V4L2_CID_PIXEL_RATE control. The qcom camss 
platform needs that in order to calculate its own clock rates. When I 
tested this patch set, I hard-coded the setting the camss driver.

I can send a patch that adds this control once this patch set has landed.


Thanks,
Daniel
