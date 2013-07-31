Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51347 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab3GaQAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 12:00:08 -0400
Received: by mail-we0-f171.google.com with SMTP id q55so778702wes.16
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 09:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJHRZ=K+oFtcTd-qCQexOZkdBwoYgL6mhmoQB0fxh0Z47nbpYg@mail.gmail.com>
References: <CAJHRZ=K+oFtcTd-qCQexOZkdBwoYgL6mhmoQB0fxh0Z47nbpYg@mail.gmail.com>
Date: Wed, 31 Jul 2013 12:00:06 -0400
Message-ID: <CAGoCfiyyJqD2SWVNRGFc8mmF+8gmn=1rwc=MWBihJcwa=iFoRw@mail.gmail.com>
Subject: Re: 950Q CC Extraction (V4L2/VBI)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Trevor Anonymous <trevor.forums@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:55 AM, Trevor Anonymous
<trevor.forums@gmail.com> wrote:
> Hi all, new to the list, hope this is an appropriate place to ask this.
>
> Quick question:
> I can extract NTSC analog closed captions with the Hauppauge 950Q as follows:
> 1. Run v4l2-ctl -i 1 ## Set input to composite
> 2. In a test application, open file /dev/video0
> 3. Read 1 byte from the file
> ** Note: This seems to be sufficient to "start" the device
> ** Calling VIDIOC_STREAMON ioctl is *not* sufficient
> 4. Run: zvbi-ntsc-cc -c -d /dev/vbi0 ## Prints the closed captions
> 5. Close file handle to /dev/video0 when finished. Device "stops".
> My question: Is opening the device and reading 1 byte a good/ok way to
> start the device? I'm only interested in closed captions, and want
> this to be as small a footprint as possible. I'm worried that this
> method may break in future driver versions.

Hi Trevor,

The fact that you need video streaming in order to access CC is a bug
in the driver (brought to my attention only a couple of weeks ago).  I
didn't properly setup the referencing counting for when to start/stop
the isoc FIFO, so the arrival of data is implicitly tied to the use of
/dev/video.

The hack you've described should work as long as you keep the
filehandle open (in fact it's pretty much what the other user hacked
in userland to workaround the bug).  That said, I would like to fix
the underlying bug so that the driver behaves like it's supposed to
(which means you should be able to access /dev/vbi for CC capture
without having to muck with streaming from /dev/video).  I suspect
that the fix won't cause the workaround you're proposing to stop
working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
