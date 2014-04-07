Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1813 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaDGMvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 08:51:53 -0400
Message-ID: <53429F53.7050005@xs4all.nl>
Date: Mon, 07 Apr 2014 14:51:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	Pawel Osciak <pawel@osciak.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: videobuf2-vmalloc suspect for corrupted data
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>,<CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com> <BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>,<53428483.7060107@xs4all.nl> <BAY176-W91C143782DF21AB7ACEC8A9680@phx.gbl>
In-Reply-To: <BAY176-W91C143782DF21AB7ACEC8A9680@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2014 01:20 PM, Divneil Wadhawan wrote:
> Hi Hans,
>> Two more questions:
>>
>> Which kernel version are you using?
> 3.4.58

That should be new enough, I see no important differences between 3.4
and 3.14 in this respect. But really, 3.4? That's over two years old!
If you have control over what kernel you use then I recommend you
upgrade.

>> Which capture driver are you using?
> It's a TSMUX driver, written locally.

I have not seen any reports of problems with vmalloc with arm in a long
time. I know the uvc driver uses vmalloc, and that's used frequently.

Question: if you use MEMORY_MMAP instead of USERPTR, does that work?

Have you tried to stream with v4l2-ctl? It's available here:
http://git.linuxtv.org/cgit.cgi/v4l-utils.git/. It's the reference
implementation of how to stream, so if that fails as well, then at
least its not your application.

Testing whether you see the same when capturing from a usb uvc webcam
(most webcams are uvc these days) would be useful as well. If it works
with a uvc webcam, but not with your driver, then I suspect the driver.

Regards,

	Hans
