Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2KKOXpH021906
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:24:33 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2KKODbc015564
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:24:13 -0400
Received: by yw-out-2324.google.com with SMTP id 3so720154ywj.81
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 13:24:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Mar 2009 14:24:12 -0600
Message-ID: <2df568dc0903201324rc5c4982x45ce071c39ddc74b@mail.gmail.com>
From: Gordon Smith <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Failure to read saa7134/saa6752hs MPEG output
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

Hello -

I'm unable to read or stream compressed data from saa7134/saa6752hs.

I have a RTD Technologies VFG7350 (saa7134 based, two channel,
hardware encoder per channel, no tuner) running current v4l-dvb in
debian 2.6.26-1.

MPEG2-TS data is normally available on /dev/video2 and /dev/video3.

Previously there were parameters for the saa6752hs module named
"force" and "ignore" to modify i2c addresses. The current module
appears to lack those parameters and may be using incorrect i2c addresses.

Current dmesg:

[   13.388944] saa6752hs 3-0020: chip found @ 0x40 (saa7133[0])
[   13.588458] saa6752hs 4-0020: chip found @ 0x40 (saa7133[1])

Prior dmesg (~2.6.25-gentoo-r7 + v4l-dvb ???):

saa6752hs 1-0021: saa6752hs: chip found @ 0x42
saa6752hs 1-0021: saa6752hs: chip found @ 0x42

Prior modprobe.conf entry:
options saa6752hs force=0x1,0x21,0x2,0x21 ignore=0x0,0x20,0x1,0x20,0x2,0x20


$ v4l2-dbg --device /dev/video2 --info
Driver info:
        Driver name   : saa7134
        Card type     : RTD Embedded Technologies VFG73
        Bus info      : PCI:0000:02:08.0
        Driver version: 526
        Capabilities  : 0x05000001
                Video Capture
                Read/Write
                Streaming

Streaming is a listed capability but the capture example at
http://v4l2spec.bytesex.org/spec/capture-example.html fails
during request for buffers.

$ v4l2-capture --device /dev/video2 --mmap
/dev/video2 does not support memory mapping

v4l2-capture.c:
        req.count               = 4;
        req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory              = V4L2_MEMORY_MMAP;

        if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
                if (EINVAL == errno) {
                        fprintf (stderr, "%s does not support "
                                 "memory mapping\n", dev_name);


A read() results in EIO error:

$ v4l2-capture --device /dev/video0 --read
read error 5, Input/output error

v4l2-capture.c:
                if (-1 == read (fd, buffers[0].start, buffers[0].length)) {
                        switch (errno) {
            ...
                        default:
                                errno_exit ("read");


This behavior does not change if the saa6752hs module is not loaded.

Is there still a way to modify the i2c address(es) for the saa6752hs module?

Any pointers are appreciated.

Gordon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
