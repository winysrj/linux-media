Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:16362 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbeF0Avd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 20:51:33 -0400
Subject: Re: [PATCH v4] media: add imx319 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@google.com, jacopo@jmondi.org,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com
References: <1527761964-13056-1-git-send-email-bingbu.cao@intel.com>
 <20180626151535.e6uju7pbmnwqnd4t@kekkonen.localdomain>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <6ff0a333-1d90-6660-6528-130669d08a7f@linux.intel.com>
Date: Wed, 27 Jun 2018 08:54:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180626151535.e6uju7pbmnwqnd4t@kekkonen.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/26/2018 11:15 PM, Sakari Ailus wrote:
> Hi Bingbu,
>
> On Thu, May 31, 2018 at 06:19:24PM +0800, bingbu.cao@intel.com wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
>> This is a camera sensor using the i2c bus for control and the
>> csi-2 bus for data.
>>
>> This driver supports following features:
>> - manual exposure and analog/digital gain control support
>> - vblank/hblank control support
>> -  4 test patterns control support
>> - vflip/hflip control support (will impact the output bayer order)
>> - support following resolutions:
>>     - 3264x2448, 3280x2464 @ 30fps
>>     - 1936x1096, 1920x1080 @ 60fps
>>     - 1640x1232, 1640x922, 1296x736, 1280x720 @ 120fps
>> - support 4 bayer orders output (via change v/hflip)
>>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
>>
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> Could you obtain the CSI-2 bus speed as well as the external clock
> frequency from the firmware? See e.g.
> drivers/media/i2c/smiapp/smiapp-core.c and
> v4l2_fwnode_endpoint_alloc_parse() there. You could use the clock-frequency
> property for the clock.
Ack.
> ...
>
>> +static void imx319_free_controls(struct imx319 *imx319)
>> +{
>> +	v4l2_ctrl_handler_free(imx319->sd.ctrl_handler);
>> +}
> Please use v4l2_ctrl_handler_free() directly instead, and remove this
> function.
>
> Both apply to the imx355 driver as well.
Ack.
>
