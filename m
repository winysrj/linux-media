Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:43459 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaEKQpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 12:45:16 -0400
Received: by mail-qa0-f41.google.com with SMTP id dc16so6159911qab.0
        for <linux-media@vger.kernel.org>; Sun, 11 May 2014 09:45:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140511115802.330f15b7@recife.lan>
References: <CAJHRZ=KtLYbK=80FOZEquufSBXogxxduKc_eD9sbDsGD3Y3N2w@mail.gmail.com>
	<20140511115802.330f15b7@recife.lan>
Date: Sun, 11 May 2014 12:45:15 -0400
Message-ID: <CAOa0s9LrKxwCvVJY=i664ytXP0xF-0rrAkq23M-9bXZLU_0xWw@mail.gmail.com>
Subject: Re: Hauppauge 950Q TS capture intermittent lock up
From: Trevor Graffa <tlgraffa@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trevor Anonymous <trevor.forums@gmail.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	cb.xiong@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Thanks. (Resending in plain text as last email was rejected by email
list). I'll look at the patch, and let you know if that helps. I'll
send out the application tomorrow as I'm not on my dev machine right
now.

-Trevor

On Sun, May 11, 2014 at 10:58 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Hi Trevor,
>
> Em Fri, 9 May 2014 11:19:49 -0400
> Trevor Anonymous <trevor.forums@gmail.com> escreveu:
>
>> Hello all,
>>
>> I have written a simple application to capture RF QAM transport
>> streams with the Hauppauge 950Q, and save to a file. This is
>> essentially the same as dvbstream, but with unnecessary stuff removed
>> (and I have verified this bug using dvbstream as well):
>> - tune using frontend device
>> - demux device: DMX_SET_PES_FILTER on pid 8192 with DMX_OUT_TS_TAP output.
>> - Read from dvr device, save to file.
>> - Interrupt app using alarm() and stop pes filter, close devices.
>>
>>
>> This works as expected. The problem is after running this a bunch of
>> times (sometimes 15-20+), the device seems to eventually get into a
>> bad state, and nothing is available to read on the dvr device. The
>> lockup never seems to happen while reading data (i.e., either data
>> comes and the app works completely, or the app reads 0 bytes). When
>> this happens, all the tuning/demod locks look good, and everything
>> appears to be working -- there just isn't data ready to read from the
>> dvr device.
>>
>> When it gets into a bad state, I have to physically remove/reinsert
>> the 950Q device or otherwise reset the device (e.g., usb reset -
>> USBDEVFS_RESET ioctl).
>
> Yes, I noticed a similar issue with last devel Kernel. I suspect
> that the culprit could be due to a sheduled work that fixes a
> hardware bug. Such scheduled work task should be cancelled when
> the device is closed or the channel is changed. This is likely
> a partial fix for it (untested):
>         https://patchwork.linuxtv.org/patch/23860/
>
> It makes sure that the thread is canceled when a new set frontend
> ioctl is sent. Yet, this patch won't solve your specific problem.
>
> I suspect that the right approach would be to also call
> cancel_work_sync(&dev->restart_streaming) on all other places
> where stop_urb_transfer() is called.
>
> Btw, could you share your small test application? That would
> help us to test the bug locally and work on a patch.
>
>>
>> Has anyone seen this issue before?
>>
>> I am running Fedora 19 with 3.13.9 kernel. Hardware is:
>> - au0828, au8522, xc5000 (with dvb-fe-xc5000c-4.1.30.7.fw)
>>
>>
>> Thanks,
>> -Trevor
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
