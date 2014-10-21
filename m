Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55782 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaJUNQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 09:16:47 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so954047obc.37
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 06:16:47 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 21 Oct 2014 15:16:31 +0200
Message-ID: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
Subject: [media] CODA960: Fails to allocate memory
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to use the CODA960 driver on a 3.18 kernel.
It seems pretty good when the module is probed (appart from the
unsupported firmware version) but when I try using the encoder, it
fails allocating dma buffers.

Here is the DT part I added :
&vpu {
    compatible = "fsl,imx6q-vpu";
    clocks = <&clks 168>, <&clks 140>, <&clks 142>;
    clock-names = "per", "ahb", "ocram";
    iramsize = <0x21000>;
    iram = <&ocram>;
    resets = <&src 1>;
    status = "okay";
};

When booting, I see :
[    4.410645] coda 2040000.vpu: Firmware code revision: 46056
[    4.416312] coda 2040000.vpu: Initialized CODA960.
[    4.421123] coda 2040000.vpu: Unsupported firmware version: 3.1.1
[    4.483577] coda 2040000.vpu: codec registered as /dev/video[0-1]

I can start v4l2-ctl and it shows that the device seems to be ok :
 v4l2-ctl --all -d /dev/video1
Driver Info (not using libv4l2):
        Driver name   : coda
        Card type     : CODA960
        Bus info      : platform:coda
        Driver version: 3.18.0
        Capabilities  : 0x84208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
Priority: 2
Format Video Capture:
        Width/Height  : 1920/1088
        Pixel Format  : 'YU12'
        Field         : None
        Bytes per Line: 1920
        Size Image    : 3133440
        Colorspace    : HDTV and modern devices (ITU709)
        Flags         :
Format Video Output:
        Width/Height  : 1920/1088
        Pixel Format  : 'H264'
        Field         : None
        Bytes per Line: 0
        Size Image    : 1048576
        Colorspace    : HDTV and modern devices (ITU709)
        Flags         :
Selection: compose, Left 0, Top 0, Width 1920, Height 1088
Selection: compose_default, Left 0, Top 0, Width 1920, Height 1088
Selection: compose_bounds, Left 0, Top 0, Width 1920, Height 1088
Selection: compose_padded, Left 0, Top 0, Width 1920, Height 1088
Selection: crop, Left 0, Top 0, Width 1920, Height 1088
Selection: crop_default, Left 0, Top 0, Width 1920, Height 1088
Selection: crop_bounds, Left 0, Top 0, Width 1920, Height 1088

User Controls

                horizontal_flip (bool)   : default=0 value=0
                  vertical_flip (bool)   : default=0 value=0

Codec Controls

                 video_gop_size (int)    : min=1 max=60 step=1
default=16 value=16
                  video_bitrate (int)    : min=0 max=32767000 step=1
default=0 value=0
    number_of_intra_refresh_mbs (int)    : min=0 max=8160 step=1
default=0 value=0
           sequence_header_mode (menu)   : min=0 max=1 default=1 value=1
       maximum_bytes_in_a_slice (int)    : min=1 max=1073741823 step=1
default=500 value=500
       number_of_mbs_in_a_slice (int)    : min=1 max=1073741823 step=1
default=1 value=1
      slice_partitioning_method (menu)   : min=0 max=2 default=0 value=0
          h264_i_frame_qp_value (int)    : min=0 max=51 step=1
default=25 value=25
          h264_p_frame_qp_value (int)    : min=0 max=51 step=1
default=25 value=25
          h264_maximum_qp_value (int)    : min=0 max=51 step=1
default=51 value=51
  h264_loop_filter_alpha_offset (int)    : min=0 max=15 step=1 default=0 value=0
   h264_loop_filter_beta_offset (int)    : min=0 max=15 step=1 default=0 value=0
          h264_loop_filter_mode (menu)   : min=0 max=1 default=0 value=0
         mpeg4_i_frame_qp_value (int)    : min=1 max=31 step=1 default=2 value=2
         mpeg4_p_frame_qp_value (int)    : min=1 max=31 step=1 default=2 value=2
                horizontal_flip (bool)   : default=0 value=0
                  vertical_flip (bool)   : default=0 value=0




But when I try to get a file outputed, it fails :

v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
[ 1197.292256] coda 2040000.vpu: dma_alloc_coherent of size 1048576 failed
VIDIOC_REQBUFS: failed: Cannot allocate memory

Did I forget to do something ?
Thanks,
JM
