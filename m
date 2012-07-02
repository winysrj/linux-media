Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43379 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2GBPYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 11:24:47 -0400
Received: by wibhm11 with SMTP id hm11so3297149wib.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2012 08:24:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF1B338.5040900@redhat.com>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl> <4FF1B338.5040900@redhat.com>
From: halli manjunatha <hallimanju@gmail.com>
Date: Mon, 2 Jul 2012 10:24:24 -0500
Message-ID: <CAMT6PydCWyByrYfzOqJQXy5ntef55mn83kHQOzqSDKW-x=TtFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Add frequency band information
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This looks good to me

Acked-by: Manjunatha Halli <manjunatha_halli@ti.com>

Regards
Manju

On Mon, Jul 2, 2012 at 9:42 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> Series looks good to me, ack series:
> Acked-by: Hans de Goede <hdegoede@redhat.com>
>
> Regards,
>
> Hans
>
>
> On 07/02/2012 04:15 PM, Hans Verkuil wrote:
>>
>> Hi all,
>>
>> This patch series adds support for the new VIDIOC_ENUM_FREQ_BANDS ioctl that
>> tells userspace if a tuner supports multiple frequency bands.
>>
>> This API is based on earlier attempts:
>>
>> http://www.spinics.net/lists/linux-media/msg48391.html
>> http://www.spinics.net/lists/linux-media/msg48435.html
>>
>> And an irc discussion:
>>
>> http://linuxtv.org/irc/v4l/index.php?date=2012-06-26
>>
>> This irc discussion also talked about adding rangelow/high to the v4l2_hw_freq_seek
>> struct, but I decided not to do that. The hwseek additions are independent to this
>> patch series, and I think it is best if Hans de Goede does that part so that that
>> API change can be made together with a driver that actually uses it.
>>
>> In order to show how the new ioctl is used, this patch series adds support for it
>> to the very, very old radio-cadet driver.
>>
>> Comments are welcome!
>>
>> Regards,
>>
>>         Hans
>>
>> PS: Mauro, I haven't been able to work on the radio profile yet, so that's not
>> included.
>>
>



--
Regards
Halli
