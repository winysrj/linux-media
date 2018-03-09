Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:39382 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbeCIKse (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 05:48:34 -0500
Received: by mail-vk0-f52.google.com with SMTP id f6so1808684vkh.6
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 02:48:33 -0800 (PST)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com. [209.85.213.46])
        by smtp.gmail.com with ESMTPSA id 104sm467075uat.0.2018.03.09.02.48.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Mar 2018 02:48:31 -0800 (PST)
Received: by mail-vk0-f46.google.com with SMTP id y127so1797789vky.9
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 02:48:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D5252C7@KMSMSX156.gar.corp.intel.com>
References: <1520525754-15726-1-git-send-email-andy.yeh@intel.com>
 <20180309085442.qyo2ufb4abaupzop@paasikivi.fi.intel.com> <CAAFQd5BexArX_tzx-HEtAiDMu-v+6i+tDPysnpJLa+hPe1=M=Q@mail.gmail.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D5252C7@KMSMSX156.gar.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 9 Mar 2018 19:48:10 +0900
Message-ID: <CAAFQd5CjRpggSZ8vgj84AsrHz2u1gCXPPewWzC2+-XUik6JVHw@mail.gmail.com>
Subject: Re: [PATCH v8] media: imx258: Add imx258 camera sensor driver
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 9, 2018 at 7:46 PM, Yeh, Andy <andy.yeh@intel.com> wrote:
> Hi Tomasz,
>
> My apology. Actually I obsoleted this [V8] https://patchwork.linuxtv.org/=
patch/47768/ just after submitted.
> Since I found few comments as what you pointed below were not addressed y=
et.
> Didn=E2=80=99t expect you to check this. I shall send an email to notify =
you two the obsolete state as well.
>
> We are working on addressing all those outstanding comments. Almost done.
> Will do reply v6 with OKAY, and send to list a new v7 with all fixed.
>

Thank you. Looking forward to next version then! (By the way, I still
think that replying to review comments, even with a simple "Okay" is a
good practice. :))

Best regards,
Tomasz

>
> Regards, Andy
>
> -----Original Message-----
> From: Tomasz Figa [mailto:tfiga@chromium.org]
> Sent: Friday, March 9, 2018 6:20 PM
> To: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Yeh, Andy <andy.yeh@intel.com>; Linux Media Mailing List <linux-media=
@vger.kernel.org>; Chen, JasonX Z <jasonx.z.chen@intel.com>; Chiang, AlanX =
<alanx.chiang@intel.com>
> Subject: Re: [PATCH v8] media: imx258: Add imx258 camera sensor driver
>
> Hi Andy, Sakari,
>
> On Fri, Mar 9, 2018 at 5:54 PM, Sakari Ailus <sakari.ailus@linux.intel.co=
m> wrote:
>> Hi Andy,
>>
>> Thanks for the update. Please see my comments below.
>>
>> On Fri, Mar 09, 2018 at 12:15:54AM +0800, Andy Yeh wrote:
>>> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
>>> This is a camera sensor using the I2C bus for control and the
>>> CSI-2 bus for data.
>>>
>>> Signed-off-by: Jason Chen <jasonx.z.chen@intel.com>
>>> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
>>> ---
>>> since v2:
>>> -- Update the streaming function to remove SW_STANDBY in the beginning.
>>> -- Adjust the delay time from 1ms to 12ms before set stream-on register=
.
>>> since v3:
>>> -- fix the sd.entity to make code be compiled on the mainline kernel.
>>> since v4:
>>> -- Enabled AG, DG, and Exposure time control correctly.
>>> since v5:
>>> -- Sensor vendor provided a new setting to fix different CLK issue
>>> -- Add one more resolution for 1048x780, used for VGA streaming since
>>> v6:
>>> -- improve i2c write function to support writing 2 registers
>>> -- Not Orring ret in update_digital_gain which lead to unintended
>>> error since v7:
>>> -- modified imx258_reg read / write function with a more portable way
>>> -- arranged some format per suggestions
>>>
>>>
>>>  MAINTAINERS                |    7 +
>>>  drivers/media/i2c/Kconfig  |   11 +
>>>  drivers/media/i2c/Makefile |    1 +
>>>  drivers/media/i2c/imx258.c | 1324
>>> ++++++++++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 1343 insertions(+)
>>>  create mode 100644 drivers/media/i2c/imx258.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS index a339bb5..9f75510 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -12646,6 +12646,13 @@ S:   Maintained
>>>  F:   drivers/ssb/
>>>  F:   include/linux/ssb/
>>>
>>> +SONY IMX258 SENSOR DRIVER
>>> +M:   Sakari Ailus <sakari.ailus@linux.intel.com>
>>> +L:   linux-media@vger.kernel.org
>>> +T:   git git://linuxtv.org/media_tree.git
>>> +S:   Maintained
>>> +F:   drivers/media/i2c/imx258.c
>>> +
>>>  SONY IMX274 SENSOR DRIVER
>>>  M:   Leon Luo <leonl@leopardimaging.com>
>>>  L:   linux-media@vger.kernel.org
>>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>>> index fd01842..bcd4bf1 100644
>>> --- a/drivers/media/i2c/Kconfig
>>> +++ b/drivers/media/i2c/Kconfig
>>> @@ -565,6 +565,17 @@ config VIDEO_APTINA_PLL  config VIDEO_SMIAPP_PLL
>>>       tristate
>>>
>>> +config VIDEO_IMX258
>>> +     tristate "Sony IMX258 sensor support"
>>> +     depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>> +     depends on MEDIA_CAMERA_SUPPORT
>>> +     ---help---
>>> +       This is a Video4Linux2 sensor-level driver for the Sony
>>> +       IMX258 camera.
>>> +
>>> +       To compile this driver as a module, choose M here: the
>>> +       module will be called imx258.
>>> +
>>>  config VIDEO_IMX274
>>>       tristate "Sony IMX274 sensor support"
>>>       depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API diff
>>> --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile index
>>> 1b62639..4bf7d00 100644
>>> --- a/drivers/media/i2c/Makefile
>>> +++ b/drivers/media/i2c/Makefile
>>> @@ -94,6 +94,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  +=3D ir-kbd-i2c.o
>>>  obj-$(CONFIG_VIDEO_ML86V7667)        +=3D ml86v7667.o
>>>  obj-$(CONFIG_VIDEO_OV2659)   +=3D ov2659.o
>>>  obj-$(CONFIG_VIDEO_TC358743) +=3D tc358743.o
>>> +obj-$(CONFIG_VIDEO_IMX258)   +=3D imx258.o
>>>  obj-$(CONFIG_VIDEO_IMX274)   +=3D imx274.o
>>>
>>>  obj-$(CONFIG_SDR_MAX2175) +=3D max2175.o diff --git
>>> a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c new file
>>> mode 100644 index 0000000..814520f
>>> --- /dev/null
>>> +++ b/drivers/media/i2c/imx258.c
>>> @@ -0,0 +1,1324 @@
>>> +// Copyright (C) 2018 Intel Corporation // SPDX-License-Identifier:
>>> +GPL-2.0
>>> +
>>> +#include <linux/acpi.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/module.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include <media/v4l2-ctrls.h>
>>> +#include <media/v4l2-device.h>
>>> +#include <asm/unaligned.h>
>>> +
>>> +#define IMX258_REG_VALUE_08BIT               1
>>> +#define IMX258_REG_VALUE_16BIT               2
>>> +#define IMX258_REG_VALUE_24BIT               3
>>
>> The last one is not used. Perhaps because the sensor does not have any
>> 24-bit registers? :-) How about removing it?
>
> I pointed in my earlier review comments that we don't even need these mac=
ros anymore. They add as much value as defining ONE =3D 1 and TWO =3D 2.
>
> Andy, this is already a second re-spin of this patch, where my previous c=
omments are left unaddressed.
>
>>
>>> +
>>> +#define IMX258_REG_MODE_SELECT               0x0100
>>> +#define IMX258_MODE_STANDBY          0x00
>>> +#define IMX258_MODE_STREAMING                0x01
>>> +
>>> +/* Chip ID */
>>> +#define IMX258_REG_CHIP_ID           0x0016
>>> +#define IMX258_CHIP_ID                       0x0258
>>> +
>>> +/* V_TIMING internal */
>>> +#define IMX258_REG_VTS                       0x0340
>>> +#define IMX258_VTS_30FPS             0x0c98
>>> +#define IMX258_VTS_MAX                       0xffff
>>> +
>>> +/*Frame Length Line*/
>>> +#define IMX258_FLL_MIN                       0x08a6
>>> +#define IMX258_FLL_MAX                       0xffff
>>> +#define IMX258_FLL_STEP                      1
>>> +#define IMX258_FLL_DEFAULT           0x0c98
>>> +
>>> +/* HBLANK control - read only */
>>> +#define IMX258_PPL_DEFAULT           5352
>>> +
>>> +/* Exposure control */
>>> +#define IMX258_REG_EXPOSURE          0x0202
>>> +#define IMX258_EXPOSURE_MIN          4
>>> +#define IMX258_EXPOSURE_STEP         1
>>> +#define IMX258_EXPOSURE_DEFAULT              0x640
>>> +#define IMX258_EXPOSURE_MAX          65535
>>> +
>>> +/* Analog gain control */
>>> +#define IMX258_REG_ANALOG_GAIN               0x0204
>>> +#define IMX258_ANA_GAIN_MIN          0
>>> +#define IMX258_ANA_GAIN_MAX          0x1fff
>>> +#define IMX258_ANA_GAIN_STEP         1
>>> +#define IMX258_ANA_GAIN_DEFAULT              0x0
>>> +
>>> +/* Digital gain control */
>>> +#define IMX258_REG_GR_DIGITAL_GAIN   0x020e
>>> +#define IMX258_REG_R_DIGITAL_GAIN    0x0210
>>> +#define IMX258_REG_B_DIGITAL_GAIN    0x0212
>>> +#define IMX258_REG_GB_DIGITAL_GAIN   0x0214
>>> +#define IMX258_DGTL_GAIN_MIN         0
>>> +#define IMX258_DGTL_GAIN_MAX         4096   /* Max =3D 0xFFF */
>>> +#define IMX258_DGTL_GAIN_DEFAULT     1024
>>> +#define IMX258_DGTL_GAIN_STEP           1
>>> +
>>> +/* Orientation */
>>> +#define REG_MIRROR_FLIP_CONTROL      0x0101
>>> +#define REG_CONFIG_MIRROR_FLIP               0x03
>>> +
>>> +struct imx258_reg {
>>> +     u16 address;
>>> +     u8 val;
>>> +};
>>> +
>>> +struct imx258_reg_list {
>>> +     u32 num_of_regs;
>>> +     const struct imx258_reg *regs;
>>> +};
>>> +
>>> +/* Link frequency config */
>>> +struct imx258_link_freq_config {
>>> +     u32 pixels_per_line;
>>> +
>>> +     /* PLL registers for this link frequency */
>>> +     struct imx258_reg_list reg_list; };
>>> +
>>> +/* Mode : resolution and related config&values */ struct imx258_mode
>>> +{
>>> +     /* Frame width */
>>> +     u32 width;
>>> +     /* Frame height */
>>> +     u32 height;
>>> +
>>> +     /* V-timing */
>>> +     u32 vts_def;
>>> +     u32 vts_min;
>>> +
>>> +     /* Index of Link frequency config to be used */
>>> +     u32 link_freq_index;
>>> +     /* Default register values */
>>> +     struct imx258_reg_list reg_list; };
>>> +
>>> +/* 4208x3118 needs 1267Mbps/lane, 4 lanes */ static const struct
>>> +imx258_reg mipi_data_rate_1267mbps[] =3D {
>>> +     { 0x0301, 0x05},
>>
>> If you have a space after the opening brace (which I'd recommend), you
>> should have one before the closing one as well.
>>
>>> +     { 0x0303, 0x02},
>>> +     { 0x0305, 0x03},
>>> +     { 0x0306, 0x00},
>>> +     { 0x0307, 0xC6},
>>> +     { 0x0309, 0x0A},
>>> +     { 0x030B, 0x01},
>>> +     { 0x030D, 0x02},
>>> +     { 0x030E, 0x00},
>>> +     { 0x030F, 0xD8},
>>> +     { 0x0310, 0x00},
>>> +     { 0x0820, 0x13},
>>> +     { 0x0821, 0x4C},
>>> +     { 0x0822, 0xCC},
>>> +     { 0x0823, 0xCC},
>>> +};
>>> +
>>> +static const struct imx258_reg mipi_data_rate_640mbps[] =3D {
>>> +     { 0x0301, 0x05},
>>> +     { 0x0303, 0x02},
>>> +     { 0x0305, 0x03},
>>> +     { 0x0306, 0x00},
>>> +     { 0x0307, 0x64},
>>> +     { 0x0309, 0x0A},
>>> +     { 0x030B, 0x01},
>>> +     { 0x030D, 0x02},
>>> +     { 0x030E, 0x00},
>>> +     { 0x030F, 0xD8},
>>> +     { 0x0310, 0x00},
>>> +     { 0x0820, 0x0A},
>>> +     { 0x0821, 0x00},
>>> +     { 0x0822, 0x00},
>>> +     { 0x0823, 0x00},
>>> +};
>>> +
>>> +static const struct imx258_reg mode_4208x3118_regs[] =3D {
>>> +     { 0x0136, 0x13},
>>> +     { 0x0137, 0x33},
>>> +     { 0x3051, 0x00},
>>> +     { 0x3052, 0x00},
>>> +     { 0x4E21, 0x14},
>>> +     { 0x6B11, 0xCF},
>>> +     { 0x7FF0, 0x08},
>>> +     { 0x7FF1, 0x0F},
>>> +     { 0x7FF2, 0x08},
>>> +     { 0x7FF3, 0x1B},
>>> +     { 0x7FF4, 0x23},
>>> +     { 0x7FF5, 0x60},
>>> +     { 0x7FF6, 0x00},
>>> +     { 0x7FF7, 0x01},
>>> +     { 0x7FF8, 0x00},
>>> +     { 0x7FF9, 0x78},
>>> +     { 0x7FFA, 0x00},
>>> +     { 0x7FFB, 0x00},
>>> +     { 0x7FFC, 0x00},
>>> +     { 0x7FFD, 0x00},
>>> +     { 0x7FFE, 0x00},
>>> +     { 0x7FFF, 0x03},
>>> +     { 0x7F76, 0x03},
>>> +     { 0x7F77, 0xFE},
>>> +     { 0x7FA8, 0x03},
>>> +     { 0x7FA9, 0xFE},
>>> +     { 0x7B24, 0x81},
>>> +     { 0x7B25, 0x00},
>>> +     { 0x6564, 0x07},
>>> +     { 0x6B0D, 0x41},
>>> +     { 0x653D, 0x04},
>>> +     { 0x6B05, 0x8C},
>>> +     { 0x6B06, 0xF9},
>>> +     { 0x6B08, 0x65},
>>> +     { 0x6B09, 0xFC},
>>> +     { 0x6B0A, 0xCF},
>>> +     { 0x6B0B, 0xD2},
>>> +     { 0x6700, 0x0E},
>>> +     { 0x6707, 0x0E},
>>> +     { 0x9104, 0x00},
>>> +     { 0x4648, 0x7F},
>>> +     { 0x7420, 0x00},
>>> +     { 0x7421, 0x1C},
>>> +     { 0x7422, 0x00},
>>> +     { 0x7423, 0xD7},
>>> +     { 0x5F04, 0x00},
>>> +     { 0x5F05, 0xED},
>>> +     { 0x0112, 0x0A},
>>> +     { 0x0113, 0x0A},
>>> +     { 0x0114, 0x03},
>>> +     { 0x0342, 0x14},
>>> +     { 0x0343, 0xE8},
>>> +     { 0x0340, 0x0C},
>>> +     { 0x0341, 0x50},
>>> +     { 0x0344, 0x00},
>>> +     { 0x0345, 0x00},
>>> +     { 0x0346, 0x00},
>>> +     { 0x0347, 0x00},
>>> +     { 0x0348, 0x10},
>>> +     { 0x0349, 0x6F},
>>> +     { 0x034A, 0x0C},
>>> +     { 0x034B, 0x2E},
>>> +     { 0x0381, 0x01},
>>> +     { 0x0383, 0x01},
>>> +     { 0x0385, 0x01},
>>> +     { 0x0387, 0x01},
>>> +     { 0x0900, 0x00},
>>> +     { 0x0901, 0x11},
>>> +     { 0x0401, 0x00},
>>> +     { 0x0404, 0x00},
>>> +     { 0x0405, 0x10},
>>> +     { 0x0408, 0x00},
>>> +     { 0x0409, 0x00},
>>> +     { 0x040A, 0x00},
>>> +     { 0x040B, 0x00},
>>> +     { 0x040C, 0x10},
>>> +     { 0x040D, 0x70},
>>> +     { 0x040E, 0x0C},
>>> +     { 0x040F, 0x30},
>>> +     { 0x3038, 0x00},
>>> +     { 0x303A, 0x00},
>>> +     { 0x303B, 0x10},
>>> +     { 0x300D, 0x00},
>>> +     { 0x034C, 0x10},
>>> +     { 0x034D, 0x70},
>>> +     { 0x034E, 0x0C},
>>> +     { 0x034F, 0x30},
>>> +     { 0x0202, 0x0C},
>>> +     { 0x0203, 0x46},
>>> +     { 0x0204, 0x00},
>>> +     { 0x0205, 0x00},
>>> +     { 0x020E, 0x01},
>>> +     { 0x020F, 0x00},
>>> +     { 0x0210, 0x01},
>>> +     { 0x0211, 0x00},
>>> +     { 0x0212, 0x01},
>>> +     { 0x0213, 0x00},
>>> +     { 0x0214, 0x01},
>>> +     { 0x0215, 0x00},
>>> +     { 0x7BCD, 0x00},
>>> +     { 0x94DC, 0x20},
>>> +     { 0x94DD, 0x20},
>>> +     { 0x94DE, 0x20},
>>> +     { 0x95DC, 0x20},
>>> +     { 0x95DD, 0x20},
>>> +     { 0x95DE, 0x20},
>>> +     { 0x7FB0, 0x00},
>>> +     { 0x9010, 0x3E},
>>> +     { 0x9419, 0x50},
>>> +     { 0x941B, 0x50},
>>> +     { 0x9519, 0x50},
>>> +     { 0x951B, 0x50},
>>> +     { 0x3030, 0x00},
>>> +     { 0x3032, 0x00},
>>> +     { 0x0220, 0x00},
>>> +};
>>> +
>>> +static const struct imx258_reg mode_2104_1560_regs[] =3D {
>>> +     { 0x0136, 0x13},
>>> +     { 0x0137, 0x33},
>>> +     { 0x3051, 0x00},
>>> +     { 0x3052, 0x00},
>>> +     { 0x4E21, 0x14},
>>> +     { 0x6B11, 0xCF},
>>> +     { 0x7FF0, 0x08},
>>> +     { 0x7FF1, 0x0F},
>>> +     { 0x7FF2, 0x08},
>>> +     { 0x7FF3, 0x1B},
>>> +     { 0x7FF4, 0x23},
>>> +     { 0x7FF5, 0x60},
>>> +     { 0x7FF6, 0x00},
>>> +     { 0x7FF7, 0x01},
>>> +     { 0x7FF8, 0x00},
>>> +     { 0x7FF9, 0x78},
>>> +     { 0x7FFA, 0x00},
>>> +     { 0x7FFB, 0x00},
>>> +     { 0x7FFC, 0x00},
>>> +     { 0x7FFD, 0x00},
>>> +     { 0x7FFE, 0x00},
>>> +     { 0x7FFF, 0x03},
>>> +     { 0x7F76, 0x03},
>>> +     { 0x7F77, 0xFE},
>>> +     { 0x7FA8, 0x03},
>>> +     { 0x7FA9, 0xFE},
>>> +     { 0x7B24, 0x81},
>>> +     { 0x7B25, 0x00},
>>> +     { 0x6564, 0x07},
>>> +     { 0x6B0D, 0x41},
>>> +     { 0x653D, 0x04},
>>> +     { 0x6B05, 0x8C},
>>> +     { 0x6B06, 0xF9},
>>> +     { 0x6B08, 0x65},
>>> +     { 0x6B09, 0xFC},
>>> +     { 0x6B0A, 0xCF},
>>> +     { 0x6B0B, 0xD2},
>>> +     { 0x6700, 0x0E},
>>> +     { 0x6707, 0x0E},
>>> +     { 0x9104, 0x00},
>>> +     { 0x4648, 0x7F},
>>> +     { 0x7420, 0x00},
>>> +     { 0x7421, 0x1C},
>>> +     { 0x7422, 0x00},
>>> +     { 0x7423, 0xD7},
>>> +     { 0x5F04, 0x00},
>>> +     { 0x5F05, 0xED},
>>> +     { 0x0112, 0x0A},
>>> +     { 0x0113, 0x0A},
>>> +     { 0x0114, 0x03},
>>> +     { 0x0342, 0x14},
>>> +     { 0x0343, 0xE8},
>>> +     { 0x0340, 0x06},
>>> +     { 0x0341, 0x38},
>>> +     { 0x0344, 0x00},
>>> +     { 0x0345, 0x00},
>>> +     { 0x0346, 0x00},
>>> +     { 0x0347, 0x00},
>>> +     { 0x0348, 0x10},
>>> +     { 0x0349, 0x6F},
>>> +     { 0x034A, 0x0C},
>>> +     { 0x034B, 0x2E},
>>> +     { 0x0381, 0x01},
>>> +     { 0x0383, 0x01},
>>> +     { 0x0385, 0x01},
>>> +     { 0x0387, 0x01},
>>> +     { 0x0900, 0x01},
>>> +     { 0x0901, 0x12},
>>> +     { 0x0401, 0x01},
>>> +     { 0x0404, 0x00},
>>> +     { 0x0405, 0x20},
>>> +     { 0x0408, 0x00},
>>> +     { 0x0409, 0x02},
>>> +     { 0x040A, 0x00},
>>> +     { 0x040B, 0x00},
>>> +     { 0x040C, 0x10},
>>> +     { 0x040D, 0x6A},
>>> +     { 0x040E, 0x06},
>>> +     { 0x040F, 0x18},
>>> +     { 0x3038, 0x00},
>>> +     { 0x303A, 0x00},
>>> +     { 0x303B, 0x10},
>>> +     { 0x300D, 0x00},
>>> +     { 0x034C, 0x08},
>>> +     { 0x034D, 0x38},
>>> +     { 0x034E, 0x06},
>>> +     { 0x034F, 0x18},
>>> +     { 0x0202, 0x06},
>>> +     { 0x0203, 0x2E},
>>> +     { 0x0204, 0x00},
>>> +     { 0x0205, 0x00},
>>> +     { 0x020E, 0x01},
>>> +     { 0x020F, 0x00},
>>> +     { 0x0210, 0x01},
>>> +     { 0x0211, 0x00},
>>> +     { 0x0212, 0x01},
>>> +     { 0x0213, 0x00},
>>> +     { 0x0214, 0x01},
>>> +     { 0x0215, 0x00},
>>> +     { 0x7BCD, 0x01},
>>> +     { 0x94DC, 0x20},
>>> +     { 0x94DD, 0x20},
>>> +     { 0x94DE, 0x20},
>>> +     { 0x95DC, 0x20},
>>> +     { 0x95DD, 0x20},
>>> +     { 0x95DE, 0x20},
>>> +     { 0x7FB0, 0x00},
>>> +     { 0x9010, 0x3E},
>>> +     { 0x9419, 0x50},
>>> +     { 0x941B, 0x50},
>>> +     { 0x9519, 0x50},
>>> +     { 0x951B, 0x50},
>>> +     { 0x3030, 0x00},
>>> +     { 0x3032, 0x00},
>>> +     { 0x0220, 0x00},
>>> +};
>>> +
>>> +static const struct imx258_reg mode_1048_780_regs[] =3D {
>>> +     { 0x0136, 0x13},
>>> +     { 0x0137, 0x33},
>>> +     { 0x3051, 0x00},
>>> +     { 0x3052, 0x00},
>>> +     { 0x4E21, 0x14},
>>> +     { 0x6B11, 0xCF},
>>> +     { 0x7FF0, 0x08},
>>> +     { 0x7FF1, 0x0F},
>>> +     { 0x7FF2, 0x08},
>>> +     { 0x7FF3, 0x1B},
>>> +     { 0x7FF4, 0x23},
>>> +     { 0x7FF5, 0x60},
>>> +     { 0x7FF6, 0x00},
>>> +     { 0x7FF7, 0x01},
>>> +     { 0x7FF8, 0x00},
>>> +     { 0x7FF9, 0x78},
>>> +     { 0x7FFA, 0x00},
>>> +     { 0x7FFB, 0x00},
>>> +     { 0x7FFC, 0x00},
>>> +     { 0x7FFD, 0x00},
>>> +     { 0x7FFE, 0x00},
>>> +     { 0x7FFF, 0x03},
>>> +     { 0x7F76, 0x03},
>>> +     { 0x7F77, 0xFE},
>>> +     { 0x7FA8, 0x03},
>>> +     { 0x7FA9, 0xFE},
>>> +     { 0x7B24, 0x81},
>>> +     { 0x7B25, 0x00},
>>> +     { 0x6564, 0x07},
>>> +     { 0x6B0D, 0x41},
>>> +     { 0x653D, 0x04},
>>> +     { 0x6B05, 0x8C},
>>> +     { 0x6B06, 0xF9},
>>> +     { 0x6B08, 0x65},
>>> +     { 0x6B09, 0xFC},
>>> +     { 0x6B0A, 0xCF},
>>> +     { 0x6B0B, 0xD2},
>>> +     { 0x6700, 0x0E},
>>> +     { 0x6707, 0x0E},
>>> +     { 0x9104, 0x00},
>>> +     { 0x4648, 0x7F},
>>> +     { 0x7420, 0x00},
>>> +     { 0x7421, 0x1C},
>>> +     { 0x7422, 0x00},
>>> +     { 0x7423, 0xD7},
>>> +     { 0x5F04, 0x00},
>>> +     { 0x5F05, 0xED},
>>> +     { 0x0112, 0x0A},
>>> +     { 0x0113, 0x0A},
>>> +     { 0x0114, 0x03},
>>> +     { 0x0342, 0x14},
>>> +     { 0x0343, 0xE8},
>>> +     { 0x0340, 0x03},
>>> +     { 0x0341, 0x4C},
>>> +     { 0x0344, 0x00},
>>> +     { 0x0345, 0x00},
>>> +     { 0x0346, 0x00},
>>> +     { 0x0347, 0x00},
>>> +     { 0x0348, 0x10},
>>> +     { 0x0349, 0x6F},
>>> +     { 0x034A, 0x0C},
>>> +     { 0x034B, 0x2E},
>>> +     { 0x0381, 0x01},
>>> +     { 0x0383, 0x01},
>>> +     { 0x0385, 0x01},
>>> +     { 0x0387, 0x01},
>>> +     { 0x0900, 0x01},
>>> +     { 0x0901, 0x14},
>>> +     { 0x0401, 0x01},
>>> +     { 0x0404, 0x00},
>>> +     { 0x0405, 0x40},
>>> +     { 0x0408, 0x00},
>>> +     { 0x0409, 0x06},
>>> +     { 0x040A, 0x00},
>>> +     { 0x040B, 0x00},
>>> +     { 0x040C, 0x10},
>>> +     { 0x040D, 0x64},
>>> +     { 0x040E, 0x03},
>>> +     { 0x040F, 0x0C},
>>> +     { 0x3038, 0x00},
>>> +     { 0x303A, 0x00},
>>> +     { 0x303B, 0x10},
>>> +     { 0x300D, 0x00},
>>> +     { 0x034C, 0x04},
>>> +     { 0x034D, 0x18},
>>> +     { 0x034E, 0x03},
>>> +     { 0x034F, 0x0C},
>>> +     { 0x0202, 0x03},
>>> +     { 0x0203, 0x42},
>>> +     { 0x0204, 0x00},
>>> +     { 0x0205, 0x00},
>>> +     { 0x020E, 0x01},
>>> +     { 0x020F, 0x00},
>>> +     { 0x0210, 0x01},
>>> +     { 0x0211, 0x00},
>>> +     { 0x0212, 0x01},
>>> +     { 0x0213, 0x00},
>>> +     { 0x0214, 0x01},
>>> +     { 0x0215, 0x00},
>>> +     { 0x7BCD, 0x00},
>>> +     { 0x94DC, 0x20},
>>> +     { 0x94DD, 0x20},
>>> +     { 0x94DE, 0x20},
>>> +     { 0x95DC, 0x20},
>>> +     { 0x95DD, 0x20},
>>> +     { 0x95DE, 0x20},
>>> +     { 0x7FB0, 0x00},
>>> +     { 0x9010, 0x3E},
>>> +     { 0x9419, 0x50},
>>> +     { 0x941B, 0x50},
>>> +     { 0x9519, 0x50},
>>> +     { 0x951B, 0x50},
>>> +     { 0x3030, 0x00},
>>> +     { 0x3032, 0x00},
>>> +     { 0x0220, 0x00},
>>> +};
>>> +
>>> +static const char * const imx258_test_pattern_menu[] =3D {
>>> +     "Disabled",
>>> +     "Vertical Color Bar Type 1",
>>> +     "Vertical Color Bar Type 2",
>>> +     "Vertical Color Bar Type 3",
>>> +     "Vertical Color Bar Type 4"
>>> +};
>>> +
>>> +/* Configurations for supported link frequencies */
>>> +#define IMX258_LINK_FREQ_634MHZ      633600000ULL
>>> +#define IMX258_LINK_FREQ_320MHZ      320000000ULL
>>> +
>>> +/*
>>> + * pixel_rate =3D link_freq * data-rate * nr_of_lanes /
>>> +bits_per_sample
>>> + * data rate =3D> double data rate; number of lanes =3D> 4; bits per
>>> +pixel =3D> 10  */ static u64 link_freq_to_pixel_rate(u64 f) {
>>> +     f *=3D 2 * 4;
>>> +     do_div(f, 10);
>>> +
>>> +     return f;
>>> +}
>>> +
>>> +/* Menu items for LINK_FREQ V4L2 control */ static const s64
>>> +link_freq_menu_items[] =3D {
>>> +     IMX258_LINK_FREQ_634MHZ,
>>> +     IMX258_LINK_FREQ_320MHZ,
>>> +};
>>> +
>>> +/* Link frequency configs */
>>> +static const struct imx258_link_freq_config link_freq_configs[] =3D {
>>> +     {
>>> +             .pixels_per_line =3D IMX258_PPL_DEFAULT,
>>> +             .reg_list =3D {
>>> +                     .num_of_regs =3D ARRAY_SIZE(mipi_data_rate_1267mb=
ps),
>>> +                     .regs =3D mipi_data_rate_1267mbps,
>>> +             }
>>> +     },
>>> +     {
>>> +             .pixels_per_line =3D IMX258_PPL_DEFAULT,
>>> +             .reg_list =3D {
>>> +                     .num_of_regs =3D ARRAY_SIZE(mipi_data_rate_640mbp=
s),
>>> +                     .regs =3D mipi_data_rate_640mbps,
>>> +             }
>>> +     },
>>> +};
>
> I also had comments for using explicit indices in this array, to avoid mi=
stakes in supported_modes[] below.
>
>>> +
>>> +/* Mode configs */
>>> +static const struct imx258_mode supported_modes[] =3D {
>>> +     {
>>> +             .width =3D 4208,
>>> +             .height =3D 3118,
>>> +             .vts_def =3D IMX258_VTS_30FPS,
>>> +             .vts_min =3D IMX258_VTS_30FPS,
>>> +             .reg_list =3D {
>>> +                     .num_of_regs =3D ARRAY_SIZE(mode_4208x3118_regs),
>>> +                     .regs =3D mode_4208x3118_regs,
>>> +             },
>>> +             .link_freq_index =3D 0,
>>> +     },
>>> +     {
>>> +             .width =3D 2104,
>>> +             .height =3D 1560,
>>> +             .vts_def =3D IMX258_VTS_30FPS,
>>> +             .vts_min =3D 1608,
>>> +             .reg_list =3D {
>>> +                     .num_of_regs =3D ARRAY_SIZE(mode_2104_1560_regs),
>>> +                     .regs =3D mode_2104_1560_regs,
>>> +             },
>>> +             .link_freq_index =3D 1,
>>> +     },
>>> +     {
>>> +             .width =3D 1048,
>>> +             .height =3D 780,
>>> +             .vts_def =3D IMX258_VTS_30FPS,
>>> +             .vts_min =3D 804,
>>> +             .reg_list =3D {
>>> +                     .num_of_regs =3D ARRAY_SIZE(mode_1048_780_regs),
>>> +                     .regs =3D mode_1048_780_regs,
>>> +             },
>>> +             .link_freq_index =3D 1,
>>> +     },
>>> +};
>>> +
>>> +struct imx258 {
>>> +     struct v4l2_subdev sd;
>>> +     struct media_pad pad;
>>> +
>>> +     struct v4l2_ctrl_handler ctrl_handler;
>>> +     /* V4L2 Controls */
>>> +     struct v4l2_ctrl *link_freq;
>>> +     struct v4l2_ctrl *pixel_rate;
>>> +     struct v4l2_ctrl *vblank;
>>> +     struct v4l2_ctrl *hblank;
>>> +     struct v4l2_ctrl *exposure;
>>> +
>>> +     /* Current mode */
>>> +     const struct imx258_mode *cur_mode;
>>> +
>>> +     /* Mutex for serialized access */
>>> +     struct mutex mutex;
>>> +     /*
>>> +      * Protect sensor module set pad format and start streaming norma=
lly.
>>> +      */
>>> +
>>> +     /* Streaming on/off */
>>> +     bool streaming;
>>> +};
>>> +
>>> +#define to_imx258(_sd)       container_of(_sd, struct imx258, sd)
>>> +
>>> +/* Read registers up to 2 at a time */ static int
>>> +imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val) {
>>> +     struct i2c_client *client =3D v4l2_get_subdevdata(&imx258->sd);
>>> +     struct i2c_msg msgs[2];
>>> +     u8 addr_buf[2] =3D { reg >> 8, reg & 0xff };
>>> +     u8 data_buf[4] =3D { 0, };
>>> +     int ret;
>>> +
>>> +     if (len > 4)
>>> +             return -EINVAL;
>>> +
>>> +     /* Write register address */
>>> +     msgs[0].addr =3D client->addr;
>>> +     msgs[0].flags =3D 0;
>>> +     msgs[0].len =3D ARRAY_SIZE(addr_buf);
>>> +     msgs[0].buf =3D addr_buf;
>>> +
>>> +     /* Read data from register */
>>> +     msgs[1].addr =3D client->addr;
>>> +     msgs[1].flags =3D I2C_M_RD;
>>> +     msgs[1].len =3D len;
>>> +     msgs[1].buf =3D &data_buf[4 - len];
>>> +
>>> +     ret =3D i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
>>> +     if (ret !=3D ARRAY_SIZE(msgs))
>>> +             return -EIO;
>>> +
>>> +     *val =3D get_unaligned_be32(data_buf);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/* Write registers up to 2 at a time */ static int
>>> +imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val) {
>>> +     struct i2c_client *client =3D v4l2_get_subdevdata(&imx258->sd);
>>> +     u8 __buf[6], *buf =3D __buf;
>>> +
>>> +     if (len > 4)
>>> +             return -EINVAL;
>>> +
>>> +     *buf++ =3D reg >> 8;
>>> +     *buf++ =3D reg & 0xff;
>>
>> You assign reg in variable declaration in imx258_read_reg(). Could you
>> do the same here? Or even better, use put_unaligned_be16().
>>
>> I wasn't aware of these functions, thanks for introducing them to me.
>> :-)
>>
>> You can then remove buf and rename __buf as buf.
>
> I believe I gave an exact implementation, without that problem, in my pre=
vious comments actually.
>
> Andy, please, really please, go through all the comments in my reply to v=
6 on the list and make sure that they are all addressed. Perhaps reply to i=
t, with "Okay" next to each comment, to make sure some of the message was n=
ot lost due to some weird mail client settings.
>
> Best regards,
> Tomasz
