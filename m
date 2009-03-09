Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48311 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbZCIR0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 13:26:42 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Mon, 9 Mar 2009 12:26:19 -0500
Subject: RE: [PATCH 1/5] MT9P012: Add driver
Message-ID: <A24693684029E5489D1D202277BE89442E40F45C@dlee02.ent.ti.com>
In-Reply-To: <20090304113030.GT4640@scadufax.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

Sorry for the delay replying this...

Find my responses below.

> -----Original Message-----
> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> Sent: Wednesday, March 04, 2009 5:31 AM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Toivonen Tuukka.O (Nokia-D/Oulu); Doyu Hiroshi (Nokia-D/Helsinki);
> DongSoo(Nathaniel) Kim; MiaoStanley; Nagalla, Hari; Hiremath, Vaibhav;
> Lakhani, Amish; Menon, Nishanth
> Subject: Re: [PATCH 1/5] MT9P012: Add driver
>
> Hi,
>
> not looking at v4l2 part since it's not my area...
>
>
> On Tue, Mar 03, 2009 at 09:44:14PM +0100, ext Aguirre Rodriguez, Sergio
> Alberto wrote:
> > +#define SENSOR_DETECTED                1
> > +#define SENSOR_NOT_DETECTED    0
>
> these two should be unneeded...

Agreed, got rid of them...

>
> > +
> > +/**
> > + * struct mt9p012_reg - mt9p012 register format
> > + * @length: length of the register
> > + * @reg: 16-bit offset to register
> > + * @val: 8/16/32-bit register value
> > + *
> > + * Define a structure for MT9P012 register initialization values
> > + */
> > +struct mt9p012_reg {
> > +       u16     length;
> > +       u16     reg;
> > +       u32     val;
> > +};
> > +
> > +enum image_size {
> > +       BIN4XSCALE,
> > +       BIN4X,
> > +       BIN2X,
> > +       THREE_MP,
> > +       FIVE_MP
>
> you probably wanna prefix these with MT9P012_ to avoid namespace
> conflicts.

Done.

>
> > +};
> > +
> > +enum pixel_format {
> > +       RAWBAYER10
> > +};
> > +
> > +#define NUM_IMAGE_SIZES                5
> > +#define NUM_PIXEL_FORMATS      1
> > +#define NUM_FPS                        2       /* 2 ranges */
> > +#define FPS_LOW_RANGE          0
> > +#define FPS_HIGH_RANGE         1
> > +
> > +/**
> > + * struct capture_size - image capture size information
> > + * @width: image width in pixels
> > + * @height: image height in pixels
> > + */
> > +struct capture_size {
> > +       unsigned long width;
> > +       unsigned long height;
> > +};
> > +
> > +/**
> > + * struct mt9p012_pll_settings - struct for storage of sensor pll
> values
> > + * @vt_pix_clk_div: vertical pixel clock divider
> > + * @vt_sys_clk_div: veritcal system clock divider
> > + * @pre_pll_div: pre pll divider
> > + * @fine_int_tm: fine resolution interval time
> > + * @frame_lines: number of lines in frame
> > + * @line_len: number of pixels in line
> > + * @min_pll: minimum pll multiplier
> > + * @max_pll: maximum pll multiplier
> > + */
> > +struct mt9p012_pll_settings {
> > +       u16     vt_pix_clk_div;
> > +       u16     vt_sys_clk_div;
> > +       u16     pre_pll_div;
> > +
> > +       u16     fine_int_tm;
> > +       u16     frame_lines;
> > +       u16     line_len;
> > +
> > +       u16     min_pll;
> > +       u16     max_pll;
> > +};
> > +
> > +/*
> > + * Array of image sizes supported by MT9P012.  These must be ordered
> from
> > + * smallest image size to largest.
> > + */
> > +const static struct capture_size mt9p012_sizes[] = {
> > +       {  216, 162 },  /* 4X BINNING+SCALING */
> > +       {  648, 486 },  /* 4X BINNING */
> > +       { 1296, 972 },  /* 2X BINNING */
> > +       { 2048, 1536},  /* 3 MP */
> > +       { 2592, 1944},  /* 5 MP */
> > +};
> > +
> > +/* PLL settings for MT9P012 */
> > +enum mt9p012_pll_type {
> > +  PLL_5MP = 0,
> > +  PLL_3MP,
> > +  PLL_1296_15FPS,
> > +  PLL_1296_30FPS,
> > +  PLL_648_15FPS,
> > +  PLL_648_30FPS,
> > +  PLL_216_15FPS,
> > +  PLL_216_30FPS
> > +};
>
> missing tabs, fix identation.

Done.

>
> > +
> > +/* Debug functions */
> > +static int debug;
> > +module_param(debug, bool, 0644);
> > +MODULE_PARM_DESC(debug, "Debug level (0-1)");
>
> if it's a bool it's not debug level, it's debug on/off switch :-p
>
> > +static struct mt9p012_sensor mt9p012;
> > +static struct i2c_driver mt9p012sensor_i2c_driver;
>
> unneeded.

You're right. Done.

>
> > +static unsigned long xclk_current = MT9P012_XCLK_NOM_1;
>
> why ??

Hmm, well. This is the xclk default value we use.

The driver basically uses 2 XCLK values to cover all the supported framerates/framesizes.

Anyways, I've added a xclk_current field as part of struct mt9p012_sensor instead. Removed this static var.

>
> > +static int
> > +find_vctrl(int id)
>
> I guess it fits in one line...

Done. Fixed all similar cases.

>
> > +static int
> > +mt9p012_read_reg(struct i2c_client *client, u16 data_length, u16 reg,
> u32 *val)
> > +{
> > +       int err;
> > +       struct i2c_msg msg[1];
> > +       unsigned char data[4];
> > +
> > +       if (!client->adapter)
> > +               return -ENODEV;
> > +       if (data_length != MT9P012_8BIT && data_length != MT9P012_16BIT
> > +                                       && data_length != MT9P012_32BIT)
> > +               return -EINVAL;
> > +
> > +       msg->addr = client->addr;
> > +       msg->flags = 0;
> > +       msg->len = 2;
> > +       msg->buf = data;
> > +
> > +       /* high byte goes out first */
> > +       data[0] = (u8) (reg >> 8);;
> > +       data[1] = (u8) (reg & 0xff);
> > +       err = i2c_transfer(client->adapter, msg, 1);
> > +       if (err >= 0) {
> > +               msg->len = data_length;
> > +               msg->flags = I2C_M_RD;
> > +               err = i2c_transfer(client->adapter, msg, 1);
> > +       }
> > +       if (err >= 0) {
> > +               *val = 0;
> > +               /* high byte comes first */
> > +               if (data_length == MT9P012_8BIT)
> > +                       *val = data[0];
> > +               else if (data_length == MT9P012_16BIT)
> > +                       *val = data[1] + (data[0] << 8);
> > +               else
> > +                       *val = data[3] + (data[2] << 8) +
> > +                               (data[1] << 16) + (data[0] << 24);
> > +               return 0;
> > +       }
> > +       dev_err(&client->dev, "read from offset 0x%x error %d", reg,
> err);
>
> doesn't this chip support smbus ?? It would be a lot simpler if it
> does... :-s

I know, but I had a discussion about this some time back with David Brownell and Jean Delvare (on linux-i2c ML), and we found out that SMBus spec doesn't support 16-bit commands, and we dropped the intent.

This 16-bit length commands are needed because most registers are 16-bit length address.

>
> > +static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
> > +{
> > +       struct mt9p012_sensor *sensor = s->priv;
> > +       struct i2c_client *c = sensor->i2c_client;
> > +       int rval;
> > +
> > +       if ((on == V4L2_POWER_STANDBY) && (sensor->state ==
> SENSOR_DETECTED))
> > +               mt9p012_write_regs(c, stream_off_list);
> > +
> > +       if (on != V4L2_POWER_ON)
> > +               sensor->pdata->set_xclk(0);
> > +       else
> > +               sensor->pdata->set_xclk(xclk_current);
>
> I guess this should be clk_enable() and clk_disabled() calls.

I guess this will change as long as we change that on ISP driver.

I'll meanwhile keep it like this, and will do the corresponding adaptation once Sakari and I discuss about moving OMAP3 ISP XCLK setting to be handled with clk API...

>
> > +
> > +       rval = sensor->pdata->power_set(on);
> > +       if (rval < 0) {
> > +               dev_err(&c->dev, "Unable to set the power state: "
> DRIVER_NAME
> > +                                                               "
> sensor\n");
>
> dev_err() should already hold the driver name. This could be changed to:
>
> dev_err(&c->dev, "Unable to set the power state, err %d\n"), rval);
>
> > +               sensor->pdata->set_xclk(0);
> > +               return rval;
> > +       }
> > +
> > +       if ((on == V4L2_POWER_ON) && (sensor->state == SENSOR_DETECTED))
> > +               mt9p012_configure(s);
> > +
> > +       if ((on == V4L2_POWER_ON) && (sensor->state ==
> SENSOR_NOT_DETECTED)) {
> > +               rval = mt9p012_detect(c);
>
> this should be called during probe() and if it fails you bail out...
> otherwise the device will always be available, I guess...

This cannot be done, as in order to make the sensor work, we depend on omap3 camera initialization. (Depend on getting OMAP3 ISP clocks, which is done on main camera driver)

This can change as we are moving to v4l2_subdev, and thinking about the best ways to cleanup OMAP3ISP interface.

>
> > +               if (rval < 0) {
> > +                       dev_err(&c->dev, "Unable to detect " DRIVER_NAME
> > +                                                               "
> sensor\n");
> > +                       sensor->state = SENSOR_NOT_DETECTED;
> > +                       return rval;
> > +               }
> > +               sensor->state = SENSOR_DETECTED;
> > +               sensor->ver = rval;
> > +               pr_info(DRIVER_NAME " chip version 0x%02x detected\n",
> > +                                                               sensor-
> >ver);
>
> no pr_info, use dev_dbg();

Agreed. Done.

>
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ioctl_init - V4L2 sensor interface handler for VIDIOC_INT_INIT
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Initialize the sensor device (call mt9p012_configure())
> > + */
> > +static int ioctl_init(struct v4l2_int_device *s)
> > +{
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ioctl_dev_exit - V4L2 sensor interface handler for
> vidioc_int_dev_exit_num
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Delinitialise the dev. at slave detach.  The complement of
> ioctl_dev_init.
> > + */
> > +static int ioctl_dev_exit(struct v4l2_int_device *s)
> > +{
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ioctl_dev_init - V4L2 sensor interface handler for
> vidioc_int_dev_init_num
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Initialise the device when slave attaches to the master.  Returns 0
> if
> > + * mt9p012 device could be found, otherwise returns appropriate error.
> > + */
> > +static int ioctl_dev_init(struct v4l2_int_device *s)
> > +{
> > +       return 0;
> > +}
> > +/**
> > + * ioctl_enum_framesizes - V4L2 sensor if handler for
> vidioc_int_enum_framesizes
> > + * @s: pointer to standard V4L2 device structure
> > + * @frms: pointer to standard V4L2 framesizes enumeration structure
> > + *
> > + * Returns possible framesizes depending on choosen pixel format
> > + **/
> > +static int ioctl_enum_framesizes(struct v4l2_int_device *s,
> > +                                       struct v4l2_frmsizeenum *frms)
> > +{
> > +       int ifmt;
> > +
> > +       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> > +               if (frms->pixel_format ==
> mt9p012_formats[ifmt].pixelformat)
> > +                       break;
> > +       }
> > +       /* Is requested pixelformat not found on sensor? */
> > +       if (ifmt == NUM_CAPTURE_FORMATS)
> > +               return -EINVAL;
> > +
> > +       /* Do we already reached all discrete framesizes? */
> > +       if (frms->index >= 5)
> > +               return -EINVAL;
> > +
> > +       frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> > +       frms->discrete.width = mt9p012_sizes[frms->index].width;
> > +       frms->discrete.height = mt9p012_sizes[frms->index].height;
> > +
> > +       return 0;
> > +}
> > +
> > +const struct v4l2_fract mt9p012_frameintervals[] = {
> > +       {  .numerator = 1, .denominator = 11 },
> > +       {  .numerator = 1, .denominator = 15 },
> > +       {  .numerator = 1, .denominator = 20 },
> > +       {  .numerator = 1, .denominator = 25 },
> > +       {  .numerator = 1, .denominator = 30 },
> > +};
> > +
> > +static int ioctl_enum_frameintervals(struct v4l2_int_device *s,
> > +                                       struct v4l2_frmivalenum *frmi)
> > +{
> > +       int ifmt;
> > +
> > +       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> > +               if (frmi->pixel_format ==
> mt9p012_formats[ifmt].pixelformat)
> > +                       break;
> > +       }
> > +       /* Is requested pixelformat not found on sensor? */
> > +       if (ifmt == NUM_CAPTURE_FORMATS)
> > +               return -EINVAL;
> > +
> > +       /* Do we already reached all discrete framesizes? */
> > +
> > +       if (((frmi->width == mt9p012_sizes[4].width) &&
> > +                               (frmi->height ==
> mt9p012_sizes[4].height)) ||
> > +                               ((frmi->width == mt9p012_sizes[3].width)
> &&
> > +                               (frmi->height ==
> mt9p012_sizes[3].height))) {
> > +               /* FIXME: The only frameinterval supported by 5MP and
> 3MP
> > +                * capture sizes is 1/11 fps
> > +                */
> > +               if (frmi->index != 0)
> > +                       return -EINVAL;
> > +       } else {
> > +               if (frmi->index >= 5)
> > +                       return -EINVAL;
> > +       }
> > +
> > +       frmi->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> > +       frmi->discrete.numerator =
> > +                               mt9p012_frameintervals[frmi-
> >index].numerator;
> > +       frmi->discrete.denominator =
> > +                               mt9p012_frameintervals[frmi-
> >index].denominator;
> > +
> > +       return 0;
> > +}
> > +
> > +static struct v4l2_int_ioctl_desc mt9p012_ioctl_desc[] = {
> > +       { .num = vidioc_int_enum_framesizes_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_enum_framesizes },
> > +       { .num = vidioc_int_enum_frameintervals_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_enum_frameintervals },
> > +       { .num = vidioc_int_dev_init_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_dev_init },
> > +       { .num = vidioc_int_dev_exit_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_dev_exit },
> > +       { .num = vidioc_int_s_power_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_s_power },
> > +       { .num = vidioc_int_g_priv_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_g_priv },
> > +       { .num = vidioc_int_init_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_init },
> > +       { .num = vidioc_int_enum_fmt_cap_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
> > +       { .num = vidioc_int_try_fmt_cap_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
> > +       { .num = vidioc_int_g_fmt_cap_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
> > +       { .num = vidioc_int_s_fmt_cap_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
> > +       { .num = vidioc_int_g_parm_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_g_parm },
> > +       { .num = vidioc_int_s_parm_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_s_parm },
> > +       { .num = vidioc_int_queryctrl_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_queryctrl },
> > +       { .num = vidioc_int_g_ctrl_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_g_ctrl },
> > +       { .num = vidioc_int_s_ctrl_num,
> > +         .func = (v4l2_int_ioctl_func *)ioctl_s_ctrl },
> > +};
> > +
> > +static struct v4l2_int_slave mt9p012_slave = {
> > +       .ioctls = mt9p012_ioctl_desc,
> > +       .num_ioctls = ARRAY_SIZE(mt9p012_ioctl_desc),
> > +};
> > +
> > +static struct v4l2_int_device mt9p012_int_device = {
> > +       .module = THIS_MODULE,
> > +       .name = DRIVER_NAME,
> > +       .priv = &mt9p012,
> > +       .type = v4l2_int_type_slave,
> > +       .u = {
> > +               .slave = &mt9p012_slave,
> > +       },
>
> please tabify this.

Done.

>
> > +};
> > +
> > +/**
> > + * mt9p012_probe - sensor driver i2c probe handler
> > + * @client: i2c driver client device structure
> > + *
> > + * Register sensor as an i2c client device and V4L2
> > + * device.
> > + */
> > +static int
> > +mt9p012_probe(struct i2c_client *client, const struct i2c_device_id
> *id)
> > +{
> > +       struct mt9p012_sensor *sensor = &mt9p012;
>
> you should kzalloc(sensor) during probe() and be sure to kfree() in the
> error case and on remove().

Done.

>
> > +       int err;
> > +
> > +       if (i2c_get_clientdata(client))
> > +               return -EBUSY;
> > +
> > +       sensor->pdata = client->dev.platform_data;
>
> it's not a good practice to hold the complete pdata. You should have
> something like:
>
>
> struct mt9p012_platform_data *pdata = client->dev.platorm_data;
>
> if (!pdata) {
>       dev_err(&client->dev, "no pdata\n";
>       return -EINVAL
> }
>
> sensor->power_set = pdata->power_set;
> sensor->... = pdata->...

Agreed, Done.

> > +
> > +       if (!sensor->pdata) {
> > +               dev_err(&client->dev, "no platform data?\n");
> > +               return -ENODEV;
>
> why no dev ?? the device seems to exist...

Ok, should returning -EINVAL be ok? What do you think?

>
> > +       }
> > +
> > +       sensor->v4l2_int_device = &mt9p012_int_device;
> > +       sensor->i2c_client = client;
>
> You don't wanna hold client, you just need dev. From dev you can fecth
> the i2c client pointer again by:
>
> sensor->dev = &client->dev;
>
> ...
>
> client = to_i2c_client(sensor->dev);

Agreed, done.

>
> > +       i2c_set_clientdata(client, sensor);
> > +
> > +       /* Make the default capture format QCIF V4L2_PIX_FMT_SGRBG10 */
> > +       sensor->pix.width = MT9P012_VIDEO_WIDTH_4X_BINN_SCALED;
> > +       sensor->pix.height = MT9P012_VIDEO_WIDTH_4X_BINN_SCALED;
> > +       sensor->pix.pixelformat = V4L2_PIX_FMT_SGRBG10;
> > +
> > +       err = v4l2_int_device_register(sensor->v4l2_int_device);
> > +       if (err)
> > +               i2c_set_clientdata(client, NULL);
> > +
> > +       return err;
> > +}
> > +
> > +/**
> > + * mt9p012_remove - sensor driver i2c remove handler
> > + * @client: i2c driver client device structure
> > + *
> > + * Unregister sensor as an i2c client device and V4L2
> > + * device.  Complement of mt9p012_probe().
> > + */
> > +static int __exit
> > +mt9p012_remove(struct i2c_client *client)
>
> you can't do it, remove __exit from here. i2c drivers can't sit in
> __init or __exit only sections.

Done.
>
> > +{
> > +       struct mt9p012_sensor *sensor = i2c_get_clientdata(client);
> > +
> > +       if (!client->adapter)
> > +               return -ENODEV; /* our client isn't attached */
>
> this won't happen, if it does, fix your driver :-p

Agreed. Removed the check.

>
> > +
> > +       v4l2_int_device_unregister(sensor->v4l2_int_device);
> > +       i2c_set_clientdata(client, NULL);
> > +
> > +       return 0;
> > +}
> > +
> > +static const struct i2c_device_id mt9p012_id[] = {
> > +       { DRIVER_NAME, 0 },
> > +       { },
> > +};
> > +MODULE_DEVICE_TABLE(i2c, mt9p012_id);
> > +
> > +static struct i2c_driver mt9p012sensor_i2c_driver = {
> > +       .driver = {
> > +               .name = DRIVER_NAME,
> > +               .owner = THIS_MODULE,
> > +       },
> > +       .probe = mt9p012_probe,
> > +       .remove = __exit_p(mt9p012_remove),
>
> remove __exit_p()

Done.

>
> > +       .id_table = mt9p012_id,
> > +};
> > +
> > +static struct mt9p012_sensor mt9p012 = {
> > +       .timeperframe = {
> > +               .numerator = 1,
> > +               .denominator = 15,
> > +       },
> > +       .state = SENSOR_NOT_DETECTED,
> > +};
> > +
> > +/**
> > + * mt9p012sensor_init - sensor driver module_init handler
> > + *
> > + * Registers driver as an i2c client driver.  Returns 0 on success,
> > + * error code otherwise.
> > + */
> > +static int __init mt9p012sensor_init(void)
> > +{
> > +       return i2c_add_driver(&mt9p012sensor_i2c_driver);
> > +}
> > +module_init(mt9p012sensor_init);
> > +
> > +/**
> > + * mt9p012sensor_cleanup - sensor driver module_exit handler
> > + *
> > + * Unregisters/deletes driver as an i2c client driver.
> > + * Complement of mt9p012sensor_init.
> > + */
> > +static void __exit mt9p012sensor_cleanup(void)
> > +{
> > +       i2c_del_driver(&mt9p012sensor_i2c_driver);
> > +}
> > +module_exit(mt9p012sensor_cleanup);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("mt9p012 camera sensor driver");
> > diff --git a/drivers/media/video/mt9p012_regs.h
> b/drivers/media/video/mt9p012_regs.h
> > new file mode 100644
> > index 0000000..70f6ee7
> > --- /dev/null
> > +++ b/drivers/media/video/mt9p012_regs.h
> > @@ -0,0 +1,74 @@
> > +/*
> > + * drivers/media/video/mt9p012_regs.h
> > + *
> > + * Register definitions for the MT9P012 camera sensor.
> > + *
> > + * Author:
> > + *     Sameer Venkatraman <sameerv@ti.com>
> > + *     Sergio Aguirre <saaguirre@ti.com>
> > + *     Martinez Leonides
> > + *
> > + *
> > + * Copyright (C) 2008 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> License
> > + * version 2. This program is licensed "as is" without any warranty of
> any
> > + * kind, whether express or implied.
> > + */
>
> no reason to add this. It's only used in the sibbling C file, so move
> these there.

Done.

>
> > diff --git a/include/media/mt9p012.h b/include/media/mt9p012.h
> > new file mode 100644
> > index 0000000..13a9745
> > --- /dev/null
> > +++ b/include/media/mt9p012.h
> > @@ -0,0 +1,37 @@
> > +/*
> > + * drivers/media/video/mt9p012.h
>
> This path is wrong and nobody uses it anymore, it should be in form:
>
> mt9p012.h - Register definitions for the MT9P012 camera sensor

Done.

>
> > + *
> > + * Register definitions for the MT9P012 camera sensor.
> > + *
> > + * Author:
> > + *     Sameer Venkatraman <sameerv@ti.com>
> > + *     Martinez Leonides
> > + *
> > + *
> > + * Copyright (C) 2008 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> License
> > + * version 2. This program is licensed "as is" without any warranty of
> any
> > + * kind, whether express or implied.
> > + */
> > +
> > +#ifndef MT9P012_H
> > +#define MT9P012_H
> > +
> > +
> > +#define MT9P012_I2C_ADDR               0x10
> > +
> > +/**
> > + * struct mt9p012_platform_data - platform data values and access
> functions
> > + * @power_set: Power state access function, zero is off, non-zero is on.
> > + * @default_regs: Default registers written after power-on or reset.
> > + * @ifparm: Interface parameters access function
> > + * @priv_data_set: device private data (pointer) access function
> > + */
> > +struct mt9p012_platform_data {
> > +       int (*power_set)(enum v4l2_power power);
> > +       u32 (*set_xclk)(u32 xclkfreq);
>
> You shouldn't need this function, should be using clk fw.

Agree, but left it like this meanwhile, as we need to rework that on ISP driver first.

Thanks a lot for your time!
Sergio
>
> --
> balbi

