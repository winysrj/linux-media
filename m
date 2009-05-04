Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:6419 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbZEDOER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 10:04:17 -0400
Received: by ey-out-2122.google.com with SMTP id 9so980314eyd.37
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 07:04:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18097.62.70.2.252.1241442220.squirrel@webmail.xs4all.nl>
References: <18097.62.70.2.252.1241442220.squirrel@webmail.xs4all.nl>
Date: Mon, 4 May 2009 18:04:16 +0400
Message-ID: <208cbae30905040704p7ec02d9bm4ef1e2fe6af63c93@mail.gmail.com>
Subject: Re: [questions] dmesg: Non-NULL drvdata on register
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 4, 2009 at 5:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hello,
>>
>> Not so many time ago i noticed such line in dmesg:
>>
>> radio-mr800 2-1:1.0: Non-NULL drvdata on register
>>
>> Quick review showed that it appears in usb_amradio_probe fucntions. Then
>> i found such code in v4l2_device_register() function (v4l2-device.c
>> file):
>>
>> /* Set name to driver name + device name if it is empty. */
>>         if (!v4l2_dev->name[0])
>>                 snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %
>> s",
>>                         dev->driver->name, dev_name(dev));
>>         if (dev_get_drvdata(dev))
>>                 v4l2_warn(v4l2_dev, "Non-NULL drvdata on register\n");
>>         dev_set_drvdata(dev, v4l2_dev);
>>         return 0;
>>
>> The questions is - should i deal with this warning in dmesg? Probably
>> the order of callbacks in radio-mr800 probe function is incorrect.
>
> I (or you :-) should look into this: I think the usb subsystem is calling
> dev_set_drvdata as well, so we could have a clash here.

I can if i'll find free time for this :)

>> The second questions - should i make atomic_t users counter instead of
>> int users counter? Then i can use atomic_inc(), atomic_dec(),
>> atomic_set(). It helps me to remove lock/unlock_kernel() functions.
>
> 'users' can go away completely: if you grep for it, then you'll see that
> it is only set, but never used.
>
> I think I've commented on the kernel lock before: I think it is bogus
> here. And that the amradio_set_mute handling is wrong as well: you open
> the radio device twice, then close one file descriptor, and suddenly the
> audio will be muted, even though there still is a file descriptor open.
>
> Regards,
>
>        Hans

Well, looks like it's possible to null usb_amradio_open, right?
The only reason why users counter here is suspend/resume handling.
The idea was to stop radio in suspend procedure if there users>0 and
start radio on resume if users>0. If there are no users we can do
nothing on suspend/resume. The decision was based on radio->users
counter, and i see that i can do this using radio->muted.
This idea was not implemented yet. May i ask your comments here, Hans?

-- 
Best regards, Klimov Alexey
