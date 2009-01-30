Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0U4PWS3013008
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 23:25:32 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0U4Or2q022450
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 23:24:53 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Curran, Dominic" <dcurran@ti.com>, linux-omap
	<linux-omap@vger.kernel.org>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 30 Jan 2009 09:54:40 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403FA79021F@dbde02.ent.ti.com>
In-Reply-To: <200901291853.38538.dcurran@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "greg.hofer@hp.com" <greg.hofer@hp.com>
Subject: RE: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046
 sensor.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Dominic Curran
> Sent: Friday, January 30, 2009 6:24 AM
> To: linux-omap; video4linux-list@redhat.com
> Cc: greg.hofer@hp.com
> Subject: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046
> sensor.
>
> From: Dominic Curran <dcurran@ti.com>
> Subject: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046
> sensor.
>
> This patch adds the driver files for the Sony IMX046 8MP camera
> sensor.
> Driver sets up the sensor to send frame data via the MIPI CSI2 i/f.
> Sensor is setup to output the following base sizes:
>  - 3280 x 2464 (8MP)
>  - 3280 x 616  (2MP)
>  - 820  x 616
> Sensor's output image format is Bayer10 (GrR/BGb).
>
> Driver has V4L2 controls for:
>  - Exposure
>  - Analog Gain
>
> Signed-off-by: Greg Hofer <greg.hofer@hp.com>
> Signed-off-by: Dominic Curran <dcurran@ti.com>
> ---
>  drivers/media/video/Kconfig  |    8
>  drivers/media/video/Makefile |    1
>  drivers/media/video/imx046.c | 1635
> +++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/imx046.h |  326 ++++++++
>  4 files changed, 1970 insertions(+)
>  create mode 100644 drivers/media/video/imx046.c
>  create mode 100644 drivers/media/video/imx046.h
>
> Index: omapzoom04/drivers/media/video/Kconfig
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/Kconfig
> +++ omapzoom04/drivers/media/video/Kconfig
> @@ -334,6 +334,14 @@ config VIDEO_OV3640_CSI2
>         This enables the use of the CSI2 serial bus for the ov3640
>         camera.
>
> +config VIDEO_IMX046
> +     tristate "Sony IMX046 sensor driver (8MP)"
> +     depends on I2C && VIDEO_V4L2
> +     ---help---
> +       This is a Video4Linux2 sensor-level driver for the Sony
> +       IMX046 camera.  It is currently working with the TI OMAP3
> +          camera controller.
> +
>  config VIDEO_SAA7110
>       tristate "Philips SAA7110 video decoder"
>       depends on VIDEO_V4L1 && I2C
> Index: omapzoom04/drivers/media/video/Makefile
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/Makefile
> +++ omapzoom04/drivers/media/video/Makefile
> @@ -115,6 +115,7 @@ obj-$(CONFIG_VIDEO_OV9640)        += ov9640.o
>  obj-$(CONFIG_VIDEO_MT9P012)  += mt9p012.o
>  obj-$(CONFIG_VIDEO_DW9710) += dw9710.o
>  obj-$(CONFIG_VIDEO_OV3640)     += ov3640.o
> +obj-$(CONFIG_VIDEO_IMX046)     += imx046.o
>
>  obj-$(CONFIG_USB_DABUSB)        += dabusb.o
>  obj-$(CONFIG_USB_OV511)         += ov511.o
> Index: omapzoom04/drivers/media/video/imx046.c
> ===================================================================
> --- /dev/null
> +++ omapzoom04/drivers/media/video/imx046.c
> @@ -0,0 +1,1635 @@
> +/*
> + * drivers/media/video/imx046.c
> + *
> + * Sony imx046 sensor driver
> + *
> + *
> + * Copyright (C) 2008 Hewlett Packard
> + *
> + * Leverage mt9p012.c
> + *
> + * This file is licensed under the terms of the GNU General Public
> License
> + * version 2. This program is licensed "as is" without any warranty
> of any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <media/v4l2-int-device.h>
> +
[Hiremath, Vaibhav] line break needed.

> +#include "imx046.h"
> +#include "omap34xxcam.h"
> +#include "isp/isp.h"
> +#include "isp/ispcsi2.h"
> +
> +
> +#define IMX046_DRIVER_NAME  "imx046"
> +#define IMX046_MOD_NAME "IMX046: "
> +
> +#define I2C_M_WR 0
> +
> +
> +/* from IMX046ES_registerSetting_I2C_MIPI_2lane_def_080925.xls */
> +const static struct imx046_reg initial_list[] = {
> +     {IMX046_REG_IMAGE_ORIENTATION, 0x03, I2C_8BIT},
> +     {IMX046_REG_COARSE_INT_TIME, 0x0120, I2C_16BIT},
> +     {IMX046_REG_ANALOG_GAIN_GLOBAL, 0x80, I2C_16BIT},
> +     {0x300A, 0x80, I2C_8BIT},
> +     {IMX046_REG_Y_OPBADDR_START_DI, 0x08, I2C_8BIT},
> +     {IMX046_REG_Y_OPBADDR_END_DI, 0x37, I2C_8BIT},
> +     {IMX046_REG_CHCODE_OUTCHSINGLE, 0x60, I2C_8BIT},
> +     {IMX046_REG_OUTIF, 0x01, I2C_8BIT},
> +     {IMX046_REG_RGPOF_RGPOFV2, 0x28, I2C_8BIT},
> +     {IMX046_REG_CPCKAUTOEN, 0x00, I2C_8BIT},
> +     {IMX046_REG_RGCPVFB, 0x60, I2C_8BIT},
> +     {IMX046_REG_RGAZPDRV, 0x24, I2C_8BIT},
> +     {IMX046_REG_RGAZTEST, 0x34, I2C_8BIT},
> +     {IMX046_REG_RGVSUNLV, 0x3B, I2C_8BIT},
> +     {IMX046_REG_CLPOWER, 0x30, I2C_8BIT},
> +     {IMX046_REG_CLPOWERSP, 0x00, I2C_8BIT},
> +     {IMX046_REG_ACLDIRV_TVADDCLP, 0x00, I2C_8BIT},
> +     {IMX046_REG_OPB_CTRL, 0x0080, I2C_16BIT},
> +     {0x30AB, 0x1C, I2C_8BIT},
> +     {0x30B0, 0x32, I2C_8BIT},
> +     {0x30B2, 0x83, I2C_8BIT},
> +     {IMX046_REG_RAW10CH2V2P_LO, 0xD8, I2C_8BIT},
> +     {IMX046_REG_RAW10CH2V2D_LO, 0x17, I2C_8BIT},
> +     {IMX046_REG_COMP8CH1V2P_LO, 0xCF, I2C_8BIT},
> +     {IMX046_REG_COMP8CH1V2D_LO, 0xF1, I2C_8BIT},
> +     {IMX046_REG_RAW10CH1V2P_LO, 0xD8, I2C_8BIT},
> +     {IMX046_REG_RAW10CH1V2D_LO, 0x17, I2C_8BIT},
> +     {0x3302, 0x0A, I2C_8BIT},
> +     {0x3303, 0x09, I2C_8BIT},
> +     {IMX046_REG_RGTLPX, 0x05, I2C_8BIT},
> +     {IMX046_REG_RGTCLKPREPARE, 0x04, I2C_8BIT},
> +     {IMX046_REG_RGTCLKZERO, 0x15, I2C_8BIT},
> +     {IMX046_REG_RGTCLKPRE, 0x03, I2C_8BIT},
> +     {IMX046_REG_RGTCLKPOST, 0x13, I2C_8BIT},
> +     {IMX046_REG_RGTCLKTRAIL, 0x05, I2C_8BIT},
> +     {IMX046_REG_RGTHSEXIT, 0x0B, I2C_8BIT},
> +     {0x302B, 0x38, I2C_8BIT},  /* for 18Mhz xclk */
> +     {I2C_REG_TERM, I2C_VAL_TERM, I2C_LEN_TERM}
> +};
> +
> +/**
> + * struct imx046_sensor - main structure for storage of sensor
> information
> + * @pdata: access functions and data for platform level information
> + * @v4l2_int_device: V4L2 device structure structure
> + * @i2c_client: iic client device structure
> + * @pix: V4L2 pixel format information structure
> + * @timeperframe: time per frame expressed as V4L fraction
> + * @scaler:
> + * @ver: imx046 chip version
> + * @fps: frames per second value
> + */
> +struct imx046_sensor {
> +     const struct imx046_platform_data *pdata;
> +     struct v4l2_int_device *v4l2_int_device;
> +     struct i2c_client *i2c_client;
> +     struct v4l2_pix_format pix;
> +     struct v4l2_fract timeperframe;
> +     int scaler;
> +     int ver;
> +     int fps;
> +     int state;
> +     bool resuming;
> +};
> +
> +static struct imx046_sensor imx046;
> +static struct i2c_driver imx046sensor_i2c_driver;
> +static unsigned long xclk_current = IMX046_XCLK_NOM_1;
> +static enum imx046_image_size isize_current = EIGHT_MP;
> +
> +/* list of image formats supported by imx046 sensor */
> +const static struct v4l2_fmtdesc imx046_formats[] = {
> +     {
> +             .description    = "Bayer10 (GrR/BGb)",
> +             .pixelformat    = V4L2_PIX_FMT_SGRBG10,
> +     }
> +};
> +
> +#define NUM_CAPTURE_FORMATS ARRAY_SIZE(imx046_formats)
> +
> +static u32 min_exposure_time = 1000;
> +static u32 max_exposure_time = 128000;
> +static enum v4l2_power current_power_state;
> +
> +/* Structure of Sensor settings that change with image size */
> +static struct imx046_sensor_settings sensor_settings[] = {
> +      /* NOTE: must be in same order as image_size array */
> +
> +     /* HALF_MP */
> +     {
> +             .clk = {
> +                     .pre_pll_div = 1,
> +                     .pll_mult = 18,
> +                     .post_pll_div = 1,
> +                     .vt_pix_clk_div = 10,
> +                     .vt_sys_clk_div = 1,
> +             },
> +             .mipi = {
> +                     .data_lanes = 1,
> +                     .ths_prepare = 2,
> +                     .ths_zero = 5,
> +                     .ths_settle_lower = 8,
> +                     .ths_settle_upper = 28,
> +             },
> +             .frame = {
> +                     .frame_len_lines_min = 629,
> +                     .line_len_pck = 3440,
> +                     .x_addr_start = 0,
> +                     .x_addr_end = 3279,
> +                     .y_addr_start = 0,
> +                     .y_addr_end = 2463,
> +                     .x_output_size = 820,
> +                     .y_output_size = 616,
> +                     .x_even_inc = 5,
> +                     .x_odd_inc = 3,
> +                     .y_even_inc = 5,
> +                     .y_odd_inc = 3,
> +                     .v_mode_add = 0,
> +                     .h_mode_add = 0,
> +                     .h_add_ave = 1,
> +             },
> +     },
> +
> +     /* TWO_MP */
> +     {
> +             .clk = {
> +                     .pre_pll_div = 1,
> +                     .pll_mult = 18,
> +                     .post_pll_div = 1,
> +                     .vt_pix_clk_div = 10,
> +                     .vt_sys_clk_div = 1,
> +             },
> +             .mipi = {
> +                     .data_lanes = 2,
> +                     .ths_prepare = 4,
> +                     .ths_zero = 5,
> +                     .ths_settle_lower = 13,
> +                     .ths_settle_upper = 33,
> +             },
> +             .frame = {
> +                     .frame_len_lines_min = 629,
> +                     .line_len_pck = 3440,
> +                     .x_addr_start = 0,
> +                     .x_addr_end = 3279,
> +                     .y_addr_start = 0,
> +                     .y_addr_end = 2463,
> +                     .x_output_size = 3280,
> +                     .y_output_size = 618,
> +                     .x_even_inc = 1,
> +                     .x_odd_inc = 1,
> +                     .y_even_inc = 5,
> +                     .y_odd_inc = 3,
> +                     .v_mode_add = 0,
> +                     .h_mode_add = 0,
> +                     .h_add_ave = 0,
> +             },
> +     },
> +
> +     /* EIGHT_MP */
> +     {
> +             .clk = {
> +                     .pre_pll_div = 1,
> +                     .pll_mult = 18,
> +                     .post_pll_div = 1,
> +                     .vt_pix_clk_div = 10,
> +                     .vt_sys_clk_div = 1,
> +             },
> +             .mipi = {
> +                     .data_lanes = 2,
> +                     .ths_prepare = 4,
> +                     .ths_zero = 5,
> +                     .ths_settle_lower = 13,
> +                     .ths_settle_upper = 33,
> +             },
> +             .frame = {
> +                     .frame_len_lines_min = 2510,
> +                     .line_len_pck = 3440,
> +                     .x_addr_start = 0,
> +                     .x_addr_end = 3279,
> +                     .y_addr_start = 0,
> +                     .y_addr_end = 2463,
> +                     .x_output_size = 3280,
> +                     .y_output_size = 2464,
> +                     .x_even_inc = 1,
> +                     .x_odd_inc = 1,
> +                     .y_even_inc = 1,
> +                     .y_odd_inc = 1,
> +                     .v_mode_add = 0,
> +                     .h_mode_add = 0,
> +                     .h_add_ave = 0,
> +             },
> +     },
> +};
> +
> +static struct imx046_clock_freq current_clk;
> +
> +struct i2c_list {
> +     struct i2c_msg *reg_list;
> +     unsigned int list_size;
> +};
> +
> +/**
> + * struct vcontrol - Video controls
> + * @v4l2_queryctrl: V4L2 VIDIOC_QUERYCTRL ioctl structure
> + * @current_value: current value of this control
> + */
> +static struct vcontrol {
> +     struct v4l2_queryctrl qc;
> +     int current_value;
> +} imx046sensor_video_control[] = {
> +     {
> +             {
> +                     .id = V4L2_CID_EXPOSURE,
> +                     .type = V4L2_CTRL_TYPE_INTEGER,
> +                     .name = "Exposure",
> +                     .minimum = IMX046_MIN_EXPOSURE,
> +                     .maximum = IMX046_MAX_EXPOSURE,
> +                     .step = IMX046_EXPOSURE_STEP,
> +                     .default_value = IMX046_DEF_EXPOSURE,
> +             },
> +             .current_value = IMX046_DEF_EXPOSURE,
> +     },
> +     {
> +             {
> +                     .id = V4L2_CID_GAIN,
> +                     .type = V4L2_CTRL_TYPE_INTEGER,
> +                     .name = "Analog Gain",
> +                     .minimum = IMX046_MIN_GAIN,
> +                     .maximum = IMX046_MAX_GAIN,
> +                     .step = IMX046_GAIN_STEP,
> +                     .default_value = IMX046_DEF_GAIN,
> +             },
> +             .current_value = IMX046_DEF_GAIN,
> +     }
> +};
> +
> +/**
> + * find_vctrl - Finds the requested ID in the video control
> structure array
> + * @id: ID of control to search the video control array for
> + *
> + * Returns the index of the requested ID from the control structure
> array
> + */
> +static int
> +find_vctrl(int id)
> +{
> +     int i;
> +
> +     if (id < V4L2_CID_BASE)
> +             return -EDOM;
> +
> +     for (i = (ARRAY_SIZE(imx046sensor_video_control) - 1); i >= 0;
> i--)
> +             if (imx046sensor_video_control[i].qc.id == id)
> +                     break;
> +     if (i < 0)
> +             i = -EINVAL;
> +     return i;
> +}
> +
> +/**
> + * imx046_read_reg - Read a value from a register in an imx046
> sensor device
> + * @client: i2c driver client structure
> + * @data_length: length of data to be read
> + * @reg: register address / offset
> + * @val: stores the value that gets read
> + *
> + * Read a value from a register in an imx046 sensor device.
> + * The value is returned in 'val'.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int
> +imx046_read_reg(struct i2c_client *client, u16 data_length, u16
> reg, u32 *val)
> +{
> +     int err;
> +     struct i2c_msg msg[1];
> +     unsigned char data[4];
> +
> +     if (!client->adapter)
> +             return -ENODEV;
> +     if (data_length != I2C_8BIT && data_length != I2C_16BIT
> +                     && data_length != I2C_32BIT)
> +             return -EINVAL;
> +
> +     msg->addr = client->addr;
> +     msg->flags = 0;
> +     msg->len = 2;
> +     msg->buf = data;
> +
> +     /* Write addr - high byte goes out first */
> +     data[0] = (u8) (reg >> 8);;
> +     data[1] = (u8) (reg & 0xff);
> +     err = i2c_transfer(client->adapter, msg, 1);
> +
> +     /* Read back data */
> +     if (err >= 0) {
> +             msg->len = data_length;
> +             msg->flags = I2C_M_RD;
> +             err = i2c_transfer(client->adapter, msg, 1);
> +     }
> +     if (err >= 0) {
> +             *val = 0;
> +             /* high byte comes first */
> +             if (data_length == I2C_8BIT)
> +                     *val = data[0];
> +             else if (data_length == I2C_16BIT)
> +                     *val = data[1] + (data[0] << 8);
> +             else
> +                     *val = data[3] + (data[2] << 8) +
> +                             (data[1] << 16) + (data[0] << 24);
> +             return 0;
> +     }
> +     dev_err(&client->dev, "read from offset 0x%x error %d", reg,
> err);
[Hiremath, Vaibhav] Since this lies under V4l framework I would recommend using v4l_xxx instead of dev_xxx.

> +     return err;
> +}
> +
> +/**
> + * Write a value to a register in imx046 sensor device.
> + * @client: i2c driver client structure.
> + * @reg: Address of the register to read value from.
> + * @val: Value to be written to a specific register.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int imx046_write_reg(struct i2c_client *client, u16 reg,
> +                                             u32 val, u16 data_length)
> +{
> +     int err = 0;
> +     struct i2c_msg msg[1];
> +     unsigned char data[6];
> +     int retries = 0;
> +
> +     if (!client->adapter)
> +             return -ENODEV;
> +
[Hiremath, Vaibhav] Don't we need to validate data_length here, similar to read?

> +retry:
> +     msg->addr = client->addr;
> +     msg->flags = I2C_M_WR;
> +     msg->len = data_length+2;  /* add address bytes */
> +     msg->buf = data;
> +
> +     /* high byte goes out first */
> +     data[0] = (u8) (reg >> 8);
> +     data[1] = (u8) (reg & 0xff);
> +     if (data_length == I2C_8BIT) {
> +             data[2] = val & 0xff;
> +     } else if (data_length == I2C_16BIT) {
> +             data[2] = (val >> 8) & 0xff;
> +             data[3] = val & 0xff;
> +     } else {
> +             data[2] = (val >> 24) & 0xff;
> +             data[3] = (val >> 16) & 0xff;
> +             data[4] = (val >> 8) & 0xff;
> +             data[5] = val & 0xff;
> +     }
> +
> +     if (data_length == 1)
> +             dev_dbg(&client->dev, "IMX046 Wrt:[0x%04X]=0x%02X\n",
> +                             reg, val);
> +     else if (data_length == 2)
> +             dev_dbg(&client->dev, "IMX046 Wrt:[0x%04X]=0x%04X\n",
> +                             reg, val);
> +
> +     err = i2c_transfer(client->adapter, msg, 1);
> +     udelay(50);
> +
[Hiremath, Vaibhav] Do we need delay here?

> +     if (err >= 0)
> +             return 0;
> +
> +     if (retries <= 5) {
> +             dev_dbg(&client->dev, "Retrying I2C... %d", retries);
> +             retries++;
> +             set_current_state(TASK_UNINTERRUPTIBLE);
[Hiremath, Vaibhav] Why this is uninterruptible?

> +             schedule_timeout(msecs_to_jiffies(20));
> +             goto retry;
> +     }
> +
> +     return err;
> +}
> +
> +/**
> + * Initialize a list of imx046 registers.
> + * The list of registers is terminated by the pair of values
> + * {OV3640_REG_TERM, OV3640_VAL_TERM}.
> + * @client: i2c driver client structure.
> + * @reglist[]: List of address of the registers to write data.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int imx046_write_regs(struct i2c_client *client,
> +                                     const struct imx046_reg reglist[])
> +{
> +     int err = 0;
> +     const struct imx046_reg *list = reglist;
> +
> +     while (!((list->reg == I2C_REG_TERM)
> +             && (list->val == I2C_VAL_TERM))) {
> +             err = imx046_write_reg(client, list->reg,
> +                             list->val, list->length);
> +             udelay(100);
[Hiremath, Vaibhav] Again why delay?
 We already have udelay(50) in imx046_write_reg.

> +             if (err)
> +                     return err;
> +             list++;
> +     }
> +     return 0;
> +}
> +
> +/**
> + * imx046_find_size - Find the best match for a requested image
> capture size
> + * @width: requested image width in pixels
> + * @height: requested image height in pixels
> + *
> + * Find the best match for a requested image capture size.  The
> best match
> + * is chosen as the nearest match that has the same number or fewer
> pixels
> + * as the requested size, or the smallest image size if the
> requested size
> + * has fewer pixels than the smallest image.
> + * Since the available sizes are subsampled in the vertical
> direction only,
> + * the routine will find the size with a height that is equal to or
> less
> + * than the requested height.
> + */
> +static enum imx046_image_size imx046_find_size(unsigned int width,
> +                                                     unsigned int height)
> +{
> +     enum imx046_image_size isize;
> +
> +     for (isize = HALF_MP; isize <= EIGHT_MP; isize++) {
> +             if ((imx046_sizes[isize].height >= height) &&
> +                     (imx046_sizes[isize].width >= width)) {
> +                     break;
> +             }
> +     }
> +
> +     printk(KERN_DEBUG "imx046_find_size: Req Size=%dx%d, "
> +                     "Calc Size=%dx%d\n",
> +                     width, height, (int)imx046_sizes[isize].width,
> +                     (int)imx046_sizes[isize].height);
> +
> +     return isize;
> +}
> +
> +/**
> + * Set CSI2 Virtual ID.
> + * @client: i2c client driver structure
> + * @id: Virtual channel ID.
> + *
> + * Sets the channel ID which identifies data packets sent by this
> device
> + * on the CSI2 bus.
> + **/
> +static int imx046_set_virtual_id(struct i2c_client *client, u32 id)
> +{
> +     return imx046_write_reg(client, IMX046_REG_CCP2_CHANNEL_ID,
> +                             (0x3 & id), I2C_8BIT);
> +}
> +
> +/**
> + * imx046_set_framerate - Sets framerate by adjusting
> frame_length_lines reg.
> + * @s: pointer to standard V4L2 device structure
> + * @fper: frame period numerator and denominator in seconds
> + *
> + * The maximum exposure time is also updated since it is affected
> by the
> + * frame rate.
> + **/
> +static int imx046_set_framerate(struct v4l2_int_device *s,
> +                                             struct v4l2_fract *fper)
> +{
> +     int err = 0;
> +     u16 isize = isize_current;
> +     u32 frame_length_lines, line_time_q8;
> +     struct imx046_sensor *sensor = s->priv;
> +     struct i2c_client *client = sensor->i2c_client;
> +     struct imx046_sensor_settings *ss;
> +
> +     if ((fper->numerator == 0) || (fper->denominator == 0)) {
> +             /* supply a default nominal_timeperframe */
> +             fper->numerator = 1;
> +             fper->denominator = IMX046_DEF_FPS;
> +     }
> +
> +     sensor->fps = fper->denominator / fper->numerator;
> +     if (sensor->fps < IMX046_MIN_FPS) {
> +             sensor->fps = IMX046_MIN_FPS;
> +             fper->numerator = 1;
> +             fper->denominator = sensor->fps;
> +     } else if (sensor->fps > IMX046_MAX_FPS) {
> +             sensor->fps = IMX046_MAX_FPS;
> +             fper->numerator = 1;
> +             fper->denominator = sensor->fps;
> +     }
> +
> +     ss = &sensor_settings[isize_current];
> +
> +     line_time_q8 = ((u32)ss->frame.line_len_pck * 1000000) /
> +             (current_clk.vt_pix_clk >> 8); /* usec's */
> +
> +     frame_length_lines = (((u32)fper->numerator * 1000000 * 256 /
> +             fper->denominator)) / line_time_q8;
> +
> +     /* Range check frame_length_lines */
> +     if (frame_length_lines > IMX046_MAX_FRAME_LENGTH_LINES)
> +             frame_length_lines = IMX046_MAX_FRAME_LENGTH_LINES;
> +     else if (frame_length_lines < ss->frame.frame_len_lines_min)
> +             frame_length_lines = ss->frame.frame_len_lines_min;
> +
> +     imx046_write_reg(client, IMX046_REG_FRAME_LEN_LINES,
> +                                     frame_length_lines, I2C_16BIT);
> +
> +     sensor_settings[isize].frame.frame_len_lines =
> frame_length_lines;
> +
> +     /* Update max exposure time */
> +     max_exposure_time = (line_time_q8 * (frame_length_lines - 1))
> >> 8;
> +
> +     printk(KERN_DEBUG "IMX046 Set Framerate: fper=%d/%d, "
> +             "frame_len_lines=%d, max_expT=%dus\n", fper->numerator,
> +             fper->denominator, frame_length_lines,
> max_exposure_time);
> +
> +     return err;
> +}
> +
> +/**
> + * imx046sensor_calc_xclk - Calculate the required xclk frequency
> + *
> + * Xclk is not determined from framerate for the IMX046
> + */
> +static unsigned long imx046sensor_calc_xclk(void)
> +{
> +     xclk_current = IMX046_XCLK_NOM_1;
> +
> +     return xclk_current;
> +}
> +
> +/**
> + * Sets the correct orientation based on the sensor version.
> + *   IU046F2-Z   version=2  orientation=3
> + *   IU046F4-2D  version>2  orientation=0
> + */
> +static int imx046_set_orientation(struct i2c_client *client, u32
> ver)
> +{
> +     int err;
> +     u8 orient;
> +
> +     orient = (ver <= 0x2) ? 0x3 : 0x0;
> +     err = imx046_write_reg(client, IMX046_REG_IMAGE_ORIENTATION,
> +                             orient, I2C_8BIT);
> +     return err;
> +}
> +
> +/**
> + * imx046sensor_set_exposure_time - sets exposure time per input
> value
> + * @exp_time: exposure time to be set on device (in usec)
> + * @s: pointer to standard V4L2 device structure
> + * @lvc: pointer to V4L2 exposure entry in
> imx046sensor_video_controls array
> + *
> + * If the requested exposure time is within the allowed limits, the
> HW
> + * is configured to use the new exposure time, and the
> + * imx046sensor_video_control[] array is updated with the new
> current value.
> + * The function returns 0 upon success.  Otherwise an error code is
> + * returned.
> + */
> +int imx046sensor_set_exposure_time(u32 exp_time, struct
> v4l2_int_device *s,
> +                                                     struct vcontrol *lvc)
> +{
> +     int err = 0, i;
> +     struct imx046_sensor *sensor = s->priv;
> +     struct i2c_client *client = sensor->i2c_client;
> +     u16 coarse_int_time = 0;
> +     u32 line_time_q8 = 0;
> +     struct imx046_sensor_settings *ss;
> +
> +     if ((current_power_state == V4L2_POWER_ON) || sensor-
> >resuming) {
> +             if (exp_time < min_exposure_time) {
> +                     dev_err(&client->dev, "Exposure time %d us not
> within"
> +                                     " the legal range.\n", exp_time);
> +                     dev_err(&client->dev, "Exposure time must be
> between"
> +                                     " %d us and %d us\n",
> +                                     min_exposure_time, max_exposure_time);
> +                     exp_time = min_exposure_time;
> +             }
> +
> +             if (exp_time > max_exposure_time) {
> +                     dev_err(&client->dev, "Exposure time %d us not
> within"
> +                                     " the legal range.\n", exp_time);
> +                     dev_err(&client->dev, "Exposure time must be
> between"
> +                                     " %d us and %d us\n",
> +                                     min_exposure_time, max_exposure_time);
> +                     exp_time = max_exposure_time;
> +             }
> +
> +             ss = &sensor_settings[isize_current];
> +
> +             line_time_q8 =
> +                     ((u32)ss->frame.line_len_pck * 1000000) /
> +                     (current_clk.vt_pix_clk >> 8); /* usec's */
> +
> +             coarse_int_time = ((exp_time * 256) + (line_time_q8 >>
> 1)) /
> +                              line_time_q8;
> +
> +             if (coarse_int_time > ss->frame.frame_len_lines - 2)
> +                     coarse_int_time = ss->frame.frame_len_lines - 2;
> +
> +             err = imx046_write_reg(client,
> IMX046_REG_COARSE_INT_TIME,
> +                                     coarse_int_time, I2C_16BIT);
> +     }
> +
> +     if (err) {
> +             dev_err(&client->dev, "Error setting exposure time: %d",
> err);
> +     } else {
> +             i = find_vctrl(V4L2_CID_EXPOSURE);
> +             if (i >= 0) {
> +                     lvc = &imx046sensor_video_control[i];
> +                     lvc->current_value = exp_time;
> +             }
> +     }
> +
> +     return err;
> +}
> +
> +/**
> + * imx046sensor_set_gain - sets sensor analog gain per input value
> + * @gain: analog gain value to be set on device
> + * @s: pointer to standard V4L2 device structure
> + * @lvc: pointer to V4L2 analog gain entry in
> imx046sensor_video_control array
> + *
> + * If the requested analog gain is within the allowed limits, the
> HW
> + * is configured to use the new gain value, and the
> imx046sensor_video_control
> + * array is updated with the new current value.
> + * The function returns 0 upon success.  Otherwise an error code is
> + * returned.
> + */
> +int imx046sensor_set_gain(u16 lineargain, struct v4l2_int_device
> *s,
> +                                                     struct vcontrol *lvc)
> +{
> +     int err = 0, i;
> +     u16 reg_gain = 0;
> +
> +     struct imx046_sensor *sensor = s->priv;
> +     struct i2c_client *client = sensor->i2c_client;
> +
> +     if (current_power_state == V4L2_POWER_ON || sensor->resuming)
> {
> +             if (lineargain < IMX046_MIN_GAIN) {
> +                     lineargain = IMX046_MIN_GAIN;
> +                     dev_err(&client->dev, "Gain out of legal range.");
> +             }
> +             if (lineargain > IMX046_MAX_GAIN) {
> +                     lineargain = IMX046_MAX_GAIN;
> +                     dev_err(&client->dev, "Gain out of legal range.");
> +             }
> +
> +             /*      Convert gain from linear to register value
> +                     - reg_gain = 256 - 256 / linear_gain
> +                     - do divide with rounding
> +             */
> +             reg_gain = 256 -
> +                             ((((u32)(256 << 9) + (1 << 8)) / lineargain)
> +                             >> 1);
> +             dev_dbg(&client->dev, "set_gain: lineargain=%d
> reg_gain=%d\n",
> +                             lineargain, reg_gain);
> +
> +             err = imx046_write_reg(client,
> IMX046_REG_ANALOG_GAIN_GLOBAL,
> +                                     reg_gain, I2C_16BIT);
> +     }
> +
> +     if (err) {
> +             dev_err(&client->dev, "Error setting analog gain: %d",
> err);
> +     } else {
> +             i = find_vctrl(V4L2_CID_GAIN);
> +             if (i >= 0) {
> +                     lvc = &imx046sensor_video_control[i];
> +                     lvc->current_value = lineargain;
> +             }
> +     }
> +
> +     return err;
> +}
> +
> +/**
> + * imx046_update_clocks - calcs sensor clocks based on sensor
> settings.
> + * @isize: image size enum
> + */
> +int imx046_update_clocks(u32 xclk, enum imx046_image_size isize)
> +{
> +     current_clk.vco_clk =
> +                     xclk * sensor_settings[isize].clk.pll_mult /
> +                     sensor_settings[isize].clk.pre_pll_div /
> +                     sensor_settings[isize].clk.post_pll_div;
> +
> +     current_clk.vt_pix_clk = current_clk.vco_clk * 2 /
> +                     (sensor_settings[isize].clk.vt_pix_clk_div *
> +                     sensor_settings[isize].clk.vt_sys_clk_div);
> +
> +     if (sensor_settings[isize].mipi.data_lanes == 2)
> +             current_clk.mipi_clk = current_clk.vco_clk;
> +     else
> +             current_clk.mipi_clk = current_clk.vco_clk / 2;
> +
> +     current_clk.ddr_clk = current_clk.mipi_clk / 2;
> +
> +     printk(KERN_DEBUG "IMX046: xclk=%u, vco_clk=%u, "
> +             "vt_pix_clk=%u,  mipi_clk=%u,  ddr_clk=%u\n",
> +             xclk, current_clk.vco_clk, current_clk.vt_pix_clk,
> +             current_clk.mipi_clk, current_clk.ddr_clk);
> +
> +     return 0;
> +}
> +
> +/**
> + * imx046_setup_pll - initializes sensor PLL registers.
> + * @c: i2c client driver structure
> + * @isize: image size enum
> + */
> +int imx046_setup_pll(struct i2c_client *client, enum
> imx046_image_size isize)
> +{
> +     u32 rgpltd_reg;
> +     u32 rgpltd[3] = {2, 0, 1};
> +
> +     imx046_write_reg(client, IMX046_REG_PRE_PLL_CLK_DIV,
> +             sensor_settings[isize].clk.pre_pll_div, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_PLL_MULTIPLIER,
> +             sensor_settings[isize].clk.pll_mult, I2C_16BIT);
> +
> +     imx046_read_reg(client, I2C_8BIT, IMX046_REG_RGPLTD_RGCLKEN,
> +             &rgpltd_reg);
> +     rgpltd_reg &= ~RGPLTD_MASK;
> +     rgpltd_reg |= rgpltd[sensor_settings[isize].clk.post_pll_div
> >> 1];
> +     imx046_write_reg(client, IMX046_REG_RGPLTD_RGCLKEN,
> +             rgpltd_reg, I2C_8BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_VT_PIX_CLK_DIV,
> +             sensor_settings[isize].clk.vt_pix_clk_div, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_VT_SYS_CLK_DIV,
> +             sensor_settings[isize].clk.vt_sys_clk_div, I2C_16BIT);
> +
> +     printk(KERN_DEBUG "IMX046: pre_pll_clk_div=%u, pll_mult=%u, "
> +             "rgpltd=0x%x, vt_pix_clk_div=%u, vt_sys_clk_div=%u\n",
> +             sensor_settings[isize].clk.pre_pll_div,
> +             sensor_settings[isize].clk.pll_mult, rgpltd_reg,
> +             sensor_settings[isize].clk.vt_pix_clk_div,
> +             sensor_settings[isize].clk.vt_sys_clk_div);
> +
> +     return 0;
> +}
> +
> +/**
> + * imx046_setup_mipi - initializes sensor & isp MIPI registers.
> + * @c: i2c client driver structure
> + * @isize: image size enum
> + */
> +int imx046_setup_mipi(struct imx046_sensor *sensor,
> +                     enum imx046_image_size isize)
> +{
> +     struct i2c_client *client = sensor->i2c_client;
> +
> +     /* NOTE: Make sure imx046_update_clocks is called 1st */
> +
> +     /* Enable MIPI */
> +     imx046_write_reg(client, IMX046_REG_RGOUTSEL1, 0x00,
> I2C_8BIT);
> +     imx046_write_reg(client, IMX046_REG_TESTDI, 0x04, I2C_8BIT);
> +
> +     /* Set sensor Mipi timing params */
> +     imx046_write_reg(client, IMX046_REG_RGTHSTRAIL, 0x06,
> I2C_8BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_RGTHSPREPARE,
> +             sensor_settings[isize].mipi.ths_prepare, I2C_8BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_RGTHSZERO,
> +             sensor_settings[isize].mipi.ths_zero, I2C_8BIT);
> +
> +     /* Set number of lanes in sensor */
> +     if (sensor_settings[isize].mipi.data_lanes == 2)
> +             imx046_write_reg(client, IMX046_REG_RGLANESEL, 0x00,
> I2C_8BIT);
> +     else
> +             imx046_write_reg(client, IMX046_REG_RGLANESEL, 0x01,
> I2C_8BIT);
> +
> +     /* Set number of lanes in isp */
> +     sensor->pdata-
> >csi2_lane_count(sensor_settings[isize].mipi.data_lanes);
> +
> +     /* Send settings to ISP-CSI2 Receiver PHY */
> +     sensor->pdata->csi2_calc_phy_cfg0(current_clk.mipi_clk,
> +             sensor_settings[isize].mipi.ths_settle_lower,
> +             sensor_settings[isize].mipi.ths_settle_upper);
> +
> +     /* Dump some registers for debug purposes */
> +     printk(KERN_DEBUG "imx:THSPREPARE=0x%02X\n",
> +             sensor_settings[isize].mipi.ths_prepare);
> +     printk(KERN_DEBUG "imx:THSZERO=0x%02X\n",
> +             sensor_settings[isize].mipi.ths_zero);
> +     printk(KERN_DEBUG "imx:LANESEL=0x%02X\n",
> +             (sensor_settings[isize].mipi.data_lanes == 2) ? 0 : 1);
> +
> +     return 0;
> +}
> +
> +/**
> + * imx046_configure_frame - initializes image frame registers
> + * @c: i2c client driver structure
> + * @isize: image size enum
> + */
> +int imx046_configure_frame(struct i2c_client *client,
> +                     enum imx046_image_size isize)
> +{
> +     u32 val;
> +
> +     imx046_write_reg(client, IMX046_REG_FRAME_LEN_LINES,
> +             sensor_settings[isize].frame.frame_len_lines_min,
> I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_LINE_LEN_PCK,
> +             sensor_settings[isize].frame.line_len_pck, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_X_ADDR_START,
> +             sensor_settings[isize].frame.x_addr_start, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_X_ADDR_END,
> +             sensor_settings[isize].frame.x_addr_end, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_Y_ADDR_START,
> +             sensor_settings[isize].frame.y_addr_start, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_Y_ADDR_END,
> +             sensor_settings[isize].frame.y_addr_end, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_X_OUTPUT_SIZE,
> +             sensor_settings[isize].frame.x_output_size, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_Y_OUTPUT_SIZE,
> +             sensor_settings[isize].frame.y_output_size, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_X_EVEN_INC,
> +             sensor_settings[isize].frame.x_even_inc, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_X_ODD_INC,
> +             sensor_settings[isize].frame.x_odd_inc, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_Y_EVEN_INC,
> +             sensor_settings[isize].frame.y_even_inc, I2C_16BIT);
> +
> +     imx046_write_reg(client, IMX046_REG_Y_ODD_INC,
> +             sensor_settings[isize].frame.y_odd_inc, I2C_16BIT);
> +
> +     imx046_read_reg(client, I2C_8BIT, IMX046_REG_PGACUR_VMODEADD,
> &val);
> +     val &= ~VMODEADD_MASK;
> +     val |= sensor_settings[isize].frame.v_mode_add <<
> VMODEADD_SHIFT;
> +     imx046_write_reg(client, IMX046_REG_PGACUR_VMODEADD, val,
> I2C_8BIT);
> +
> +     imx046_read_reg(client, I2C_8BIT, IMX046_REG_HMODEADD, &val);
> +     val &= ~HMODEADD_MASK;
> +     val |= sensor_settings[isize].frame.h_mode_add <<
> HMODEADD_SHIFT;
> +     imx046_write_reg(client, IMX046_REG_HMODEADD, val, I2C_8BIT);
> +
> +     imx046_read_reg(client, I2C_8BIT, IMX046_REG_HADDAVE, &val);
> +     val &= ~HADDAVE_MASK;
> +     val |= sensor_settings[isize].frame.h_add_ave <<
> HADDAVE_SHIFT;
> +     imx046_write_reg(client, IMX046_REG_HADDAVE, val, I2C_8BIT);
> +
> +     return 0;
> +}
> +
> +/**
> + * imx046_configure - Configure the imx046 for the specified image
> mode
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Configure the imx046 for a specified image size, pixel format,
> and frame
> + * period.  xclk is the frequency (in Hz) of the xclk input to the
> imx046.
> + * fper is the frame period (in seconds) expressed as a fraction.
> + * Returns zero if successful, or non-zero otherwise.
> + * The actual frame period is returned in fper.
> + */
> +static int imx046_configure(struct v4l2_int_device *s)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct v4l2_pix_format *pix = &sensor->pix;
> +     struct i2c_client *client = sensor->i2c_client;
> +     enum imx046_image_size isize;
> +     int err, i;
> +     struct vcontrol *lvc = NULL;
> +
> +     isize = imx046_find_size(pix->width, pix->height);
> +     isize_current = isize;
> +
> +     err = imx046_write_reg(client, IMX046_REG_SW_RESET, 0x01,
> I2C_8BIT);
> +     mdelay(5);
> +
> +     imx046_write_regs(client, initial_list);
> +
> +     imx046_update_clocks(xclk_current, isize);
> +     imx046_setup_pll(client, isize);
> +
> +     imx046_setup_mipi(sensor, isize);
> +
> +     /* configure image size and pixel format */
> +     imx046_configure_frame(client, isize);
> +
> +     /* Setting of frame rate */
> +     err = imx046_set_framerate(s, &sensor->timeperframe);
> +
> +     imx046_set_orientation(client, sensor->ver);
> +
> +     sensor->pdata->cfg_interface_bridge(0x00);
> +     sensor->pdata->csi2_cfg_vp_out_ctrl(2);
> +     sensor->pdata->csi2_ctrl_update(false);
> +
> +     sensor->pdata->csi2_cfg_virtual_id(0, IMX046_CSI2_VIRTUAL_ID);
> +     sensor->pdata->csi2_ctx_update(0, false);
> +     imx046_set_virtual_id(client, IMX046_CSI2_VIRTUAL_ID);
> +
> +     /* Set initial exposure and gain */
> +     i = find_vctrl(V4L2_CID_EXPOSURE);
> +     if (i >= 0) {
> +             lvc = &imx046sensor_video_control[i];
> +             imx046sensor_set_exposure_time(lvc->current_value,
> +                                     sensor->v4l2_int_device, lvc);
> +     }
> +
> +     i = find_vctrl(V4L2_CID_GAIN);
> +     if (i >= 0) {
> +             lvc = &imx046sensor_video_control[i];
> +             imx046sensor_set_gain(lvc->current_value,
> +                             sensor->v4l2_int_device, lvc);
> +     }
> +
> +     /* configure streaming ON */
> +     err = imx046_write_reg(client, IMX046_REG_MODE_SELECT, 0x01,
> I2C_8BIT);
> +     mdelay(1);
> +
> +     return err;
> +}
> +
> +/**
> + * imx046_detect - Detect if an imx046 is present, and if so which
> revision
> + * @client: pointer to the i2c client driver structure
> + *
> + * Detect if an imx046 is present, and if so which revision.
> + * A device is considered to be detected if the manufacturer ID
> (MIDH and MIDL)
> + * and the product ID (PID) registers match the expected values.
> + * Any value of the version ID (VER) register is accepted.
> + * Returns a negative error number if no device is detected, or the
> + * non-negative value of the version ID register if a device is
> detected.
> + */
> +static int
> +imx046_detect(struct i2c_client *client)
> +{
> +     u32 model_id, mfr_id, rev;
> +     struct imx046_sensor *sensor;
> +
> +     dev_dbg(&client->dev, "imx046_detect client.addr=0x%x\n",
> +                     client->addr);
> +
> +     if (!client)
> +             return -ENODEV;
> +
> +     sensor = i2c_get_clientdata(client);
> +
> +     if (imx046_read_reg(client, I2C_16BIT, IMX046_REG_MODEL_ID,
> &model_id))
> +             return -ENODEV;
> +     if (imx046_read_reg(client, I2C_8BIT, IMX046_REG_MFR_ID,
> &mfr_id))
> +             return -ENODEV;
> +     if (imx046_read_reg(client, I2C_8BIT, IMX046_REG_REV_NUMBER,
> &rev))
> +             return -ENODEV;
> +
> +     dev_info(&client->dev, "model id detected 0x%x mfr 0x%x, rev#
> 0x%x\n",
> +                                                     model_id, mfr_id, rev);
> +     if ((model_id != IMX046_MOD_ID) || (mfr_id != IMX046_MFR_ID))
> {
> +             /* We didn't read the values we expected, so
> +              * this must not be an IMX046.
> +              */
> +             dev_warn(&client->dev, "model id mismatch 0x%x mfr
> 0x%x\n",
> +                                                     model_id, mfr_id);
> +
> +             return -ENODEV;
> +     }
> +     return rev;
> +}
> +
> +/**
> + * ioctl_queryctrl - V4L2 sensor interface handler for
> VIDIOC_QUERYCTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control
> information
> + * from the imx046sensor_video_control[] array.
> + * Otherwise, returns -EINVAL if the control is not supported.
> + */
> +static int ioctl_queryctrl(struct v4l2_int_device *s,
> +                             struct v4l2_queryctrl *qc)
> +{
> +     int i;
> +
> +     i = find_vctrl(qc->id);
> +     if (i == -EINVAL)
> +             qc->flags = V4L2_CTRL_FLAG_DISABLED;
> +
> +     if (i < 0)
> +             return -EINVAL;
> +
> +     *qc = imx046sensor_video_control[i].qc;
> +     return 0;
> +}
> +
> +/**
> + * ioctl_g_ctrl - V4L2 sensor interface handler for VIDIOC_G_CTRL
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control's
> current
> + * value from the imx046sensor_video_control[] array.
> + * Otherwise, returns -EINVAL if the control is not supported.
> + */
> +static int ioctl_g_ctrl(struct v4l2_int_device *s,
> +                          struct v4l2_control *vc)
> +{
> +     struct vcontrol *lvc;
> +     int i;
> +
> +     i = find_vctrl(vc->id);
> +     if (i < 0)
> +             return -EINVAL;
> +     lvc = &imx046sensor_video_control[i];
> +
> +     switch (vc->id) {
> +     case  V4L2_CID_EXPOSURE:
> +             vc->value = lvc->current_value;
> +             break;
> +     case V4L2_CID_GAIN:
> +             vc->value = lvc->current_value;
> +             break;
> +     }
> +
> +     return 0;
> +}
> +
> +/**
> + * ioctl_s_ctrl - V4L2 sensor interface handler for VIDIOC_S_CTRL
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
> + *
> + * If the requested control is supported, sets the control's
> current
> + * value in HW (and updates the imx046sensor_video_control[]
> array).
> + * Otherwise, * returns -EINVAL if the control is not supported.
> + */
> +static int ioctl_s_ctrl(struct v4l2_int_device *s,
> +                          struct v4l2_control *vc)
> +{
> +     int retval = -EINVAL;
> +     int i;
> +     struct vcontrol *lvc;
> +
> +     i = find_vctrl(vc->id);
> +     if (i < 0)
> +             return -EINVAL;
> +     lvc = &imx046sensor_video_control[i];
> +
> +     switch (vc->id) {
> +     case V4L2_CID_EXPOSURE:
> +             retval = imx046sensor_set_exposure_time(vc->value, s,
> lvc);
> +             break;
> +     case V4L2_CID_GAIN:
> +             retval = imx046sensor_set_gain(vc->value, s, lvc);
> +             break;
> +     }
> +
> +     return retval;
> +}
> +
> +/**
> + * ioctl_enum_fmt_cap - Implement the CAPTURE buffer
> VIDIOC_ENUM_FMT ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
> + *
> + * Implement the VIDIOC_ENUM_FMT ioctl for the CAPTURE buffer type.
> + */
> +static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
> +                                struct v4l2_fmtdesc *fmt)
> +{
> +     int index = fmt->index;
> +     enum v4l2_buf_type type = fmt->type;
> +
> +     memset(fmt, 0, sizeof(*fmt));
> +     fmt->index = index;
> +     fmt->type = type;
> +
> +     switch (fmt->type) {
> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +             if (index >= NUM_CAPTURE_FORMATS)
> +                     return -EINVAL;
> +     break;
> +     default:
> +             return -EINVAL;
> +     }
> +
> +     fmt->flags = imx046_formats[index].flags;
> +     strlcpy(fmt->description, imx046_formats[index].description,
> +                                     sizeof(fmt->description));
> +     fmt->pixelformat = imx046_formats[index].pixelformat;
> +
> +     return 0;
> +}
> +
> +/**
> + * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
> + *
> + * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type.
> This
> + * ioctl is used to negotiate the image capture size and pixel
> format
> + * without actually making it take effect.
> + */
> +static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
> +                          struct v4l2_format *f)
> +{
> +     enum imx046_image_size isize;
> +     int ifmt;
> +     struct v4l2_pix_format *pix = &f->fmt.pix;
> +     struct imx046_sensor *sensor = s->priv;
> +     struct v4l2_pix_format *pix2 = &sensor->pix;
> +
> +     isize = imx046_find_size(pix->width, pix->height);
> +
> +     pix->width = imx046_sizes[isize].width;
> +     pix->height = imx046_sizes[isize].height;
> +     for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +             if (pix->pixelformat ==
> imx046_formats[ifmt].pixelformat)
> +                     break;
> +     }
> +     if (ifmt == NUM_CAPTURE_FORMATS)
> +             ifmt = 0;
> +     pix->pixelformat = imx046_formats[ifmt].pixelformat;
> +     pix->field = V4L2_FIELD_NONE;
> +     pix->bytesperline = pix->width * 2;
> +     pix->sizeimage = pix->bytesperline * pix->height;
> +     pix->priv = 0;
> +     pix->colorspace = V4L2_COLORSPACE_SRGB;
> +     *pix2 = *pix;
> +     return 0;
> +}
> +
> +/**
> + * ioctl_s_fmt_cap - V4L2 sensor interface handler for VIDIOC_S_FMT
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
> + *
> + * If the requested format is supported, configures the HW to use
> that
> + * format, returns error code if format not supported or HW can't
> be
> + * correctly configured.
> + */
> +static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
> +                             struct v4l2_format *f)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct v4l2_pix_format *pix = &f->fmt.pix;
> +     int rval;
> +
> +     rval = ioctl_try_fmt_cap(s, f);
> +     if (rval)
> +             return rval;
> +     else
> +             sensor->pix = *pix;
> +
> +
> +     return rval;
> +}
> +
> +/**
> + * ioctl_g_fmt_cap - V4L2 sensor interface handler for
> ioctl_g_fmt_cap
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 v4l2_format structure
> + *
> + * Returns the sensor's current pixel format in the v4l2_format
> + * parameter.
> + */
> +static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
> +                             struct v4l2_format *f)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     f->fmt.pix = sensor->pix;
> +
> +     return 0;
> +}
> +
> +/**
> + * ioctl_g_parm - V4L2 sensor interface handler for VIDIOC_G_PARM
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
> + *
> + * Returns the sensor's video CAPTURE parameters.
> + */
> +static int ioctl_g_parm(struct v4l2_int_device *s,
> +                          struct v4l2_streamparm *a)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct v4l2_captureparm *cparm = &a->parm.capture;
> +
> +     if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +             return -EINVAL;
> +
> +     memset(a, 0, sizeof(*a));
> +     a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +     cparm->capability = V4L2_CAP_TIMEPERFRAME;
> +     cparm->timeperframe = sensor->timeperframe;
> +
> +     return 0;
> +}
> +
> +/**
> + * ioctl_s_parm - V4L2 sensor interface handler for VIDIOC_S_PARM
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
> + *
> + * Configures the sensor to use the input parameters, if possible.
> If
> + * not possible, reverts to the old parameters and returns the
> + * appropriate error code.
> + */
> +static int ioctl_s_parm(struct v4l2_int_device *s,
> +                          struct v4l2_streamparm *a)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct v4l2_fract *timeperframe = &a-
> >parm.capture.timeperframe;
> +
> +     sensor->timeperframe = *timeperframe;
> +     imx046sensor_calc_xclk();
> +     *timeperframe = sensor->timeperframe;
> +
> +     return 0;
> +}
> +
> +
> +/**
> + * ioctl_g_priv - V4L2 sensor interface handler for
> vidioc_int_g_priv_num
> + * @s: pointer to standard V4L2 device structure
> + * @p: void pointer to hold sensor's private data address
> + *
> + * Returns device's (sensor's) private data area address in p
> parameter
> + */
> +static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +
> +     return sensor->pdata->priv_data_set(p);
> +}
> +
> +/**
> + * ioctl_s_power - V4L2 sensor interface handler for
> vidioc_int_s_power_num
> + * @s: pointer to standard V4L2 device structure
> + * @on: power state to which device is to be set
> + *
> + * Sets devices power state to requrested state, if possible.
> + */
> +static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power
> on)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct i2c_client *c = sensor->i2c_client;
> +     struct omap34xxcam_hw_config hw_config;
> +     struct vcontrol *lvc;
> +     int rval, i;
> +
> +     rval = ioctl_g_priv(s, &hw_config);
> +     if (rval) {
> +             dev_err(&c->dev, "Unable to get hw params\n");
> +             return rval;
> +     }
> +
> +     if ((on == V4L2_POWER_STANDBY) && (sensor->state ==
> SENSOR_DETECTED)) {
> +             /* imx046_write_regs(c, stream_off_list,
> +                                             I2C_STREAM_OFF_LIST_SIZE); */
> +     }
> +
> +     if (on != V4L2_POWER_ON)
> +             sensor->pdata->set_xclk(0, hw_config.u.sensor.xclk);
> +     else
> +             sensor->pdata->set_xclk(xclk_current,
> hw_config.u.sensor.xclk);
> +
> +     rval = sensor->pdata->power_set(on);
> +     if (rval < 0) {
> +             dev_err(&c->dev, "Unable to set the power state: "
> +                     IMX046_DRIVER_NAME " sensor\n");
> +             sensor->pdata->set_xclk(0, hw_config.u.sensor.xclk);
> +             return rval;
> +     }
> +
> +     if ((current_power_state == V4L2_POWER_STANDBY) &&
> +                                     (on == V4L2_POWER_ON) &&
> +                                     (sensor->state == SENSOR_DETECTED)) {
> +             sensor->resuming = true;
> +             imx046_configure(s);
> +     }
> +
> +     if ((on == V4L2_POWER_ON) && (sensor->state ==
> SENSOR_NOT_DETECTED)) {
> +             rval = imx046_detect(c);
> +             if (rval < 0) {
> +                     dev_err(&c->dev, "Unable to detect "
> +                                     IMX046_DRIVER_NAME " sensor\n");
> +                     sensor->state = SENSOR_NOT_DETECTED;
> +                     return rval;
> +             }
> +             sensor->state = SENSOR_DETECTED;
> +             sensor->ver = rval;
> +             pr_info(IMX046_DRIVER_NAME " chip version 0x%02x
> detected\n",
> +                                                             sensor->ver);
> +     }
> +
> +     if (on == V4L2_POWER_OFF) {
> +             /* Reset defaults for controls */
> +             i = find_vctrl(V4L2_CID_GAIN);
> +             if (i >= 0) {
> +                     lvc = &imx046sensor_video_control[i];
> +                     lvc->current_value = IMX046_DEF_GAIN;
> +             }
> +             i = find_vctrl(V4L2_CID_EXPOSURE);
> +             if (i >= 0) {
> +                     lvc = &imx046sensor_video_control[i];
> +                     lvc->current_value = IMX046_DEF_EXPOSURE;
> +             }
> +     }
> +
> +     sensor->resuming = false;
> +     current_power_state = on;
> +     return 0;
> +}
> +
> +/**
> + * ioctl_init - V4L2 sensor interface handler for VIDIOC_INT_INIT
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Initialize the sensor device (call imx046_configure())
> + */
> +static int ioctl_init(struct v4l2_int_device *s)
> +{
> +     return 0;
> +}
> +
> +/**
> + * ioctl_dev_exit - V4L2 sensor interface handler for
> vidioc_int_dev_exit_num
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Delinitialise the dev. at slave detach.  The complement of
> ioctl_dev_init.
> + */
> +static int ioctl_dev_exit(struct v4l2_int_device *s)
> +{
> +     return 0;
> +}
> +
> +/**
> + * ioctl_dev_init - V4L2 sensor interface handler for
> vidioc_int_dev_init_num
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Initialise the device when slave attaches to the master.
> Returns 0 if
> + * imx046 device could be found, otherwise returns appropriate
> error.
> + */
> +static int ioctl_dev_init(struct v4l2_int_device *s)
> +{
> +     struct imx046_sensor *sensor = s->priv;
> +     struct i2c_client *c = sensor->i2c_client;
> +     int err;
> +
> +     err = imx046_detect(c);
> +     if (err < 0) {
> +             dev_err(&c->dev, "Unable to detect " IMX046_DRIVER_NAME
> +                                                             " sensor\n");
> +             return err;
> +     }
> +
> +     sensor->ver = err;
> +     pr_info(IMX046_DRIVER_NAME " chip version 0x%02x detected\n",
> +                                                             sensor->ver);
> +
> +     return 0;
> +}
> +
> +/**
> + * ioctl_enum_framesizes - V4L2 sensor if handler for
> vidioc_int_enum_framesizes
> + * @s: pointer to standard V4L2 device structure
> + * @frms: pointer to standard V4L2 framesizes enumeration structure
> + *
> + * Returns possible framesizes depending on choosen pixel format
> + **/
> +static int ioctl_enum_framesizes(struct v4l2_int_device *s,
> +                                     struct v4l2_frmsizeenum *frms)
> +{
> +     int ifmt;
> +
> +     for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +             if (frms->pixel_format ==
> imx046_formats[ifmt].pixelformat)
> +                     break;
> +     }
> +     /* Is requested pixelformat not found on sensor? */
> +     if (ifmt == NUM_CAPTURE_FORMATS)
> +             return -EINVAL;
> +
> +     /* Check that the index we are being asked for is not
> +        out of bounds. */
> +     if (frms->index >= ARRAY_SIZE(imx046_sizes))
> +             return -EINVAL;
> +
> +     frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +     frms->discrete.width = imx046_sizes[frms->index].width;
> +     frms->discrete.height = imx046_sizes[frms->index].height;
> +
> +     return 0;
> +}
> +
> +const struct v4l2_fract imx046_frameintervals[] = {
> +     { .numerator = 3, .denominator = 30 },
> +     { .numerator = 1, .denominator = 30 },
> +};
> +
> +static int ioctl_enum_frameintervals(struct v4l2_int_device *s,
> +                                     struct v4l2_frmivalenum *frmi)
> +{
> +     int ifmt;
> +
> +     /* Check that the requested format is one we support */
> +     for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +             if (frmi->pixel_format ==
> imx046_formats[ifmt].pixelformat)
> +                     break;
> +     }
> +
> +     if (ifmt == NUM_CAPTURE_FORMATS)
> +             return -EINVAL;
> +
> +     /* Check that the index we are being asked for is not
> +        out of bounds. */
> +     if (frmi->index >= ARRAY_SIZE(imx046_frameintervals))
> +             return -EINVAL;
> +
> +     /* Make sure that the 8MP size reports a max of 10fps */
> +     if (frmi->width == 3280 && frmi->height == 2464) {
> +             if (frmi->index != 0)
> +                     return -EINVAL;
> +     }
> +
> +     frmi->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +     frmi->discrete.numerator =
> +                             imx046_frameintervals[frmi-
> >index].numerator;
> +     frmi->discrete.denominator =
> +                             imx046_frameintervals[frmi-
> >index].denominator;
> +
> +     return 0;
> +}
> +
> +static struct v4l2_int_ioctl_desc imx046_ioctl_desc[] = {
> +     { .num = vidioc_int_enum_framesizes_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_enum_framesizes},
> +     { .num = vidioc_int_enum_frameintervals_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_enum_frameintervals},
> +     { .num = vidioc_int_dev_init_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_dev_init},
> +     { .num = vidioc_int_dev_exit_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_dev_exit},
> +     { .num = vidioc_int_s_power_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_s_power },
> +     { .num = vidioc_int_g_priv_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_g_priv },
> +     { .num = vidioc_int_init_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_init },
> +     { .num = vidioc_int_enum_fmt_cap_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
> +     { .num = vidioc_int_try_fmt_cap_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
> +     { .num = vidioc_int_g_fmt_cap_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
> +     { .num = vidioc_int_s_fmt_cap_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
> +     { .num = vidioc_int_g_parm_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_g_parm },
> +     { .num = vidioc_int_s_parm_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_s_parm },
> +     { .num = vidioc_int_queryctrl_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_queryctrl },
> +     { .num = vidioc_int_g_ctrl_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_g_ctrl },
> +     { .num = vidioc_int_s_ctrl_num,
> +       .func = (v4l2_int_ioctl_func *)ioctl_s_ctrl },
> +};
> +
> +static struct v4l2_int_slave imx046_slave = {
> +     .ioctls = imx046_ioctl_desc,
> +     .num_ioctls = ARRAY_SIZE(imx046_ioctl_desc),
> +};
> +
> +static struct v4l2_int_device imx046_int_device = {
> +     .module = THIS_MODULE,
> +     .name = IMX046_DRIVER_NAME,
> +     .priv = &imx046,
> +     .type = v4l2_int_type_slave,
> +     .u = {
> +             .slave = &imx046_slave,
> +     },
> +};
> +
> +/**
> + * imx046_probe - sensor driver i2c probe handler
> + * @client: i2c driver client device structure
> + *
> + * Register sensor as an i2c client device and V4L2
> + * device.
> + */
> +static int __devinit imx046_probe(struct i2c_client *client,
> +                                const struct i2c_device_id *id)
> +{
> +     struct imx046_sensor *sensor = &imx046;
> +     int err;
> +
> +     if (i2c_get_clientdata(client))
> +             return -EBUSY;
> +
> +     sensor->pdata = client->dev.platform_data;
> +
> +     if (!sensor->pdata) {
> +             dev_err(&client->dev, "no platform data?\n");
> +             return -ENODEV;
> +     }
> +
> +     sensor->v4l2_int_device = &imx046_int_device;
> +     sensor->i2c_client = client;
> +
> +     i2c_set_clientdata(client, sensor);
> +
> +     /* Make the default capture format QCIF V4L2_PIX_FMT_SGRBG10
> */
> +     sensor->pix.width = IMX046_IMAGE_WIDTH_MAX;
> +     sensor->pix.height = IMX046_IMAGE_HEIGHT_MAX;
> +     sensor->pix.pixelformat = V4L2_PIX_FMT_SGRBG10;
> +
> +     err = v4l2_int_device_register(sensor->v4l2_int_device);
> +     if (err)
> +             i2c_set_clientdata(client, NULL);
> +
> +     return 0;
> +}
> +
> +/**
> + * imx046_remove - sensor driver i2c remove handler
> + * @client: i2c driver client device structure
> + *
> + * Unregister sensor as an i2c client device and V4L2
> + * device.  Complement of imx046_probe().
> + */
> +static int __exit
> +imx046_remove(struct i2c_client *client)
> +{
> +     struct imx046_sensor *sensor = i2c_get_clientdata(client);
> +
> +     if (!client->adapter)
> +             return -ENODEV; /* our client isn't attached */
> +
> +     v4l2_int_device_unregister(sensor->v4l2_int_device);
> +     i2c_set_clientdata(client, NULL);
> +
> +     return 0;
> +}
> +
> +static const struct i2c_device_id imx046_id[] = {
> +     { IMX046_DRIVER_NAME, 0 },
> +     { },
> +};
> +MODULE_DEVICE_TABLE(i2c, imx046_id);
> +
> +static struct i2c_driver imx046sensor_i2c_driver = {
> +     .driver = {
> +             .name = IMX046_DRIVER_NAME,
> +             .owner = THIS_MODULE,
> +     },
> +     .probe = imx046_probe,
> +     .remove = __exit_p(imx046_remove),
> +     .id_table = imx046_id,
> +};
> +
> +static struct imx046_sensor imx046 = {
> +     .timeperframe = {
> +             .numerator = 1,
> +             .denominator = 30,
> +     },
> +     .state = SENSOR_NOT_DETECTED,
> +};
> +
> +/**
> + * imx046sensor_init - sensor driver module_init handler
> + *
> + * Registers driver as an i2c client driver.  Returns 0 on success,
> + * error code otherwise.
> + */
> +static int __init imx046sensor_init(void)
> +{
> +     int err;
> +
> +     err = i2c_add_driver(&imx046sensor_i2c_driver);
> +     if (err) {
> +             printk(KERN_ERR "Failed to register" IMX046_DRIVER_NAME
> ".\n");
> +             return err;
> +     }
> +     return 0;
> +}
> +late_initcall(imx046sensor_init);
> +
> +/**
> + * imx046sensor_cleanup - sensor driver module_exit handler
> + *
> + * Unregisters/deletes driver as an i2c client driver.
> + * Complement of imx046sensor_init.
> + */
> +static void __exit imx046sensor_cleanup(void)
> +{
> +     i2c_del_driver(&imx046sensor_i2c_driver);
> +}
> +module_exit(imx046sensor_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("imx046 camera sensor driver");
> Index: omapzoom04/drivers/media/video/imx046.h
> ===================================================================
> --- /dev/null
> +++ omapzoom04/drivers/media/video/imx046.h
> @@ -0,0 +1,326 @@
> +/*
> + * drivers/media/video/imx046.h
> + *
> + * Register definitions for the IMX046 Sensor.
> + *
> + * Leverage MT9P012.h
> + *
> + * Copyright (C) 2008 Hewlett Packard.
> + *
> + * This file is licensed under the terms of the GNU General Public
> License
> + * version 2. This program is licensed "as is" without any warranty
> of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef IMX046_H
> +#define IMX046_H
> +
> +#define IMX046_I2C_ADDR              0x1A
> +
> +/* The ID values we are looking for */
> +#define IMX046_MOD_ID                        0x0046
> +#define IMX046_MFR_ID                        0x000B
> +
> +#define VAUX_2_8_V           0x09
> +#define VAUX_1_8_V           0x05
> +#define VAUX_DEV_GRP_P1      0x20
> +#define VAUX_DEV_GRP_NONE    0x00
> +
> +/* IMX046 has 8/16/32 I2C registers */
> +#define I2C_8BIT                     1
> +#define I2C_16BIT                    2
> +#define I2C_32BIT                    4
> +
> +/* Terminating list entry for reg */
> +#define I2C_REG_TERM         0xFFFF
> +/* Terminating list entry for val */
> +#define I2C_VAL_TERM         0xFFFFFFFF
> +/* Terminating list entry for len */
> +#define I2C_LEN_TERM         0xFFFF
> +
> +/* terminating token for reg list */
> +#define IMX046_TOK_TERM              0xFF
> +
> +/* delay token for reg list */
> +#define IMX046_TOK_DELAY             100
> +
> +/* Sensor specific GPIO signals */
> +#define IMX046_RESET_GPIO    98
> +#define IMX046_STANDBY_GPIO  58
> +
> +/* CSI2 Virtual ID */
> +#define IMX046_CSI2_VIRTUAL_ID       0x0
> +
> +#define IMX046_CLKRC                 0x11
> +
> +/* Average black level */
> +#define IMX046_BLACK_LEVEL_AVG       64
> +
> +/* Used registers */
> +#define IMX046_REG_MODEL_ID                          0x0000
> +#define IMX046_REG_REV_NUMBER                        0x0002
> +#define IMX046_REG_MFR_ID                            0x0003
> +
> +#define IMX046_REG_MODE_SELECT                       0x0100
> +#define IMX046_REG_IMAGE_ORIENTATION 0x0101
> +#define IMX046_REG_SW_RESET                          0x0103
> +#define IMX046_REG_GROUPED_PAR_HOLD          0x0104
> +#define IMX046_REG_CCP2_CHANNEL_ID           0x0110
> +
> +#define IMX046_REG_FINE_INT_TIME             0x0200
> +#define IMX046_REG_COARSE_INT_TIME           0x0202
> +
> +#define IMX046_REG_ANALOG_GAIN_GLOBAL        0x0204
> +#define IMX046_REG_ANALOG_GAIN_GREENR        0x0206
> +#define IMX046_REG_ANALOG_GAIN_RED           0x0208
> +#define IMX046_REG_ANALOG_GAIN_BLUE          0x020A
> +#define IMX046_REG_ANALOG_GAIN_GREENB        0x020C
> +#define IMX046_REG_DIGITAL_GAIN_GREENR       0x020E
> +#define IMX046_REG_DIGITAL_GAIN_RED          0x0210
> +#define IMX046_REG_DIGITAL_GAIN_BLUE 0x0212
> +#define IMX046_REG_DIGITAL_GAIN_GREENB       0x0214
> +
> +#define IMX046_REG_VT_PIX_CLK_DIV            0x0300
> +#define IMX046_REG_VT_SYS_CLK_DIV            0x0302
> +#define IMX046_REG_PRE_PLL_CLK_DIV           0x0304
> +#define IMX046_REG_PLL_MULTIPLIER            0x0306
> +#define IMX046_REG_OP_PIX_CLK_DIV            0x0308
> +#define IMX046_REG_OP_SYS_CLK_DIV            0x030A
> +
> +#define IMX046_REG_FRAME_LEN_LINES           0x0340
> +#define IMX046_REG_LINE_LEN_PCK                      0x0342
> +
> +#define IMX046_REG_X_ADDR_START                      0x0344
> +#define IMX046_REG_Y_ADDR_START                      0x0346
> +#define IMX046_REG_X_ADDR_END                        0x0348
> +#define IMX046_REG_Y_ADDR_END                        0x034A
> +#define IMX046_REG_X_OUTPUT_SIZE             0x034C
> +#define IMX046_REG_Y_OUTPUT_SIZE             0x034E
> +#define IMX046_REG_X_EVEN_INC                        0x0380
> +#define IMX046_REG_X_ODD_INC                 0x0382
> +#define IMX046_REG_Y_EVEN_INC                        0x0384
> +#define IMX046_REG_Y_ODD_INC                 0x0386
> +
> +#define IMX046_REG_HMODEADD                          0x3001
> +#define HMODEADD_SHIFT                                       7
> +#define HMODEADD_MASK                                        (0x1 <<
> HMODEADD_SHIFT)
> +#define IMX046_REG_OPB_CTRL                          0x300C
> +#define IMX046_REG_Y_OPBADDR_START_DI        0x3014
> +#define IMX046_REG_Y_OPBADDR_END_DI          0x3015
> +#define IMX046_REG_PGACUR_VMODEADD           0x3016
> +#define VMODEADD_SHIFT                                       6
> +#define VMODEADD_MASK                                        (0x1 <<
> VMODEADD_SHIFT)
> +#define IMX046_REG_CHCODE_OUTCHSINGLE        0x3017
> +#define IMX046_REG_OUTIF                             0x301C
> +#define IMX046_REG_RGPLTD_RGCLKEN            0x3022
> +#define RGPLTD_MASK                                          0x3
> +#define IMX046_REG_RGPOF_RGPOFV2             0x3031
> +#define IMX046_REG_CPCKAUTOEN                        0x3040
> +#define IMX046_REG_RGCPVFB                           0x3041
> +#define IMX046_REG_RGAZPDRV                          0x3051
> +#define IMX046_REG_RGAZTEST                          0x3053
> +#define IMX046_REG_RGVSUNLV                          0x3055
> +#define IMX046_REG_CLPOWER                           0x3060
> +#define IMX046_REG_CLPOWERSP                 0x3065
> +#define IMX046_REG_ACLDIRV_TVADDCLP          0x30AA
> +#define IMX046_REG_TESTDI                            0x30E5
> +#define IMX046_REG_HADDAVE                           0x30E8
> +#define HADDAVE_SHIFT                                        7
> +#define HADDAVE_MASK                                         (0x1 <<
> HADDAVE_SHIFT)
> +
> +#define IMX046_REG_RAW10CH2V2P_LO            0x31A4
> +#define IMX046_REG_RAW10CH2V2D_LO            0x31A6
> +#define IMX046_REG_COMP8CH1V2P_LO            0x31AC
> +#define IMX046_REG_COMP8CH1V2D_LO            0x31AE
> +#define IMX046_REG_RAW10CH1V2P_LO            0x31B4
> +#define IMX046_REG_RAW10CH1V2D_LO            0x31B6
> +
> +#define IMX046_REG_RGOUTSEL1                 0x3300
> +#define IMX046_REG_RGLANESEL                 0x3301
> +#define IMX046_REG_RGTLPX                            0x3304
> +#define IMX046_REG_RGTCLKPREPARE             0x3305
> +#define IMX046_REG_RGTCLKZERO                        0x3306
> +#define IMX046_REG_RGTCLKPRE                         0x3307
> +#define IMX046_REG_RGTCLKPOST                        0x3308
> +#define IMX046_REG_RGTCLKTRAIL                       0x3309
> +#define IMX046_REG_RGTHSEXIT                         0x330A
> +#define IMX046_REG_RGTHSPREPARE                      0x330B
> +#define IMX046_REG_RGTHSZERO                 0x330C
> +#define IMX046_REG_RGTHSTRAIL                        0x330D
> +
> +
> +/*
> + * The nominal xclk input frequency of the IMX046 is 18MHz, maximum
> + * frequency is 45MHz, and minimum frequency is 6MHz.
> + */
> +#define IMX046_XCLK_MIN      6000000
> +#define IMX046_XCLK_MAX      45000000
> +#define IMX046_XCLK_NOM_1    18000000
> +#define IMX046_XCLK_NOM_2    18000000
> +
> +/* FPS Capabilities */
> +#define IMX046_MIN_FPS               7
> +#define IMX046_DEF_FPS               15
> +#define IMX046_MAX_FPS               30
> +
> +#define I2C_RETRY_COUNT              5
> +
> +/* Still capture 8 MP */
> +#define IMX046_IMAGE_WIDTH_MAX       3280
> +#define IMX046_IMAGE_HEIGHT_MAX      2464
> +
> +/* Analog gain values */
> +#define IMX046_MIN_GAIN              (256*1)
> +#define IMX046_MAX_GAIN              (256*8)
> +#define IMX046_DEF_GAIN              (256*2)
> +#define IMX046_GAIN_STEP     0x1
> +
> +/* Exposure time values */
> +#define IMX046_MIN_EXPOSURE          250
> +#define IMX046_MAX_EXPOSURE          128000
> +#define IMX046_DEF_EXPOSURE      33000
> +#define IMX046_EXPOSURE_STEP 50
> +
> +#define IMX046_MAX_FRAME_LENGTH_LINES        0xFFFF
> +
> +#define SENSOR_DETECTED              1
> +#define SENSOR_NOT_DETECTED  0
> +
> +/**
> + * struct imx046_reg - imx046 register format
> + * @reg: 16-bit offset to register
> + * @val: 8/16/32-bit register value
> + * @length: length of the register
> + *
> + * Define a structure for IMX046 register initialization values
> + */
> +struct imx046_reg {
> +     u16     reg;
> +     u32     val;
> +     u16     length;
> +};
> +
> +enum imx046_image_size {
> +     HALF_MP,
> +     TWO_MP,
> +     EIGHT_MP
> +};
> +
> +/**
> + * struct imx046_capture_size - image capture size information
> + * @width: image width in pixels
> + * @height: image height in pixels
> + */
> +struct imx046_capture_size {
> +     unsigned long width;
> +     unsigned long height;
> +};
> +
> +/**
> + * struct imx046_platform_data - platform data values and access
> functions
> + * @power_set: Power state access function, zero is off, non-zero
> is on.
> + * @default_regs: Default registers written after power-on or
> reset.
> + * @ifparm: Interface parameters access function
> + * @priv_data_set: device private data (pointer) access function
> + */
> +struct imx046_platform_data {
> +     int (*power_set)(enum v4l2_power power);
> +     const struct imx046_reg *default_regs;
> +     int (*ifparm)(struct v4l2_ifparm *p);
> +     int (*priv_data_set)(void *);
> +     u32 (*set_xclk)(u32 xclk, u8 xclksel);
> +     int (*cfg_interface_bridge)(u32);
> +     int (*csi2_lane_count)(int count);
> +     int (*csi2_cfg_vp_out_ctrl)(u8 vp_out_ctrl);
> +     int (*csi2_ctrl_update)(bool);
> +     int (*csi2_cfg_virtual_id)(u8 ctx, u8 id);
> +     int (*csi2_ctx_update)(u8 ctx, bool);
> +     int (*csi2_calc_phy_cfg0)(u32, u32, u32);
> +};
> +
> +/**
> + * struct struct clk_settings - struct for storage of sensor
> + * clock settings
> + */
> +struct imx046_clk_settings {
> +     u16     pre_pll_div;
> +     u16     pll_mult;
> +     u16  post_pll_div;
> +     u16     vt_pix_clk_div;
> +     u16     vt_sys_clk_div;
> +};
> +
> +/**
> + * struct struct mipi_settings - struct for storage of sensor
> + * mipi settings
> + */
> +struct imx046_mipi_settings {
> +     u16     data_lanes;
> +     u16     ths_prepare;
> +     u16     ths_zero;
> +     u16     ths_settle_lower;
> +     u16     ths_settle_upper;
> +};
> +
> +/**
> + * struct struct frame_settings - struct for storage of sensor
> + * frame settings
> + */
> +struct imx046_frame_settings {
> +     u16     frame_len_lines_min;
> +     u16     frame_len_lines;
> +     u16     line_len_pck;
> +     u16     x_addr_start;
> +     u16     x_addr_end;
> +     u16     y_addr_start;
> +     u16     y_addr_end;
> +     u16     x_output_size;
> +     u16     y_output_size;
> +     u16     x_even_inc;
> +     u16     x_odd_inc;
> +     u16     y_even_inc;
> +     u16     y_odd_inc;
> +     u16     v_mode_add;
> +     u16     h_mode_add;
> +     u16     h_add_ave;
> +};
> +
> +/**
> + * struct struct imx046_sensor_settings - struct for storage of
> + * sensor settings.
> + */
> +struct imx046_sensor_settings {
> +     struct imx046_clk_settings clk;
> +     struct imx046_mipi_settings mipi;
> +     struct imx046_frame_settings frame;
> +};
> +
> +/**
> + * struct struct imx046_clock_freq - struct for storage of sensor
> + * clock frequencies
> + */
> +struct imx046_clock_freq {
> +     u32 vco_clk;
> +     u32 mipi_clk;
> +     u32 ddr_clk;
> +     u32 vt_pix_clk;
> +};
> +
> +/**
> + * Array of image sizes supported by IMX046.  These must be ordered
> from
> + * smallest image size to largest.
> + */
> +const static struct imx046_capture_size imx046_sizes[] = {
> +     { 820, 616 },           /* 0.5Mp - 4X Horizontal & Vertical
> Elim. */
> +     { 3280, 616 },  /* 2Mp - 4X Vertical Elim. */
> +     { 3280, 2464},  /* 8MP - Full Resolution */
> +};
> +
> +/* PLL settings for imx046 */
> +enum imx046_pll_type {
> +     PLL_0_5MP = 0,
> +     PLL_2MP,
> +     PLL_8MP,
> +};
> +
> +#endif /* ifndef IMX046_H */
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
