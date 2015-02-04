Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50244 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbbBDUze (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 15:55:34 -0500
MIME-Version: 1.0
In-Reply-To: <2517945.eGhlRo2yDj@avalon>
References: <1421365163-29394-1-git-send-email-prabhakar.csengg@gmail.com> <2517945.eGhlRo2yDj@avalon>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 4 Feb 2015 20:55:02 +0000
Message-ID: <CA+V-a8uTzo3DL+rCGK2wPHtwqQTDxfzNOBXB+RVszJnThSBMqQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: add support for omnivision's ov2659 sensor
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Grant Likely <grant.likely@linaro.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Wed, Feb 4, 2015 at 5:03 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch. Here's a partial review.
>
> On Thursday 15 January 2015 23:39:23 Lad, Prabhakar wrote:
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> this patch adds support for omnivision's ov2659
>> sensor.
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  .../devicetree/bindings/media/i2c/ov2659.txt       |   33 +
>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>  MAINTAINERS                                        |   10 +
>>  drivers/media/i2c/Kconfig                          |   11 +
>>  drivers/media/i2c/Makefile                         |    1 +
>>  drivers/media/i2c/ov2659.c                         | 1623 +++++++++++++++++
>>  include/media/ov2659.h                             |   33 +
>>  7 files changed, 1712 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
>>  create mode 100644 drivers/media/i2c/ov2659.c
>>  create mode 100644 include/media/ov2659.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2659.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov2659.txt new file mode
>> 100644
>> index 0000000..fc49f44
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2659.txt
>> @@ -0,0 +1,33 @@
>> +* OV2659 1/5-Inch 2Mp SOC Camera
>> +
>> +The OV2659 is a 1/5-inch SOC camera, with an active array size of 1632H x
>> 1212V.
>> +It is programmable through a SCCB.
>> +
>> +Required Properties:
>> +- compatible: Must be "ovt,ov2659"
>> +
>> +- reg: I2C slave address
>> +
>> +- clock-frequency: Input clock frequency.
>> +
>> +For further reading on port node refer to
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +     i2c0@1c22000 {
>> +             ...
>> +             ...
>> +              ov2659@30 {
>> +                     compatible = "ovt,ov2659";
>> +                     reg = <0x30>;
>> +
>> +                     port {
>> +                             ov2659_0: endpoint {
>> +                                     clock-frequency = <12000000>;
>> +                                     remote-endpoint = <&vpfe_ep>;
>> +                             };
>> +                     };
>> +             };
>> +             ...
>> +     };
>
> [snip]
>
>> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
>> new file mode 100644
>> index 0000000..ce8ec8d
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov2659.c
>> @@ -0,0 +1,1623 @@
>
> [snip]
>
>> +static int debug;
>> +module_param(debug, int, 0644);
>> +MODULE_PARM_DESC(debug, "Debug level (0-2)");
>
> The debug parameter is printed in the probe function and then unused. You can
> remove it.
>
OK will drop it.

> [snip]
>
>> +struct ov2659 {
>> +     struct v4l2_subdev sd;
>> +     struct media_pad pad;
>> +     enum v4l2_mbus_type bus_type;
>> +     const struct ov2659_platform_data *pdata;
>> +
>> +     /* Protects the struct fields below */
>> +     struct mutex lock;
>> +
>> +     struct i2c_client *client;
>> +
>> +     unsigned short id;
>
> The id field is only used at probe time, you can make it a local variable.
>
OK will make local.

>> +     const struct ov2659_framesize *frame_size;
>> +     /* Current Output format Register Value (REG_FORMAT_CTRL00) */
>> +     struct sensor_register *format_ctrl_regs;
>> +
>> +     struct v4l2_mbus_framefmt format;
>> +
>> +     /* Sensor specific feq/pll config */
>> +     struct ov2659_pll_ctrl pll;
>> +
>> +     int streaming;
>> +     int power;
>> +};
>
> [snip]
>
>> +static const struct ov2659_framesize ov2659_framesizes[] = {
>> +     { /* QVGA */
>> +             .width          = 320,
>> +             .height         = 240,
>> +             .regs           = ov2659_qvga,
>> +             .max_exp_lines  = 248,
>> +     }, { /* VGA */
>> +             .width          = 640,
>> +             .height         = 480,
>> +             .regs           = ov2659_vga,
>> +             .max_exp_lines  = 498,
>> +     }, { /* SVGA */
>> +             .width          = 800,
>> +             .height         = 600,
>> +             .regs           = ov2659_svga,
>> +             .max_exp_lines  = 498,
>> +     }, { /* XGA */
>> +             .width          = 1024,
>> +             .height         = 768,
>> +             .regs           = ov2659_xga,
>> +             .max_exp_lines  = 498,
>> +     }, { /* 720P */
>> +             .width          = 1280,
>> +             .height         = 720,
>> +             .regs           = ov2659_720p,
>> +             .max_exp_lines  = 498,
>> +     }, { /* SXGA */
>> +             .width          = 1280,
>> +             .height         = 1024,
>> +             .regs           = ov2659_sxga,
>> +             .max_exp_lines  = 1048,
>> +     }, { /* UXGA */
>> +             .width          = 1600,
>> +             .height         = 1200,
>> +             .regs           = ov2659_uxga,
>> +             .max_exp_lines  = 498,
>> +     },
>> +};
>
> That's what bothers me the most about drivers for Omnivision sensors. For some
> reason (I'd bet on lack of proper documentation) they list a couple of
> supported resolutions with corresponding register values, instead of computing
> the register values from the format configured by userspace. That's not the
> way we want to go. Prabhakar, do you have enough documentation to fix that ?
>
I am afraid I have limited documentation here.

> [snip]
>
>> +/* sensor register write */
>> +static int ov2659_write(struct i2c_client *client, u16 reg, u8 val)
>> +{
>> +     struct i2c_msg msg[1];
>> +     int ret, i;
>> +     u8 buf[3];
>> +
>> +     buf[0] = reg >> 8;
>> +     buf[1] = reg & 0xFF;
>> +     buf[2] = val;
>> +
>> +     msg->addr = client->addr;
>> +     msg->flags = client->flags;
>> +     msg->buf = buf;
>> +     msg->len = sizeof(buf);
>> +
>> +     for (i = 0; i < 5; i++) {
>
> Is the loop really needed, or just copied from a different driver ?
>
not really, just incase if transfer fails retrys.

>> +             ret = i2c_transfer(client->adapter, msg, 1);
>> +             if (ret >= 0)
>> +                     return 0;
>> +
>> +             dev_dbg(&client->dev,
>> +                     "ov2659 write reg(0x%x val:0x%x) failed !\n", reg, val);
>> +             udelay(10);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +/* sensor register read */
>> +static int ov2659_read(struct i2c_client *client, u16 reg, u8 *val)
>> +{
>> +     struct i2c_msg msg[2];
>> +     int ret, i;
>> +     u8 buf[2];
>> +
>> +     buf[0] = reg >> 8;
>> +     buf[1] = reg & 0xFF;
>> +
>> +     msg[0].addr = client->addr;
>> +     msg[0].flags = client->flags;
>> +     msg[0].buf = buf;
>> +     msg[0].len = sizeof(buf);
>> +
>> +     msg[1].addr = client->addr;
>> +     msg[1].flags = client->flags|I2C_M_RD;
>
> checkpatch.pl should have warned about this. Could you please fix checkpatch
> errors and warnings ?
>
strange this was checkpatched, anyway will fix it.

>> +     msg[1].buf = buf;
>> +     msg[1].len = 1;
>> +
>> +     for (i = 0; i < 5; i++) {
>> +             ret = i2c_transfer(client->adapter, msg, 2);
>> +             if (ret >= 0) {
>> +                     *val = buf[0];
>> +                     return 0;
>> +             }
>> +
>> +             dev_dbg(&client->dev,
>> +                     "ov2659 read reg(0x%x val:0x%x) failed !\n", reg, *val);
>> +             udelay(10);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static int ov2659_write_array(struct i2c_client *client,
>> +                           const struct sensor_register *regs)
>> +{
>> +     int i, ret = 0;
>> +
>> +     for (i = 0; ret == 0 && regs[i].addr; i++) {
>> +             ret = ov2659_write(client, regs[i].addr, regs[i].value);
>> +             usleep_range(5000, 6000);
>
> That will result in a large delay when the array grows. Is it really needed ?
> Waiting might be needed after writing some of the registers, but most probably
> not most of them.
>
Ok will verify it.


>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static int dump_reg(struct i2c_client *client, u16 reg)
>> +{
>> +     u8 val = 0;
>> +     int ret;
>> +
>> +     ret = ov2659_read(client, reg, &val);
>> +     dev_dbg(&client->dev, "%s: 0x%04x: 0x%02x\n",
>> +                             __func__, reg, val);
>> +     return ret;
>> +}
>> +
>> +static void ov2659_reg_dump(struct i2c_client *client)
>> +{
>> +     int i;
>> +
>> +     dump_reg(client, REG_SOFTWARE_STANDBY);
>> +     dump_reg(client, REG_SOFTWARE_RESET);
>> +
>> +     for (i = 0x3000; i <= 0x302f; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x3400; i <= 0x3406; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x3500; i <= 0x3513; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x3600; i <= 0x3640; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x3800; i <= 0x3821; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x3a00; i <= 0x3a26; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x4000; i <= 0x4009; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x4201; i <= 0x4202; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x4300; i <= 0x4301; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x4600; i <= 0x4609; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x4700; i <= 0x4709; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x5000; i <= 0x50a0; i++)
>> +             dump_reg(client, i);
>> +
>> +     for (i = 0x5600; i <= 0x5606; i++)
>> +             dump_reg(client, i);
>
> That's pretty rough. I'm not sure such a detailed level of debugging is
> needed. You should at least return at the beginning of the function if DEBUG
> isn't defined, to avoid reading all registers without printing their value.
>
OK will fix it.

>> +}
>
> [snip]
>
>> +static void __ov2659_set_power(struct ov2659 *ov2659, int on)
>> +{
>> +     struct i2c_client *client = ov2659->client;
>> +
>> +     on = !!on;
>> +
>> +     dev_dbg(&client->dev, "%s: on: %d\n", __func__, on);
>> +
>> +     if (ov2659->power == on)
>> +             return;
>> +
>> +     ov2659->power = on;
>
> This seems to be a no-op. I would either remove this function, or, better, add
> regulators support to the driver.
>
Will drop it.

>> +}
>> +
>> +static int ov2659_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +     struct ov2659 *ov2659 = to_ov2659(sd);
>> +     struct i2c_client *client = ov2659->client;
>> +
>> +     dev_dbg(&client->dev, "%s: on: %d\n", __func__, on);
>> +
>> +     mutex_lock(&ov2659->lock);
>> +     __ov2659_set_power(ov2659, on);
>> +     mutex_unlock(&ov2659->lock);
>> +
>> +     return 0;
>> +}
>
> [snip]
>
>> +static int ov2659_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +     struct ov2659 *ov2659 = to_ov2659(sd);
>> +     int ret;
>> +
>> +     on = !!on;
>> +
>> +     dev_dbg(&client->dev, "%s: on: %d\n", __func__, on);
>> +
>> +     if (ov2659->streaming == on)
>> +             return 0;
>> +
>> +     mutex_lock(&ov2659->lock);
>
> Shouldn't you protect the above check as well ?
>
Yes, will fix it.

>> +
>> +     if (!on) {
>> +             /* Stop Streaming Sequence */
>> +             ov2659_set_streaming(ov2659, 0);
>> +             ov2659->streaming = on;
>> +             __ov2659_set_power(ov2659, 0);
>> +             mutex_unlock(&ov2659->lock);
>> +
>> +             return 0;
>> +     }
>> +
>> +     /* Start Streaming Sequence */
>> +     __ov2659_set_power(ov2659, 1);
>> +
>> +     ret = ov2659_write_array(client, ov2659_init_regs);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ov2659_set_pixel_clock(ov2659);
>> +     ov2659_set_frame_size(ov2659);
>> +     ov2659_set_format(ov2659);
>> +
>> +     ov2659_set_streaming(ov2659, 1);
>> +
>> +     ov2659_reg_dump(client);
>> +     ov2659->streaming = on;
>> +     mutex_unlock(&ov2659->lock);
>> +
>> +     return 0;
>> +}
>
> [snip]
>
>> +static int ov2659_detect_sensor(struct v4l2_subdev *sd)
>> +{
>> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +     struct ov2659 *ov2659 = to_ov2659(sd);
>> +     u8 pid, ver;
>> +     int ret;
>> +
>> +     dev_dbg(&client->dev, "%s:\n", __func__);
>> +
>> +     mutex_lock(&ov2659->lock);
>
> As sensor detection is only performed from the probe function before
> registering the subdev I don't think locking is needed here.
>
OK will drop it.

>> +      __ov2659_set_power(ov2659, 1);
>> +     usleep_range(25000, 26000);
>> +
>> +     /* soft reset */
>> +     ret = ov2659_write(client, REG_SOFTWARE_RESET, 0x01);
>> +     if (ret != 0) {
>> +             dev_err(&client->dev, "Sensor soft reset failed\n");
>> +             ret = -ENODEV;
>
> ret is then ignored.
>
will return ret.

>> +     }
>> +     mdelay(5);
>
> Don't delay, please sleep.
>
OK

>> +
>> +     /* Check sensor revision */
>> +     ret = ov2659_read(client, REG_SC_CHIP_ID_H, &pid);
>> +     if (!ret)
>> +             ret = ov2659_read(client, REG_SC_CHIP_ID_L, &ver);
>> +
>> +     __ov2659_set_power(ov2659, 0);
>> +
>> +     if (!ret) {
>> +             ov2659->id = OV265X_ID(pid, ver);
>> +             if (ov2659->id != OV2659_ID) {
>> +                     dev_err(&client->dev,
>> +                             "Sensor detection failed (%04X, %d)\n",
>> +                             ov2659->id, ret);
>> +                     ret = -ENODEV;
>> +             } else {
>> +                     dev_info(&client->dev, "Found OV%04X sensor\n",
>> +                             ov2659->id);
>> +             }
>> +     }
>> +     mutex_unlock(&ov2659->lock);
>> +
>> +     return ret;
>> +}
>> +
>> +static struct ov2659_platform_data *
>> +ov2659_get_pdata(struct i2c_client *client)
>> +{
>> +     struct ov2659_platform_data *pdata;
>> +     struct device_node *endpoint;
>> +     int ret;
>> +
>> +     dev_dbg(&client->dev, "ov2659_get_pdata invoked\n");
>> +
>> +     if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
>> +             return client->dev.platform_data;
>> +
>> +     dev_dbg(&client->dev, "ov2659_get_pdata: DT Node found\n");
>> +
>> +     endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
>> +     if (!endpoint)
>> +             return NULL;
>> +
>> +     dev_dbg(&client->dev, "ov2659_get_pdata: endpoint found\n");
>> +
>> +     pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata)
>> +             goto done;
>> +
>> +     ret = of_property_read_u32(endpoint, "clock-frequency",
>> +                                &pdata->mclk_frequency);
>> +     if (ret < 0) {
>> +             pdata->mclk_frequency = OV2659_DEFAULT_MCLK_FREQ;
>> +             dev_info(&client->dev, "using default %u Hz clock frequency\n",
>> +                      pdata->mclk_frequency);
>> +     }
>
> The clock-frequency property is defined as mandatory, a default case is thus
> not needed.
>
OK will drop it.

> I would add CCF support to the driver and request the input clock (which is
> called xvclk and not mclk) at probe time. You could then set the clock
> frequency to the value specified in DT, and read it back to get the exact
> frequency provided by the clock source.
>
Ok will add CCF.

Regards,
--Prabhakar Lad
