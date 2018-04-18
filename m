Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:40826 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752703AbeDRXjH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 19:39:07 -0400
Received: by mail-io0-f179.google.com with SMTP id t123-v6so4507733iof.7
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2018 16:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417160122.rfdlbdafmivgi5cd@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com> <20180417160122.rfdlbdafmivgi5cd@flea>
From: Samuel Bobrowicz <sam@elite-embedded.com>
Date: Wed, 18 Apr 2018 16:39:06 -0700
Message-ID: <CAFwsNOE3aockxFDbPP4B6LDckGrvM5grqcov5wui0aCyuQs4Tw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

I applied your patches, and they are a big improvement for what I am
trying to do, but things still aren't working right on my platform.

How confident are you that the MIPI mode will work with this version
of the driver? I am having issues that I believe are due to incorrect
clock generation. Our engineers did some reverse engineering of the
clock tree themselves, and came up with a slightly different model.
I've captured their model in a spreadsheet here:
https://tinyurl.com/pll-calc . Just modify the register and xclk
values to see the clocks change. Do your tests disagree with this
potential model?

I'm not sure which model is more correct, but my tests suggest the
high speed MIPI clock is generated directly off the PLL. This means
the PLL multiplier you are generating in your algorithm is not high
enough to satisfy the bandwidth. If this is the case, MIPI mode will
require a different set of parameters that enable some of the
downstream dividers, so that the PLL multiplier can be higher while
the PCLK value still matches the needed rate calculated from the
resolution.

Any thoughts on this before I dive in and start tweaking the algorithm
in mipi mode?

Sam
-----------------------
Sam Bobrowicz
Elite Embedded Consulting LLC
elite-embedded.com


On Tue, Apr 17, 2018 at 9:01 AM, Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
> On Mon, Apr 16, 2018 at 04:22:39PM -0700, Samuel Bobrowicz wrote:
>> I've been digging around the ov5640.c code for a few weeks now, these
>> look like some solid improvements. I'll give them a shot and let you
>> know how they work.
>
> Great, thanks!
>
>> On that note, I'm bringing up a module that uses dual lane MIPI with a
>> 12MHz fixed oscillator for xclk (Digilent's Pcam 5c). The mainline
>> version of the driver seems to only support xclk of 22MHz (or maybe
>> 24MHz), despite allowing xclk values from 6-24MHz. Will any of these
>> patches add support for a 12MHz xclk while in MIPI mode?
>
> My setup has a 24MHz crystal, and work with a parallel bus so I
> haven't been able to test yours. However, yeah, I guess my patches
> will improve your situation a lot.
>
> Maxime
>
> --
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> https://bootlin.com
