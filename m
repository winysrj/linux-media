Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:62183 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZGROQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 10:16:40 -0400
Received: by yxe14 with SMTP id 14so2434505yxe.33
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 07:16:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090718101612.315370@gmx.net>
References: <20090718101612.315370@gmx.net>
Date: Sat, 18 Jul 2009 10:16:40 -0400
Message-ID: <829197380907180716m45b3a05dr5fb84eece6a6bf7@mail.gmail.com>
Subject: Re: Terratec Grabby
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 18, 2009 at 6:16 AM, Alina Friedrichsen<x-alina@gmx.net> wrote:
> Hello,
>
> how to solve the following kernel error message?
>
>> em28xx #0: vidioc_s_fmt_vid_cap queue busy
>
> I want watch TV with the good old xawtv of Debian lenny with linux 2.6.31-rc3-git3 and the current driver of the v4l-dvb git repository.
>
> When I want to use the vlc for it then get the following error messages:
>
> [0x1ce7848] v4l2 access debug: opening device '/dev/video0'
> [0x1ce7848] v4l2 access debug: V4L2 device: Terratec Grabby using driver: em28xx (version: 0.1.2) on usb-0000:00:1d.7-1
> [0x1ce7848] v4l2 access debug: the device has the capabilities: (X) Video Capure, (X) Audio, ( ) Tuner
> [0x1ce7848] v4l2 access debug: supported I/O methods are: (X) Read/Write, (X) Streaming, ( ) Asynchronous
> [0x1ce7848] v4l2 access debug: video input 0 (Composite1) has type: External analog input
> [0x1ce7848] v4l2 access debug: video input 1 (S-Video) has type: External analog input *
> [0x1ce7848] v4l2 access error: cannot get video input characteristics (Das Argument ist ungültig)
> [0x1ce7848] main access warning: no access module matching "v4l2" could be loaded
> [0x1ce7848] main access debug: TIMER module_need() : 611.941 ms - Total 611.941 ms / 1 intvls (Avg 611.941 ms)
> [0x1f64538] main input error: open of `v4l2://' failed: (null)
>
> Thanks!
>
> Regards
> Alina
>
> --
> Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3 -
> sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser
>

Hello Alina,

Generally speaking, questions like this are best sent to the
linux-media mailing list.

That said, it looks like your kernel build might have a problem and
may not have all the required modules.  Did you build the kernel
yourself from source?

I would have to look at the source to better understand the source of
that particular error.  Could you please provide the full dmesg
output?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
