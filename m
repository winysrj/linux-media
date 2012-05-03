Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44945 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927Ab2ECMEQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 08:04:16 -0400
Received: by qady23 with SMTP id y23so234459qad.7
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 05:04:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120502194700.GF852@valkosipuli.localdomain>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
 <1335971749-21258-8-git-send-email-saaguirre@ti.com> <20120502194700.GF852@valkosipuli.localdomain>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 3 May 2012 07:03:54 -0500
Message-ID: <CAKnK67S5zZW0HAUYrg4ZqudiQqcOY+kbZeDeQ1OGU+s+cShBDQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] arm: omap4430sdp: Add support for omap4iss camera
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for reviewing.

On Wed, May 2, 2012 at 2:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Hi Sergio,
>
> Thanks for the patches!!
>
> On Wed, May 02, 2012 at 10:15:46AM -0500, Sergio Aguirre wrote:
> ...
>> +static int sdp4430_ov_cam1_power(struct v4l2_subdev *subdev, int on)
>> +{
>> +     struct device *dev = subdev->v4l2_dev->dev;
>> +     int ret;
>> +
>> +     if (on) {
>> +             if (!regulator_is_enabled(sdp4430_cam2pwr_reg)) {
>> +                     ret = regulator_enable(sdp4430_cam2pwr_reg);
>> +                     if (ret) {
>> +                             dev_err(dev,
>> +                                     "Error in enabling sensor power regulator 'cam2pwr'\n");
>> +                             return ret;
>> +                     }
>> +
>> +                     msleep(50);
>> +             }
>> +
>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 1);
>> +             msleep(10);
>> +             ret = clk_enable(sdp4430_cam1_aux_clk); /* Enable XCLK */
>> +             if (ret) {
>> +                     dev_err(dev,
>> +                             "Error in clk_enable() in %s(%d)\n",
>> +                             __func__, on);
>> +                     gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
>> +                     return ret;
>> +             }
>> +             msleep(10);
>> +     } else {
>> +             clk_disable(sdp4430_cam1_aux_clk);
>> +             msleep(1);
>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
>> +             if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
>> +                     ret = regulator_disable(sdp4430_cam2pwr_reg);
>> +                     if (ret) {
>> +                             dev_err(dev,
>> +                                     "Error in disabling sensor power regulator 'cam2pwr'\n");
>> +                             return ret;
>> +                     }
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>
> Isn't this something that should be part of the sensor driver? There's
> nothing in the above code that would be board specific, except the names of
> the clocks, regulators and GPIOs. The sensor driver could hold the names
> instead; this would be also compatible with the device tree.

Agreed. I see what you mean...

I'll take care of that.

>
> It should be possible to have s_power() callback NULL, too.
>
>> +static int sdp4430_ov_cam2_power(struct v4l2_subdev *subdev, int on)
>> +{
>> +     struct device *dev = subdev->v4l2_dev->dev;
>> +     int ret;
>> +
>> +     if (on) {
>> +             u8 gpoctl = 0;
>> +
>> +             ret = regulator_enable(sdp4430_cam2pwr_reg);
>> +             if (ret) {
>> +                     dev_err(dev,
>> +                             "Error in enabling sensor power regulator 'cam2pwr'\n");
>> +                     return ret;
>> +             }
>> +
>> +             msleep(50);
>> +
>> +             if (twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &gpoctl,
>> +                                 TWL6040_REG_GPOCTL))
>> +                     return -ENODEV;
>> +             if (twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE,
>> +                                  gpoctl | TWL6040_GPO3,
>> +                                  TWL6040_REG_GPOCTL))
>> +                     return -ENODEV;
>
> The above piece of code looks quite interesting. What does it do?

Well, this is because the camera adapter board in 4430SDP has 3
sensors actually:

- 1 Sony IMX060 12.1 MP sensor
- 2 OmniVision OV5650 sensors

And there's 3 wideband analog switches, like this:

http://www.analog.com/static/imported-files/data_sheets/ADG936_936R.pdf

That basically select either IMX060 or OV5650 for CSI2A input.

So, this commands are because the TWL6040 chip has a GPO pin to toggle
this, instead
of an OMAP GPIO (Don't ask me why :) )

Anyways... I see your point, maybe this should be explained better
through a comment.

Regards,
Sergio
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
