Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:60520 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965317Ab3FUHin (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:38:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by fpa01n0.fpasia.hk (Postfix) with ESMTP id 6F5A7CE9F38
	for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 15:38:41 +0800 (HKT)
Received: from fpa01n0.fpasia.hk ([127.0.0.1])
	by localhost (fpa01n0.office.fpa.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OnOxtL-eixXe for <linux-media@vger.kernel.org>;
	Fri, 21 Jun 2013 15:38:40 +0800 (HKT)
Received: from s01.gtsys.com.hk (gtsnode.office.fpasia.hk [10.10.37.40])
	by fpa01n0.fpasia.hk (Postfix) with ESMTP id 832C0CE9F37
	for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 15:38:40 +0800 (HKT)
Received: from [10.128.2.32] (n219077172016.netvigator.com [219.77.172.16])
	by s01.gtsys.com.hk (Postfix) with ESMTPSA id 51AF0C019E5
	for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 15:38:38 +0800 (HKT)
Message-ID: <51C402FF.7010909@gtsys.com.hk>
Date: Fri, 21 Jun 2013 15:38:39 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: imx27 coda interface no capture output
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

After Freescale was so kind and forward the v4l-codadx6-imx27.bin
the firmware loaded properly and I see a /dev/video1 the v4l_ctrl looks promising

root@gtsir-nand:~# v4l2-ctl --list-formats -d /dev/video1
ioctl: VIDIOC_ENUM_FMT
         Index       : 0
         Type        : Video Capture
         Pixel Format: 'H264'
         Name        : H264 Encoded Stream

         Index       : 1
         Type        : Video Capture
         Pixel Format: 'MPG4'
         Name        : MPEG4 Encoded Stream

root@gtsir-nand:~# v4l2-ctl -d /dev/video1 -l

User Controls

                 horizontal_flip (bool)   : default=0 value=0
                   vertical_flip (bool)   : default=0 value=0

MPEG Encoder Controls

                  video_gop_size (int)    : min=1 max=60 step=1 default=16 value=16
                   video_bitrate (int)    : min=0 max=32767000 step=1 default=0 
value=0
            sequence_header_mode (menu)   : min=0 max=1 default=1 value=1
        maximum_bytes_in_a_slice (int)    : min=1 max=1073741823 step=1 
default=500 value=500
        number_of_mbs_in_a_slice (int)    : min=1 max=1073741823 step=1 
default=1 value=1
       slice_partitioning_method (menu)   : min=0 max=2 default=0 value=0
           h264_i_frame_qp_value (int)    : min=1 max=51 step=1 default=25 value=25
           h264_p_frame_qp_value (int)    : min=1 max=51 step=1 default=25 value=25
          mpeg4_i_frame_qp_value (int)    : min=1 max=31 step=1 default=2 value=2
          mpeg4_p_frame_qp_value (int)    : min=1 max=31 step=1 default=2 value=2


But the capture is not working :-(

root@gtsir-nand:~# ./video1.x -f MPG4  -w 320 -h 240 a.mpg4
g_width = 320, g_height = 240
--------------------------------------------------------------------------------------------
	 Width = 320	 Height = 240	 Image size = 589824
	 pixelformat = 875967048	 colorspace = 3
--------------------------------------------------------------------------------------------
^C

and the kernel spit this
[ 3043.981600] coda coda-imx27.0: coda_stop_streaming: timeout, sending SEQ_END 
anyway
[ 3044.998085] coda coda-imx27.0: CODA_COMMAND_SEQ_END failed

did I miss something ??  just enlighten me please

Thanks
Chris







