Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbeFAJvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 05:51:52 -0400
Subject: Re: [RESEND PATCH V2 2/2] media: ak7375: Add ak7375 lens voice coil
 driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com, tfiga@chromium.org
References: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
 <1527242135-22866-2-git-send-email-bingbu.cao@intel.com>
 <20180601093416.i5mnos5titb5ggiz@paasikivi.fi.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <a0f63669-db91-7174-1f88-761bff6af0d3@linux.intel.com>
Date: Fri, 1 Jun 2018 17:54:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180601093416.i5mnos5titb5ggiz@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018年06月01日 17:34, Sakari Ailus wrote:
> Hi Bingbu,
>
> A few comments below.
>
> On Fri, May 25, 2018 at 05:55:35PM +0800, bingbu.cao@intel.com wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> Add a V4L2 sub-device driver for the ak7375 lens voice coil.
>> This is a voice coil module using the I2C bus to control the
>> focus position.
>>
>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> ---
>>   MAINTAINERS                |   8 ++
>>   drivers/media/i2c/Kconfig  |  10 ++
>>   drivers/media/i2c/Makefile |   1 +
>>   drivers/media/i2c/ak7375.c | 278 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 297 insertions(+)
>>   create mode 100644 drivers/media/i2c/ak7375.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ea362219c4aa..20379a7baca0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -625,6 +625,14 @@ T:	git git://linuxtv.org/anttip/media_tree.git
>>   S:	Maintained
>>   F:	drivers/media/usb/airspy/
>>   
>> +AKM AK7375 LENS VOICE COIL DRIVER
>> +M:	Tianshu Qiu <tian.shu.qiu@intel.com>
>> +L:	linux-media@vger.kernel.org
>> +T:	git git://linuxtv.org/media_tree.git
>> +S:	Maintained
>> +F:	drivers/media/i2c/ak7375.c
>> +F:	Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt
> The name of the file also needs to match. Currently it doesn't. How about
> "asahi-kasei,ak7375.txt"?
Ack.
Does it make sense if just change the compatible string to 
"asahi-kasei,ak7375" and keep the file name unchanged?
I have no clear idea about the DT binding rules.
>
> Could you also move the MAINTAINERS entry to the patch adding the DT
> bindings?
Ack.
>
>> +
>>   ALACRITECH GIGABIT ETHERNET DRIVER
>>   M:	Lino Sanfilippo <LinoSanfilippo@gmx.de>
>>   S:	Maintained
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 341452fe98df..ff3cb5afb0e1 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -326,6 +326,16 @@ config VIDEO_AD5820
>>   	  This is a driver for the AD5820 camera lens voice coil.
>>   	  It is used for example in Nokia N900 (RX-51).
>>   
>> +config VIDEO_AK7375
>> +	tristate "AK7375 lens voice coil support"
>> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +	depends on VIDEO_V4L2_SUBDEV_API
>> +	help
>> +	  This is a driver for the AK7375 camera lens voice coil.
>> +	  AK7375 is a 12 bit DAC with 120mA output current sink
>> +	  capability. This is designed for linear control of
>> +	  voice coil motors, controlled via I2C serial interface.
>> +
>>   config VIDEO_DW9714
>>   	tristate "DW9714 lens voice coil support"
>>   	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index d679d57cd3b3..05b97e319ea9 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -23,6 +23,7 @@ obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
>>   obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>>   obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
>>   obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
>> +obj-$(CONFIG_VIDEO_AK7375)  += ak7375.o
>>   obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
>>   obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>>   obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
>> diff --git a/drivers/media/i2c/ak7375.c b/drivers/media/i2c/ak7375.c
>> new file mode 100644
>> index 000000000000..012e673e9ced
>> --- /dev/null
>> +++ b/drivers/media/i2c/ak7375.c
> ...
>
>> +static const struct of_device_id ak7375_of_table[] = {
>> +	{ .compatible = "akm,ak7375" },
> "asahi-kasei,ak7375"
>
