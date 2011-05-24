Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35639 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1EXI6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 04:58:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
Date: Tue, 24 May 2011 10:58:33 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <201105241039.58428.laurent.pinchart@ideasonboard.com> <BANLkTimFd2dcGooY5+FnuJ6inAmO0iBvJA@mail.gmail.com>
In-Reply-To: <BANLkTimFd2dcGooY5+FnuJ6inAmO0iBvJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241058.33683.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Tuesday 24 May 2011 10:56:22 javier Martin wrote:
> On 24 May 2011 10:39, Laurent Pinchart wrote:
> > On Tuesday 24 May 2011 10:31:46 javier Martin wrote:
> >> On 23 May 2011 11:03, Laurent Pinchart wrote:
> >> > On Saturday 21 May 2011 17:29:18 Guennadi Liakhovetski wrote:
> >> >> On Fri, 20 May 2011, Javier Martin wrote:
> >> > [snip]
> >> > 
> >> >> > diff --git a/drivers/media/video/mt9p031.c
> >> >> > b/drivers/media/video/mt9p031.c new file mode 100644
> >> >> > index 0000000..e406b64
> >> >> > --- /dev/null
> >> >> > +++ b/drivers/media/video/mt9p031.c
> >> > 
> >> > [snip]
> >> > 
> >> >> > +}
> >> >> > +
> >> >> > +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> >> >> > +{
> >> >> > +   int ret;
> >> >> > +
> >> >> > +   /* turn on VDD_IO */
> >> >> > +   ret = regulator_enable(mt9p031->reg_2v8);
> >> >> > +   if (ret) {
> >> >> > +           pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> >> >> 
> >> >> dev_err()
> >> >> 
> >> >> > +           return ret;
> >> >> > +   }
> >> >> > +   if (mt9p031->pdata->set_xclk)
> >> >> > +           mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);
> >> > 
> >> > Can you make 54000000 a #define at the beginning of the file ?
> >> > 
> >> > You should soft-reset the chip here by calling mt9p031_reset().
> >> 
> >> If I do this, I would be force to cache some registers and restart
> >> them. I've tried to do this but I don't know what is failing that
> >> there are some artifacts consisting on horizontal black lines in the
> >> image.
> > 
> > You need to cache registers anyway, as the chip will be reset to default
> > values by the core power cycling. And as I'm writing those lines I
> > realize that you don't power cycle reg_1v8. This needs to be done to
> > save power.
> > 
> >> Please, let me push this to mainline without this feature as a first
> >> step, since I'll have to spend some assigned to another project.
> > 
> > Power handling is an important feature. I don't think the driver is ready
> > without it.
> > 
> >> [snip]
> >> 
> >> >> > + */
> >> >> > +static int mt9p031_video_probe(struct i2c_client *client)
> >> >> > +{
> >> >> > +   s32 data;
> >> >> > +   int ret;
> >> >> > +
> >> >> > +   /* Read out the chip version register */
> >> >> > +   data = reg_read(client, MT9P031_CHIP_VERSION);
> >> >> > +   if (data != MT9P031_CHIP_VERSION_VALUE) {
> >> >> > +           dev_err(&client->dev,
> >> >> > +                   "No MT9P031 chip detected, register read %x\n",
> >> >> > data); +           return -ENODEV;
> >> >> > +   }
> >> >> > +
> >> >> > +   dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n",
> >> >> > data); +
> >> >> > +   ret = mt9p031_reset(client);
> >> >> > +   if (ret < 0)
> >> >> > +           dev_err(&client->dev, "Failed to initialise the
> >> >> > camera\n");
> >> > 
> >> > If you move the soft-reset operation to mt9p031_power_on(), you don't
> >> > need to call it here.
> >> 
> >> The reason for this is the same as before. I haven't still been able
> >> to success on restarting registers and getting everything to work
> >> fine.
> >> It would be great if you allowed me to push this as it is as an
> >> intermediate step.
> > 
> > Sorry, but I'd like to see power management properly implemented before
> > the driver hits mainline. Other less important features (such as
> > exposure/gain controls for instance) can be missing, but proper power
> > management is important.
> 
> OK, I'll focus on this feature from now on. However, I can't guarantee
> that I won't be removed from the project in the process. If that
> happens I will send my current patches to the community and someone
> else will have to complete the job.

I understand. I could take over but I don't have an MT9P031 hardware :-S

> >> [snip]
> >> 
> >> >> > +   mt9p031->rect.width     = MT9P031_MAX_WIDTH;
> >> >> > +   mt9p031->rect.height    = MT9P031_MAX_HEIGHT;
> >> >> > +
> >> >> > +   mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> >> >> > +
> >> >> > +   mt9p031->format.width = MT9P031_MAX_WIDTH;
> >> >> > +   mt9p031->format.height = MT9P031_MAX_HEIGHT;
> >> >> > +   mt9p031->format.field = V4L2_FIELD_NONE;
> >> >> > +   mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> >> >> > +
> >> >> > +   mt9p031->xskip = 1;
> >> >> > +   mt9p031->yskip = 1;
> >> >> > +
> >> >> > +   mt9p031->reg_1v8 = regulator_get(NULL, "cam_1v8");
> >> >> > +   if (IS_ERR(mt9p031->reg_1v8)) {
> >> >> > +           ret = PTR_ERR(mt9p031->reg_1v8);
> >> >> > +           pr_err("Failed 1.8v regulator: %d\n", ret);
> >> >> 
> >> >> dev_err()
> >> >> 
> >> >> > +           goto e1v8;
> >> >> > +   }
> >> > 
> >> > The driver can be used with boards where either or both of the 1.8V
> >> > and 2.8V supplies are always on, thus not connected to any regulator.
> >> > I'm not sure how that's usually handled, if board code should define
> >> > an "always-on" power supply, or if the driver shouldn't fail when no
> >> > regulator is present. In any case, this must be handled.
> >> 
> >> I think board code should define an "always-on" power supply.
> > 
> > Fine with me. How is that done BTW ?
> 
> You can use a fixed regulator for that purpose:
> http://lxr.linux.no/#linux+v2.6.37.2/include/linux/regulator/fixed.h

struct fixed_voltage_config is meant to be passed to drivers through platform 
data. It doesn't declare an "always-on" regulator.

-- 
Regards,

Laurent Pinchart
