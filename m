Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZCIU6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 16:58:31 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Mon, 9 Mar 2009 15:58:14 -0500
Subject: RE: [PATCH 3/5] OV3640: Add driver
Message-ID: <A24693684029E5489D1D202277BE89442E40F7EF@dlee02.ent.ti.com>
In-Reply-To: <1236212613.8608.19.camel@tux.localhost>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]

<snip>

> > --- /dev/null
> > +++ b/drivers/media/video/ov3640.c
> > @@ -0,0 +1,2202 @@
> > +/*
> > + * drivers/media/video/ov3640.c
> > + *
> > + * ov3640 sensor driver
> > + *
> > + *
> > + * Copyright (C) 2008 Texas Instruments.
> 
> 2009 ?

Fixed.

<snip>

> > +static int ov3640_read_reg(struct i2c_client *client, u16 data_length,
> u16 reg,
> > +                                                               u32
> *val)
> > +{
> > +       int err = 0;
> > +       struct i2c_msg msg[1];
> > +       unsigned char data[4];
> > +
> > +       if (!client->adapter)
> > +               return -ENODEV;
> > +
> > +       msg->addr = client->addr;
> > +       msg->flags = I2C_M_WR;
> > +       msg->len = 2;
> > +       msg->buf = data;
> > +
> > +       /* High byte goes out first */
> > +       data[0] = (u8) (reg >> 8);
> > +       data[1] = (u8) (reg & 0xff);
> > +
> > +       err = i2c_transfer(client->adapter, msg, 1);
> 
> Please, let me understand.. You call i2c_transfer() and ask it to
> transfer one message(third parameter), right ?
> So, the returned value is negative errno or the number of messages
> executed. Logic says that you should check somethin like this:
> 	if (err = 1) {
> 		good;
> 	} else {
> 		i2c_transfer failed;
> 		we should deal with it(printk, try again, etc)
> 	}
> 
> Or even:
> 	if (unlikely(err != 1)) {
> 		i2c_transfer failed;
> 	}
> 	Good code continue;
> 
> Right or wrong ?

The idea of this piece of code is to:

- First do a write transfer with nothing else than the register address to read.
- Then do a I2C read transfer to receive the value from register selected in previous write with the size of data_length variable.

I do agree that perhaps a cleanup for this piece of code needs to be done... I'll clean it up, test, and repost the resulting patch for your review. :)

> 
> > +       if (err >= 0) {
> > +               mdelay(3);
> > +               msg->flags = I2C_M_RD;
> > +               msg->len = data_length;
> > +               err = i2c_transfer(client->adapter, msg, 1);
> > +       }
> > +       if (err >= 0) {
> > +               *val = 0;
> > +               /* High byte comes first */
> > +               if (data_length == 1)
> > +                       *val = data[0];
> > +               else if (data_length == 2)
> > +                       *val = data[1] + (data[0] << 8);
> > +               else
> > +                       *val = data[3] + (data[2] << 8) +
> > +                               (data[1] << 16) + (data[0] << 24);
> > +               return 0;
> > +       }
> > +       dev_err(&client->dev, "read from offset 0x%x error %d", reg,
> err);
> 
> "\n" should be in dev_err.

Done

> 
> > +       return err;
> > +}
> > +
> > +/* Write a value to a register in ov3640 sensor device.
> > + * @client: i2c driver client structure.
> > + * @reg: Address of the register to read value from.
> > + * @val: Value to be written to a specific register.
> > + * Returns zero if successful, or non-zero otherwise.
> > + */
> > +static int ov3640_write_reg(struct i2c_client *client, u16 reg, u8 val)
> > +{
> > +       int err = 0;
> > +       struct i2c_msg msg[1];
> > +       unsigned char data[3];
> > +       int retries = 0;
> > +
> > +       if (!client->adapter)
> > +               return -ENODEV;
> > +retry:
> > +       msg->addr = client->addr;
> > +       msg->flags = I2C_M_WR;
> > +       msg->len = 3;
> > +       msg->buf = data;
> > +
> > +       /* high byte goes out first */
> > +       data[0] = (u8) (reg >> 8);
> > +       data[1] = (u8) (reg & 0xff);
> > +       data[2] = val;
> > +
> > +       err = i2c_transfer(client->adapter, msg, 1);
> > +       udelay(50);
> > +
> > +       if (err >= 0)
> 
> Well, probably all checks of returned values after i2c_transfer should
> be reformatted in right way.

I'll redesign this...

> 
> 
> > +               return 0;
> > +
> > +       if (retries <= 5) {
> > +               dev_dbg(&client->dev, "Retrying I2C... %d", retries);
> 
> "\n"

Done.

<snip>

> > +       /* FIXME: QXGA framerate setting forced to 15 FPS */
> > +       if (isize == QXGA) {
> > +               err = ov3640_write_reg(client, OV3640_PLL_1, 0x32);
> > +               err = ov3640_write_reg(client, OV3640_PLL_2, 0x21);
> > +               err = ov3640_write_reg(client, OV3640_PLL_3, 0x21);
> > +               err = ov3640_write_reg(client, OV3640_CLK, 0x01);
> > +               err = ov3640_write_reg(client, 0x304c, 0x81);
> 
> I see no checking of returned values. For example, if first function
> failed, rest functions will keep going.

Agreed.. I think I'll definitely redesign this to avoid this kind of trouble.

<snip>

> > +
> > +       /* Common registers */
> > +       err = ov3640_write_regs(client, ov3640_common[isize]);
> > +
> > +       /* Configure image size and pixel format */
> > +       err = ov3640_write_regs(client, ov3640_reg_init[pfmt][isize]);
> > +
> > +       /* Setting of frame rate (OV suggested way) */
> > +       err = ov3640_set_framerate(client, &sensor->timeperframe,
> isize);
> > +#ifdef CONFIG_VIDEO_OV3640_CSI2
> > +       /* Set CSI2 common register settings */
> > +       err = ov3640_write_regs(client, ov3640_common_csi2);
> > +#endif
> 
> Again, no checking of err.

Agree, will fix..

<snip>

> > +
> > +               err = ov3640_write_reg(client, OV3640_SIZE_IN_MISC,
> > +                                                       (vsize_h |
> hsize_h));
> > +               err = ov3640_write_reg(client, OV3640_HSIZE_IN_L,
> hsize_l);
> > +               err = ov3640_write_reg(client, OV3640_VSIZE_IN_L,
> vsize_l);
> > +               err = ov3640_write_reg(client, OV3640_SIZE_OUT_MISC,
> > +                                                       (height_h |
> width_h));
> > +               err = ov3640_write_reg(client, OV3640_HSIZE_OUT_L,
> width_l);
> > +               err = ov3640_write_reg(client, OV3640_VSIZE_OUT_L,
> height_l);
> > +               err = ov3640_write_reg(client, OV3640_ISP_PAD_CTR2,
> 0x42);
> > +               err = ov3640_write_reg(client, OV3640_ISP_XOUT_H,
> width_h);
> > +               err = ov3640_write_reg(client, OV3640_ISP_XOUT_L,
> > +                                                       (width_l  -
> 0x08));
> > +               err = ov3640_write_reg(client, OV3640_ISP_YOUT_H,
> > +                                                       (height_h >>
> 4));
> > +               err = ov3640_write_reg(client, OV3640_ISP_YOUT_L,
> > +                                                       (height_l -
> 0x04));
> 
> The same thing here.

Agree, will fix..

<snip> 

> > +static int ioctl_s_ctrl(struct v4l2_int_device *s,
> > +                            struct v4l2_control *vc)
> > +{
> > +       int retval = -EINVAL;
> > +       int i;
> > +       struct ov3640_sensor *sensor = s->priv;
> > +       struct i2c_client *client = sensor->i2c_client;
> > +       struct vcontrol *lvc;
> > +
> > +       i = find_vctrl(vc->id);
> > +       if (i < 0)
> > +               return -EINVAL;
> > +
> > +       lvc = &video_control[i];
> > +
> > +       switch (vc->id) {
> > +       case V4L2_CID_BRIGHTNESS:
> > +               if (vc->value >= 0 && vc->value <= 6) {
> > +                       retval = ov3640_write_regs(client,
> > +                                                       brightness[vc-
> >value]);
> > +               } else {
> > +                       dev_err(&client->dev, "BRIGHTNESS LEVEL NOT
> SUPPORTED");
> > +                       return -EINVAL;
> > +               }
> > +               break;
> > +       case V4L2_CID_CONTRAST:
> > +               if (vc->value >= 0 && vc->value <= 6)
> > +                       retval = ov3640_write_regs(client, contrast[vc-
> >value]);
> > +               else {
> > +                       dev_err(&client->dev, "CONTRAST LEVEL NOT
> SUPPORTED");
> > +                       return -EINVAL;
> > +               }
> > +               break;
> > +       case V4L2_CID_PRIVATE_BASE:
> > +               if (vc->value >= 0 && vc->value <= 2)
> > +                       retval = ov3640_write_regs(client, colors[vc-
> >value]);
> > +               else {
> > +                       dev_err(&client->dev, "COLOR LEVEL NOT
> SUPPORTED");
> > +                       return -EINVAL;
> 
> I don't sure - may be you like big letters in logs..
> Anyway, "\n" is absent in this 3 dev_err.

Ok, removed all caps, and added "\n".

Thanks,
Sergio
