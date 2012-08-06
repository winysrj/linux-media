Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50227 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892Ab2HFIhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 04:37:45 -0400
References: <501D4535.8080404@lockie.ca> <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com> <501DA203.7070800@lockie.ca>
In-Reply-To: <501DA203.7070800@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: boot slow down
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 06 Aug 2012 04:37:50 -0400
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <e2182b8d-a2fe-4a72-aa58-40995e92cf2d@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James <bjlockie@lockie.ca> wrote:

>On 08/04/12 13:42, Andy Walls wrote:
>> James <bjlockie@lockie.ca> wrote:
>> 
>>> There's a big pause before the 'unable'
>>>
>>> [    2.243856] usb 4-1: Manufacturer: Logitech
>>> [   62.739097] cx25840 6-0044: unable to open firmware
>>> v4l-cx23885-avcore-01.fw
>>>
>>>
>>> I have a cx23885
>>> cx23885[0]: registered device video0 [v4l2]
>>>
>>> Is there any way to stop it from trying to load the firmware?
>>> What is the firmware for, analog tv? Digital works fine and analog
>is
>>> useless to me.
>>> I assume it is timing out there.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> The firmware is for the analog broadcast audio standard (e.g. BTSC)
>detection microcontroller.
>> 
>> The A/V core of the CX23885/7/8 chips is for analog vidoe and audio
>processing (broadcast, CVBS, SVideo, audio L/R in).
>> 
>> The A/V core of the CX23885 provides the IR unit and the Video PLL
>provides the timing for the IR unit.
>> 
>> The A/V core of the CX23888 provides the Video PLL which is the
>timing for the IR unit in the CX23888.
>> 
>> Just grab the firmware and be done with it.  Don't waste time with
>trying to make the cx23885 working properly but halfway.
>> 
>> Regards,
>> Andy
>
>I already have the firmware.
># ls -l /lib/firmware/v4l-cx23885-avcore-01.fw 
>-rw-r--r-- 1 root root 16382 Oct 15  2011
>/lib/firmware/v4l-cx23885-avcore-01.fw
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hmm.  The firmware file size and location look right.

The 60 second delay is the default kernel delay waiting for the userspace firmware loader to fetch th file amd provide it to the kernel via sysfs.

That doesn't appear to be happening.  I know udev runs some script to accomplish that.  I'm away from my development system, so I can't investigate further.

Regards,
Andy
