Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40331 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbeLCRdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 12:33:49 -0500
Date: Mon, 3 Dec 2018 18:33:27 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Adam Ford <aford173@gmail.com>
Cc: jacopo+renesas@jmondi.org, maxime.ripard@bootlin.com,
        sam@elite-embedded.com, Steve Longerbeam <slongerbeam@gmail.com>,
        mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Subject: Re: [PATCH 2/2] media: ov5640: make MIPI clock depend on mode
Message-ID: <20181203173327.GA12431@w540>
References: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org>
 <1543502916-21632-3-git-send-email-jacopo+renesas@jmondi.org>
 <CAHCN7xLb8LRWQiaXYLsJn+bhU=z=kG-oUNU8Euueb3LOvn57PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CAHCN7xLb8LRWQiaXYLsJn+bhU=z=kG-oUNU8Euueb3LOvn57PQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Adam,
    thanks for testing

On Mon, Dec 03, 2018 at 10:28:04AM -0600, Adam Ford wrote:
> On Thu, Nov 29, 2018 at 8:49 AM Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> >
> > The MIPI clock generation tree uses the MIPI_DIV divider to generate both the
> > MIPI SCALER CLOCK and the PIXEL_CLOCK. It seems the MIPI BIT CLK frequency is
> > generated by either the MIPI SCALER or the PIXEL CLOCK, depending if the
> > currently applied image mode uses the scaler or not.
> >
> > Make the MIPI_DIV selection value depend on the subsampling mode used by the
> > currently applied image mode.
> >
> > Tested with:
> > 172x144 320x240, 640x480, 1024x756, 1024x768, 1280x720, 1920x1080 in YUYV mode
> > at 10, 15, 20, and 30 FPS with MIPI CSI-2 2 lanes mode.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>
> I am not able to apply this patch to 4.19.6, 4.19-RC5, or Linux-media master [1]
>
> Is there a specific branch/repo somewhere I can pull?  I was able to
> apply patch 1/2 just fine, but 2/2 wouldn't apply

Reading the cover letter:
"these two patches should be applied on top of Maxime's clock tree rework v5"

Maxime has included those 2 in his v6. You may want to test that one
:)

Thanks
   j

>
> [1] - git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
>
> adam
> > ---
> > Maxime,
> >    this patch is not just a cosmetic updates to the 'set_mipi_pclk()'
> > comment block as I anticipated, but it actually fix the framerate handling
> > compared for CSI-2, which in you v5 results halved for most modes. I have
> > not included any "Fixes:" tag, as I hope this patch will get in with your v5.
> >
> > That's my bad, as in the patches I sent to be applied on top of your v4 I
> > forgot to add a change, and the requested SCLK rate was always half of what
> > it was actually required.
> >
> > Also, I have left out from this patches most of Sam's improvements (better SCLK
> > selection policies, and programming of register OV5640_REG_PCLK_PERIOD as for
> > from testing they're not required, and I don't want to pile more patches than
> > necessary for the next merge window, not to slow down the clock tree rework
> > inclusion. We can get back to it after it got merged.
> >
> > This are the test result obtained by capturing 100 frames with yavta and
> > inspecting the reported fps results.
> >
> > Results are pretty neat, 2592x1944 mode apart, which runs a bit slow.
> >
> > capturing 176x144 @ 10FPS
> > Captured 100 frames in 10.019398 seconds (9.980640 fps, 505898.657683 B/s).
> > capturing 176x144 @ 15FPS
> > Captured 100 frames in 6.681860 seconds (14.965892 fps, 758591.132803 B/s).
> > capturing 176x144 @ 20FPS
> > Captured 100 frames in 5.056204 seconds (19.777683 fps, 1002491.196755 B/s).
> > capturing 176x144 @ 30FPS
> > Captured 100 frames in 3.357204 seconds (29.786686 fps, 1509827.521040 B/s).
> >
> > capturing 320x240 @ 10FPS
> > Captured 100 frames in 10.015432 seconds (9.984591 fps, 1533633.245951 B/s).
> > capturing 320x240 @ 15FPS
> > Captured 100 frames in 6.684035 seconds (14.961021 fps, 2298012.872049 B/s).
> > capturing 320x240 @ 20FPS
> > Captured 100 frames in 5.019164 seconds (19.923635 fps, 3060270.391218 B/s).
> > capturing 320x240 @ 30FPS
> > Captured 100 frames in 3.352991 seconds (29.824115 fps, 4580984.103432 B/s).
> >
> > capturing 640x480 @ 10FPS
> > Captured 100 frames in 9.990389 seconds (10.009620 fps, 6149910.678538 B/s).
> > capturing 640x480 @ 15FPS
> > Captured 100 frames in 6.856242 seconds (14.585249 fps, 8961176.838123 B/s).
> > capturing 640x480 @ 20FPS
> > Captured 100 frames in 5.030264 seconds (19.879670 fps, 12214069.053476 B/s).
> > capturing 640x480 @ 30FPS
> > Captured 100 frames in 3.364612 seconds (29.721103 fps, 18260645.750580 B/s).
> >
> > capturing 720x480 @ 10FPS
> > Captured 100 frames in 10.022488 seconds (9.977562 fps, 6896491.169279 B/s).
> > capturing 720x480 @ 15FPS
> > Captured 100 frames in 6.891968 seconds (14.509643 fps, 10029065.232208 B/s).
> > capturing 720x480 @ 20FPS
> > Captured 100 frames in 5.234133 seconds (19.105360 fps, 13205624.616211 B/s).
> > capturing 720x480 @ 30FPS
> > Captured 100 frames in 3.602298 seconds (27.760055 fps, 19187750.044688 B/s).
> >
> > capturing 720x576 @ 10FPS
> > Captured 100 frames in 10.197244 seconds (9.806571 fps, 8133961.937805 B/s).
> > capturing 720x576 @ 15FPS
> > Captured 100 frames in 6.925244 seconds (14.439924 fps, 11977050.339261 B/s).
> > capturing 720x576 @ 20FPS
> > Captured 100 frames in 4.999968 seconds (20.000127 fps, 16588905.060854 B/s).
> > capturing 720x576 @ 30FPS
> > Captured 100 frames in 3.487568 seconds (28.673276 fps, 23782762.085212 B/s).
> >
> > capturing 1024x768 @ 10FPS
> > Captured 100 frames in 10.107128 seconds (9.894007 fps, 15561928.174298 B/s).
> > capturing 1024x768 @ 15FPS
> > Captured 100 frames in 6.810568 seconds (14.683062 fps, 23094459.169337 B/s).
> > capturing 1024x768 @ 20FPS
> > Captured 100 frames in 5.012039 seconds (19.951960 fps, 31381719.096759 B/s).
> > capturing 1024x768 @ 30FPS
> > Captured 100 frames in 3.346338 seconds (29.883407 fps, 47002534.905114 B/s).
> >
> > capturing 1280x720 @ 10FPS
> > Captured 100 frames in 9.957613 seconds (10.042567 fps, 18510459.665283 B/s).
> > capturing 1280x720 @ 15FPS
> > Captured 100 frames in 6.597751 seconds (15.156679 fps, 27936790.986673 B/s).
> > capturing 1280x720 @ 20FPS
> > Captured 100 frames in 4.946115 seconds (20.217888 fps, 37265611.495083 B/s).
> > capturing 1280x720 @ 30FPS
> > Captured 100 frames in 3.301329 seconds (30.290825 fps, 55832049.080847 B/s).
> >
> > capturing 1920x1080 @ 10FPS
> > Captured 100 frames in 10.024745 seconds (9.975316 fps, 41369629.470131 B/s).
> > capturing 1920x1080 @ 15FPS
> > Captured 100 frames in 6.674363 seconds (14.982702 fps, 62136260.577244 B/s).
> > capturing 1920x1080 @ 20FPS
> > Captured 100 frames in 5.102174 seconds (19.599488 fps, 81282998.172684 B/s).
> > capturing 1920x1080 @ 30FPS
> > Captured 100 frames in 3.341157 seconds (29.929746 fps, 124124642.214916 B/s).
> >
> > capturing 2592x1944 @ 10FPS
> > Captured 100 frames in 13.019132 seconds (7.681004 fps, 77406819.428913 B/s).
> > capturing 2592x1944 @ 15FPS
> > Captured 100 frames in 8.819705 seconds (11.338248 fps, 114263413.559267 B/s).
> > capturing 2592x1944 @ 20FPS
> > Captured 100 frames in 6.876134 seconds (14.543055 fps, 146560487.484508 B/s).
> > capturing 2592x1944 @ 30FPS
> > Captured 100 frames in 4.359511 seconds (22.938352 fps, 231165743.130365 B/s).
> > ---
> >  drivers/media/i2c/ov5640.c | 93 +++++++++++++++++++++++-----------------------
> >  1 file changed, 46 insertions(+), 47 deletions(-)
> >
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index c659efe918a4..13b7a0d04840 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -740,8 +740,11 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> >   *                         |    +---------------> SCLK 2X
> >   *                         |  +-------------+
> >   *                         +->| PCLK Div    | - reg 0x3108, bits 4-5
> > - *                            +-+-----------+
> > - *                              +---------------> PCLK
> > + *                            ++------------+
> > + *                             +  +-----------+
> > + *                             +->|   P_DIV   | - reg 0x3035, bits 0-3
> > + *                                +-----+-----+
> > + *                                       +------------> PCLK
> >   *
> >   * This is deviating from the datasheet at least for the register
> >   * 0x3108, since it's said here that the PCLK would be clocked from
> > @@ -751,7 +754,6 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> >   *  - the PLL pre-divider output rate should be in the 4-27MHz range
> >   *  - the PLL multiplier output rate should be in the 500-1000MHz range
> >   *  - PCLK >= SCLK * 2 in YUV, >= SCLK in Raw or JPEG
> > - *  - MIPI SCLK = (bpp / lanes) / PCLK
> >   *
> >   * In the two latter cases, these constraints are met since our
> >   * factors are hardcoded. If we were to change that, we would need to
> > @@ -777,10 +779,11 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> >  #define OV5640_SYSDIV_MAX      16
> >
> >  /*
> > - * This is supposed to be ranging from 1 to 16, but the value is always
> > - * set to 2 in the vendor kernels.
> > + * Hardcode these values for scaler and non-scaler modes.
> > + * FIXME: to be re-calcualted for 1 data lanes setups
> >   */
> > -#define OV5640_MIPI_DIV                2
> > +#define OV5640_MIPI_DIV_PCLK   2
> > +#define OV5640_MIPI_DIV_SCLK   1
> >
> >  /*
> >   * This is supposed to be ranging from 1 to 2, but the value is always
> > @@ -892,65 +895,61 @@ static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> >   * ov5640_set_mipi_pclk() - Calculate the clock tree configuration values
> >   *                         for the MIPI CSI-2 output.
> >   *
> > - * @rate: The requested bandwidth in bytes per second.
> > - *       It is calculated as: HTOT * VTOT * FPS * bpp
> > + * @rate: The requested bandwidth per lane in bytes per second.
> > + *       'Bandwidth Per Lane' is calculated as:
> > + *       bpl = HTOT * VTOT * FPS * bpp / num_lanes;
> >   *
> >   * This function use the requested bandwidth to calculate:
> > - * - sample_rate = bandwidth / bpp;
> > - * - mipi_clk = bandwidth / num_lanes / 2; ( / 2 for CSI-2 DDR)
> > + * - sample_rate = bpl / (bpp / num_lanes);
> > + *              = bpl / (PLL_RDIV * BIT_DIV * PCLK_DIV * MIPI_DIV / num_lanes);
> > + *
> > + * - mipi_sclk   = bpl / MIPI_DIV / 2; ( / 2 is for CSI-2 DDR)
> >   *
> > - * The bandwidth corresponds to the SYSCLK frequency generated by the
> > - * PLL pre-divider, the PLL multiplier and the SYS divider (see the clock
> > - * tree documented here above).
> > + * with these fixed parameters:
> > + *     PLL_RDIV        = 2;
> > + *     BIT_DIVIDER     = 2; (MIPI_BIT_MODE == 8 ? 2 : 2,5);
> > + *     PCLK_DIV        = 1;
> >   *
> > - * From the SYSCLK frequency, the MIPI CSI-2 clock tree generates the
> > - * pixel clock and the MIPI BIT clock as follows:
> > + * The MIPI clock generation differs for modes that use the scaler and modes
> > + * that do not. In case the scaler is in use, the MIPI_SCLK generates the MIPI
> > + * BIT CLk, and thus:
> >   *
> > - * MIPI_BIT_CLK = SYSCLK / MIPI_DIV / 2;
> > - * PIXEL_CLK = SYSCLK / PLL_RDVI / BIT_DIVIDER / PCLK_DIV / MIPI_DIV
> > + * - mipi_sclk = bpl / MIPI_DIV / 2;
> > + *   MIPI_DIV = 1;
> >   *
> > - * with this fixed parameters:
> > - * PLL_RDIV    = 2;
> > - * BIT_DIVIDER = 2; (MIPI_BIT_MODE == 8 ? 2 : 2,5);
> > - * PCLK_DIV    = 1;
> > + * For modes that do not go through the scaler, the MIPI BIT CLOCK is generated
> > + * from the pixel clock, and thus:
> >   *
> > - * With these values we have:
> > + * - sample_rate = bpl / (bpp / num_lanes);
> > + *              = bpl / (2 * 2 * 1 * MIPI_DIV / num_lanes);
> > + *              = bpl / (4 * MIPI_DIV / num_lanes);
> > + * - MIPI_DIV   = bpp / (4 * num_lanes);
> >   *
> > - * pixel_clock = bandwidth / bpp
> > - *            = bandwidth / 4 / MIPI_DIV;
> > + * FIXME: this have been tested with 16bpp and 2 lanes setup only.
> > + * MIPI_DIV is fixed to value 2, but it -might- be changed according to the
> > + * above formula for setups with 1 lane or image formats with different bpp.
> >   *
> > - * And so we can calculate MIPI_DIV as:
> > - * MIPI_DIV = bpp / 4;
> > + * FIXME: this deviates from the sensor manual documentation which is quite
> > + * thin on the MIPI clock tree generation part.
> >   */
> >  static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor,
> >                                 unsigned long rate)
> >  {
> >         const struct ov5640_mode_info *mode = sensor->current_mode;
> > -       u8 mipi_div = OV5640_MIPI_DIV;
> >         u8 prediv, mult, sysdiv;
> > +       u8 mipi_div;
> >         int ret;
> >
> > -       /* FIXME:
> > -        * Practical experience shows we get a correct frame rate by
> > -        * halving the bandwidth rate by 2, to slow down SYSCLK frequency.
> > -        * Divide both SYSCLK and MIPI_DIV by two (with OV5640_MIPI_DIV
> > -        * currently fixed at value '2', while according to the above
> > -        * formula it should have been = bpp / 4 = 4).
> > -        *
> > -        * So that:
> > -        * pixel_clock = bandwidth / 2 / bpp
> > -        *             = bandwidth / 2 / 4 / MIPI_DIV;
> > -        * MIPI_DIV = bpp / 4 / 2;
> > -        */
> > -       rate /= 2;
> > -
> > -       /* FIXME:
> > -        * High resolution modes (1280x720, 1920x1080) requires an higher
> > -        * clock speed. Half the MIPI_DIVIDER value to double the output
> > -        * pixel clock and MIPI_CLK speeds.
> > +       /*
> > +        * 1280x720 is reported to use 'SUBSAMPLING' only,
> > +        * but according to the sensor manual it goes through the
> > +        * scaler before subsampling.
> >          */
> > -       if (mode->hact > 1024)
> > -               mipi_div /= 2;
> > +       if (mode->dn_mode == SCALING ||
> > +          (mode->id == OV5640_MODE_720P_1280_720))
> > +               mipi_div = OV5640_MIPI_DIV_SCLK;
> > +       else
> > +               mipi_div = OV5640_MIPI_DIV_PCLK;
> >
> >         ov5640_calc_sys_clk(sensor, rate, &prediv, &mult, &sysdiv);
> >
> > --
> > 2.7.4
> >

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcBWjnAAoJEHI0Bo8WoVY8WgkQAJD7rwwToLRrDLMREwGOoAWT
Aui+OQ6l6nVgOn7uGhAohFwQ+FjIwY4lkt0a70YubtlxudiQg98PMADhumFdzI5Z
Irskh0eDNV7Kew1QVI3cGmuc1TFwNBx6RJym3YzeH6rzmVuwIFcn1fuJDdlCRUys
d80QH/cUHOafUGtVN0pcDQhHNrcvbWnmIbdJg9PABl7bCFfabRz4FfQk/vKvNias
/9cXUOWzgLmRe9flFE+rLBPXz8bDNEVVnFp5IOETEHNePHlIOvusYRduNFpvuvfg
UvLdxFDmFf0U0Rd3M91o3XEV/nUsoJ0ODw6I3njzk5glEbahGRl9Zy1qhJrd4pHM
zJXb3Tmza4kTrAqlgcFysJdwG8bc8BHIx8z2W8tzeXXdzecrJkPDxBv7aUWAORBY
7bH6NdKEdH/oBeAZLkDWnsXSHNXtjvr+zpx5QuiCwFpNtkwGQ+bKkYO4quuDN4sy
D+gz15G3u2owzAOXX7K4YiKUEvBca9PjU0kowmf95ZUgv5Gez/ZUzKjeIM3Pnj7r
PmMfu1Ekr8LqmT1Zo1zUSVkqYfq3RmtF5Ozz74ZhDofukSJLoFOC1L8FpMWxKweT
dpTyxsWN0sJnuOzEgEJmyYn4V0KuCnJFG+S+/nbt4RSfVizxEzTenqH+cHS1LAuU
AnvMxfXMoTSQPVdLpqTd
=L6JN
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
