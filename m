Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58982 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935160Ab1IOVq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 17:46:59 -0400
Received: by fxe4 with SMTP id 4so1043833fxe.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 14:46:58 -0700 (PDT)
Message-ID: <4E727251.9030308@googlemail.com>
Date: Thu, 15 Sep 2011 23:46:57 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: moinejf@free.fr
Subject: Re: Question about USB interface index restriction in gspca
References: <4E6FAB94.2010007@googlemail.com> <20110914082513.574baac2@tele>
In-Reply-To: <20110914082513.574baac2@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.09.2011 08:25, schrieb Jean-Francois Moine:
> On Tue, 13 Sep 2011 21:14:28 +0200
> Frank Schäfer<fschaefer.oss@googlemail.com>  wrote:
>
>> I have a question about the following code in gspca.c:
>>
>> in function gspca_dev_probe(...):
>>       ...
>>       /* the USB video interface must be the first one */
>>       if (dev->config->desc.bNumInterfaces != 1
>> &&  intf->cur_altsetting->desc.bInterfaceNumber != 0)
>>               return -ENODEV;
>>       ...
>>
>> Is there a special reason for not allowing devices with USB interface
>> index>  0 for video ?
>> I'm experimenting with a device that has the video interface at index 3
>> and two audio interfaces at index 0 and 1 (index two is missing !).
>> And the follow-up question: can we assume that all device handled by the
>> gspca-driver have vendor specific video interfaces ?
>> Then we could change the code to
>>
>>       ...
>>       /* the USB video interface must be of class vendor */
>>       if (intf->cur_altsetting->desc.bInterfaceClass !=
>> USB_CLASS_VENDOR_SPEC)
>>               return -ENODEV;
>>        ...
> Hi Frank,
>
> For webcam devices, the interface class is meaningful only when set to
> USB_CLASS_VIDEO (UVC). Otherwise, I saw many different values.
Does that mean that there are devices out in the wild that report for 
example USB_CLASS_WIRELESS_CONTROLLER for the video interface ???

> For video on a particular interface, the subdriver must call the
> function gspca_dev_probe2() as this is done in spca1528 and xirlink_cit.
>
> Regards.
Hmm, sure, that would work...
But wouldn't it be better to improve the interface check and merge the 
two probing functions ?
The subdrivers can decide which interfaces are (not) probed and the 
gspca core does plausability checks (e.g. bulk/isoc endpoint ? usb class ?).

Regards,
Frank

