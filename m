Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12076 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbbFSG1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 02:27:22 -0400
Message-id: <5583B645.601@samsung.com>
Date: Fri, 19 Jun 2015 08:27:17 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-leds@vger.kernel.org,
	Linux Media <linux-media@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v9 2/8] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1432566843-6391-1-git-send-email-j.anaszewski@samsung.com>
 <1432566843-6391-3-git-send-email-j.anaszewski@samsung.com>
 <CALW4P+JBbBZa4rQcMtxhWGD+cEa7yHE_pWazxpDaK25xf08N4Q@mail.gmail.com>
In-reply-to: <CALW4P+JBbBZa4rQcMtxhWGD+cEa7yHE_pWazxpDaK25xf08N4Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On 06/18/2015 07:45 PM, Alexey Klimov wrote:
> Hi Jacek,
>
> On Mon, May 25, 2015 at 6:13 PM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> This patch adds helper functions for registering/unregistering
>> LED Flash class devices as V4L2 sub-devices. The functions should
>> be called from the LED subsystem device driver. In case the
>> support for V4L2 Flash sub-devices is disabled in the kernel
>> config the functions' empty versions will be used.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/v4l2-core/Kconfig                |   11 +
>>   drivers/media/v4l2-core/Makefile               |    2 +
>>   drivers/media/v4l2-core/v4l2-flash-led-class.c |  671 ++++++++++++++++++++++++
>>   include/media/v4l2-flash-led-class.h           |  148 ++++++
>>   4 files changed, 832 insertions(+)
>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash-led-class.c
>>   create mode 100644 include/media/v4l2-flash-led-class.h
[...]
>> +struct v4l2_flash *v4l2_flash_init(
>> +       struct device *dev, struct device_node *of_node,
>> +       struct led_classdev_flash *fled_cdev,
>> +       struct led_classdev_flash *iled_cdev,
>> +       const struct v4l2_flash_ops *ops,
>> +       struct v4l2_flash_config *config)
>> +{
>> +       struct v4l2_flash *v4l2_flash;
>
>> +       struct led_classdev *led_cdev = &fled_cdev->led_cdev;
>> +       struct v4l2_subdev *sd;
>> +       int ret;
>> +
>> +       if (!fled_cdev || !ops || !config)
>> +               return ERR_PTR(-EINVAL);
>
> Could you please if it is correct? You're checking fled_cdev but four
> lines above you're using fled_cdev and taking led_cdev pointer from
> there. Maybe it's better to move calculation of led_cdev down and
> place after if-check?

Thanks for spotting this. I'll submit fixed version soon.

-- 
Best Regards,
Jacek Anaszewski
