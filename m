Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33379 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964791AbcKMWAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 17:00:40 -0500
Received: by mail-qk0-f170.google.com with SMTP id x190so76824944qkb.0
        for <linux-media@vger.kernel.org>; Sun, 13 Nov 2016 14:00:39 -0800 (PST)
MIME-Version: 1.0
From: "Md. Islam" <mislam4@kent.edu>
Date: Sun, 13 Nov 2016 17:00:38 -0500
Message-ID: <CAFgPn1CFzn=Si4PeLHLQe4sskh07iD0uMNJBvwqgAcpXdnJTaA@mail.gmail.com>
Subject: Querying V4L2_CTRL_CLASS_MPEG doesn't return anything
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I want to set the bitrate of my webcam (HP Envy laptop). ./v4l2-ctl
--all gives me following:

Driver Info (not using libv4l2):
Driver name   : uvcvideo
Card type     : HP Truevision HD
Bus info      : usb-0000:00:1d.0-1.3
Driver version: 4.4.24
Capabilities  : 0x84200001
Video Capture
Streaming
Extended Pix Format
Device Capabilities
Device Caps   : 0x04200001
Video Capture
Streaming
Extended Pix Format
Priority: 2
Video input : 0 (Camera 1: ok)
Format Video Capture:
Width/Height      : 1280/720
Pixel Format      : 'MJPG'
Field             : None
Bytes per Line    : 0
Size Image        : 1843789
Colorspace        : sRGB
Transfer Function : Default
YCbCr Encoding    : Default
Quantization      : Default
Flags             :
Crop Capability Video Capture:
Bounds      : Left 0, Top 0, Width 1280, Height 720
Default     : Left 0, Top 0, Width 1280, Height 720
Pixel Aspect: 1/1
Selection: crop_default, Left 0, Top 0, Width 1280, Height 720
Selection: crop_bounds, Left 0, Top 0, Width 1280, Height 720
Streaming Parameters Video Capture:
Capabilities     : timeperframe
Frames per second: 30.000 (30/1)
Read buffers     : 0
                     brightness (int)    : min=-64 max=64 step=1
default=0 value=0
                       contrast (int)    : min=0 max=64 step=1
default=32 value=32
                     saturation (int)    : min=0 max=128 step=1
default=64 value=64
                            hue (int)    : min=-40 max=40 step=1
default=0 value=0
 white_balance_temperature_auto (bool)   : default=1 value=1
                          gamma (int)    : min=72 max=500 step=1
default=100 value=100
                           gain (int)    : min=0 max=100 step=1
default=0 value=0
           power_line_frequency (menu)   : min=0 max=2 default=2 value=2
      white_balance_temperature (int)    : min=2800 max=6500 step=1
default=4000 value=4000 flags=inactive
                      sharpness (int)    : min=0 max=5 step=1 default=0 value=0
         backlight_compensation (int)    : min=0 max=1 step=1 default=0 value=0
                  exposure_auto (menu)   : min=0 max=3 default=3 value=3
              exposure_absolute (int)    : min=10 max=2500 step=1
default=156 value=156 flags=inactive
         exposure_auto_priority (bool)   : default=0 value=1

I don't see MPEG related options here. Does it mean that MPEG is not
supported by the webcam? I also tried following function to query
V4L2_CTRL_CLASS_MPEG options.

static void show_mpeg_controls(int fd, int show_menus)
{
const unsigned next_fl = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_CLASS_MPEG;
struct v4l2_query_ext_ctrl qctrl;
int id;

memset(&qctrl, 0, sizeof(qctrl));
qctrl.id = next_fl;
while (query_ext_ctrl_ioctl(fd, qctrl) == 0) {
            if (V4L2_CTRL_ID2CLASS(qctrl.id) != V4L2_CTRL_CLASS_MPEG)
                break;
print_control(fd, qctrl, show_menus);
qctrl.id |= next_fl;
}
}

It wouldn't print anything. Could you please advise me what is wrong
here? I'm new to V4L2. Looking forward to your suggestions.

Many thanks
Tamim
