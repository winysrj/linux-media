Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36913 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaKDVF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 16:05:26 -0500
Received: by mail-pd0-f182.google.com with SMTP id fp1so14475956pdb.27
        for <linux-media@vger.kernel.org>; Tue, 04 Nov 2014 13:05:25 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 5 Nov 2014 01:05:25 +0400
Message-ID: <CANZNk82AqfbSkUd_xONtjAxLePA0TMhS_5wuWERObyGSZ5QYoA@mail.gmail.com>
Subject: v4l2-ctl bug(?) printing ctrl payload array
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com,
	gjasny@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I used today's git master HEAD of v4l-utils.
There's a device which provides r/w v4l2 control for a map of motion
thresholds by regions. See

md_threshold_grid (u16)    : min=0 max=65535 step=1 default=768
[45][45] flags=has-payload

So when i print its value with "-C md_threshold_grid", i see "MD
Threshold Grid[0]:" in the beginning of every line. I guess it is
supposed to have a number in brackets increase each line?
I am not smart enought to fix this in code from first glance, so I'm
just reporting this.

00:57:28krieger@zver /usr/local/src/v4l-utils/utils/v4l2-ctl
 $ git describe --long
v4l-utils-1.6.0-29-gc873001

00:49:32krieger@zver /usr/local/src/v4l-utils/utils/v4l2-ctl
 $ ./v4l2-ctl -d /dev/video12 --all
Driver Info (not using libv4l2):
        Driver name   : solo6x10
        Card type     : Softlogic 6x10 Enc 2
        Bus info      : PCI:0000:07:05.0
        Driver version: 3.18.0
        Capabilities  : 0x85200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format
Priority: 2
Video input : 0 (Encoder 3: no signal)
Video Standard = 0x00001000
        NTSC-M
Format Video Capture:
        Width/Height  : 352/240
        Pixel Format  : 'H264'
        Field         : None
        Bytes per Line: 0
        Size Image    : 200704
        Colorspace    : Broadcast NTSC/PAL (SMPTE170M/ITU601)
        Flags         :
Streaming Parameters Video Capture:
        Capabilities     : timeperframe
        Frames per second: 30.000 (30/1)
        Read buffers     : 2

User Controls

                     brightness (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                       contrast (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                     saturation (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                            hue (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                      sharpness (int)    : min=0 max=15 step=1
default=0 value=0 flags=slider
                       osd_text (str)    : min=0 max=44 step=1
value='' flags=has-payload

Codec Controls

                 video_gop_size (int)    : min=1 max=255 step=1
default=30 value=30
          h264_minimum_qp_value (int)    : min=0 max=31 step=1 default=3 value=3

Detection Controls

          motion_detection_mode (menu)   : min=0 max=2 default=0 value=2
            md_global_threshold (int)    : min=0 max=255 step=1
default=3 value=3 flags=slider
              md_threshold_grid (u16)    : min=0 max=65535 step=1
default=768 [45][45] flags=has-payload
                     brightness (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                       contrast (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                     saturation (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                            hue (int)    : min=0 max=255 step=1
default=128 value=128 flags=slider
                      sharpness (int)    : min=0 max=15 step=1
default=0 value=0 flags=slider

00:53:23krieger@zver /usr/local/src/v4l-utils/utils/v4l2-ctl
 $ ./v4l2-ctl -d /dev/video12 -C md_threshold_grid
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0
MD Threshold Grid[0]:      0,      0,      0,      0,      0,      0,
    0,      0,      0,      0,      0,      0,      0,      0,      0,
     0,      0,      0,      0,      0,      0,      0,      0,
0,      0,      0,      0,      0,      0,      0,      0,      0,
 0,      0,      0,      0,      0,      0,      0,      0,      0,
  0,      0,      0,      0

-- 
Andrey Utkin
