Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:45263 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZCUEHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 00:07:55 -0400
Subject: Re: Failure to read saa7134/saa6752hs MPEG output
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+video4linux-list@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
References: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 05:02:57 +0100
Message-Id: <1237608177.13642.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 20.03.2009, 14:24 -0600 schrieb Gordon Smith:
> Hello -
> 
> I'm unable to read or stream compressed data from saa7134/saa6752hs.
> 
> I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> hardware encoder per channel, no tuner) running current v4l-dvb in
> debian 2.6.26-1.
> 
> MPEG2-TS data is normally available on /dev/video2 and /dev/video3.
> 
> Previously there were parameters for the saa6752hs module named
> "force" and "ignore" to modify i2c addresses. The current module
> appears to lack those parameters and may be using incorrect i2c addresses.
> 
> Current dmesg:
> 
> [   13.388944] saa6752hs 3-0020: chip found @ 0x40 (saa7133[0])
> [   13.588458] saa6752hs 4-0020: chip found @ 0x40 (saa7133[1])
> 
> Prior dmesg (~2.6.25-gentoo-r7 + v4l-dvb ???):
> 
> saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> 
> Prior modprobe.conf entry:
> options saa6752hs force=0x1,0x21,0x2,0x21 ignore=0x0,0x20,0x1,0x20,0x2,0x20
> 
> 
> $ v4l2-dbg --device /dev/video2 --info
> Driver info:
>         Driver name   : saa7134
>         Card type     : RTD Embedded Technologies VFG73
>         Bus info      : PCI:0000:02:08.0
>         Driver version: 526
>         Capabilities  : 0x05000001
>                 Video Capture
>                 Read/Write
>                 Streaming
> 
> Streaming is a listed capability but the capture example at
> http://v4l2spec.bytesex.org/spec/capture-example.html fails
> during request for buffers.
> 
> $ v4l2-capture --device /dev/video2 --mmap
> /dev/video2 does not support memory mapping
> 
> v4l2-capture.c:
>         req.count               = 4;
>         req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         req.memory              = V4L2_MEMORY_MMAP;
> 
>         if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
>                 if (EINVAL == errno) {
>                         fprintf (stderr, "%s does not support "
>                                  "memory mapping\n", dev_name);
> 
> 
> A read() results in EIO error:
> 
> $ v4l2-capture --device /dev/video0 --read
> read error 5, Input/output error
> 
> v4l2-capture.c:
>                 if (-1 == read (fd, buffers[0].start, buffers[0].length)) {
>                         switch (errno) {
>             ...
>                         default:
>                                 errno_exit ("read");
> 
> 
> This behavior does not change if the saa6752hs module is not loaded.
> 
> Is there still a way to modify the i2c address(es) for the saa6752hs module?
> 
> Any pointers are appreciated.
> 
> Gordon
> 

thanks for the report.

It was probably forgotten that the prior insmod option had a reason.

Try to change it to 0x21 in saa7134-i2c.c

static char *i2c_devs[128] = {
	[ 0x20      ] = "mpeg encoder (saa6752hs)",
	[ 0xa0 >> 1 ] = "eeprom",
	[ 0xc0 >> 1 ] = "tuner (analog)",
	[ 0x86 >> 1 ] = "tda9887",
	[ 0x5a >> 1 ] = "remote control",
};

and report if your cards a usable again.

Seems we need the chip address per card without that insmod option and
reliable probing.

Cheers,
Hermann


