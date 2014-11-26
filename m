Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57200 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaKZQzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 11:55:41 -0500
Message-ID: <1417020934.3177.15.camel@pengutronix.de>
Subject: Re: i.MX6 CODA960 encoder
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Date: Wed, 26 Nov 2014 17:55:34 +0100
In-Reply-To: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
References: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Mittwoch, den 26.11.2014, 14:33 +0100 schrieb Jean-Michel Hautbois:
> Hi,
> 
> We are writing a gstreamer plugin to support CODA960 encoder on i.MX6,
> and it is not working so now trying to use v4l2-ctl for the moment.
> As I am asking about encoder, is there a way to make it support YUYV
> as input or is the firmware not able to do it ? I could not find a
> reference manual about that...

The H.264 and MPEG-4 encoders support planar 4:2:0 subsampled formats
only: YU12, YV12, and chroma-interleaved NV12.
The JPEG encoder can also handle planar 4:2:2 subsampled frames, but
none of the interleaved (YUYV, UYVY, ...) variants.

> So back to the issue.
> $> cat /sys/class/video4linux/video0/name
> coda-encoder
> $> v4l2-ctl -d0 --list-formats
> ioctl: VIDIOC_ENUM_FMT
>     Index       : 0
>     Type        : Video Capture
>     Pixel Format: 'H264' (compressed)
>     Name        : H264 Encoded Stream
> 
>     Index       : 1
>     Type        : Video Capture
>     Pixel Format: 'MPG4' (compressed)
>     Name        : MPEG4 Encoded Stream
> 
> $> v4l2-ctl -d0 --list-formats-out
> ioctl: VIDIOC_ENUM_FMT
>     Index       : 0
>     Type        : Video Output
>     Pixel Format: 'YU12'
>     Name        : YUV 4:2:0 Planar, YCbCr
> 
>     Index       : 1
>     Type        : Video Output
>     Pixel Format: 'YV12'
>     Name        : YUV 4:2:0 Planar, YCrCb

Please apply all coda patches in the media-tree master branch first.
The output format list should include NV12 then.

> ==> First question, vid-cap should be related to the capture format,
> so YUV format in the encoder case, no ?
> 
> $> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelformat=YU12
> $> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
> unsupported pixelformat
> VIDIOC_STREAMON: failed: Invalid argument

On v3.18-rc6 with the coda patches currently in the pipeline applied, I
get this:

$ v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelformat=YU12
$ v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
K>P>P>P>P>P>P>P>P>P>P>P>P>P>P>P>K>P>P>P>P>P>P>P>P>P>P>P>P>P>P>P>K>P>P>P>P>P>P 38 fps
> 38 fps
[...]

> And here is the dmesg :
> [  444.470057] coda 2040000.vpu: s_ctrl: id = 9963796, val = 0
> [  444.470093] coda 2040000.vpu: s_ctrl: id = 9963797, val = 0
> [  444.470118] coda 2040000.vpu: s_ctrl: id = 10029519, val = 0
> [  444.470140] coda 2040000.vpu: s_ctrl: id = 10029515, val = 16
> [  444.470162] coda 2040000.vpu: s_ctrl: id = 10029662, val = 25
> [  444.470183] coda 2040000.vpu: s_ctrl: id = 10029663, val = 25
> [  444.470205] coda 2040000.vpu: s_ctrl: id = 10029666, val = 51
> [  444.470226] coda 2040000.vpu: s_ctrl: id = 10029672, val = 0
> [  444.470248] coda 2040000.vpu: s_ctrl: id = 10029673, val = 0
> [  444.470268] coda 2040000.vpu: s_ctrl: id = 10029674, val = 0
> [  444.470289] coda 2040000.vpu: s_ctrl: id = 10029712, val = 2
> [  444.470310] coda 2040000.vpu: s_ctrl: id = 10029713, val = 2
> [  444.470330] coda 2040000.vpu: s_ctrl: id = 10029533, val = 0
> [  444.470351] coda 2040000.vpu: s_ctrl: id = 10029532, val = 1
> [  444.470372] coda 2040000.vpu: s_ctrl: id = 10029531, val = 500
> [  444.470393] coda 2040000.vpu: s_ctrl: id = 10029528, val = 1
> [  444.470414] coda 2040000.vpu: s_ctrl: id = 10029526, val = 0
> [  444.484473] coda 2040000.vpu: Created instance 0 (bdade800)
> [  444.484503] video0: open (0)
> [  444.484586] video0: VIDIOC_QUERYCAP: driver=coda, card=CODA960,
> bus=platform:coda, version=0x00031200, capabilities=0x84208000,
> device_caps=0x04208000
> [  444.484685] video0: VIDIOC_QUERYCTRL: id=0x980001, type=6,
> name=User Controls, min/max=0/0, step=0, default=0, flags=0x00000044
> [  444.484768] video0: VIDIOC_QUERYCTRL: id=0x980914, type=2,
> name=Horizontal Flip, min/max=0/1, step=1, default=0, flags=0x00000000
> [  444.487570] video0: VIDIOC_QUERYCTRL: id=0x980915, type=2,
> name=Vertical Flip, min/max=0/1, step=1, default=0, flags=0x00000000
> [  444.487741] video0: VIDIOC_QUERYCTRL: id=0x990001, type=6,
> name=Codec Controls, min/max=0/0, step=0, default=0, flags=0x00000044
> [  444.487818] video0: VIDIOC_QUERYCTRL: id=0x9909cb, type=1,
> name=Video GOP Size, min/max=1/60, step=1, default=16,
> flags=0x00000000
> [  444.487954] video0: VIDIOC_QUERYCTRL: id=0x9909cf, type=1,
> name=Video Bitrate, min/max=0/32767000, step=1, default=0,
> flags=0x00000000
> [  444.488109] video0: VIDIOC_QUERYCTRL: id=0x9909d6, type=1,
> name=Number of Intra Refresh MBs, min/max=0/8160, step=1, default=0,
> flags=0x00000000
> [  444.488280] video0: VIDIOC_QUERYCTRL: id=0x9909d8, type=3,
> name=Sequence Header Mode, min/max=0/1, step=1, default=1,
> flags=0x00000000
> [  444.488434] video0: VIDIOC_QUERYCTRL: id=0x9909db, type=1,
> name=Maximum Bytes in a Slice, min/max=1/1073741823, step=1,
> default=500, flags=0x00000000
> [  444.488599] video0: VIDIOC_QUERYCTRL: id=0x9909dc, type=1,
> name=Number of MBs in a Slice, min/max=1/1073741823, step=1,
> default=1, flags=0x00000000
> [  444.488760] video0: VIDIOC_QUERYCTRL: id=0x9909dd, type=3,
> name=Slice Partitioning Method, min/max=0/2, step=1, default=0,
> flags=0x00000000
> [  444.488928] video0: VIDIOC_QUERYCTRL: id=0x990a5e, type=1,
> name=H264 I-Frame QP Value, min/max=0/51, step=1, default=25,
> flags=0x00000000
> [  444.489080] video0: VIDIOC_QUERYCTRL: id=0x990a5f, type=1,
> name=H264 P-Frame QP Value, min/max=0/51, step=1, default=25,
> flags=0x00000000
> [  444.489234] video0: VIDIOC_QUERYCTRL: id=0x990a62, type=1,
> name=H264 Maximum QP Value, min/max=0/51, step=1, default=51,
> flags=0x00000000
> [  444.489390] video0: VIDIOC_QUERYCTRL: id=0x990a68, type=1,
> name=H264 Loop Filter Alpha Offset, min/max=0/15, step=1, default=0,
> flags=0x00000000
> [  444.489565] video0: VIDIOC_QUERYCTRL: id=0x990a69, type=1,
> name=H264 Loop Filter Beta Offset, min/max=0/15, step=1, default=0,
> flags=0x00000000
> [  444.489737] video0: VIDIOC_QUERYCTRL: id=0x990a6a, type=3,
> name=H264 Loop Filter Mode, min/max=0/1, step=1, default=0,
> flags=0x00000000
> [  444.489892] video0: VIDIOC_QUERYCTRL: id=0x990a90, type=1,
> name=MPEG4 I-Frame QP Value, min/max=1/31, step=1, default=2,
> flags=0x00000000
> [  444.490046] video0: VIDIOC_QUERYCTRL: id=0x990a91, type=1,
> name=MPEG4 P-Frame QP Value, min/max=1/31, step=1, default=2,
> flags=0x00000000
> [  444.490225] video0: VIDIOC_QUERYCTRL: error -22: id=0x80990a91,
> type=0, name=, min/max=0/0, step=0, default=0, flags=0x00000000
> [  444.490373] video0: VIDIOC_SUBSCRIBE_EVENT: type=0x2, id=0x0, flags=0x0
> [  444.490734] coda 2040000.vpu: get 3 buffer(s) of size 1048576 each.
> [  444.519024] video0: VIDIOC_REQBUFS: count=3, type=vid-cap, memory=mmap
> [  444.519140] coda 2040000.vpu: get 3 buffer(s) of size 3133440 each.
> [  444.566697] video0: VIDIOC_REQBUFS: count=3, type=vid-out, memory=mmap
> [  444.566745] video0: VIDIOC_QUERYBUF: 00:00:00.00000000 index=0,
> type=vid-cap, flags=0x00004000, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x40000000, length=1048576
> [  444.566780] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.566870] video0: mmap (0)
> [  444.566901] video0: VIDIOC_QBUF: 00:00:00.00000000 index=0,
> type=vid-cap, flags=0x00004003, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x0, length=1048576
> [  444.566935] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.566951] video0: VIDIOC_QUERYBUF: 00:00:00.00000000 index=1,
> type=vid-cap, flags=0x00004000, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x40100000, length=1048576
> [  444.566983] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.567022] video0: mmap (0)
> [  444.567042] video0: VIDIOC_QBUF: 00:00:00.00000000 index=1,
> type=vid-cap, flags=0x00004003, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x100000, length=1048576
> [  444.567075] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.567090] video0: VIDIOC_QUERYBUF: 00:00:00.00000000 index=2,
> type=vid-cap, flags=0x00004000, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x40200000, length=1048576
> [  444.567122] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.567171] video0: mmap (0)
> [  444.567193] video0: VIDIOC_QBUF: 00:00:00.00000000 index=2,
> type=vid-cap, flags=0x00004003, field=any, sequence=0, memory=mmap,
> bytesused=0, offset/userptr=0x200000, length=1048576
> [  444.567224] timecode=00:00:00 type=0, flags=0x00000000, frames=0,
> userbits=0x00000000
> [  444.567241] video0: VIDIOC_G_FMT: type=vid-out, width=1920,
> height=1088, pixelformat=YU12, field=none, bytesperline=1920,
> sizeimage=3133440, colorspace=3, flags 0
> [  444.567986] video0: VIDIOC_STREAMON: type=vid-cap
> [  444.568019] video0: VIDIOC_STREAMON: error -22: type=vid-out
> [  444.569843] coda 2040000.vpu: Releasing instance bdade800
> [  444.569930] coda 2040000.vpu: coda_stop_streaming: capture
> [  444.574044] video0: release
> 
> What did I miss ?
> How has it been tested (this would give me a way to test it the same way) ?
> 
> Thanks,
> JM

regards
Philipp

