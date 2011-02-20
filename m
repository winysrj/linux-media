Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1BTJfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 04:35:32 -0500
Received: by wyb38 with SMTP id 38so230979wyb.19
        for <linux-media@vger.kernel.org>; Sun, 20 Feb 2011 01:35:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102200947.19706.hverkuil@xs4all.nl>
References: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
	<201102200947.19706.hverkuil@xs4all.nl>
Date: Sun, 20 Feb 2011 11:35:30 +0200
Message-ID: <AANLkTi=cW5RDsRQ3AfMhuAM=FMSvnmvxngGMxZHc3M2K@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/1] Get rid of V4L2 internal device interface usage
From: David Cohen <dacohen@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 20, 2011 at 10:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi David,

Hi Hans,

>
> On Saturday, February 19, 2011 17:35:46 David Cohen wrote:
>> Hi,
>>
>> This is the first patch (set) version to remove V4L2 internal device interface.
>> I have converted tcm825x VGA sensor to V4L2 sub device interface. I removed
>> also some workarounds in the driver which doesn't fit anymore in its new
>> interface.
>
> Very nice! It looks good. I noticed that you didn't convert it to the control
> framework yet, but after looking at the controls I think that it is probably
> better if I do that anyway. There are several private controls in this driver,
> and I will need to take a good look at those.

Yes, to port to control fw is not part of this task yet. IMO there are
plenty of missing tasks to let the driver in a good shape and it may
need a very good rework. For now I'm focusing in remove v4l2 internal
interface.

>
>> TODO:
>>  - Remove V4L2 int device interface from omap24xxcam driver.
>>  - Define a new interface to handle xclk. OMAP3 ISP could be used as base.
>>  - Use some base platform (probably N8X0) to add board code and test them.
>>  - Remove V4L2 int device. :)
>
> It would be so nice to have that API removed :-)

Yes. :)

Br,

David

>
> Regards,
>
>        Hans
>
>>
>> Br,
>>
>> David
>> ---
>>
>> David Cohen (1):
>>   tcm825x: convert driver to V4L2 sub device interface
>>
>>  drivers/media/video/tcm825x.c |  369 ++++++++++++-----------------------------
>>  drivers/media/video/tcm825x.h |    6 +-
>>  2 files changed, 109 insertions(+), 266 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
>
