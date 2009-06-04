Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3288 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZFDJ1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 05:27:37 -0400
Message-ID: <5143.62.70.2.252.1244107655.squirrel@webmail.xs4all.nl>
Date: Thu, 4 Jun 2009 11:27:35 +0200 (CEST)
Subject: Re: [PATCH]V4L:some v4l drivers have error for
     video_register_device
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: "Laurent Pinchart" <laurent.pinchart@skynet.be>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, 2009-06-04 at 11:18 +0200, Laurent Pinchart wrote:
>> Hi,
>>
>> On Thursday 04 June 2009 06:20:07 figo.zhang wrote:
>> > The function video_register_device() will call the
>> > video_register_device_index(). In this function, firtly it will do
>> some
>> > argments check , if failed,it will return a negative number such as
>> > -EINVAL, and then do cdev_alloc() and device_register(), if success
>> return
>> > zero. so video_register_device_index() canot return a a positive
>> number.
>> >
>> > for example, see the drivers/media/video/stk-webcam.c (line 1325):
>> >
>> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
>> > 	if (err)
>> > 		STK_ERROR("v4l registration failed\n");
>> > 	else
>> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
>> > 			" /dev/video%d\n", dev->vdev.num);
>> >
>> > in my opinion, it will be cleaner to do something like this:
>> >
>> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
>> > 	if (err != 0)
>> > 		STK_ERROR("v4l registration failed\n");
>> > 	else
>> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
>> > 			" /dev/video%d\n", dev->vdev.num);
>>
>> What's the difference ? (err != 0) and (err) are identical.
>>
>> Best regards,
>>
>> Laurent Pinchart
>
> yes, it is the same, but it is easy for reading.

To be honest, I think '(err)' is easier to read. Unless there is some new
CodingStyle rule I'm not aware of I see no reason for applying these
changes.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

