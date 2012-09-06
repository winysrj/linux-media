Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2IFONo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 10:13:44 -0400
Received: by qaas11 with SMTP id s11so1403468qaa.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 07:13:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5047CAA2.4050702@gmail.com>
References: <1346848110-17882-1-git-send-email-sangwook.lee@linaro.org>
	<5047CAA2.4050702@gmail.com>
Date: Thu, 6 Sep 2012 15:13:43 +0100
Message-ID: <CADPsn1Yi50DmE4g6C5iev9DbLBSPuOkxMKVbC7ErmeCSXre+jA@mail.gmail.com>
Subject: Re: [RFC PATCH v5] media: add v4l2 subdev driver for S5K4ECGX sensor
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Scott Bambrough <scott.bambrough@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

Thank you for the review again.

On 5 September 2012 22:56, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Sangwook,
>
> On 09/05/2012 02:28 PM, Sangwook Lee wrote:
[snip]
>> +#include<linux/vmalloc.h>
>
> What do we need this header for ?

Ok, let me delete this.

>
>> +
>> +#include<media/media-entity.h>
>> +#include<media/s5k4ecgx.h>
>> +#include<media/v4l2-ctrls.h>
>> +#include<media/v4l2-device.h>
>> +#include<media/v4l2-mediabus.h>
>> +#include<media/v4l2-subdev.h>
> ...
>> +
>> +static int s5k4ecgx_set_ahb_address(struct v4l2_subdev *sd)
>> +{
>> +     int ret;
>> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +     /* Set APB peripherals start address */
>> +     ret = s5k4ecgx_i2c_write(client, AHB_MSB_ADDR_PTR, GEN_REG_OFFSH);
>> +     if (ret)
>> +             return ret;
>> +     /*
>> +      * FIXME: This is copied from s5k6aa, because of no information
>> +      * in s5k4ecgx's datasheet.
>> +      * sw_reset is activated to put device into idle status
>> +      */
>> +     ret = s5k4ecgx_i2c_write(client, 0x0010, 0x0001);
>> +     if (ret)
>> +             return ret;
>> +
>> +     /* FIXME: no information available about this register */
>
> Let's drop that comment, we will fix all magic numbers once proper
> documentation is available.

Ok.

>
>> +     ret = s5k4ecgx_i2c_write(client, 0x1030, 0x0000);
>> +     if (ret)
>> +             return ret;
>> +     /* Halt ARM CPU */
>> +     ret = s5k4ecgx_i2c_write(client, 0x0014, 0x0001);
>> +
>> +     return ret;
>
> Just do
>
>         return s5k4ecgx_i2c_write(client, 0x0014, 0x0001);

OK, I will fix this.

>> +}
>> +
>> +#define FW_HEAD 6
>> +/* Register address, value are 4, 2 bytes */
>> +#define FW_REG_SIZE 6
>
> FW_REG_SIZE is a bit confusing, maybe we could name this FW_RECORD_SIZE
> or something similar ?

Fair enough

>
>> +/*
>> + * Firmware has the following format:
>> + *<total number of records (4-bytes + 2-bytes padding) N>,<  record 0>,
>> + *<  record N - 1>,<  CRC32-CCITT (4-bytes)>
>> + * where "record" is a 4-byte register address followed by 2-byte
>> + * register value (little endian)
>> + */
>> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>> +{
>> +     const struct firmware *fw;
>> +     int err, i, regs_num;
>> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +     u16 val;
>> +     u32 addr, crc, crc_file, addr_inc = 0;
>> +     u8 *fwbuf;
>> +
>> +     err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
>> +     if (err) {
>> +             v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
>> +             goto fw_out1;
>
> return err;

OK, I will fix this.

>
> ?
>> +     }
>> +     fwbuf = kmemdup(fw->data, fw->size, GFP_KERNEL);
>
> Why do we need this kmemdup ? Couldn't we just use fw->data ?

OK,  Iet me reconsider this.

>
>> +     if (!fwbuf) {
>> +             err = -ENOMEM;
>> +             goto fw_out2;
>> +     }
>> +     crc_file = *(u32 *)(fwbuf + regs_num * FW_REG_SIZE);
>
> regs_num is uninitialized ?
>
>> +     crc = crc32_le(~0, fwbuf, regs_num * FW_REG_SIZE);
>> +     if (crc != crc_file) {
>> +             v4l2_err(sd, "FW: invalid crc (%#x:%#x)\n", crc, crc_file);
>> +             err = -EINVAL;
>> +             goto fw_out3;
>> +     }
>> +     regs_num = *(u32 *)(fwbuf);
>
> I guess this needs to be moved up. I would make it
>
>         regs_num = le32_to_cpu(*(u32 *)fw->data);
>
> And perhaps we need a check like:
>
>         if (fw->size < regs_num * FW_REG_SIZE)
>                 return -EINVAL;
> ?
>> +     v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
>> +              S5K4ECGX_FIRMWARE, fw->size, regs_num);
>> +     regs_num++; /* Add header */
>> +     for (i = 1; i<  regs_num; i++) {
>> +             addr = *(u32 *)(fwbuf + i * FW_REG_SIZE);
>> +             val = *(u16 *)(fwbuf + i * FW_REG_SIZE + 4);
>
> I think you need to access addr and val through le32_to_cpu() as well,
> even though your ARM system might be little-endian by default, this
> driver could possibly be used on machines with different endianness.
>
> Something like this could be more optimal:
>
>         const u8 *ptr = fw->data + FW_REG_SIZE;
>
>         for (i = 1; i < regs_num; i++) {
>                 addr = le32_to_cpu(*(u32 *)ptr);
>                 ptr += 4;
>                 val = le16_to_cpu(*(u16 *)ptr);
>                 ptr += FW_REG_SIZE;
>

Thanks for your advice. I will take le32(16)_to_cpu.


>> +             if (addr - addr_inc != 2)
>> +                     err = s5k4ecgx_write(client, addr, val);
>> +             else
>> +                     err = s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR, val);
>> +             if (err)
>> +                     goto fw_out3;
>
> nit: break instead of goto ?
Ok, I will fix this.

>
>> +             addr_inc = addr;
>> +     }
>> +fw_out3:
>> +     kfree(fwbuf);
>> +fw_out2:
>> +     release_firmware(fw);
>> +fw_out1:
>> +
>> +     return err;
>> +}
> ...
>> +static int s5k4ecgx_init_sensor(struct v4l2_subdev *sd)
>> +{
>> +     int ret;
>> +
>> +     ret = s5k4ecgx_set_ahb_address(sd);
>> +     /* The delay is from manufacturer's settings */
>> +     msleep(100);
>> +
>> +     ret |= s5k4ecgx_load_firmware(sd);
>
>         if (!ret)
>                 ret = s5k4ecgx_load_firmware(sd);
>         else
> ?

Ok, I will fix this.

>> +
>> +     if (ret)
>> +             v4l2_err(sd, "Failed to write initial settings\n");
>> +
>> +     return 0;
>
>         return ret; ?
> ...
>> +module_i2c_driver(v4l2_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("Samsung S5K4ECGX 5MP SOC camera");
>> +MODULE_AUTHOR("Sangwook Lee<sangwook.lee@linaro.org>");
>> +MODULE_AUTHOR("Seok-Young Jang<quartz.jang@samsung.com>");
>
> Was there anything really contributed by this person ?

I think I have to give him some credits because I started to work on
the sensor driver which
was originally based on his driver source code. In fact I didn't add
the name, simply
his information was there, so I didn't delete the name, even though
later the driver was getting
more and more from s5k6aa driver.


>
>> +MODULE_LICENSE("GPL");
>> +MODULE_FIRMWARE(S5K4ECGX_FIRMWARE);
>> diff --git a/include/media/s5k4ecgx.h b/include/media/s5k4ecgx.h
>> new file mode 100644
>> index 0000000..fbed5cb
>> --- /dev/null
>> +++ b/include/media/s5k4ecgx.h
>> @@ -0,0 +1,37 @@
>> +/*
>> + * S5K4ECGX image sensor header file
>> + *
>> + * Copyright (C) 2012, Linaro
>> + * Copyright (C) 2011, Samsung Electronics Co., Ltd.
>
> 2011 -> 2012 ?
Ok, I will fix this.

>
> Otherwise looks good. Would be interesting to add capture support
> to this driver later. I've seen it supports JPEG compressed stream,
> also with interleaved preview raw data inside it.

Yes, we can tackle this later.

>
> We have similar problem with S5C73M3 sensor, you have to configure
> two resolutions for JPEG and YUV for a single stream. Here you
> additionally could choose from various preview "sub-stream" pixel
> formats (YCBCR, RGB, etc.).
>
> --
>
> Regards,
> Sylwester

Regards
Sangwook
