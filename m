Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52708 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1K1MhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 07:37:20 -0500
Received: by yenl6 with SMTP id l6so2799150yen.19
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 04:37:19 -0800 (PST)
Message-ID: <4ED3807A.8060200@gmail.com>
Date: Mon, 28 Nov 2011 15:37:14 +0300
From: Alexander Zhavnerchik <alex.vizor@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2:
 -32 (exp. 2).
References: <4ED29713.1010202@gmail.com> <201111281135.57435.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111281135.57435.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Unfortunately my laptop died today, I'll sent details once I repair it.

Thanks,
Alex

On 28.11.2011 13:35, Laurent Pinchart wrote:
> Hi Alex,
>
> On Sunday 27 November 2011 21:01:23 Alex wrote:
>> Hi guys,
>>
>> I'm using kernel 3.2-rc3 and get following in dmesg on every try to use
>> thinkpad integrated camera (here I did rmmod and modprobe before test):
>> [ 9481.258170] usbcore: deregistering interface driver uvcvideo
>> [ 9481.296659] uvcvideo: Failed to submit URB 0 (-28).
>> [ 9481.296677] uvcvideo 1-1.6:1.1: resume error -28
>> [ 9490.117546] uvcvideo: Found UVC 1.00 device Integrated Camera
>> (04f2:b221) [ 9490.119166] input: Integrated Camera as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input13
>> [ 9490.119298] usbcore: registered new interface driver uvcvideo
>> [ 9490.119302] USB Video Class driver (1.1.1)
>> [ 9498.101683] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>> unit 2: -32 (exp. 2).
>> [ 9498.113603] uvcvideo: Failed to submit URB 0 (-28).
> Those two errors might be unrelated.
>
> For the second one, I'm tempted to blame
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-
> stable.git;a=commit;h=f0cc710a6dec5b808a6f13f1f8853c094fce5f12. Could you
> please try reverting it, and see if it fixes your issue ? If so, let's report
> that to the linux-usb mailing list.
>
> For the first one, could you please send me the lsusb -v output for your
> webcam ?
>

