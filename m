Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45890 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbeEVTyt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 15:54:49 -0400
Date: Tue, 22 May 2018 21:54:37 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
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
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers
 initialization
Message-ID: <20180522195437.bay6muqp3uqq5k3z@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
 <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
 <20180521073902.ayky27k5pcyfyyvc@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180521073902.ayky27k5pcyfyyvc@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 09:39:02AM +0200, Maxime Ripard wrote:
> On Fri, May 18, 2018 at 07:42:34PM -0700, Sam Bobrowicz wrote:
> > On Fri, May 18, 2018 at 3:35 AM, Daniel Mack <daniel@zonque.org> wrote:
> > > On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> > >>
> > >> Part of the hardcoded initialization sequence is to set up the proper
> > >> clock
> > >> dividers. However, this is now done dynamically through proper code and as
> > >> such, the static one is now redundant.
> > >>
> > >> Let's remove it.
> > >>
> > >> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > >> ---
> > >
> > >
> > > [...]
> > >
> > >> @@ -625,8 +623,8 @@ static const struct reg_value
> > >> ov5640_setting_30fps_1080P_1920_1080[] = {
> > >>         {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> > >>         {0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
> > >>         {0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> > >> -       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, 0},
> > >> -       {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
> > >> +       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
> > >> +       {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
> > >
> > >
> > > This is the mode that I'm testing with. Previously, the hard-coded registers
> > > here were:
> > >
> > >  OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
> > >  OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0x54
> > >  OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x07
> > >
> > > Your new code that calculates the clock rates dynamically ends up with
> > > different values however:
> > >
> > >  OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
> > >  OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0xa8
> > >  OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x03
> > >
> > > Interestingly, leaving the hard-coded values in the array *and* letting
> > > ov5640_set_mipi_pclk() do its thing later still works. So again it seems
> > > that writes to registers after 0x3035/0x3036/0x3037 seem to depend on the
> > > values of these timing registers. You might need to leave these values as
> > > dummies in the array. Confusing.
> > >
> > > Any idea?
> > >
> > >
> > > Thanks,
> > > Daniel
> > 
> > This set of patches is also not working for my MIPI platform (mine has
> > a 12 MHz external clock). I am pretty sure is isn't working because it
> > does not include the following, which my tests have found to be
> > necessary:
> > 
> > 1) Setting pclk period reg in order to correct DPHY timing.
> > 2) Disabling of MIPI lanes when streaming not enabled.
> > 3) setting mipi_div to 1 when the scaler is disabled
> > 4) Doubling ADC clock on faster resolutions.
> 
> Yeah, I left them out because I didn't think this was relevant to this
> patchset but should come as future improvements. However, given that
> it works with the parallel bus, maybe the two first are needed when
> adjusting the rate.

I've checked for the pclk period, and it's hardcoded to the same value
all the time, so I guess this is not the reason it doesn't work on
MIPI CSI anymore.

Daniel, could you test:
http://code.bulix.org/ki6kgz-339327?raw

And let us know the results?

Thanks!
Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
