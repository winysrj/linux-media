Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.oregonstate.edu ([128.193.15.35]:42364 "EHLO
	smtp1.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab0CLW0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 17:26:48 -0500
Message-ID: <4B9ABE3C.6010909@onid.orst.edu>
Date: Fri, 12 Mar 2010 14:20:44 -0800
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Remaining drivers that aren't V4L2?
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com> <201003122242.06508.hverkuil@xs4all.nl>
In-Reply-To: <201003122242.06508.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Friday 12 March 2010 21:11:49 Devin Heitmueller wrote:
>   
>> Hello,
>>
>> I know some months ago, there was some discussion about a few drivers
>> which were stragglers and had not been converted from V4L to V4L2.
>>
>> Do we have a current list of driver which still haven't been converted?
>>     
>
> These drivers are still v4l1:
>
> arv
> bw-qcam
> c-qcam
> cpia_pp
> cpia_usb
> ov511
> se401
> stradis
> stv680
> usbvideo
> w9966
>
> Some of these have counterparts in gspca these days so possibly some drivers
> can be removed by now. Hans, can you point those out?
>
> arv, bw-qcam, c-qcam, cpia_pp and stradis can probably be moved to staging
> and if no one steps up then they can be dropped altogether.
>   

Does this mean that the bw-qcam driver will be removed in future 
revisions or does this mean it will just never be updated to v4l2?

> According to my notes I should be able to test cpia_usb. I would have to
> verify that, though. I think it is only used in a USB microscope. It is
> effectively a webcam. I can also test usbvideo (USB 1 TV capture device).
> The latter is probably the most important driver that needs converting,
> because I think these are not uncommon.
>
> However, I have no time to work on such a driver conversion. But if someone
> is seriously willing to put time and effort in that, then I am willing to
> mail the hardware.
>
>   
>> I started doing some more tvtime work last night, and I would *love*
>> to drop V4L support (and *only* support V4L2 devices), since it would
>> make the code much cleaner, more reliable, and easier to test.
>>
>> If there are only a few obscure webcams remaining, then I'm willing to
>> tell those users that they have to stick with whatever old version of
>> tvtime they've been using since the last release four years ago.
>>     
>
> To my knowledge the usbvideo driver is probably the least obscure device
> that is still using V4L1.
>
> Regards,
>
> 	Hans
>
>   

