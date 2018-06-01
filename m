Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36894 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbeFAXGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 19:06:00 -0400
Received: by mail-it0-f67.google.com with SMTP id l6-v6so3779072iti.2
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 16:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180521073902.ayky27k5pcyfyyvc@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com> <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com> <20180521073902.ayky27k5pcyfyyvc@flea>
From: Sam Bobrowicz <sam@elite-embedded.com>
Date: Fri, 1 Jun 2018 16:05:58 -0700
Message-ID: <CAFwsNOFPogtuk396e7gRJfVkAujAbkmCJxPdhGmp1Gvf0u3XSA@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers initialization
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Daniel Mack <daniel@zonque.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> On May 21, 2018, at 12:39 AM, Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>>
>>> On Fri, May 18, 2018 at 07:42:34PM -0700, Sam Bobrowicz wrote:
>>>> On Fri, May 18, 2018 at 3:35 AM, Daniel Mack <daniel@zonque.org> wrote:
>>>> On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
>>>>
>>>> Part of the hardcoded initialization sequence is to set up the proper
>>>> clock
>>>> dividers. However, this is now done dynamically through proper code and as
>>>> such, the static one is now redundant.
>>>>
>>>> Let's remove it.
>>>>
>>>> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>>> ---
>>>
>>>
>>> [...]
>>>
>>>> @@ -625,8 +623,8 @@ static const struct reg_value
>>>> ov5640_setting_30fps_1080P_1920_1080[] = {
>>>>       {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
>>>>       {0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
>>>>       {0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>>>> -       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, 0},
>>>> -       {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
>>>> +       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
>>>> +       {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
>>>
>>>
>>> This is the mode that I'm testing with. Previously, the hard-coded registers
>>> here were:
>>>
>>> OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
>>> OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0x54
>>> OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x07
>>>
>>> Your new code that calculates the clock rates dynamically ends up with
>>> different values however:
>>>
>>> OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
>>> OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0xa8
>>> OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x03
>>>
>>> Interestingly, leaving the hard-coded values in the array *and* letting
>>> ov5640_set_mipi_pclk() do its thing later still works. So again it seems
>>> that writes to registers after 0x3035/0x3036/0x3037 seem to depend on the
>>> values of these timing registers. You might need to leave these values as
>>> dummies in the array. Confusing.
>>>
>>> Any idea?
>>>
>>>
>>> Thanks,
>>> Daniel
>>
>> This set of patches is also not working for my MIPI platform (mine has
>> a 12 MHz external clock). I am pretty sure is isn't working because it
>> does not include the following, which my tests have found to be
>> necessary:
>>
>> 1) Setting pclk period reg in order to correct DPHY timing.
>> 2) Disabling of MIPI lanes when streaming not enabled.
>> 3) setting mipi_div to 1 when the scaler is disabled
>> 4) Doubling ADC clock on faster resolutions.
>
> Yeah, I left them out because I didn't think this was relevant to this
> patchset but should come as future improvements. However, given that
> it works with the parallel bus, maybe the two first are needed when
> adjusting the rate.
>
I agree that 1-4 are separate improvements to MIPI mode that may not
affect all modules. They do break mine, but that has been true since
the driver was released (mainly because of my 12 MHz clock and more
stringent CSI RX requirements). So it makes sense for me to address
them in a follow-up series. But I do think that we should get the
clock generation a little closer to what I know works for MIPI so we
don't break things for people that do have MIPI working.

> The mipi divider however seems to be a bit more complicated than you
> report here. It is indeed set to 1 when the scaler is enabled (all
> resolutions > 1280 * 960), but it's also set to 4 in some cases
> (640x480@30, 320x240@30, 176x144@30). I couldn't really find any
> relationship between the resolution/framerate and whether to use a
> divider of 2 or 4.

I didn't notice the divide by 4, interesting. I have a theory
though... it could be that the constraint of PCLK relative to SCLK is:

SCLK*(cpp/scaler ratio)<=PCLK<= ?
cpp=Components/pixel (1 for JPEG, 2 for YUV, e.g.)

Since the scaler is in auto mode, the scaler ratio might automatically
change depending on the resolution selected, something like (using int
math):

(hTotal/hActive) * (vTotal/vActive) = scaler ratio

If SCLK is responsible for reading the data into the scaler, and PCLK
is responsible for reading data out to the physical interface, this
would make sense. It will require more experiments to verify any of
this, though, and unfortunately I don't have a lot of time to put into
this right now.

On my platform I have also run into an upper bound for PCLK, where it
seems that PCLK must be <= SCLK when the scaler is enabled. I think
this may have to do with some of my platform's idiosyncrasies, so I'm
not ready to say that it needs to be addressed in this series. But if
others run into it while testing MIPI, you should consider
implementing #3 above to address it.

> And the faster resolutions were working already, so I guess the ADC
> clock is already fast enough with a 24MHz oscillator?

That's my theory. It seems to have pretty loose requirements as long
as it is fast enough, which is why I did the simple 2x solution. It
doesn't need to be addressed here though. If anyone runs into images
that are all black or bluish, this is a possible culprit.

> Maxime
>
> --
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> https://bootlin.com

I'm back, sorry for the delay. Here is a patch that should fix a few
things for MIPI users. Just apply it directly after applying the
series. Someone else should definitely verify this on a different MIPI
platform.

https://nofile.io/f/W8J3thK7pOp/clock_fixes.patch

These are the noteworthy changes I made.

*Added writes to init blob for 0x3034 (bit div) and 0x3037 (pll r
div). This is because bit div and pll root div never get written to
the expected values (8 and 2), so they remain as defaults (10 and 1).
It would also be possible to modify set_mipi_pclk to just write these
values there, but I didn't wan't to mess with your functions too much.

*Change MIPI SCLK constraint in comments to match the notes found
here: https://community.nxp.com/servlet/JiveServlet/downloadImage/105-32914-99951/ov5640_diagram.jpg.
It seems that the pixels are serialized into components when they
cross from SCLK to PCLK, so the MIPI serial clock does not care about
cpp, only bpc (bits/component).

*Lower MIPI DIV to 1 for now. It may be necessary to conditionally set
it later if people are still having trouble, but always using 2 will
make PCLK<SCLK*cpp, and definitely break non-scaled resolutions.

*MIPI div register doesn't need a -1. When set to zero, it actually
divides by 16.

Also, FYI, I've made some improvements to my clock configuration
spreadsheet and incorporated a register dump function into set_mode
that prints the relevant registers so they can be copied into the
spreadsheet for interpretation. Just let me know if anyone wants it.

Sam
