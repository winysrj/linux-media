Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OIpTrd023564
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 14:51:29 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2OIp27G011544
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 14:51:03 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+video4linux-list@gmail.com>,
	"Robert W. Boone" <rboone@rtd.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1237860232.4023.14.camel@pc07.localdom.local>
References: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
	<1237608177.13642.8.camel@pc07.localdom.local>
	<2df568dc0903231033t30ed26afr80b413e889b096ae@mail.gmail.com>
	<1237860232.4023.14.camel@pc07.localdom.local>
Content-Type: multipart/mixed; boundary="=-SoVQ6knTrCT83LHOf7vD"
Date: Tue, 24 Mar 2009 19:47:13 +0100
Message-Id: <1237920433.4964.30.camel@pc07.localdom.local>
Mime-Version: 1.0
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


--=-SoVQ6knTrCT83LHOf7vD
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Am Dienstag, den 24.03.2009, 03:03 +0100 schrieb hermann pitton:
> Hi,
> 
> Am Montag, den 23.03.2009, 11:33 -0600 schrieb Gordon Smith:
> > On Fri, Mar 20, 2009 at 10:02 PM, hermann pitton
> > <hermann-pitton@arcor.de> wrote:
> > >
> > > Hi,
> > >
> > > Am Freitag, den 20.03.2009, 14:24 -0600 schrieb Gordon Smith:
> > > > Hello -
> > > >
> > > > I'm unable to read or stream compressed data from saa7134/saa6752hs.
> > > >
> > > > I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> > > > hardware encoder per channel, no tuner) running current v4l-dvb in
> > > > debian 2.6.26-1.
> > > >
> > > > MPEG2-TS data is normally available on /dev/video2 and /dev/video3.
> > > >
> > > > Previously there were parameters for the saa6752hs module named
> > > > "force" and "ignore" to modify i2c addresses. The current module
> > > > appears to lack those parameters and may be using incorrect i2c addresses.
> > > >
> > > > Current dmesg:
> > > >
> > > > [   13.388944] saa6752hs 3-0020: chip found @ 0x40 (saa7133[0])
> > > > [   13.588458] saa6752hs 4-0020: chip found @ 0x40 (saa7133[1])
> > > >
> > > > Prior dmesg (~2.6.25-gentoo-r7 + v4l-dvb ???):
> > > >
> > > > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> > > > saa6752hs 1-0021: saa6752hs: chip found @ 0x42
> > > >
> > > > Prior modprobe.conf entry:
> > > > options saa6752hs force=0x1,0x21,0x2,0x21 ignore=0x0,0x20,0x1,0x20,0x2,0x20

It was disabled by Hans when converting to v4l2_subdev here.
http://linuxtv.org/hg/v4l-dvb/rev/c41af551e79f

It is only valid for kernels < 2.6.22 now in saa6752hs.

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22) 
/* Addresses to scan */ 
static unsigned short normal_i2c[] = {0x20, I2C_CLIENT_END}; 

I2C_CLIENT_INSMOD; 
+#endif 

And we only have that single 0x20 address in saa7134-core.c etc.
That should be the problem.

> > > >
> > > > $ v4l2-dbg --device /dev/video2 --info
> > > > Driver info:
> > > >         Driver name   : saa7134
> > > >         Card type     : RTD Embedded Technologies VFG73
> > > >         Bus info      : PCI:0000:02:08.0
> > > >         Driver version: 526
> > > >         Capabilities  : 0x05000001
> > > >                 Video Capture
> > > >                 Read/Write
> > > >                 Streaming
> > > >
> > > > Streaming is a listed capability but the capture example at
> > > > http://v4l2spec.bytesex.org/spec/capture-example.html fails
> > > > during request for buffers.
> > > >
> > > > $ v4l2-capture --device /dev/video2 --mmap
> > > > /dev/video2 does not support memory mapping
> > > >
> > > > v4l2-capture.c:
> > > >         req.count               = 4;
> > > >         req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > > >         req.memory              = V4L2_MEMORY_MMAP;
> > > >
> > > >         if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
> > > >                 if (EINVAL == errno) {
> > > >                         fprintf (stderr, "%s does not support "
> > > >                                  "memory mapping\n", dev_name);
> > > >
> > > >
> > > > A read() results in EIO error:
> > > >
> > > > $ v4l2-capture --device /dev/video0 --read
> > > > read error 5, Input/output error
> > > >
> > > > v4l2-capture.c:
> > > >                 if (-1 == read (fd, buffers[0].start, buffers[0].length)) {
> > > >                         switch (errno) {
> > > >             ...
> > > >                         default:
> > > >                                 errno_exit ("read");
> > > >
> > > >
> > > > This behavior does not change if the saa6752hs module is not loaded.
> > > >
> > > > Is there still a way to modify the i2c address(es) for the saa6752hs module?
> > > >
> > > > Any pointers are appreciated.
> > > >
> > > > Gordon
> > > >
> > >
> > > thanks for the report.
> > >
> > > It was probably forgotten that the prior insmod option had a reason.
> > >
> > > Try to change it to 0x21 in saa7134-i2c.c
> > >
> > > static char *i2c_devs[128] = {
> > >        [ 0x20      ] = "mpeg encoder (saa6752hs)",
> > >        [ 0xa0 >> 1 ] = "eeprom",
> > >        [ 0xc0 >> 1 ] = "tuner (analog)",
> > >        [ 0x86 >> 1 ] = "tda9887",
> > >        [ 0x5a >> 1 ] = "remote control",
> > > };
> > >
> > > and report if your cards a usable again.
> > >
> > > Seems we need the chip address per card without that insmod option and
> > > reliable probing.
> > >
> > > Cheers,
> > > Hermann
> > 
> > Hermann -
> > 
> > I made the change to saa7134-i2c.c but the i2c address did not change.
> > I added my initials (gms) to dmesg, so I know I'm loading the new
> > module.
> > 
> > I set i2c_debug=1 for saa7134. Here is one device:
> > 
> > [   13.369175] saa7130/34: v4l2 driver version 0.2.14-gms loaded
> > [   13.369294] saa7133[0]: found at 0000:02:08.0, rev: 17, irq: 11,
> > latency: 32, mmio: 0x80000000
> > [   13.369310] saa7133[0]: subsystem: 1435:7350, board: RTD Embedded
> > Technologies VFG7350 [card=72,autodetected]
> > [   13.369335] saa7133[0]: board init: gpio is 10000
> > [   13.472509] saa7133[0]: i2c xfer: < a0 00 >
> > [   13.480139] saa7133[0]: i2c xfer: < a1 =35 =14 =50 =73 =ff =ff =ff
> > =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> > ....snip...
> > =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
> > [   13.520135] saa7133[0]: i2c eeprom 00: 35 14 50 73 ff ff ff ff ff
> > ff ff ff ff ff ff ff
> > ....snip...
> > [   13.520467] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff
> > [   13.608743] saa6752hs 1-0020: chip found (gms) @ 0x40 (saa7133[0])
> > [   13.608762] saa7133[0]: i2c xfer: < 40 13 >
> > [   13.616164] saa7133[0]: i2c xfer: < 41 =13 =13 =13 =13 =13 =13 =13
> > =13 =13 =13 =13 =13 >
> > [   13.624161] saa6752hs i2c attach [addr=0x20,client=saa6752hs]
> > [   13.624337] saa7133[0]: registered device video0 [v4l2]
> > [   13.624390] saa7133[0]: registered device vbi0
> 
> yes, sorry, there is more to change.
> 
> The 0x20 address is also hard coded in saa7134-core.c, saa7134-empress.c
> and saa6752hs.c.
> 
> I also don't find your old insmod option for multiple addresses back to
> 2.6.18 for now. I'll try to find some time to look up the history next
> days.

See above, static unsigned short normal_i2c[] seems to have allowed to
set even 0x21, but only 0x20 was visible there.

> With the wrong address and i2c_debug=1 you should see a bunch of ERROR:
> NO DEVICE stuff from 0x40 and 0x41 if you try "cat /dev/video2" mpeg.
> 
> Is it really detected at 0x42 with i2c_scan=1 ?
> Except on i2c_debug level the code seems to tolerate all wrong addresses
> without warnings.

Please provide the i2c_scan with the device detected at 0x42. I seem to
find all card related mails from Robert W. Boone from RTD, but not that
different address information.

We should wait until Hans is back from the Linux embedded conference,
since he is working on it and I don't even have a working empress
device, but it seems we need a solution for multiple addresses here too.

If I did not miss anything greping around after lunch, the attached
patch might work as an interim for you.

Cheers,
Hermann





--=-SoVQ6knTrCT83LHOf7vD
Content-Disposition: inline; filename=empress-saa6752hs-at-0x21-testing.patch
Content-Type: text/x-patch; name=empress-saa6752hs-at-0x21-testing.patch;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 12a10f808bfd linux/drivers/media/video/saa7134/saa6752hs.c
--- a/linux/drivers/media/video/saa7134/saa6752hs.c	Sat Feb 14 08:51:28 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa6752hs.c	Tue Mar 24 14:31:09 2009 +0100
@@ -48,7 +48,7 @@
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
 /* Addresses to scan */
-static unsigned short normal_i2c[] = {0x20, I2C_CLIENT_END};
+static unsigned short normal_i2c[] = {0x21, I2C_CLIENT_END};
 
 I2C_CLIENT_INSMOD;
 #endif
diff -r 12a10f808bfd linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Sat Feb 14 08:51:28 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue Mar 24 14:31:09 2009 +0100
@@ -1044,7 +1044,7 @@
 	if (card_is_empress(dev)) {
 		struct v4l2_subdev *sd =
 			v4l2_i2c_new_subdev(&dev->i2c_adap, "saa6752hs",
-				"saa6752hs", 0x20);
+				"saa6752hs", 0x21);
 
 		if (sd)
 			sd->grp_id = GRP_EMPRESS;
diff -r 12a10f808bfd linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Sat Feb 14 08:51:28 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Mar 24 14:31:09 2009 +0100
@@ -417,7 +417,7 @@
 	    !strcmp(chip->match.name, "saa6752hs"))
 		return saa_call_empress(dev, core, g_chip_ident, chip);
 	if (chip->match.type == V4L2_CHIP_MATCH_I2C_ADDR &&
-	    chip->match.addr == 0x20)
+	    chip->match.addr == 0x21)
 		return saa_call_empress(dev, core, g_chip_ident, chip);
 	return -EINVAL;
 }
diff -r 12a10f808bfd linux/drivers/media/video/saa7134/saa7134-i2c.c
--- a/linux/drivers/media/video/saa7134/saa7134-i2c.c	Sat Feb 14 08:51:28 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-i2c.c	Tue Mar 24 14:31:09 2009 +0100
@@ -407,7 +407,7 @@
 }
 
 static char *i2c_devs[128] = {
-	[ 0x20      ] = "mpeg encoder (saa6752hs)",
+	[ 0x21      ] = "mpeg encoder (saa6752hs)",
 	[ 0xa0 >> 1 ] = "eeprom",
 	[ 0xc0 >> 1 ] = "tuner (analog)",
 	[ 0x86 >> 1 ] = "tda9887",

--=-SoVQ6knTrCT83LHOf7vD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-SoVQ6knTrCT83LHOf7vD--
