Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BC5C04EB9
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A1820838
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99A1820838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbeLFMc7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 07:32:59 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55576 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729409AbeLFMc6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 07:32:58 -0500
Received: from [IPv6:2001:420:44c1:2579:257d:be73:2120:ab20] ([IPv6:2001:420:44c1:2579:257d:be73:2120:ab20])
        by smtp-cloud8.xs4all.net with ESMTPA
        id UspogZMQYO44XUsprgUSvQ; Thu, 06 Dec 2018 13:32:56 +0100
Subject: Re: [PATCH v5] media: imx: add mem2mem device
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
 <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
 <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
 <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
 <b93de9f7-0ef7-6b13-594f-c8ef750554ea@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6f0d8d9b-1609-a610-57f0-27223ddcc942@xs4all.nl>
Date:   Thu, 6 Dec 2018 13:32:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <b93de9f7-0ef7-6b13-594f-c8ef750554ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfILyeEs0MvK2FHOeK8cpG8NrnBqu75omca6IEDFADvzAfyvoOTAVLDJeWyivEIldKyLgsnC53AjGDEUtzffzXngw3CWn3OKfx9/6U4qnIghWPa03QP6N
 NPqq4vza+Gf3rMdbIpgXvRnEPXudK9bWzpKIZdWi30kx1KCBkA2ud9wPwe66BCEftH+TVBFD5zujmu1LfPGu3Z5nwvV0XKu3EuZngId45lPh+2AzXrIGqT1J
 oJrIwrBW99WJB/zpAeODymSG7shNFO7KEs/NbfeSFJFobEgyovLqFx58INh6VGT94h05Nc9IAN4KbGDjOJqadFntxptoTaHfCmqpfcKVG9MB0iOALCMHXWla
 xRQsQENXPTwcqh01R9wpL8TynSZ0q/AJF3uzkQFqWm9zCQgDqUXx052maEeOkRCSjYEL1Gd/
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/06/18 00:13, Steve Longerbeam wrote:
> 
> 
> On 12/5/18 10:50 AM, Hans Verkuil wrote:
>> On 12/05/2018 02:20 AM, Steve Longerbeam wrote:
>>> Hi Hans, Philipp,
>>>
>>> One comment on my side...
>>>
>>> On 12/3/18 7:21 AM, Hans Verkuil wrote:
>>>> <snip>
>>>>> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
>>>>> +{
>>>>> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
>>>>> +	struct video_device *vfd = priv->vdev.vfd;
>>>>> +
>>>>> +	mutex_lock(&priv->mutex);
>>>>> +
>>>>> +	if (video_is_registered(vfd)) {
>>>>> +		video_unregister_device(vfd);
>>>>> +		media_entity_cleanup(&vfd->entity);
>>>> Is this needed?
>>>>
>>>> If this is to be part of the media controller, then I expect to see a call
>>>> to v4l2_m2m_register_media_controller() somewhere.
>>>>
>>> Yes, I agree there should be a call to
>>> v4l2_m2m_register_media_controller(). This driver does not connect with
>>> any of the imx-media entities, but calling it will at least make the
>>> mem2mem output/capture device entities (and processing entity) visible
>>> in the media graph.
>>>
>>> Philipp, can you pick/squash the following from my media-tree github fork?
>>>
>>> 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
>>> d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem
>>> device")
>>> 6787a50cdc ("media: imx: mem2mem: Register with media control")
>>>
>>> Steve
>>>
>> Why is this driver part of the imx driver? Since it doesn't connect with
>> any of the imx-media entities, doesn't that mean that this is really a
>> stand-alone driver?
> 
> It is basically a stand-alone m2m driver, but it makes use of some 
> imx-media utility functions like imx_media_enum_format(). Also making it 
> a true stand-alone driver would require creating a second /dev/mediaN 
> device.

If it is standalone, is it reused in newer iMX versions? (7 or 8)

And if it is just a regular m2m device, then it doesn't need to create a
media device either (doesn't hurt, but it is not required).

Regards,

	Hans

> 
> Steve
> 

