Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64149 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965628Ab2ERRSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 13:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120514002430.GH3373@valkosipuli.retiisi.org.uk>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
	<1335971749-21258-8-git-send-email-saaguirre@ti.com>
	<20120502194700.GF852@valkosipuli.localdomain>
	<CAKnK67S5zZW0HAUYrg4ZqudiQqcOY+kbZeDeQ1OGU+s+cShBDQ@mail.gmail.com>
	<CAKnK67SZGES33T02Ki3imZi20OKRSRe+u9nONsq2KoEGVz4_0w@mail.gmail.com>
	<20120514002430.GH3373@valkosipuli.retiisi.org.uk>
Date: Fri, 18 May 2012 12:18:47 -0500
Message-ID: <CAC-OdnDd1OZWAMEe=xPoxBbiSGXfSsNQKstP4mUD5VyFv5rQow@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] arm: omap4430sdp: Add support for omap4iss camera
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "Aguirre, Sergio" <saaguirre@ti.com>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sun, May 13, 2012 at 7:24 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sergio,
>
> On Thu, May 03, 2012 at 10:20:47PM -0500, Aguirre, Sergio wrote:
>> Hi Sakari,
>>
>> On Thu, May 3, 2012 at 7:03 AM, Aguirre, Sergio <saaguirre@ti.com> wrote:
>> > Hi Sakari,
>> >
>> > Thanks for reviewing.
>> >
>> > On Wed, May 2, 2012 at 2:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> >>
>> >> Hi Sergio,
>> >>
>> >> Thanks for the patches!!
>> >>
>> >> On Wed, May 02, 2012 at 10:15:46AM -0500, Sergio Aguirre wrote:
>> >> ...
>> >>> +static int sdp4430_ov_cam1_power(struct v4l2_subdev *subdev, int on)
>> >>> +{
>> >>> +     struct device *dev = subdev->v4l2_dev->dev;
>> >>> +     int ret;
>> >>> +
>> >>> +     if (on) {
>> >>> +             if (!regulator_is_enabled(sdp4430_cam2pwr_reg)) {
>> >>> +                     ret = regulator_enable(sdp4430_cam2pwr_reg);
>> >>> +                     if (ret) {
>> >>> +                             dev_err(dev,
>> >>> +                                     "Error in enabling sensor power regulator 'cam2pwr'\n");
>> >>> +                             return ret;
>> >>> +                     }
>> >>> +
>> >>> +                     msleep(50);
>> >>> +             }
>> >>> +
>> >>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 1);
>> >>> +             msleep(10);
>> >>> +             ret = clk_enable(sdp4430_cam1_aux_clk); /* Enable XCLK */
>> >>> +             if (ret) {
>> >>> +                     dev_err(dev,
>> >>> +                             "Error in clk_enable() in %s(%d)\n",
>> >>> +                             __func__, on);
>> >>> +                     gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
>> >>> +                     return ret;
>> >>> +             }
>> >>> +             msleep(10);
>> >>> +     } else {
>> >>> +             clk_disable(sdp4430_cam1_aux_clk);
>> >>> +             msleep(1);
>> >>> +             gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
>> >>> +             if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
>> >>> +                     ret = regulator_disable(sdp4430_cam2pwr_reg);
>> >>> +                     if (ret) {
>> >>> +                             dev_err(dev,
>> >>> +                                     "Error in disabling sensor power regulator 'cam2pwr'\n");
>> >>> +                             return ret;
>> >>> +                     }
>> >>> +             }
>> >>> +     }
>> >>> +
>> >>> +     return 0;
>> >>> +}
>> >>
>> >> Isn't this something that should be part of the sensor driver? There's
>> >> nothing in the above code that would be board specific, except the names of
>> >> the clocks, regulators and GPIOs. The sensor driver could hold the names
>> >> instead; this would be also compatible with the device tree.
>> >
>> > Agreed. I see what you mean...
>> >
>> > I'll take care of that.
>>
>> Can you please check out these patches?
>>
>> 1. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/cb6c10d58053180364461e6bc8d30d1ec87e6e22
>
> Ideally we should really get rid of the board code callbacks. What do you
> need to do there?

Well, in a OMAP44xx Blaze:

http://svtronics.com/products/27-blaze-mdp

The CSI2-A interface has 2 possible sensor inputs:

- Sony IMX060 12 MP
- OmniVision OV5650 5MP

Which are muxed with a High speed differential selector.

(Analog devices part: ADG936, found here:
http://www.analog.com/static/imported-files/data_sheets/ADG936_936R.pdf)

And to make it more fun, you switch that with a GPIO in an Audio IC (TWL6040) !

Quite a mess, but leaves me with few options, so that's why I need
that to be board
specific, and that by providing these function that can be used to
take care of such
"creative" designs :P

Have better ideas?

>
>> 2. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/6732e0db25c6647b34ef8f01c244a49a1fd6b45d
>
> Isn't reset voltage level (high or low) a property of the sensor rather than
> the board?
>
> Well, I know sometimes the people who typically design the hardware can be
> quite inventive. ;)

Unfortunately, that's exactly the case!

Again, in this "creative" design in Blaze platform I mentioned above,
they also have a
level inverter just before the RESET pin in the sensor. So that makes
it active high, from
the GPIO driver point of view :/

Not sure if there's a better way of handling this...

Thanks for the comments!

Regards,
Sergio

>
>> 3. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/d61c4e3142dc9cae972f9128fe73d986838c0ca1
>
>> 4. http://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/e83f36001c7f7cbe184ad094d9b0c95c39e5028f
>
> Cheers,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
