Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f184.google.com ([209.85.212.184]:45217 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZJTQK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 12:10:57 -0400
Received: by vws14 with SMTP id 14so1838680vws.33
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 09:11:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 10:11:00 -0600
Message-ID: <2df568dc0910200911w301da2cbyb7ba8726d2f0c94a@mail.gmail.com>
Subject: saa7134-empress output format problem
From: Gordon Smith <spider.karma+linux-media@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello -

I have a saa7134 video encoder card "RTD Embedded Technologies VFG73"
in 2.6.28.9 with recent v4l2 (3919b17dc88e). It has two compression
channels and no tuner.

The output pixel format for the compressed devices is showing
'BGR3' and it should be 'MPEG'. The data from the output
device appears to be uncompressed data.

Also, the video standard has been disconnected from the input device.
The input device /dev/video1 is NTSC, and the encoded
output device /dev/video3 is PAL. They should both be NTSC. H.Verkuil
had initially fixed this problem last April.

I'm wondering if I missed something obvious or missed changes in the
last 6 months
or if there could be a regression problem.

Thanks for your help.

dmesg:
[    9.055669] saa7133[0]: registered device video0 [v4l2]
[    9.058483] saa7133[0]: registered device vbi0
[    9.218654] saa7133[1]: registered device video1 [v4l2]
[    9.218922] saa7133[1]: registered device vbi1
[    9.234472] saa7133[0]: registered device video2 [mpeg]
[    9.234802] saa7133[1]: registered device video3 [mpeg]

Prior correct pixel format (compare to further below):
Format Video Capture:
      Width/Height  : 720/576
      Pixel Format  : 'MPEG'
      Field         : Any
      Bytes per Line: 0
      Size Image    : 12032
      Colorspace    : Unknown (00000000)

Current info:

# v4l2-ctl --device /dev/video3 --all
Driver Info:
      Driver name   : saa7134
      Card type     : RTD Embedded Technologies VFG73
      Bus info      : PCI:0000:02:09.0
      Driver version: 527
      Capabilities  : 0x05000015
              Video Capture
              Video Overlay
              VBI Capture
              Read/Write
              Streaming
Format Video Capture:
      Width/Height  : 720/576
      Pixel Format  : 'BGR3'
      Field         : Interlaced
      Bytes per Line: 2160
      Size Image    : 1244160
      Colorspace    : Unknown (00000000)
Format Video Overlay:
      Left/Top    : 0/0
      Width/Height: 0/0
      Field       : Any
      Chroma Key  : 0x00000000
      Global Alpha: 0x00
      Clip Count  : 0
      Clip Bitmap : No
Format VBI Capture:
      Sampling Rate   : 27000000 Hz
      Offset          : 256 samples (9.48148e-06 secs after leading edge)
      Samples per Line: 2048
      Sample Format   : GREY
      Start 1st Field : 7
      Count 1st Field : 16
      Start 2nd Field : 319
      Count 2nd Field : 16
Framebuffer Format:
      Capability    : Clipping List
      Flags         :
      Width         : 0
      Height        : 0
      Pixel Format  : ''
      Bytes per Line: 0
      Size image    : 0
      Colorspace    : Unknown (00000000)
Crop Capability Video Capture:
      Bounds      : Left 0, Top 46, Width 720, Height 578
      Default     : Left 0, Top 48, Width 720, Height 576
      Pixel Aspect: 54/59
Crop: Left 0, Top 48, Width 720, Height 576
Video input : 0 (Composite 0)
Audio input : 0 (audio)
Frequency: 0 (0.000000 MHz)
Video Standard = 0x000000ff
      PAL-B/B1/G/H/I/D/D1/K
Tuner:
      Name                 :
      Capabilities         : 62.5 kHz
      Frequency range      : 0.0 MHz - 0.0 MHz
      Signal strength/AFC  : 0%/0
      Current audio mode   : mono
      Available subchannels:

# v4l2-ctl --device /dev/video1 --all
Driver Info:
      Driver name   : saa7134
      Card type     : RTD Embedded Technologies VFG73
      Bus info      : PCI:0000:02:08.0
      Driver version: 527
      Capabilities  : 0x05000015
              Video Capture
              Video Overlay
              VBI Capture
              Read/Write
              Streaming
Format Video Capture:
      Width/Height  : 720/576
      Pixel Format  : 'BGR3'
      Field         : Interlaced
      Bytes per Line: 2160
      Size Image    : 1244160
      Colorspace    : Unknown (00000000)
Format Video Overlay:
      Left/Top    : 0/0
      Width/Height: 0/0
      Field       : Any
      Chroma Key  : 0x00000000
      Global Alpha: 0x00
      Clip Count  : 0
      Clip Bitmap : No
Format VBI Capture:
      Sampling Rate   : 27000000 Hz
      Offset          : 256 samples (9.48148e-06 secs after leading edge)
      Samples per Line: 2048
      Sample Format   : GREY
      Start 1st Field : 10
      Count 1st Field : 12
      Start 2nd Field : 273
      Count 2nd Field : 12
Framebuffer Format:
      Capability    : Clipping List
      Flags         :
      Width         : 0
      Height        : 0
      Pixel Format  : ''
      Bytes per Line: 0
      Size image    : 0
      Colorspace    : Unknown (00000000)
Crop Capability Video Capture:
      Bounds      : Left 0, Top 44, Width 704, Height 480
      Default     : Left 0, Top 46, Width 704, Height 480
      Pixel Aspect: 11/10
Crop: Left 0, Top 46, Width 704, Height 480
Video input : 0 (Composite 0)
Audio input : 0 (audio)
Frequency: 0 (0.000000 MHz)
Video Standard = 0x0000b000
      NTSC-M/M-JP/M-KR
Tuner:
      Name                 :
      Capabilities         : 62.5 kHz
      Frequency range      : 0.0 MHz - 0.0 MHz
      Signal strength/AFC  : 0%/0
      Current audio mode   : mono
      Available subchannels:
