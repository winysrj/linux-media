Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:42791 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZLJP0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 10:26:13 -0500
Received: by ywh6 with SMTP id 6so7191558ywh.4
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 07:26:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912101519.04700.laurent.pinchart@ideasonboard.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com>
	 <200912101519.04700.laurent.pinchart@ideasonboard.com>
Date: Thu, 10 Dec 2009 12:26:19 -0300
Message-ID: <36be2c7a0912100726t65de68c6n2f02eea25ac5a586@mail.gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
From: Pablo Baena <pbaena@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can you tell me how to obtain such backtrace? This is a hard panic and
I don't know how to obtain a backtrace, since the keyboard gets
unresponsive.

On Thu, Dec 10, 2009 at 11:19 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Pablo,
>
> On Monday 07 December 2009 18:18:11 Pablo Baena wrote:
>> I get a kernel panic when running the attached sample code.
>>
>> I run it as:
>>
>> $ gcc capture.c -o capture
>> $ export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
>> $ ./capture -d/dev/video0 -c1000 -r
>>
>> -r tells it to capture using read(), which libv4l emulates.
>>
>> In the example code, I use read() to fetch from the webcam directly,
>> without using select() to wait for a frame. In the v4l documentation,
>> it states that read() should block until it has a new frame available.
>>
>> This is a Bus 002 Device 005: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera.
>>
>> I can't capture the kernel panic because everything hangs and I have
>> no kernel debugger to try to get that info. I attach a poor quality
>> image taken with a webcam from the screen. I even tried having a
>> vmware virtual machine to try to better capture the panic, but in the
>> virtual machine it doesn't hang.
>>
>> This is Ubuntu 9.10, Linux pablo-laptop 2.6.31-16-generic #52-Ubuntu
>> SMP Thu Dec 3 22:00:22 UTC 2009 i686 GNU/Linux.
>>
>> But I got reports that the same camera on Debian 5.3 is also panicking.
>>
>> Please advice if you need more information to solve this problem.
>
> I can't reproduce the problem here (with another camera).
>
> To investigate I will need a copy of the source code and binary kernel module
> for the uvcvideo driver running on your system as well as a complete complete
> backtrace.
>
> --
> Regards,
>
> Laurent Pinchart
>



-- 
"Not possessing the gift of reflection, a dog does not know that he
does not know, and does not understand that he understands nothing;
we, on the other hand, are aware of both. If we behave otherwise, it
is from stupidity, or else from self-deception, to preserve our peace
of mind."
