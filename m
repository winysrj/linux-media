Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33569 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbbDTHL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 03:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1504171331050.1319-100000@iolanthe.rowland.org>
References: <1429284290-25153-3-git-send-email-tomeu.vizoso@collabora.com> <Pine.LNX.4.44L0.1504171331050.1319-100000@iolanthe.rowland.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Mon, 20 Apr 2015 09:11:36 +0200
Message-ID: <CAAObsKCP4dTvOPB=XrZexauHmdC99JYkc6cYKoaT-vZjnLaynw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] [media] uvcvideo: Remain runtime-suspended at sleeps
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 April 2015 at 19:32, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 17 Apr 2015, Tomeu Vizoso wrote:
>
>> When the system goes to sleep and afterwards resumes, a significant
>> amount of time is spent suspending and resuming devices that were
>> already runtime-suspended.
>>
>> By setting the power.force_direct_complete flag, the PM core will ignore
>> the state of descendant devices and the device will be let in
>> runtime-suspend.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>  drivers/media/usb/uvc/uvc_driver.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
>> index 5970dd6..ae75a70 100644
>> --- a/drivers/media/usb/uvc/uvc_driver.c
>> +++ b/drivers/media/usb/uvc/uvc_driver.c
>> @@ -1945,6 +1945,8 @@ static int uvc_probe(struct usb_interface *intf,
>>                       "supported.\n", ret);
>>       }
>>
>> +     intf->dev.parent->power.force_direct_complete = true;
>
> This seems wrong.  The uvc driver is bound to intf, not to intf's
> parent.  So it would be okay for the driver to set
> intf->dev.power.force_direct_complete, but it's wrong to set
> intf->dev.parent->power.force_direct_complete.

Agreed.

Thanks,

Tomeu

> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
