Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58219 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755913AbZJ3UZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 16:25:54 -0400
Date: Fri, 30 Oct 2009 21:25:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: RE: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client
 API optional
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401557987F6@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0910302112300.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE401557987F6@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Oct 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> Thanks for your time for updating this driver. But I still don't think
> it is in a state to be re-used on TI's VPFE platform. Please see
> below for my comments.
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Friday, October 30, 2009 10:02 AM
> >To: Linux Media Mailing List
> >Cc: Hans Verkuil; Laurent Pinchart; Sakari Ailus; Karicheri, Muralidharan
> >Subject: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client API
> >optional
> >
> >Now that we have moved most of the functions over to the v4l2-subdev API,
> >only
> >quering and setting bus parameters are still performed using the legacy
> >soc-camera client API. Make the use of this API optional for mt9t031.
> >
> >Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >---
> >
> >Muralidharan, this one is for you to test. To differentiate between the
> >soc-camera case and a generic user I check i2c client's platform data
> >(client->dev.platform_data), so, you have to make sure your user doesn't
> >use that field for something else.
> >
> Currently I am using this field for bus parameters such as pclk polarity.
> If there is an API (bus parameter) to set this after probing the sensor, 
> that may work too. I will check your latest driver and let you know if
> I see an issue in migrating to this version.

No, that shall come with the bus-configuration API. I was already thinking 
about switching to passing a pointer to struct soc_camera_link or 
something similar in platform_data, because that's exactly what that 
struct is for. Of course, we would have to agree on a specific object with 
platform parameters there also for non soc-camera drivers.

> >One more note: I'm not sure about where v4l2_device_unregister_subdev()
> >should be called. In soc-camera the core calls
> >v4l2_i2c_new_subdev_board(), which then calls
> >v4l2_device_register_subdev(). Logically, it's also the core that then
> >calls v4l2_device_unregister_subdev(). Whereas I see many other client
> >drivers call v4l2_device_unregister_subdev() internally. So, if your
> >bridge driver does not call v4l2_device_unregister_subdev() itself and
> >expects the client to call it, there will be a slight problem with that
> >too.
> 
> In my bridge driver also v4l2_i2c_new_subdev_board() is called to load 
> up the sub device. When the bridge driver is removed (remove() call), it 
> calls v4l2_device_unregister() which will unregister the v4l2 device and 
> all sub devices (in turn calls v4l2_device_unregister_subdev()). But 
> most of the sub devices also calls v4l2_device_unregister_subdev() in 
> the remove() function of the module (so also the version of the mt9t031 
> that I use). So even if that call is kept in the mt9t031 sensor driver 
> (not sure if someone use it as a standalone driver), it would just 
> return since the v4l2_dev ptr in sd ptr would have been set to null as a 
> result of the bridge driver remove() call. What do you think?

...as long as sd has not been freed yet by then. But in case of mt9t031 
the subdevice is embedded in driver-instance object, which is freed, when 
the respective i2c device gets unregistered or the driver unloaded. So, 
you could call it twice here, yes.

> See also some comments below..
> 
> >
> > drivers/media/video/mt9t031.c |  146 ++++++++++++++++++++-----------------
> >----
> > 1 files changed, 70 insertions(+), 76 deletions(-)
> >
> >diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> >index c95c277..49357bd 100644
> >--- a/drivers/media/video/mt9t031.c
> >+++ b/drivers/media/video/mt9t031.c
> >@@ -204,6 +204,59 @@ static unsigned long mt9t031_query_bus_param(struct
> >soc_camera_device *icd)
> > 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
> > }
> >
> >+static const struct v4l2_queryctrl mt9t031_controls[] = {
> >+	{
> >+		.id		= V4L2_CID_VFLIP,
> >+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> >+		.name		= "Flip Vertically",
> >+		.minimum	= 0,
> >+		.maximum	= 1,
> >+		.step		= 1,
> >+		.default_value	= 0,
> >+	}, {
> >+		.id		= V4L2_CID_HFLIP,
> >+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> >+		.name		= "Flip Horizontally",
> >+		.minimum	= 0,
> >+		.maximum	= 1,
> >+		.step		= 1,
> >+		.default_value	= 0,
> >+	}, {
> >+		.id		= V4L2_CID_GAIN,
> >+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >+		.name		= "Gain",
> >+		.minimum	= 0,
> >+		.maximum	= 127,
> >+		.step		= 1,
> >+		.default_value	= 64,
> >+		.flags		= V4L2_CTRL_FLAG_SLIDER,
> >+	}, {
> >+		.id		= V4L2_CID_EXPOSURE,
> >+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >+		.name		= "Exposure",
> >+		.minimum	= 1,
> >+		.maximum	= 255,
> >+		.step		= 1,
> >+		.default_value	= 255,
> >+		.flags		= V4L2_CTRL_FLAG_SLIDER,
> >+	}, {
> >+		.id		= V4L2_CID_EXPOSURE_AUTO,
> >+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> >+		.name		= "Automatic Exposure",
> >+		.minimum	= 0,
> >+		.maximum	= 1,
> >+		.step		= 1,
> >+		.default_value	= 1,
> >+	}
> >+};
> >+
> >+static struct soc_camera_ops mt9t031_ops = {
> >+	.set_bus_param		= mt9t031_set_bus_param,
> >+	.query_bus_param	= mt9t031_query_bus_param,
> >+	.controls		= mt9t031_controls,
> >+	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> >+};
> >+
> 
> [MK] Why don't you implement queryctrl ops in core? query_bus_param
> & set_bus_param() can be implemented as a sub device operation as well
> right? I think we need to get the bus parameter RFC implemented and
> this driver could be targeted for it's first use so that we could
> work together to get it accepted. I didn't get a chance to study your 
> bus image format RFC, but plan to review it soon and to see if it can be
> used in my platform as well. For use of this driver in our platform,
> all reference to soc_ must be removed. I am ok if the structure is
> re-used, but if this driver calls any soc_camera function, it canot
> be used in my platform.

Why? Some soc-camera functions are just library functions, you just have 
to build soc-camera into your kernel. (also see below)

> BTW, I am attaching a version of the driver that we use in our kernel 
> tree for your reference which will give you an idea of my requirement.
> 

[snip]

> >@@ -565,7 +562,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
> >struct v4l2_control *ctrl)
> > {
> > 	struct i2c_client *client = sd->priv;
> > 	struct mt9t031 *mt9t031 = to_mt9t031(client);
> >-	struct soc_camera_device *icd = client->dev.platform_data;
> > 	const struct v4l2_queryctrl *qctrl;
> > 	int data;
> >
> >@@ -657,7 +653,8 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
> >struct v4l2_control *ctrl)
> >
> > 			if (set_shutter(client, total_h) < 0)
> > 				return -EIO;
> >-			qctrl = soc_camera_find_qctrl(icd->ops,
> >V4L2_CID_EXPOSURE);
> >+			qctrl = soc_camera_find_qctrl(&mt9t031_ops,
> >+						      V4L2_CID_EXPOSURE);
> 
> [MK] Why do we still need this call? In my version of the sensor driver,
> I just implement the queryctrl() operation in core_ops. This cannot work
> since soc_camera_find_qctrl() is implemented only in SoC camera.

As mentioned above, that's just a library function without any further 
dependencies, so, why reimplement it?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
