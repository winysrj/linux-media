Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:42563 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbeDLOAm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 10:00:42 -0400
Received: by mail-qt0-f173.google.com with SMTP id j3so6251483qtn.9
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 07:00:42 -0700 (PDT)
MIME-Version: 1.0
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Thu, 12 Apr 2018 16:00:41 +0200
Message-ID: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
Subject: imx-media: MT9P031 Capture issues on IMX6
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings everyone,
I am using Linux 4.14.31 on an IMX6 platform, with an MT9P031 sensor
attached to the ipu1_csi0 (parallel).
My Gstreamer version is 1.14.0 and v4l-utils version is 1.14.2.
The problem is that I am unable to set up a capture pipeline.

Even the simplest capture pipeline such as:

gst-launch-1.0 v4l2src device=/dev/video4 ! fakesink

returns the following error:
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
Internal data stream error.
Additional debug info:
../../../../gstreamer-1.14.0/libs/gst/base/gstbasesrc.c(3055):
gst_base_src_loop (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
streaming stopped, reason not-negotiated (-4)
ERROR: pipeline doesn't want to preroll.

I get the same error on any pipeline involving v4l2src.

I have set up the media entity links using:
media-ctl -l "'mt9p031 0-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"

And I configure the pads using:
media-ctl -V "'mt9p031 0-0048':0 [fmt:SGRBG8/640x480 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:SGRBG8/640x480 field:none]"
media-ctl -V "'ipu1_csi0':2 [fmt:SGRBG8/640x480 field:none]"

And I do not get any errors from these commands.

The output of "v4l2-ctl --all -d /dev/video4" is:

Driver Info (not using libv4l2):
        Driver name   : imx-media-captu
        Card type     : imx-media-capture
        Bus info      : platform:ipu1_csi0
        Driver version: 4.14.31
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
Format Video Capture:
        Width/Height      : 656/486
        Pixel Format      : 'GR16'
        Field             : None
        Bytes per Line    : 1312
        Size Image        : 637632
        Colorspace        : sRGB
        Transfer Function : sRGB
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Full Range
        Flags             : ee8abea8
Streaming Parameters Video Capture:
        Capabilities     : timeperframe
        Frames per second: 30.000 (30/1)
        Read buffers     : 0

User Controls

                       exposure 0x00980911 (int)    : min=1
max=1048575 step=1 default=1943 value=1943
                           gain 0x00980913 (int)    : min=8 max=1024
step=1 default=8 value=8
                horizontal_flip 0x00980914 (bool)   : default=0 value=0
                  vertical_flip 0x00980915 (bool)   : default=0 value=0
                       blc_auto 0x00981902 (bool)   : default=1 value=1
               blc_target_level 0x00981903 (int)    : min=0 max=4095
step=1 default=168 value=168
              blc_analog_offset 0x00981904 (int)    : min=-255 max=255
step=1 default=32 value=32
             blc_digital_offset 0x00981905 (int)    : min=-2048
max=2047 step=1 default=40 value=40
                     fim_enable 0x00981990 (bool)   : default=0 value=0
                fim_num_average 0x00981991 (int)    : min=1 max=64
step=1 default=8 value=8
              fim_tolerance_min 0x00981992 (int)    : min=2 max=200
step=1 default=50 value=50
              fim_tolerance_max 0x00981993 (int)    : min=0 max=500
step=1 default=0 value=0
                   fim_num_skip 0x00981994 (int)    : min=0 max=256
step=1 default=2 value=2
         fim_input_capture_edge 0x00981995 (int)    : min=0 max=3
step=1 default=0 value=0
      fim_input_capture_channel 0x00981996 (int)    : min=0 max=1
step=1 default=0 value=0

Image Processing Controls

                     pixel_rate 0x009f0902 (int64)  : min=54000000
max=54000000 step=1 default=54000000 value=54000000 flags=read-only
                   test_pattern 0x009f0903 (menu)   : min=0 max=9
default=0 value=0


What confuses me here is that the Pixel Format shown by v4l2-ctl is
'GR16', which is not what I expected. And it seems like the media-ctl
pad configuration commands are unable to change the Pixel Format, even
though they do not return any errors.

I would really appreciate if anyone could help in debugging this issue.

Thanks and best regards,
Ibtsam Haq
