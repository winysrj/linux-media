Return-path: <linux-media-owner@vger.kernel.org>
Received: from st11p00mm-asmtpout001.mac.com ([17.172.81.0]:54318 "EHLO
	st11p00mm-asmtp001.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbaHLRq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 13:46:56 -0400
Message-id: <53EA44FB.7080607@me.com>
Date: Tue, 12 Aug 2014 19:46:51 +0300
From: Kimmo Taskinen <kimmo.taskinen@me.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <6676742.btapbsDqkp@avalon>
 <53EA4057.4020103@xs4all.nl> <21335650.ENAaDBpIbk@avalon>
In-reply-to: <21335650.ENAaDBpIbk@avalon>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have seen similar dmesg message in some other situations (still with 
3.15.6 at least):

Jul 31 00:08:38 daphile user.err kernel: xhci_hcd 0000:02:00.0: ERROR: 
unexpected command completion code 0x11.

Jul 31 00:08:38 daphile user.info kernel: usb 6-2: Not enough bandwidth 
for altsetting 1

Jul 31 00:08:38 daphile user.err kernel: usb 6-2: 1:1: usb_set_interface 
failed (-22)


The problem has been related to the use of USB DAC with NEC uPD72020x 
based PCIe USB card. And the problem is very strange because the some 
DACs work perfectly fine with it and some do not. On the other hand 
those non-working DACs work fine when connected to some other 
(motherboard) USB connector. So it's quite complicated interaction 
problem, who's to blame.

Do you think this could be anyhow related this thread?

Kimmo

On 12.08.2014 19:35, Laurent Pinchart wrote:
> On Tuesday 12 August 2014 18:27:03 Hans Verkuil wrote:
>> On 08/12/2014 06:21 PM, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> On Tuesday 12 August 2014 17:38:55 Hans Verkuil wrote:
>>>> On 08/12/2014 05:07 PM, Hans de Goede wrote:
>>>>> On 08/07/2014 04:49 PM, Udo van den Heuvel wrote:
>>>>>> On 2014-08-04 11:17, Laurent Pinchart wrote:
>>>>>>> (CC'ing Hans de Goede, the pwc maintainer, and the linux-media mailing
>>>>>>> list)
>>>>> Thanks for the bug report. I've been looking into this, and there
>>>>> seem to be 2 problems:
>>>>>
>>>>> 1: xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code
>>>>> 0x11.
>>>>>
>>>>> This seems to be what is causing things to not work with a usb-3 port
>>>>> for you. Might be fixed by this commit:
>>>>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drive
>>>>> rs/usb/host?h=usb-next&id=3213b151387df0b95f4eada104f68eb1c1409cb3
>>>>>
>>>>> Can you please do "lspci -nn", and then copy and paste the output here,
>>>>> so that we can see what sort of xhci controller you've (and try to
>>>>> reproduce the problem).
>>>>>
>>>>> 2: The triggering of a WARN_ON in __vb2_queue_cancel() when called on
>>>>> streamoff. I've been looking at the code and I cannot figure out why
>>>>> this is triggering I'm afraid.
>>>> You can ignore this one.
>>>>
>>>> The uvc driver is doing messy things with vb2 which causes this warning.
>>>> That said, it will not break things for you. It is just a warning that
>>>> the driver needs to be improved.
>>> I can certainly take the blame when my code needs to be improved, but in
>>> this case the webcam is supported by the pwc driver, not the uvc driver
>>> :-)
>> It was a bit confusing, but he has two problems: one pwc, one (the warning)
>> for uvc.
> Right, I've missed the second one, my bad. A similar issue was present with
> the pwc driver, which you have fixed in "[PATCH] pwc: fix WARN_ON" I believe.
>
> I'll have a look at the uvcvideo issue. It can be ignored for now.
>

