Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47536 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LCKLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 05:11:38 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1235515qaq.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 02:11:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354528977.50830.YahooMailNeo@web160606.mail.bf1.yahoo.com>
References: <1354528977.50830.YahooMailNeo@web160606.mail.bf1.yahoo.com>
Date: Mon, 3 Dec 2012 05:11:37 -0500
Message-ID: <CAGoCfiw-UanZdDkZ0mE7iRmtPrRhOhk1PAT2QoxJd=h=NvpaKg@mail.gmail.com>
Subject: Re: How to use multiple video devices simultaneously
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitriy Alekseev <alexeev6@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2012 at 5:02 AM, Dmitriy Alekseev <alexeev6@yahoo.com> wrote:
> Hello.
>
> I have a pair of capture dongles Avermedia DVD EZMaker 7 (C039) which have cx231xx chip.
> Now using vlc and gst-launch-0.10 I can watch/stream video only from one of them simultaneously.
>
> For example videolan messages I got opening second device:
> [0x7f055c001688] v4l2 demux error:
> VIDIOC_QBUF failed libv4l2: error mmapping buffer 0: Device or resource busy
> [0x7f055c001688] v4l2 demux error:
> VIDIOC_QBUF failed libv4l2: warning v4l2 mmap buffers still mapped on close()
> [0x7f055c002ec8] v4l2 access error: mmap failed (Device or resource busy)
> [0x7f055c002ec8] v4l2 access error: mmap failed (Device or resource busy)
> [0xb5c698] main input error: open of `v4l2:///dev/video0' failed: (null)
>
> I wonder, what the problem is?

You're probably using too much USB bandwidth.  A single USB host
controller does not have enough bandwidth to support two full
resolution video captures at the same time.  The video is
uncompressed, and each will try to use around 60% of the available USB
bandwidth.

For a scenario like this, you would need to have two separate USB host
controllers, reduce the capture resolution significantly, or choose
different boards (such as a PCI or PCIe product).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
