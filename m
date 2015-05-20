Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34873 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbETNr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 09:47:29 -0400
Message-id: <555C906D.4030902@samsung.com>
Date: Wed, 20 May 2015 15:47:25 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: Re: [PATCH 4/5] leds: aat1290: Pass dev and dev->of_node to
 v4l2_flash_init()
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
 <1432076645-4799-5-git-send-email-sakari.ailus@iki.fi>
 <555C582E.8000807@samsung.com> <555C63CF.2020304@samsung.com>
 <20150520122714.GC8365@valkosipuli.retiisi.org.uk>
In-reply-to: <20150520122714.GC8365@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 02:27 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, May 20, 2015 at 12:37:03PM +0200, Jacek Anaszewski wrote:
>> On 05/20/2015 11:47 AM, Jacek Anaszewski wrote:
>>> Hi Sakari,
>>>
>>> On 05/20/2015 01:04 AM, Sakari Ailus wrote:
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>> ---
>>>>   drivers/leds/leds-aat1290.c |    5 ++---
>>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
>>>> index c656a2d..71bf6bb 100644
>>>> --- a/drivers/leds/leds-aat1290.c
>>>> +++ b/drivers/leds/leds-aat1290.c
>>>> @@ -524,9 +524,8 @@ static int aat1290_led_probe(struct
>>>> platform_device *pdev)
>>>>       led_cdev->dev->of_node = sub_node;
>>>>
>>>>       /* Create V4L2 Flash subdev. */
>>>> -    led->v4l2_flash = v4l2_flash_init(fled_cdev,
>>>> -                      &v4l2_flash_ops,
>>>> -                      &v4l2_sd_cfg);
>>>> +    led->v4l2_flash = v4l2_flash_init(dev, NULL, fled_cdev,
>>>> +                      &v4l2_flash_ops, &v4l2_sd_cfg);
>>>
>>> Here the first argument should be led_cdev->dev, not dev, which is
>>> &pdev->dev, whereas led_cdev->dev is returned by
>>> device_create_with_groups (it takes dev as a parent) called from
>>> led_classdev_register.
>>
>> The reason for this is the fact that pdev->dev has its of_node
>> field initialized, which makes v4l2_async trying to match
>> subdev by parent node of a LED device, not by sub-LED related
>> DT node.
>
> If v4l2_subdev->of_node is set, then it won't be replaced with one from
> struct device. I.e. you need to provide of_node pointer only if it's
> different from dev->of_node.
>

It will always be different since dev->of_node pointer is related
to the main DT node of LED device, whereas each LED connected to it
must be expressed in the form of sub-node, as
Documentation/devicetree/bindings/leds/common.txt DT states.

-- 
Best Regards,
Jacek Anaszewski
