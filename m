Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:46039 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049AbZCXVHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:07:42 -0400
Subject: Re: Failure to read saa7134/saa6752hs MPEG output
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+video4linux-list@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Robert W. Boone" <rboone@rtd.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <2df568dc0903241242j12c07039o3169de0ada62bfcb@mail.gmail.com>
References: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
	 <1237860232.4023.14.camel@pc07.localdom.local>
	 <1237920433.4964.30.camel@pc07.localdom.local>
	 <200903242015.21905.hverkuil@xs4all.nl>
	 <2df568dc0903241242j12c07039o3169de0ada62bfcb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 22:03:39 +0100
Message-Id: <1237928619.4964.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 24.03.2009, 13:42 -0600 schrieb Gordon Smith:
> On Tue, Mar 24, 2009 at 1:15 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tuesday 24 March 2009 19:47:13 hermann pitton wrote:
> >> Am Dienstag, den 24.03.2009, 03:03 +0100 schrieb hermann pitton:
> >> > Hi,
> >> >
> >> > Am Montag, den 23.03.2009, 11:33 -0600 schrieb Gordon Smith:
> >> > > On Fri, Mar 20, 2009 at 10:02 PM, hermann pitton
> >> > >
> >> > > <hermann-pitton@arcor.de> wrote:
> >> > > > Hi,
> >> > > >
> >> > > > Am Freitag, den 20.03.2009, 14:24 -0600 schrieb Gordon Smith:
> >> > > > > Hello -
> >> > > > >
> >> > > > > I'm unable to read or stream compressed data from
> >> > > > > saa7134/saa6752hs.
> >> > > > >
> >> > > > > I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> >> > > > > hardware encoder per channel, no tuner) running current v4l-dvb
> >> > > > > in debian 2.6.26-1.
> >> > > > >
> >> > > > > MPEG2-TS data is normally available on /dev/video2 and
> >> > > > > /dev/video3.
> >> > > > >
> >> > > > > Previously there were parameters for the saa6752hs module named
> >> > > > > "force" and "ignore" to modify i2c addresses. The current module
> >> > > > > appears to lack those parameters and may be using incorrect i2c
> >> > > > > addresses.
> >> > > > >
> >> > > > > Current dmesg:
> >> > > > >
> >> > > > > [   13.388944] saa6752hs 3-0020: chip found @ 0x40 (saa7133[0])
> >> > > > > [   13.588458] saa6752hs 4-0020: chip found @ 0x40 (saa7133[1])
> >> > > > >
> >> > > > > Prior dmesg (~2.6.25-gentoo-r7 + v4l-dvb ???):
> >> > > > >
> >> > > > > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> >> > > > > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> >> > > > >
> >> > > > > Prior modprobe.conf entry:
> >> > > > > options saa6752hs force=0x1,0x21,0x2,0x21
> >> > > > > ignore=0x0,0x20,0x1,0x20,0x2,0x20
> >>
> >> It was disabled by Hans when converting to v4l2_subdev here.
> >> http://linuxtv.org/hg/v4l-dvb/rev/c41af551e79f
> >>
> >> It is only valid for kernels < 2.6.22 now in saa6752hs.
> >>
> >> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
> >> /* Addresses to scan */
> >> static unsigned short normal_i2c[] = {0x20, I2C_CLIENT_END};
> >>
> >> I2C_CLIENT_INSMOD;
> >> +#endif
> >>
> >> And we only have that single 0x20 address in saa7134-core.c etc.
> >> That should be the problem.
> >>
> >> > > > > $ v4l2-dbg --device /dev/video2 --info
> >> > > > > Driver info:
> >> > > > >         Driver name   : saa7134
> >> > > > >         Card type     : RTD Embedded Technologies VFG73
> >> > > > >         Bus info      : PCI:0000:02:08.0
> >> > > > >         Driver version: 526
> >> > > > >         Capabilities  : 0x05000001
> >> > > > >                 Video Capture
> >> > > > >                 Read/Write
> >> > > > >                 Streaming
> >> > > > >
> >> > > > > Streaming is a listed capability but the capture example at
> >> > > > > http://v4l2spec.bytesex.org/spec/capture-example.html fails
> >> > > > > during request for buffers.
> >> > > > >
> >> > > > > $ v4l2-capture --device /dev/video2 --mmap
> >> > > > > /dev/video2 does not support memory mapping
> >> > > > >
> >> > > > > v4l2-capture.c:
> >> > > > >         req.count               = 4;
> >> > > > >         req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> > > > >         req.memory              = V4L2_MEMORY_MMAP;
> >> > > > >
> >> > > > >         if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
> >> > > > >                 if (EINVAL == errno) {
> >> > > > >                         fprintf (stderr, "%s does not support "
> >> > > > >                                  "memory mapping\n", dev_name);
> >> > > > >
> >> > > > >
> >> > > > > A read() results in EIO error:
> >> > > > >
> >> > > > > $ v4l2-capture --device /dev/video0 --read
> >> > > > > read error 5, Input/output error
> >> > > > >
> >> > > > > v4l2-capture.c:
> >> > > > >                 if (-1 == read (fd, buffers[0].start,
> >> > > > > buffers[0].length)) { switch (errno) {
> >> > > > >             ...
> >> > > > >                         default:
> >> > > > >                                 errno_exit ("read");
> >> > > > >
> >> > > > >
> >> > > > > This behavior does not change if the saa6752hs module is not
> >> > > > > loaded.
> >> > > > >
> >> > > > > Is there still a way to modify the i2c address(es) for the
> >> > > > > saa6752hs module?
> >> > > > >
> >> > > > > Any pointers are appreciated.
> >> > > > >
> >> > > > > Gordon
> >> > > >
> >> > > > thanks for the report.
> >> > > >
> >> > > > It was probably forgotten that the prior insmod option had a
> >> > > > reason.
> >> > > >
> >> > > > Try to change it to 0x21 in saa7134-i2c.c
> >> > > >
> >> > > > static char *i2c_devs[128] = {
> >> > > >        [ 0x20      ] = "mpeg encoder (saa6752hs)",
> >> > > >        [ 0xa0 >> 1 ] = "eeprom",
> >> > > >        [ 0xc0 >> 1 ] = "tuner (analog)",
> >> > > >        [ 0x86 >> 1 ] = "tda9887",
> >> > > >        [ 0x5a >> 1 ] = "remote control",
> >> > > > };
> >> > > >
> >> > > > and report if your cards a usable again.
> >> > > >
> >> > > > Seems we need the chip address per card without that insmod option
> >> > > > and reliable probing.
> >> > > >
> >> > > > Cheers,
> >> > > > Hermann
> >> > >
> >> > > Hermann -
> >> > >
> >> > > I made the change to saa7134-i2c.c but the i2c address did not
> >> > > change. I added my initials (gms) to dmesg, so I know I'm loading the
> >> > > new module.
> >> > >
> >> > > I set i2c_debug=1 for saa7134. Here is one device:
> >> > >
> >> > > [   13.369175] saa7130/34: v4l2 driver version 0.2.14-gms loaded
> >> > > [   13.369294] saa7133[0]: found at 0000:02:08.0, rev: 17, irq: 11,
> >> > > latency: 32, mmio: 0x80000000
> >> > > [   13.369310] saa7133[0]: subsystem: 1435:7350, board: RTD Embedded
> >> > > Technologies VFG7350 [card=72,autodetected]
> >> > > [   13.369335] saa7133[0]: board init: gpio is 10000
> >> > > [   13.472509] saa7133[0]: i2c xfer: < a0 00 >
> >> > > [   13.480139] saa7133[0]: i2c xfer: < a1 =35 =14 =50 =73 =ff =ff =ff
> >> > > =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> >> > > ....snip...
> >> > > =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> >> > > =ff =ff > [   13.520135] saa7133[0]: i2c eeprom 00: 35 14 50 73 ff ff
> >> > > ff ff ff ff ff ff ff ff ff ff
> >> > > ....snip...
> >> > > [   13.520467] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> >> > > ff ff ff ff ff ff ff
> >> > > [   13.608743] saa6752hs 1-0020: chip found (gms) @ 0x40 (saa7133[0])
> >> > > [   13.608762] saa7133[0]: i2c xfer: < 40 13 >
> >> > > [   13.616164] saa7133[0]: i2c xfer: < 41 =13 =13 =13 =13 =13 =13 =13
> >> > > =13 =13 =13 =13 =13 >
> >> > > [   13.624161] saa6752hs i2c attach [addr=0x20,client=saa6752hs]
> >> > > [   13.624337] saa7133[0]: registered device video0 [v4l2]
> >> > > [   13.624390] saa7133[0]: registered device vbi0
> >> >
> >> > yes, sorry, there is more to change.
> >> >
> >> > The 0x20 address is also hard coded in saa7134-core.c,
> >> > saa7134-empress.c and saa6752hs.c.
> >> >
> >> > I also don't find your old insmod option for multiple addresses back to
> >> > 2.6.18 for now. I'll try to find some time to look up the history next
> >> > days.
> >>
> >> See above, static unsigned short normal_i2c[] seems to have allowed to
> >> set even 0x21, but only 0x20 was visible there.
> >>
> >> > With the wrong address and i2c_debug=1 you should see a bunch of ERROR:
> >> > NO DEVICE stuff from 0x40 and 0x41 if you try "cat /dev/video2" mpeg.
> >> >
> >> > Is it really detected at 0x42 with i2c_scan=1 ?
> >> > Except on i2c_debug level the code seems to tolerate all wrong
> >> > addresses without warnings.
> >>
> >> Please provide the i2c_scan with the device detected at 0x42. I seem to
> >> find all card related mails from Robert W. Boone from RTD, but not that
> >> different address information.
> >>
> >> We should wait until Hans is back from the Linux embedded conference,
> >> since he is working on it and I don't even have a working empress
> >> device, but it seems we need a solution for multiple addresses here too.
> >>
> >> If I did not miss anything greping around after lunch, the attached
> >> patch might work as an interim for you.
> >
> > It's good to know that this device can also appear on address 0x42. I'll fix
> > this properly this weekend. I need to do some work to add saa6588 support
> > to saa7134 as well, so I can do this at the same time.
> >
> > BTW, please post to the new linux-media list rather than the obsolete
> > video4linux list. I'm no longer subscribed there which is why I didn't see
> > this earlier.
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >
> 
> I have Hermann's data request to verify 0x42 address.
> 
> >From RTD Linux Application Note, there is a pcf8574 for digital I/O at 0x40..
> The saa6752hs is at 0x21.
> 
> Here is edited dmesg with i2_scan for first channel:
> 
> [   13.268713] Linux video capture interface: v2.00
> [   13.418744] saa7130/34: v4l2 driver version 0.2.14-gms1 loaded
> [   13.418875] saa7133[0]: found at 0000:02:08.0, rev: 17, irq: 11,
> latency: 32, mmio: 0x80000000
> [   13.418891] saa7133[0]: subsystem: 1435:7350, board: RTD Embedded
> Technologies VFG7350 [card=72,autodetected]
> [   13.418918] saa7133[0]: board init: gpio is 10000
> [   13.520522] saa7133[0]: i2c xfer: < a0 00 >
> [   13.528156] saa7133[0]: i2c xfer: < a1 =35 =14 =50 =73 =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff
> ....snip...
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
> [   13.568135] saa7133[0]: i2c eeprom 00: 35 14 50 73 ff ff ff ff ff
> ff ff ff ff ff ff ff
> ....snip...
> [   13.568467] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   13.812492] saa7133[1]: i2c xfer: < 01 ERROR: NO_DEVICE
> [   13.812640] saa7133[1]: i2c xfer: < 03 ERROR: NO_DEVICE
> ....snip...
> [   13.816919] saa7133[1]: i2c xfer: < 3d ERROR: NO_DEVICE
> [   13.817066] saa7133[1]: i2c xfer: < 3f ERROR: NO_DEVICE
> [   13.817214] saa7133[1]: i2c xfer: < 41 >
> [   13.824136] saa7133[1]: i2c xfer: < 43 >
> [   13.832136] saa7133[1]: i2c xfer: < 45 ERROR: NO_DEVICE
> [   13.832285] saa7133[1]: i2c xfer: < 47 ERROR: NO_DEVICE
> ...snip...
> [   13.838640] saa7133[1]: i2c xfer: < 9d ERROR: NO_DEVICE
> [   13.838788] saa7133[1]: i2c xfer: < 9f ERROR: NO_DEVICE
> [   13.838935] saa7133[1]: i2c xfer: < a1 >
> [   13.844136] saa7133[1]: i2c xfer: < a3 ERROR: NO_DEVICE
> [   13.844285] saa7133[1]: i2c xfer: < a5 ERROR: NO_DEVICE
> ....snip...
> [   13.850787] saa7133[1]: i2c xfer: < fd ERROR: NO_DEVICE
> [   13.850935] saa7133[1]: i2c xfer: < ff ERROR: NO_DEVICE
> [   13.678908] saa6752hs 1-0021: chip found (gms1) @ 0x42 (saa7133[0])
> [   13.678926] saa7133[0]: i2c xfer: < 42 13 >
> [   13.684221] saa7133[0]: i2c xfer: < 43 =05 =07 =00 =00 =56 =31 =42
> =34 =02 =06 =00 =00 >
> [   13.692156] saa6752hs 1-0021: support AC-3
> [   13.692177] saa6752hs i2c attach [addr=0x21,client=saa6752hs]
> [   13.692380] saa7133[0]: registered device video0 [v4l2]
> [   13.692433] saa7133[0]: registered device vbi0

Ah, that pcf8574 was most confusing.

Gordon and Hans, Thanks.

Cheers,
Hermann


