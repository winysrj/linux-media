Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56146 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0J1PQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 11:16:12 -0400
Received: by gyg4 with SMTP id 4so1275336gyg.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 08:16:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
Date: Thu, 28 Oct 2010 17:16:10 +0200
Message-ID: <AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

after reading the topic "controls, subdevs, and media framework"
(http://www.spinics.net/lists/linux-media/msg24474.html) I guess I
double-posted something here :S
But what I still don't understand is, how configuring the camera
works. You say that the subdevs (my camera sensor) are configured
directly. 2 things make me wonder. How gets the ISP informed about the
change and why don't I see my camera in the subdevs name list I
posted. All subdevs are from the ISP.

My camera already receives a clock, the i2c connection works and my
oscilloscope shows that the sensor is throwing out data on the
parallel bus pins. But unfortunately I am a completely v4l2 newbie. I
read through the v4l2-docs now but the first example already didn't
work because of the new framework. Can you point me to a way to read
/dev/video2?

Thank you very much,

 Bastian

2010/10/28 Bastian Hecht <hechtb@googlemail.com>:
> Hello Laurent,
>
> my mt9p031 camera project for the omap3530 isp has come to the point
> where the ISP registered video[0-6], media0 and v4l-subdev[0-7].
>
> As far as I can see from the names...
>
> cat /sys/class/video4linux/video*/names
> OMAP3 ISP CCP2 input
> OMAP3 ISP CSI2a output
> OMAP3 ISP CCDC output
> OMAP3 ISP preview input
> OMAP3 ISP preview output
> OMAP3 ISP resizer input
> OMAP3 ISP resizer output
>
> cat /sys/class/video4linux/v4l-subdev*/names
> OMAP3 ISP CCP2
> OMAP3 ISP CSI2a
> OMAP3 ISP CCDC
> OMAP3 ISP preview
> OMAP3 ISP resizer
> OMAP3 ISP AEWB
> OMAP3 ISP AF
> OMAP3 ISP histogram
>
> ... I want to read /dev/video2 (CCDC).
>
> When I try out a little test program from the V4L2 doc, this line fails:
>      ioctl (fd, VIDIOC_G_STD, &std_id)
>
>
> So far I adopted your mt9t001 driver, merged it with Guennadis
> mt9p031. It contains lot of stubs that I want to fill out when I
> succeed to make them called inside the kernel.
> I looked at your presentation for the media controller and wonder if I
> have to set up a pipeline by myself before I can read /dev/video2
> (http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-v4l2_summit-media.pdf).
> I failed at the point where I wanted to try out the little snippet on
> page 17 as I don't have definitions of the MEDIA_IOC_ENUM_ENTITIES.
> Are there somewhere userspace headers available?
>
> int fd;
> fd = open(“/dev/media0”, O_RDWR);
> while (1) {
>  struct media_user_entity entity;
>  struct media_user_links links;
>  ret = ioctl(fd, MEDIA_IOC_ENUM_ENTITIES, &entity);
>  if (ret < 0)
>  break;
>  while (1) {
>  ret = ioctl(fd, MEDIA_IOC_ENUM_LINKS, &links);
>  if (ret < 0)
>  break;
> }
>
> Thanks for help,
>
>  Bastian
>
>
> APPENDIX A: dmesg
>
> [  103.356018] Linux media interface: v0.10
> [  103.356048] device class 'media': registering
> [  103.442230] Linux video capture interface: v2.00
> [  103.442260] device class 'video4linux': registering
> [  103.814239] bus: 'i2c': add driver mt9p031
> [  103.894622] bus: 'platform': add driver omap3isp
> [  103.933959] address of isp_platform_data in boardconfig: bf065074
> [  103.940155] Registering platform device 'omap3isp'. Parent at platform
> [  103.940185] device: 'omap3isp': device_add
> [  103.940246] bus: 'platform': add device omap3isp
> [  103.940490] bus: 'platform': driver_probe_device: matched device
> omap3isp with driver omap3isp
> [  103.940490] bus: 'platform': really_probe: probing driver omap3isp
> with device omap3isp
> [  103.940551] address of isp_platform_data bf065074
> [  103.954467] omap3isp omap3isp: Revision 2.0 found
> [  103.962738] omap-iommu omap-iommu.0: isp: version 1.1
> [  103.969879] omap3isp omap3isp: hist: DMA channel = 0
> [  103.970001] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 5760000 Hz
> [  103.972229] omap3isp omap3isp: -------------ISP Register dump--------------
> [  103.972259] omap3isp omap3isp: ###ISP SYSCONFIG=0x00000001
> [  103.972259] omap3isp omap3isp: ###ISP SYSSTATUS=0x00000001
> [  103.972290] omap3isp omap3isp: ###ISP IRQ0ENABLE=0x00000000
> [  103.972290] omap3isp omap3isp: ###ISP IRQ0STATUS=0x00000000
> [  103.972320] omap3isp omap3isp: ###ISP TCTRL_GRESET_LENGTH=0x00000000
> [  103.972320] omap3isp omap3isp: ###ISP TCTRL_PSTRB_REPLAY=0x00000000
> [  103.972351] omap3isp omap3isp: ###ISP CTRL=0x00200200
> [  103.972351] omap3isp omap3isp: ###ISP TCTRL_CTRL=0x0000001e
> [  103.972381] omap3isp omap3isp: ###ISP TCTRL_FRAME=0x00000000
> [  103.972381] omap3isp omap3isp: ###ISP TCTRL_PSTRB_DELAY=0x00000000
> [  103.972412] omap3isp omap3isp: ###ISP TCTRL_STRB_DELAY=0x00000000
> [  103.972442] omap3isp omap3isp: ###ISP TCTRL_SHUT_DELAY=0x00000000
> [  103.972442] omap3isp omap3isp: ###ISP TCTRL_PSTRB_LENGTH=0x00000000
> [  103.972473] omap3isp omap3isp: ###ISP TCTRL_STRB_LENGTH=0x00000000
> [  103.972473] omap3isp omap3isp: ###ISP TCTRL_SHUT_LENGTH=0x00000000
> [  103.972503] omap3isp omap3isp: ###SBL PCR=0x00000000
> [  103.972503] omap3isp omap3isp: ###SBL SDR_REQ_EXP=0x00000000
> [  103.972534] omap3isp omap3isp: --------------------------------------------
> [  103.974700] device: 'media0': device_add
> [  103.975128] device: 'v4l-subdev0': device_add
> [  103.975524] device: 'video0': device_add
> [  103.975799] device: 'v4l-subdev1': device_add
> [  103.976104] device: 'video1': device_add
> [  103.976409] device: 'v4l-subdev2': device_add
> [  103.976684] device: 'video2': device_add
> [  103.976959] device: 'v4l-subdev3': device_add
> [  103.977294] device: 'video3': device_add
> [  103.977600] device: 'video4': device_add
> [  103.977905] device: 'v4l-subdev4': device_add
> [  103.978210] device: 'video5': device_add
> [  103.978485] device: 'video6': device_add
> [  103.978759] device: 'v4l-subdev5': device_add
> [  103.979156] device: 'v4l-subdev6': device_add
> [  103.979461] device: 'v4l-subdev7': device_add
> [  104.752685] device: '2-005d': device_add
> [  104.752777] bus: 'i2c': add device 2-005d
> [  104.753051] bus: 'i2c': driver_probe_device: matched device 2-005d
> with driver mt9p031
> [  104.753082] bus: 'i2c': really_probe: probing driver mt9p031 with
> device 2-005d
> [  104.769897] mt9p031 2-005d: Detected a MT9P031 chip ID 1801
> [  104.771881] mt9p031 2-005d: reset succesful
> [  104.771911] driver: '2-005d': driver_bound: bound to device 'mt9p031'
> [  104.771942] bus: 'i2c': really_probe: bound device 2-005d to driver mt9p031
> [  104.772003] driver: 'omap3isp': driver_bound: bound to device 'omap3isp'
> [  104.772033] bus: 'platform': really_probe: bound device omap3isp to
> driver omap3isp
>
>
> APPENDIX B: mt9p031.c
>
> #include <linux/device.h>
> #include <linux/i2c.h>
> #include <linux/log2.h>
> #include <linux/pm.h>
> #include <linux/slab.h>
> #include <linux/videodev2.h>
>
> //#include <media/soc_camera.h>
> #include <media/v4l2-chip-ident.h>
> #include <media/v4l2-subdev.h>
>
> /*
>  * mt9p031 i2c address 0x5d (0xBA read, 0xBB write) same as mt9t031
>  * The platform has to define i2c_board_info and link to it from
>  * struct soc_camera_link
>  */
>
> /* mt9p031 selected register addresses */
> #define MT9P031_CHIP_VERSION            0x00
> #define MT9P031_ROW_START               0x01
> #define MT9P031_COLUMN_START            0x02
> #define MT9P031_WINDOW_HEIGHT           0x03
> #define MT9P031_WINDOW_WIDTH            0x04
> #define MT9P031_HORIZONTAL_BLANKING     0x05
> #define MT9P031_VERTICAL_BLANKING       0x06
> #define MT9P031_OUTPUT_CONTROL          0x07
> #define MT9P031_SHUTTER_WIDTH_UPPER     0x08
> #define MT9P031_SHUTTER_WIDTH           0x09
> #define MT9P031_PIXEL_CLOCK_CONTROL     0x0a
> #define MT9P031_FRAME_RESTART           0x0b
> #define MT9P031_SHUTTER_DELAY           0x0c
> #define MT9P031_RESET                   0x0d
> #define MT9P031_READ_MODE_1             0x1e
> #define MT9P031_READ_MODE_2             0x20
> //#define MT9T031_READ_MODE_3           0x21 // NA readmode_2 is 2 bytes
> #define MT9P031_ROW_ADDRESS_MODE        0x22
> #define MT9P031_COLUMN_ADDRESS_MODE     0x23
> #define MT9P031_GLOBAL_GAIN             0x35
> //#define MT9T031_CHIP_ENABLE           0xF8 // PDN is pin signal. no i2c register
>
> #define MT9P031_MAX_HEIGHT              1944 // adapted
> #define MT9P031_MAX_WIDTH               2592 // adapted
> #define MT9P031_MIN_HEIGHT              2  // could be 0
> #define MT9P031_MIN_WIDTH               18 // could be 0
> #define MT9P031_HORIZONTAL_BLANK        0  // adapted R0x05
> #define MT9P031_VERTICAL_BLANK          25 // adapted R0x06
> #define MT9P031_COLUMN_SKIP             16 // adapted
> #define MT9P031_ROW_SKIP                54 // adapted
>
> #define MT9P031_CHIP_VERSION_VALUE      0x1801
>
> /*
> #define MT9T031_BUS_PARAM       (SOCAM_PCLK_SAMPLE_RISING |     \
>        SOCAM_PCLK_SAMPLE_FALLING | SOCAM_HSYNC_ACTIVE_HIGH |   \
>        SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |      \
>        SOCAM_MASTER | SOCAM_DATAWIDTH_10)
> */
> struct mt9p031 {
>        struct v4l2_subdev subdev;
>        struct media_entity_pad pad;
>
>        struct v4l2_rect rect;  /* Sensor window */
>        int model;      /* V4L2_IDENT_MT9P031* codes from v4l2-chip-ident.h */
>        u16 xskip;
>        u16 yskip;
>        unsigned int gain;
>        unsigned short y_skip_top;      /* Lines to skip at the top */
>        unsigned int exposure;
>        unsigned char autoexposure;
> };
>
> static struct mt9p031 *to_mt9p031(const struct i2c_client *client)
> {
>        return container_of(i2c_get_clientdata(client), struct mt9p031, subdev);
> }
>
> static int reg_read(struct i2c_client *client, const u8 reg)
> {
>        s32 data = i2c_smbus_read_word_data(client, reg);
>        return data < 0 ? data : swab16(data);
> }
>
> static int reg_write(struct i2c_client *client, const u8 reg,
>                     const u16 data)
> {
>        return i2c_smbus_write_word_data(client, reg, swab16(data));
> }
>
> static int reg_set(struct i2c_client *client, const u8 reg,
>                   const u16 data)
> {
>        int ret;
>
>        ret = reg_read(client, reg);
>        if (ret < 0)
>                return ret;
>        return reg_write(client, reg, ret | data);
> }
>
> static int reg_clear(struct i2c_client *client, const u8 reg,
>                     const u16 data)
> {
>        int ret;
>
>        ret = reg_read(client, reg);
>        if (ret < 0)
>                return ret;
>        return reg_write(client, reg, ret & ~data);
> }
>
> static int set_shutter(struct i2c_client *client, const u32 data)
> {
>        int ret;
>
>        ret = reg_write(client, MT9P031_SHUTTER_WIDTH_UPPER, data >> 16);
>
>        if (ret >= 0)
>                ret = reg_write(client, MT9P031_SHUTTER_WIDTH, data & 0xffff);
>
>        return ret;
> }
>
> static int get_shutter(struct i2c_client *client, u32 *data)
> {
>        int ret;
>
>        ret = reg_read(client, MT9P031_SHUTTER_WIDTH_UPPER);
>        *data = ret << 16;
>
>        if (ret >= 0)
>                ret = reg_read(client, MT9P031_SHUTTER_WIDTH);
>        *data |= ret & 0xffff;
>
>        return ret < 0 ? ret : 0;
> }
>
> static int mt9p031_idle(struct i2c_client *client)
> {
>        int ret;
>
>        /* Disable chip output, synchronous option update */
>        ret = reg_write(client, MT9P031_RESET, 1);
>        if (ret >= 0)
>                ret = reg_write(client, MT9P031_RESET, 0);
>        if (ret >= 0)
>                ret = reg_clear(client, MT9P031_OUTPUT_CONTROL, 2);
>
>        return ret >= 0 ? 0 : -EIO;
> }
>
> /////////////////////////////////////////////////////////////////////////////////
> STUB
> static int mt9t001_enum_mbus_code(struct v4l2_subdev *subdev,
>                                  struct v4l2_subdev_fh *fh,
>                                  struct v4l2_subdev_pad_mbus_code_enum *code)
> {
>        printk(KERN_ALERT "pad_op 0\n");
>        return 0;
> }
>
> static int mt9t001_enum_frame_size(struct v4l2_subdev *subdev,
>                                   struct v4l2_subdev_fh *fh,
>                                   struct v4l2_subdev_frame_size_enum *fse)
> {
>        printk(KERN_ALERT "pad_op 1\n");
>        return 0;
> }
>
> static int mt9t001_get_format(struct v4l2_subdev *subdev,
>                              struct v4l2_subdev_fh *fh, unsigned int pad,
>                              struct v4l2_mbus_framefmt *format,
>                              enum v4l2_subdev_format which)
> {
>        printk(KERN_ALERT "pad_op 4\n");
>        return 0;
> }
>
> static int mt9t001_set_format(struct v4l2_subdev *subdev,
>                              struct v4l2_subdev_fh *fh, unsigned int pad,
>                              struct v4l2_mbus_framefmt *format,
>                              enum v4l2_subdev_format which)
> {
>        printk(KERN_ALERT "pad_op 5\n");
>        return 0;
> }
> static int mt9t001_get_crop(struct v4l2_subdev *subdev,
>                            struct v4l2_subdev_fh *fh,
>                            struct v4l2_subdev_pad_crop *crop)
> {
>        printk(KERN_ALERT "pad_op 6\n");
>        return 0;
> }
>
> static int mt9t001_set_crop(struct v4l2_subdev *subdev,
>                            struct v4l2_subdev_fh *fh,
>                            struct v4l2_subdev_pad_crop *crop)
> {
>        printk(KERN_ALERT "pad_op 7\n");
>        return 0;
> }
>
>
> /////////////////////////////////////////////////////////////////////////////////
> END STUB
>
>
> static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
> {
>        struct i2c_client *client = v4l2_get_subdevdata(sd);
>        int ret;
>
>        if (enable)
>                /* Switch to master "normal" mode */
>                ret = reg_set(client, MT9P031_OUTPUT_CONTROL, 2);
>        else
>                /* Stop sensor readout */
>                ret = reg_clear(client, MT9P031_OUTPUT_CONTROL, 2);
>
>        if (ret < 0)
>                return -EIO;
>
>        return 0;
> }
>
> enum {
>        MT9P031_CTRL_VFLIP,
>        MT9P031_CTRL_HFLIP,
>        MT9P031_CTRL_GAIN,
>        MT9P031_CTRL_EXPOSURE,
>        MT9P031_CTRL_EXPOSURE_AUTO,
> };
>
> static const struct v4l2_queryctrl mt9p031_controls[] = {
>        [MT9P031_CTRL_VFLIP] = {
>                .id             = V4L2_CID_VFLIP,
>                .type           = V4L2_CTRL_TYPE_BOOLEAN,
>                .name           = "Flip Vertically",
>                .minimum        = 0,
>                .maximum        = 1,
>                .step           = 1,
>                .default_value  = 0,
>        },
>        [MT9P031_CTRL_HFLIP] = {
>                .id             = V4L2_CID_HFLIP,
>                .type           = V4L2_CTRL_TYPE_BOOLEAN,
>                .name           = "Flip Horizontally",
>                .minimum        = 0,
>                .maximum        = 1,
>                .step           = 1,
>                .default_value  = 0,
>        },
>        [MT9P031_CTRL_GAIN] = {
>                .id             = V4L2_CID_GAIN,
>                .type           = V4L2_CTRL_TYPE_INTEGER,
>                .name           = "Gain",
>                .minimum        = 0,
>                .maximum        = 127,
>                .step           = 1,
>                .default_value  = 64,
>                .flags          = V4L2_CTRL_FLAG_SLIDER,
>        },
>        [MT9P031_CTRL_EXPOSURE] = {
>                .id             = V4L2_CID_EXPOSURE,
>                .type           = V4L2_CTRL_TYPE_INTEGER,
>                .name           = "Exposure",
>                .minimum        = 1,
>                .maximum        = 255,
>                .step           = 1,
>                .default_value  = 255,
>                .flags          = V4L2_CTRL_FLAG_SLIDER,
>        },
>        [MT9P031_CTRL_EXPOSURE_AUTO] = {
>                .id             = V4L2_CID_EXPOSURE_AUTO,
>                .type           = V4L2_CTRL_TYPE_BOOLEAN,
>                .name           = "Automatic Exposure",
>                .minimum        = 0,
>                .maximum        = 1,
>                .step           = 1,
>                .default_value  = 1,
>        }
> };
>
>
>
> static int mt9p031_g_chip_ident(struct v4l2_subdev *sd,
>                                struct v4l2_dbg_chip_ident *id)
> {
>        struct i2c_client *client = v4l2_get_subdevdata(sd);
>        struct mt9p031 *mt9p031 = to_mt9p031(client);
>
>        if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
>                return -EINVAL;
>
>        if (id->match.addr != client->addr)
>                return -ENODEV;
>
>        id->ident       = mt9p031->model;
>        id->revision    = 0;
>
>        return 0;
> }
>
> static int mt9p031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> {
>        struct i2c_client *client = v4l2_get_subdevdata(sd);
>        struct mt9p031 *mt9p031 = to_mt9p031(client);
>        int data;
>
>        switch (ctrl->id) {
>        case V4L2_CID_VFLIP:
>                data = reg_read(client, MT9P031_READ_MODE_2);
>                if (data < 0)
>                        return -EIO;
>                ctrl->value = !!(data & 0x8000);
>                break;
>        case V4L2_CID_HFLIP:
>                data = reg_read(client, MT9P031_READ_MODE_2);
>                if (data < 0)
>                        return -EIO;
>                ctrl->value = !!(data & 0x4000);
>                break;
>        case V4L2_CID_EXPOSURE_AUTO:
>                ctrl->value = mt9p031->autoexposure;
>                break;
>        case V4L2_CID_GAIN:
>                ctrl->value = mt9p031->gain;
>                break;
>        case V4L2_CID_EXPOSURE:
>                ctrl->value = mt9p031->exposure;
>                break;
>        }
>        return 0;
> }
>
> static int mt9p031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> {
>        printk(KERN_ALERT "s_ctrl\n");
>        return 0;
> }
>
>
> static struct dev_pm_ops mt9p031_dev_pm_ops = {
> /*
>        .runtime_suspend        = mt9t031_runtime_suspend,
>        .runtime_resume         = mt9t031_runtime_resume,
> */
> };
>
> static struct device_type mt9p031_dev_type = {
>        .name   = "MT9P031",
>        .pm     = &mt9p031_dev_pm_ops,
> };
>
> /*
>  * Interface active, can use i2c. If it fails, it can indeed mean, that
>  * this wasn't our capture interface, so, we wait for the right one
>  */
> static int mt9p031_video_probe(struct i2c_client *client)
> {
>        struct mt9p031 *mt9p031 = to_mt9p031(client);
>        s32 data;
>        int ret;
>
>        /* Enable the chip */
>        //data = reg_write(client, MT9P031_CHIP_ENABLE, 1);
>        //dev_dbg(&client->dev, "write: %d\n", data);
>
>        /* Read out the chip version register */
>        data = reg_read(client, MT9P031_CHIP_VERSION);
>
>        switch (data) {
>        case MT9P031_CHIP_VERSION_VALUE:
>                mt9p031->model = V4L2_IDENT_MT9P031;
>                break;
>        default:
>                dev_err(&client->dev,
>                        "No MT9P031 chip detected, register read %x\n", data);
>                return -ENODEV;
>        }
>
>        dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", data);
>
>        ret = mt9p031_idle(client);
>        if (ret < 0)
>                dev_err(&client->dev, "Failed to initialise the camera\n");
>        else
>                dev_info(&client->dev, "reset succesful\n");//vdev->dev.type =
> &mt9p031_dev_type;
>
>        /* mt9t031_idle() has reset the chip to default. */
>        mt9p031->exposure = 255;
>        mt9p031->gain = 64;
>
>        return ret;
> }
>
> static int mt9p031_open(struct v4l2_subdev *subdev, u32 i)
> {
>        printk(KERN_ALERT "mt9p031 open\n");
>        return 0;
> }
> static int mt9p031_query_ctrl(struct v4l2_subdev *subdev,
>                              struct v4l2_queryctrl *qc)
> {
>        return 0;
> }
>
>
>
> static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
>        .g_ctrl         = mt9p031_g_ctrl,
>        .s_ctrl         = mt9p031_s_ctrl,
>        .g_chip_ident   = mt9p031_g_chip_ident,
>        .init           = mt9p031_open,
>        .queryctrl      = mt9p031_query_ctrl,
>
> };
>
> static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
>        .s_stream       = mt9p031_s_stream,
> };
>
>
> static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
>        .enum_mbus_code = mt9t001_enum_mbus_code,
>        .enum_frame_size = mt9t001_enum_frame_size,
>        .get_fmt = mt9t001_get_format,
>        .set_fmt = mt9t001_set_format,
>        .get_crop = mt9t001_get_crop,
>        .set_crop = mt9t001_set_crop,
> };
>
>
> static struct v4l2_subdev_ops mt9p031_subdev_ops = {
>        .core   = &mt9p031_subdev_core_ops,
>        .video  = &mt9p031_subdev_video_ops,
>        .pad    = &mt9p031_subdev_pad_ops,
> };
>
> static int mt9p031_probe(struct i2c_client *client,
>                         const struct i2c_device_id *did)
> {
>        struct mt9p031 *mt9p031;
>        struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>        int ret;
>
>
>
>        if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>                dev_warn(&adapter->dev,
>                         "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
>                return -EIO;
>        }
>
>        mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
>        if (!mt9p031)
>                return -ENOMEM;
>
>        v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
>
> //       struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
> //       isp_set_xclk(isp, 16*1000*1000, ISP_XCLK_A);
>
>        mt9p031->y_skip_top     = 0;
>        mt9p031->rect.left      = MT9P031_COLUMN_SKIP;
>        mt9p031->rect.top       = MT9P031_ROW_SKIP;
>        mt9p031->rect.width     = MT9P031_MAX_WIDTH;
>        mt9p031->rect.height    = MT9P031_MAX_HEIGHT;
>
>        /*
>         * Simulated autoexposure. If enabled, we calculate shutter width
>         * ourselves in the driver based on vertical blanking and frame width
>         */
>        mt9p031->autoexposure = 1;
>
>        mt9p031->xskip = 1;
>        mt9p031->yskip = 1;
>
>        mt9p031_idle(client);
>
>        ret = mt9p031_video_probe(client);
>
>        //mt9p031_disable(client);
>
>        if (ret) {
>                kfree(mt9p031);
>                return ret;
>        }
>
>        mt9p031->pad.type = MEDIA_PAD_TYPE_OUTPUT;
>        ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
>        if (ret) {
>                kfree(mt9p031);
>                return ret;
>        }
>
>
>
>        return ret;
> }
>
> static int mt9p031_remove(struct i2c_client *client)
> {
>        struct mt9p031 *mt9p031 = to_mt9p031(client);
>
>        client->driver = NULL;
>        kfree(mt9p031);
>
>        return 0;
> }
>
> static const struct i2c_device_id mt9p031_id[] = {
>        { "mt9p031", 0 },
>        { }
> };
> MODULE_DEVICE_TABLE(i2c, mt9p031_id);
>
> static struct i2c_driver mt9p031_i2c_driver = {
>        .driver = {
>                .name = "mt9p031",
>        },
>        .probe          = mt9p031_probe,
>        .remove         = mt9p031_remove,
>        .id_table       = mt9p031_id,
> };
>
> static int __init mt9p031_mod_init(void)
> {
>        return i2c_add_driver(&mt9p031_i2c_driver);
> }
>
> static void __exit mt9p031_mod_exit(void)
> {
>        i2c_del_driver(&mt9p031_i2c_driver);
> }
>
> module_init(mt9p031_mod_init);
> module_exit(mt9p031_mod_exit);
>
> MODULE_DESCRIPTION("Micron MT9T031 Camera driver");
> MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
> MODULE_LICENSE("GPL v2");
>
