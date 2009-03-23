Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NHXxYT012940
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 13:33:59 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2NHXbhx015213
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 13:33:37 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1288544yxm.81
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 10:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237608177.13642.8.camel@pc07.localdom.local>
References: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
	<1237608177.13642.8.camel@pc07.localdom.local>
Date: Mon, 23 Mar 2009 11:33:36 -0600
Message-ID: <2df568dc0903231033t30ed26afr80b413e889b096ae@mail.gmail.com>
From: Gordon Smith <spider.karma+video4linux-list@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Failure to read saa7134/saa6752hs MPEG output
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, Mar 20, 2009 at 10:02 PM, hermann pitton
<hermann-pitton@arcor.de> wrote:
>
> Hi,
>
> Am Freitag, den 20.03.2009, 14:24 -0600 schrieb Gordon Smith:
> > Hello -
> >
> > I'm unable to read or stream compressed data from saa7134/saa6752hs.
> >
> > I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> > hardware encoder per channel, no tuner) running current v4l-dvb in
> > debian 2.6.26-1.
> >
> > MPEG2-TS data is normally available on /dev/video2 and /dev/video3.
> >
> > Previously there were parameters for the saa6752hs module named
> > "force" and "ignore" to modify i2c addresses. The current module
> > appears to lack those parameters and may be using incorrect i2c addresses.
> >
> > Current dmesg:
> >
> > [   13.388944] saa6752hs 3-0020: chip found @ 0x40 (saa7133[0])
> > [   13.588458] saa6752hs 4-0020: chip found @ 0x40 (saa7133[1])
> >
> > Prior dmesg (~2.6.25-gentoo-r7 + v4l-dvb ???):
> >
> > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> >
> > Prior modprobe.conf entry:
> > options saa6752hs force=0x1,0x21,0x2,0x21 ignore=0x0,0x20,0x1,0x20,0x2,0x20
> >
> >
> > $ v4l2-dbg --device /dev/video2 --info
> > Driver info:
> >         Driver name   : saa7134
> >         Card type     : RTD Embedded Technologies VFG73
> >         Bus info      : PCI:0000:02:08.0
> >         Driver version: 526
> >         Capabilities  : 0x05000001
> >                 Video Capture
> >                 Read/Write
> >                 Streaming
> >
> > Streaming is a listed capability but the capture example at
> > http://v4l2spec.bytesex.org/spec/capture-example.html fails
> > during request for buffers.
> >
> > $ v4l2-capture --device /dev/video2 --mmap
> > /dev/video2 does not support memory mapping
> >
> > v4l2-capture.c:
> >         req.count               = 4;
> >         req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >         req.memory              = V4L2_MEMORY_MMAP;
> >
> >         if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
> >                 if (EINVAL == errno) {
> >                         fprintf (stderr, "%s does not support "
> >                                  "memory mapping\n", dev_name);
> >
> >
> > A read() results in EIO error:
> >
> > $ v4l2-capture --device /dev/video0 --read
> > read error 5, Input/output error
> >
> > v4l2-capture.c:
> >                 if (-1 == read (fd, buffers[0].start, buffers[0].length)) {
> >                         switch (errno) {
> >             ...
> >                         default:
> >                                 errno_exit ("read");
> >
> >
> > This behavior does not change if the saa6752hs module is not loaded.
> >
> > Is there still a way to modify the i2c address(es) for the saa6752hs module?
> >
> > Any pointers are appreciated.
> >
> > Gordon
> >
>
> thanks for the report.
>
> It was probably forgotten that the prior insmod option had a reason.
>
> Try to change it to 0x21 in saa7134-i2c.c
>
> static char *i2c_devs[128] = {
>        [ 0x20      ] = "mpeg encoder (saa6752hs)",
>        [ 0xa0 >> 1 ] = "eeprom",
>        [ 0xc0 >> 1 ] = "tuner (analog)",
>        [ 0x86 >> 1 ] = "tda9887",
>        [ 0x5a >> 1 ] = "remote control",
> };
>
> and report if your cards a usable again.
>
> Seems we need the chip address per card without that insmod option and
> reliable probing.
>
> Cheers,
> Hermann

Hermann -

I made the change to saa7134-i2c.c but the i2c address did not change.
I added my initials (gms) to dmesg, so I know I'm loading the new
module.

I set i2c_debug=1 for saa7134. Here is one device:

[   13.369175] saa7130/34: v4l2 driver version 0.2.14-gms loaded
[   13.369294] saa7133[0]: found at 0000:02:08.0, rev: 17, irq: 11,
latency: 32, mmio: 0x80000000
[   13.369310] saa7133[0]: subsystem: 1435:7350, board: RTD Embedded
Technologies VFG7350 [card=72,autodetected]
[   13.369335] saa7133[0]: board init: gpio is 10000
[   13.472509] saa7133[0]: i2c xfer: < a0 00 >
[   13.480139] saa7133[0]: i2c xfer: < a1 =35 =14 =50 =73 =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
...snip...
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
[   13.520135] saa7133[0]: i2c eeprom 00: 35 14 50 73 ff ff ff ff ff
ff ff ff ff ff ff ff
...snip...
[   13.520467] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   13.608743] saa6752hs 1-0020: chip found (gms) @ 0x40 (saa7133[0])
[   13.608762] saa7133[0]: i2c xfer: < 40 13 >
[   13.616164] saa7133[0]: i2c xfer: < 41 =13 =13 =13 =13 =13 =13 =13
=13 =13 =13 =13 =13 >
[   13.624161] saa6752hs i2c attach [addr=0x20,client=saa6752hs]
[   13.624337] saa7133[0]: registered device video0 [v4l2]
[   13.624390] saa7133[0]: registered device vbi0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
