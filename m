Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58514 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855Ab2ENAYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 20:24:35 -0400
Date: Mon, 14 May 2012 03:24:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 07/10] arm: omap4430sdp: Add support for omap4iss
 camera
Message-ID: <20120514002430.GH3373@valkosipuli.retiisi.org.uk>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
 <1335971749-21258-8-git-send-email-saaguirre@ti.com>
 <20120502194700.GF852@valkosipuli.localdomain>
 <CAKnK67S5zZW0HAUYrg4ZqudiQqcOY+kbZeDeQ1OGU+s+cShBDQ@mail.gmail.com>
 <CAKnK67SZGES33T02Ki3imZi20OKRSRe+u9nONsq2KoEGVz4_0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKnK67SZGES33T02Ki3imZi20OKRSRe+u9nONsq2KoEGVz4_0w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Thu, May 03, 2012 at 10:20:47PM -0500, Aguirre, Sergio wrote:
> Hi Sakari,
> 
> On Thu, May 3, 2012 at 7:03 AM, Aguirre, Sergio <saaguirre@ti.com> wrote:
> > Hi Sakari,
> >
> > Thanks for reviewing.
> >
> > On Wed, May 2, 2012 at 2:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >>
> >> Hi Sergio,
> >>
> >> Thanks for the patches!!
> >>
> >> On Wed, May 02, 2012 at 10:15:46AM -0500, Sergio Aguirre wrote:
> >> ...
> >>> +static int sdp4430_ov_cam1_power(struct v4l2_subdev *subdev, int on)
> >>> +{
> >>> +     struct device *dev = subdev->v4l2_dev->dev;
> >>> +     int ret;
> >>> +
> >>> +     if (on) {
> >>> +             if (!regulator_is_enabled(sdp4430_cam2pwr_reg)) {
> >>> +                     ret = regulator_enable(sdp4430_cam2pwr_reg);
> >>> +                     if (ret) {
> >>> +                             dev_err(dev,
> >>> +                                     "Error in enabling sensor power regulator 'cam2pwr'\n");
> >>> +                             return ret;
> >>> +                     }
> >>> +
> >>> +                     msleep(50);
> >>> +             }
> >>> +
> >>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 1);
> >>> +             msleep(10);
> >>> +             ret = clk_enable(sdp4430_cam1_aux_clk); /* Enable XCLK */
> >>> +             if (ret) {
> >>> +                     dev_err(dev,
> >>> +                             "Error in clk_enable() in %s(%d)\n",
> >>> +                             __func__, on);
> >>> +                     gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
> >>> +                     return ret;
> >>> +             }
> >>> +             msleep(10);
> >>> +     } else {
> >>> +             clk_disable(sdp4430_cam1_aux_clk);
> >>> +             msleep(1);
> >>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
> >>> +             if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
> >>> +                     ret = regulator_disable(sdp4430_cam2pwr_reg);
> >>> +                     if (ret) {
> >>> +                             dev_err(dev,
> >>> +                                     "Error in disabling sensor power regulator 'cam2pwr'\n");
> >>> +                             return ret;
> >>> +                     }
> >>> +             }
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>
> >> Isn't this something that should be part of the sensor driver? There's
> >> nothing in the above code that would be board specific, except the names of
> >> the clocks, regulators and GPIOs. The sensor driver could hold the names
> >> instead; this would be also compatible with the device tree.
> >
> > Agreed. I see what you mean...
> >
> > I'll take care of that.
> 
> Can you please check out these patches?
> 
> 1. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/cb6c10d58053180364461e6bc8d30d1ec87e6e22

Ideally we should really get rid of the board code callbacks. What do you
need to do there?

> 2. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/6732e0db25c6647b34ef8f01c244a49a1fd6b45d

Isn't reset voltage level (high or low) a property of the sensor rather than
the board?

Well, I know sometimes the people who typically design the hardware can be
quite inventive. ;)

> 3. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/d61c4e3142dc9cae972f9128fe73d986838c0ca1

> 4. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/e83f36001c7f7cbe184ad094d9b0c95c39e5028f

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
