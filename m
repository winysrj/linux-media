Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14158 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3CDJaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:30:15 -0500
From: Kamil Debski <k.debski@samsung.com>
To: 'Lonsn' <lonsn2005@gmail.com>,
	"'undisclosed-recipients:'"@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <51317952.9040402@gmail.com> <5131C429.2040406@gmail.com>
In-reply-to: <5131C429.2040406@gmail.com>
Subject: RE: MFC decode failed in S5PV210 in kernel 3.8
Date: Mon, 04 Mar 2013 10:30:27 +0100
Message-id: <02f101ce18ba$e8ef8cc0$bacea640$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-2022-jp
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This problem is known to us and Marek is planning a fix. However, the
problem
proved to be quite difficult, so please be patient.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Lonsn [mailto:lonsn2005@gmail.com]
> Sent: Saturday, March 02, 2013 10:20 AM
> To: undisclosed-recipients:
> Cc: linux-samsung-soc@vger.kernel.org; linux-media@vger.kernel.org;
> k.debski@samsung.com; Sylwester Nawrocki
> Subject: Re: MFC decode failed in S5PV210 in kernel 3.8
> 
> 于 2013/3/2 12:00, Lonsn 写道:
> > Hi,
> > I tested the MFC decode example v4l2_decode from
> > http://git.infradead.org/users/kmpark/public-apps and meet some
> problems
> > as following:
> > # ./v4l2_decode -f /dev/video5 -m /dev/video9 -d /dev/fb0 -c mpeg4 -i
> > shrek.m4v
> > V4L2 Codec decoding example application
> > Kamil Debski <k.debski@samsung.com>
> > Copyright 2012 Samsung Electronics Co., Ltd.
> >
> > (fb.c:fb_open:51): Framebuffer properties: xres=1024, yres=768,
> bpp=32
> > (fb.c:fb_open:53): Virtual resolution: vxres=1024 vyres=768
> > (fimc.c:fimc_open:56): FIMC Info (/dev/video5): driver="s5pv210-fimc"
> > bus_info="" card="s5pv210-fimc" fd=0x5
> > (mfc.c:mfc_open:57): MFC Info (/dev/video9): driver="s5p-mfc"
> > bus_info="" card="s5p-mfc" fd=0x6
> > (main.c:main:415): Successfully opened all necessary files and
> devices
> > (mfc.c:mfc_dec_setup_output:101): Setup MFC decoding OUTPUT buffer
> > size=1048576 (requested=1048576)
> > (mfc.c:mfc_dec_setup_output:118): Number of MFC OUTPUT buffers is 2
> > (requested 2)
> > (mfc.c:mfc_dec_setup_output:148): Succesfully mmapped 2 MFC OUTPUT
> buffers
> > (main.c:extract_and_process_header:84): Extracted header of size
> 13089
> > (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with
> index 0
> > (mfc.c:mfc_stream:236): Stream ON on OUTPUT queue
> > (mfc.c:mfc_dec_setup_capture:277): MFC buffer parameters: 0x0
> plane[0]=0
> > plane[1]=0
> > Error (mfc.c:mfc_dec_setup_capture:283): Failed to get crop
> information
> >
> > And kernel print:
> >   s5p_mfc_handle_error:420: Interrupt Error: 00000035
> > vidioc_g_crop:782: Cannont set crop
> >
> > It seems MFC buffer parameters error first.
> > The shrek.m4v comes from http://www.uky.edu/~drlane/com351/shrek.m4v
> and
> > is H264 format. But if I use -c h264, then v4l2_decode will print:
> > Error (parser.c:parse_h264_stream:337): Output buffer too small for
> > current frame
> > Error (main.c:extract_and_process_header:71): Failed to extract
> header
> > from stream
> >
> > Any suggestions?
> >
> > Thanks.
> >
> Maybe the up issue due to the input file format. Now I use a H264 ES
> file as input, failed with different output.
> #./v4l2_decode -f /dev/video5 -m /dev/video9 -d /dev/fb0 -c h264 -i
> c.h264
> Kernel print:
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
> pgd = afa78000
> [00000000] *pgd=4ea37831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 17 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0    Not tainted  (3.8.0-dirty #26)
> PC is at dma_cache_maint_page+0x58/0xa8
> LR is at 0x80000000
> pc : [<80014f2c>]    lr : [<80000000>]    psr: a0000013
> sp : ae939ac8  ip : 8050378c  fp : aead2240
> r10: 00000000  r9 : 00000001  r8 : 804aceec
> r7 : 00000001  r6 : 804b5b70  r5 : 0000fc03  r4 : 00000000
> r3 : 00000001  r2 : 0006c000  r1 : 00000000  r0 : fc03bc00
> Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c5387d  Table: 4fa78019  DAC: 00000015
> Process v4l2_decode (pid: 2433, stack limit = 0xae938230)
> Stack: (0xae939ac8 to 0xae93a000)
> 9ac0:                   00000001 80778000 00000000 80015054 80019398
> 0000006c
> 9ae0: ace36e00 00000000 aead2b40 80015d34 00000001 00000000 8050378c
> 00000000
> 9b00: ae939b54 00000000 aead2b40 804aceec 00000001 00000001 aead2240
> 804b5b70
> 9b20: 00000000 80245a4c 00000000 000000d0 00000001 802e41c8 0006c000
> aead2280
> 9b40: 72601000 0000006c 805037a8 0000006c af9f8e00 0004306b 00001020
> acc3d400
> 9b60: ae939b98 accb9550 acc3d400 accb9550 00000000 00000000 805116c4
> 802411c8
> 9b80: afb1d900 acc3d400 805116c4 00000000 0006c000 0006c000 72601000
> 76f43000
> 9ba0: 00000003 00000000 afa0ca98 00001080 60000193 803604cc ae939bdc
> 800480a8
> 9bc0: 00000000 804ba074 af907000 00036000 00036000 725cb000 0c36d194
> 80036da4
> 9be0: 20000113 20000193 00000401 acd982b8 afb1d900 00000003 af9f6144
> 802b8698
> 9c00: af9f6000 afb1d900 af9f6144 acd982b8 00001080 802bc324 af9f6000
> 80342690
> 9c20: afb1d900 00001088 af9f6000 afb1d900 00001088 00000000 af9f6070
> c802a8c0
> 9c40: 00001088 802b5338 af9f6000 afb1d900 00000000 af9f6038 acf01ee4
> 8030bdcc
> 9c60: af9f6000 80360504 af9f6000 8030d39c afb1d900 00000011 804d8988
> 804ab47c
> 9c80: acf01ee4 8030e5c0 00004003 00000002 804ab47c af989800 00000002
> afb1d918
> 9ca0: 0000109c 804d8988 acf03310 00000000 1402a8c0 c802a8c0 00000000
> afb1d900
> 9cc0: 80387d54 804aab68 804d8988 804d8988 00000000 00000011 00000001
> 802e41c8
> 9ce0: afb1d900 acf03310 afb1d918 ae939d5c 009c3f49 00000000 009c3ecd
> 802e3da8
> 9d00: af989800 00000084 00000029 804ab4ec 804aa66c ae938000 ae939d5c
> 00000008
> 9d20: af989800 afb1d900 804ab4ec 802c101c 804bbd74 00000000 804aa680
> 80512540
> 9d40: 804dde40 00400040 01400000 80065fe8 804ba828 af817020 af817020
> 8035e09c
> 9d60: af817034 ae938000 22222222 22222222 22222222 accb9550 acc3d400
> accb9550
> 9d80: acc3d400 0000000a afa07600 00000000 8037cf88 8024366c accb9550
> ae939e58
> 9da0: acd2dc88 802437d0 00000001 ae939e58 accb9400 8037cf88 ace36b3c
> 00000000
> 9dc0: 000f8335 8023dfc8 00000001 afa07600 ae939e58 8023114c ae939e58
> af817080
> 9de0: c044560f 00000000 804d3194 80233038 94f9da8f 00000001 af85e930
> ace7db00
> 9e00: ae939e58 ace36b3c 804ba828 ffffffff 00000000 800426c0 804acaec
> ffffffff
> 9e20: acc6c000 c044560f ae939e58 00000078 7129fd08 ae939e8c ae8deb00
> 80232dd4
> 9e40: 7129fd80 80234200 ace7cf00 00000001 00000003 afa07600 00000000
> 0000000a
> 9e60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000
> 9e80: 00000000 00000000 00000002 ae8deb00 00000002 00000000 00000000
> 80055ba4
> 9ea0: 00000032 76f25000 acd2dc40 af817020 af817020 8035e74c af817034
> 00000001
> 9ec0: 22222222 22222222 22222222 22222222 00000000 af817020 af817020
> afa07600
> 9ee0: af817020 c044560f af817080 7129fd80 ae938000 00000000 712a06a4
> 8022ef70
> 9f00: 7129fd80 afa07600 af5eb098 c044560f 000021b0 800b5c38 ae939f30
> aea4c0c8
> 9f20: 00000000 00000001 801b5a2c 00000000 00000000 00000000 0040004c
> 00000001
> 9f40: 00000081 76f256d8 00000001 00000000 ae938000 00000000 00000016
> 8005812c
> 9f60: 00000000 00000001 afa07600 7129fd80 c044560f 00000005 ae938000
> 00000000
> 9f80: 712a06a4 800b6214 00000000 00000001 712a0470 00000000 00000000
> 00000036
> 9fa0: 8000ede8 8000ec40 712a0470 00000000 00000005 c044560f 7129fd80
> 7129fd80
> 9fc0: 712a0470 00000000 00000000 00000036 00000000 00000000 00000000
> 712a06a4
> 9fe0: 000165e8 7129fcf4 0000b5d9 76ecfefc 00000010 00000005 00000000
> 00000000
> [<80014f2c>] (dma_cache_maint_page+0x58/0xa8) from [<80015054>]
> (arm_dma_map_page+0x80/0x84)
> [<80015054>] (arm_dma_map_page+0x80/0x84) from [<80015d34>]
> (arm_dma_map_sg+0x68/0x248)
> [<80015d34>] (arm_dma_map_sg+0x68/0x248) from [<80245a4c>]
> (vb2_dc_get_userptr+0x364/0x670)
> [<80245a4c>] (vb2_dc_get_userptr+0x364/0x670) from [<802411c8>]
> (__qbuf_userptr+0xac/0x3f0)
> [<802411c8>] (__qbuf_userptr+0xac/0x3f0) from [<8024366c>]
> (__buf_prepare+0xb4/0xd0)
> [<8024366c>] (__buf_prepare+0xb4/0xd0) from [<802437d0>]
> (vb2_qbuf+0x148/0x28c)
> [<802437d0>] (vb2_qbuf+0x148/0x28c) from [<8023dfc8>]
> (v4l2_m2m_qbuf+0x20/0x38)
> [<8023dfc8>] (v4l2_m2m_qbuf+0x20/0x38) from [<8023114c>]
> (v4l_qbuf+0x3c/0x40)
> [<8023114c>] (v4l_qbuf+0x3c/0x40) from [<80233038>]
> (__video_do_ioctl+0x264/0x324)
> [<80233038>] (__video_do_ioctl+0x264/0x324) from [<80234200>]
> (video_usercopy+0x118/0x3cc)
> [<80234200>] (video_usercopy+0x118/0x3cc) from [<8022ef70>]
> (v4l2_ioctl+0xe8/0x148)
> [<8022ef70>] (v4l2_ioctl+0xe8/0x148) from [<800b5c38>]
> (do_vfs_ioctl+0x84/0x624)
> [<800b5c38>] (do_vfs_ioctl+0x84/0x624) from [<800b6214>]
> (sys_ioctl+0x3c/0x60)
> [<800b6214>] (sys_ioctl+0x3c/0x60) from [<8000ec40>]
> (ret_fast_syscall+0x0/0x30)
> Code: 11a0cb85 11a0cbac 1084418c e35e0000 (e594c000)
> ---[ end trace 13a7778bb939e49b ]---
> 
> v4l2_decode app print:
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
> (main.c:extract_and_process_header:84): Extracted header of size 80
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (mfc.c:mfc_stream:236): Stream ON on OUTPUT queue
> (mfc.c:mfc_dec_setup_capture:277): MFC buffer parameters: 768x576
> plane[0]=442368 plane[1]=221184
> (mfc.c:mfc_dec_setup_capture:293): Crop parameters w=720 h=576 l=0 t=0
> (mfc.c:mfc_dec_setup_capture:307): Number of MFC CAPTURE buffers is 6
> (requested 6, extra 2)
> (mfc.c:mfc_dec_setup_capture:342): Succesfully mmapped 6 MFC CAPTURE
> buffers
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 0 on OUTPUT
> queue
> (fimc.c:fimc_sfmt:114): Successful SFMT on OUTPUT of FIMC (768x576)
> (fimc.c:fimc_setup_output_from_mfc:149): Succesfully setup OUTPUT of
> FIMC
> (fimc.c:fimc_sfmt:114): Successful SFMT on CAPTURE of FIMC (1024x768)
> (fimc.c:fimc_setup_capture_from_fb:193): Succesfully setup CAPTURE of
> FIMC
> (main.c:main:457): I for one welcome our succesfully setup environment.
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 0
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 1
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 2
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 3
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 4
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on CAPTURE queue with
> index 5
> (mfc.c:mfc_stream:236): Stream ON on CAPTURE queue
> (main.c:main:485): Launching threads
> (main.c:fimc_thread_func:291): Before fimc.todo
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 67319
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 48927
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 1
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 0 on OUTPUT
> queue
> (main.c:parser_thread_func:180): After OUTPUT dequeue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 297
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 1 on OUTPUT
> queue
> (main.c:parser_thread_func:180): After OUTPUT dequeue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 31646
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 1
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 0 on
> CAPTURE
> queue
> (main.c:fimc_thread_func:293): After fimc.todo
> (main.c:fimc_thread_func:295): Processing by FIMC
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 2 on
> CAPTURE
> queue
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 0 on OUTPUT
> queue
> (main.c:parser_thread_func:180): After OUTPUT dequeue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 45880
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 1 on OUTPUT
> queue
> (main.c:parser_thread_func:180): After OUTPUT dequeue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 3 on
> CAPTURE
> queue
> (main.c:mfc_thread_func:206): Before fimc.done
> (main.c:parser_thread_func:166): Extracted frame of size 37290
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 1
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue
> (mfc.c:mfc_dec_dequeue_buf:218): Dequeued buffer with index 0 on OUTPUT
> queue
> (main.c:parser_thread_func:180): After OUTPUT dequeue
> (main.c:parser_thread_func:153): parser.func = 0xa31d
> (main.c:parser_thread_func:166): Extracted frame of size 33533
> (main.c:parser_thread_func:168): Before OUTPUT queue
> (mfc.c:mfc_dec_queue_buf:178): Queued buffer on OUTPUT queue with index
> 0
> (main.c:parser_thread_func:170): After OUTPUT queue
> (main.c:parser_thread_func:178): Before OUTPUT dequeue



