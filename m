Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13380 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3CDJW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:22:28 -0500
From: Kamil Debski <k.debski@samsung.com>
To: 'Lonsn' <lonsn2005@gmail.com>, linux-samsung-soc@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>
References: <51317952.9040402@gmail.com>
In-reply-to: <51317952.9040402@gmail.com>
Subject: RE: MFC decode failed in S5PV210 in kernel 3.8
Date: Mon, 04 Mar 2013 10:22:40 +0100
Message-id: <02f001ce18b9$d1d77da0$758678e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lonsn,

> From: Lonsn [mailto:lonsn2005@gmail.com]
> Sent: Saturday, March 02, 2013 5:00 AM
> 
> Hi,
> I tested the MFC decode example v4l2_decode from
> http://git.infradead.org/users/kmpark/public-apps and meet some
> problems as following:
> # ./v4l2_decode -f /dev/video5 -m /dev/video9 -d /dev/fb0 -c mpeg4 -i
> shrek.m4v
> V4L2 Codec decoding example application
> Kamil Debski <k.debski@samsung.com>
> Copyright 2012 Samsung Electronics Co., Ltd.
> 
> (fb.c:fb_open:51): Framebuffer properties: xres=1024, yres=768, bpp=32
> (fb.c:fb_open:53): Virtual resolution: vxres=1024 vyres=768
> (fimc.c:fimc_open:56): FIMC Info (/dev/video5): driver="s5pv210-fimc"
> bus_info="" card="s5pv210-fimc" fd=0x5
> (mfc.c:mfc_open:57): MFC Info (/dev/video9): driver="s5p-mfc"
> bus_info="" card="s5p-mfc" fd=0x6
> (main.c:main:415): Successfully opened all necessary files and devices
> (mfc.c:mfc_dec_setup_output:101): Setup MFC decoding OUTPUT buffer
> size=1048576 (requested=1048576)
> (mfc.c:mfc_dec_setup_output:118): Number of MFC OUTPUT buffers is 2
> (requested 2)
> (mfc.c:mfc_dec_setup_output:148): Succesfully mmapped 2 MFC OUTPUT
> buffers
> (main.c:extract_and_process_header:84): Extracted header of size 13089
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (mfc.c:mfc_stream:236): Stream ON on OUTPUT queue
> (mfc.c:mfc_dec_setup_capture:277): MFC buffer parameters: 0x0
> plane[0]=0
> plane[1]=0
> Error (mfc.c:mfc_dec_setup_capture:283): Failed to get crop information
> 
> And kernel print:
>  s5p_mfc_handle_error:420: Interrupt Error: 00000035
> vidioc_g_crop:782: Cannont set crop
> 
> It seems MFC buffer parameters error first.
> The shrek.m4v comes from http://www.uky.edu/~drlane/com351/shrek.m4v
> and is H264 format. But if I use -c h264, then v4l2_decode will print:
> Error (parser.c:parse_h264_stream:337): Output buffer too small for
> current frame Error (main.c:extract_and_process_header:71): Failed to
> extract header from stream
> 
> Any suggestions?

As far as I know shrek.m4v is an MPEG4 stream. Did you try it as an MPEG4
stream?
 
> Thanks.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center



