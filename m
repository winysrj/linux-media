Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37067 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3EOW1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 18:27:42 -0400
Message-ID: <51940BD9.5040405@gmail.com>
Date: Thu, 16 May 2013 00:27:37 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: George Joseph <george.jp@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [RFC PATCH 1/3] [media] s5p-jpeg: Add support for Exynos4x12
 and 5250
References: <1368532420-21555-1-git-send-email-george.jp@samsung.com> <1368532420-21555-2-git-send-email-george.jp@samsung.com>
In-Reply-To: <1368532420-21555-2-git-send-email-george.jp@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi George,

Thanks for the patches. Sorry, I can't review the $subject patch in detail
as is, there is way too many things done in this single patch. It looks more
like a driver replacement. It is even hard to edit due to its size in my
e-mail client.

Hence, may I ask you to split it into several patches, each possibly 
including
single logical change, with an explanation what the patch does and why, 
e.g.:

  - encoder/decoder code split into different files (I'm not 100% sure 
it is
    needed),
  - multiplanar format support addition,
  - software watchdog addition,
  - the quantization/Huffman tables modification,
  - device tree support addition,
  - ...

The reason I'm asking for it is also there seems to be some unrelated
or unnecessary changes, like, e.g. introducing several JPEG fourccs for
different YCbCr subsampling or adding unused v4l2 control ioctls (
jpeg_enc_vidioc_g/s_ctrl, jpeg_enc_vidioc_g/s_ctrl).

It should be also be easier to test and bisect set of smaller changes when
needed. I know it means more work for you, but maybe the exynos4210
regression described in your cover letter could be avoided that way.

A general note, please don't remove "s5p_" prefix from functions that are
not static. "jpeg_" sounds a bit to generic prefix for symbols in this
single driver.

Also please make sure indentation is not broken, it looks like you are
using TAB size different than 8 characters.

It might be worth testing the driver as a loadable module, it doesn't
appear it has been tested, looking at the Makefile modifications. And
it doesn't even build currently:

drivers/media/platform/s5p-jpeg/jpeg-core: struct platform_device_id is 
24 bytes.  The last of 3 is:
0x65 0x78 0x79 0x6e 0x6f 0x73 0x34 0x32 0x31 0x32 0x2d 0x6a 0x70 0x65 
0x67 0x00 0x00 0x00 0x00 0x00 0x44 0x01 0x00 0x00
FATAL: drivers/media/platform/s5p-jpeg/jpeg-core: struct 
platform_device_id is not terminated with a NULL entry!
make[1]: *** [__modpost] Error 1

When I fix that there are errors due to your incorrect Makefile changes
(separate module for each file ??):

ERROR: "jpeg_get_frame_size" 
[drivers/media/platform/s5p-jpeg/jpeg-dec.ko] undefined!
ERROR: "jpeg_set_dec_bitstream_size" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_dec_out_fmt" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_dec_scaling" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_frame_buf_address" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_enc_dec_mode" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_encode_hoff_cnt" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_stream_buf_address" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_enc_in_fmt" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_enc_out_fmt" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_stream_size" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_encode_tbl_select" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_enc_tbl" [drivers/media/platform/s5p-jpeg/jpeg-core.ko] 
undefined!
ERROR: "jpeg_set_huf_table_enable" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_set_interrupt" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_sw_reset" [drivers/media/platform/s5p-jpeg/jpeg-core.ko] 
undefined!
ERROR: "jpeg_get_stream_size" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "jpeg_get_int_status" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "get_jpeg_dec_v4l2_ioctl_ops" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
ERROR: "get_jpeg_enc_v4l2_ioctl_ops" 
[drivers/media/platform/s5p-jpeg/jpeg-core.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Could you please add Andrzej Pietrasiewicz to Cc next time ? He might be
busy with other things, nevertheless I wouldn't like to miss any comments/
remarks from his side.

Thanks,
Sylwester
