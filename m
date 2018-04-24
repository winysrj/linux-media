Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:39027 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbeDXWLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 18:11:20 -0400
Received: by mail-it0-f65.google.com with SMTP id c3-v6so2983538itj.4
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 15:11:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180419123244.tujbrkpazbdyows6@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
 <20180417160122.rfdlbdafmivgi5cd@flea> <CAFwsNOE3aockxFDbPP4B6LDckGrvM5grqcov5wui0aCyuQs4Tw@mail.gmail.com>
 <20180419123244.tujbrkpazbdyows6@flea>
From: Sam Bobrowicz <sam@elite-embedded.com>
Date: Tue, 24 Apr 2018 15:11:19 -0700
Message-ID: <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
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

FYI, still hard at work on this. Did some more experiments last week
that seemed to corroborate the clock tree in the spreadsheet. It also
seems that the output of the P divider cell, SCLK cell and MIPI Rate
cell in the spreadsheet must have a ratio of 2x:1x:8x (respectively)
in order for the sensor to work properly on my platform, and that the
SCLK value must be close to the "rate" variable that you calculate and
pass to set_mipi_pclk. Unfortunately, I've only got the sensor working
well for 1080p@15Hz and 720p@30Hz, both with a SCLK of 42MHz (aka
84:42:336). I'm running experiments now trying to adjust the htot and
vtot values to create different required rates, and also to try to get
faster Mipi rates working. Any information you have on the
requirements of the htot and vtot values with respect to vact and hact
values would likely be helpful.

I'm also keeping an eye on the scaler clock, which I think may be
affecting certain resolutions, but haven't been able to see it make a
difference yet (see register 0x3824 and 0x460c)

I plan on pushing a set of patches once I get this figured out, we can
discuss what I should base them on when I get closer to that point.
I'm new to this process :)

--Sam
-----------------------
Sam Bobrowicz
Elite Embedded Consulting LLC
elite-embedded.com


On Thu, Apr 19, 2018 at 5:32 AM, Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
> Hi Samuel,
>
> On Wed, Apr 18, 2018 at 04:39:06PM -0700, Samuel Bobrowicz wrote:
>> I applied your patches, and they are a big improvement for what I am
>> trying to do, but things still aren't working right on my platform.
>>
>> How confident are you that the MIPI mode will work with this version
>> of the driver?
>
> Not too confident. Like I said, I did all my tests on a parallel
> camera with a scope, so I'm pretty confident for the parallel bus. But
> I haven't been able to test the MIPI-CSI side of things and tried to
> deduce it from the datasheet.
>
> tl; dr: I might very well be wrong.
>
>> I am having issues that I believe are due to incorrect clock
>> generation. Our engineers did some reverse engineering of the clock
>> tree themselves, and came up with a slightly different model.  I've
>> captured their model in a spreadsheet here:
>> https://tinyurl.com/pll-calc . Just modify the register and xclk
>> values to see the clocks change. Do your tests disagree with this
>> potential model?
>
> At least on the parallel side, it looks fairly similar, so I guess we
> can come to an agreement :)
>
> There's just the SCLK2x divider that is no longer in the path to PCLK
> but has been replaced with BIT Divider that has the same value, so it
> should work as well.
>
>> I'm not sure which model is more correct, but my tests suggest the
>> high speed MIPI clock is generated directly off the PLL. This means
>> the PLL multiplier you are generating in your algorithm is not high
>> enough to satisfy the bandwidth. If this is the case, MIPI mode will
>> require a different set of parameters that enable some of the
>> downstream dividers, so that the PLL multiplier can be higher while
>> the PCLK value still matches the needed rate calculated from the
>> resolution.
>>
>> Any thoughts on this before I dive in and start tweaking the algorithm
>> in mipi mode?
>
> Like I said, I did that analysis by plugging the camera to a scope and
> look at the PCLK generated for various combinations. Your analysis
> seems not too far off for the setup I've tested, so I guess this makes
> sense. And let me know how it works for MIPI-CSI2 so that I can update
> the patches :)
>
> Maxime
>
> --
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> https://bootlin.com
