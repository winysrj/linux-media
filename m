Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab2EAWvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 18:51:04 -0400
Date: Wed, 2 May 2012 00:50:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Subject: Re: SoC i.mx35 userptr method failure while running capture-example
 utility
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CC9525492@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1205020044000.12201@axis700.grange>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CC9525492@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

On Tue, 1 May 2012, Alex Gershgorin wrote:

> Hi everyone,
> 
> I use user-space utility from  http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/contrib/test/capture-example.c
> I made two small changes in this application and this is running on i.MX35 SoC 
>  
> fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
> fmt.fmt.pix.field       = V4L2_FIELD_ANY;
> 
> When MMAP method is used everything works fine, problem occurs when using USERPTR method
> this can see bellow :
> 
> ./capture-example -u -f -d /dev/video0 
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> Failed acquiring VMA for vaddr 0x76cd9008
> VIDIOC_QBUF error 22, Invalid arg

It doesn't surprise me, that this doesn't work. capture-example allocates 
absolutely normal user-space buffers, when called with USERPTR, and those 
buffers are very likely discontiguous. Whereas mx3-camera needs physically 
contiguous buffers, so, this can only fail. This means, you either have to 
use MMAP or you need to allocate USERPTR buffers in a special way to 
guarantee their contiguity.

> Unable to handle kernel NULL pointer dereference at virtual address 00000000

This, however, is bad and is a bug in the driver. The capture-example 
should just fail nicely with no trouble. I'll add it to my TODO and will 
try to find some time to debug and fix this, however, I'd be more than 
happy if someone else would beat me on this ;-)

Thanks
Guennadi

> pgd = 80004000
> [00000000] *pgd=00000000
> Internal error: Oops: 817 [#1] ARM
> CPU: 0    Not tainted  (3.4.0-rc5+ #2283
> PC is at mx3_videobuf_release+0x9c/0x10c
> LR is at mx3_videobuf_release+0x20/0x10c
> pc : [<802cd92c>]    lr : [<802cd8b0>]    psr: 00000093
> sp : 86db3e00  ip : 86db3e00  fp : 86db3e2c
> r10: 86ff6b20  r9 : 86817200  r8 : 00000000
> r7 : 86ff568c  r6 : 00000000  r5 : 8801a000  r4 : 86da3000
> r3 : 60000013  r2 : 86da3264  r1 : 00000000  r0 : 00000000
> Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 00c5387d  Table: 86dcc008  DAC: 00000015
> Process capture-example (pid: 52, stack limit = 0x86db2268)
> Stack: (0x86db3e00 to 0x86db4000)
> 3e00: 00000000 60000013 00000000 86ff568c 00000000 00000002 86ff56ac 00000000
> 3e20: 86db3e64 86db3e30 802c8978 802cd89c 00000000 80099414 86db3e84 86ff568c
> 3e40: 86dc9a80 8801a03c 80491828 00000000 86817200 86ff6b20 86db3e7c 86db3e68
> 3e60: 802c9a1c 802c8930 802ce048 86ff5600 86db3e9c 86db3e80 802cca14 802c9a00
> 3e80: 86ff5800 86dc9a80 00000008 86dc9a88 86db3eb4 86db3ea0 802b936c 802cc9d0
> 3ea0: 86dc9a80 86ff6b20 86db3ef4 86db3eb8 80082f00 802b932c 00000000 00000000
> 3ec0: 00000000 86d35010 86d7f000 86dc9a80 00000000 86d59000 86d90120 0000000c
> 3ee0: 86db2000 00000000 86db3f14 86db3ef8 8007ff58 80082df0 00000000 86d59000
> 3f00: 00000000 00000001 86db3f3c 86db3f18 8001c72c 8007fee4 86d59000 86d82000
> 3f20: 00000100 76ef1770 000000f8 8000e564 86db3f4c 86db3f40 8001c7a8 8001c6b4
> 3f40: 86db3f7c 86db3f50 8001dab4 8001c78c 7eb002b8 00000001 00000004 00000000
> 3f60: 86db3fa4 86db3f70 800824fc 000000f8 86db3f94 86db3f80 8001dfc0 8001d8c4
> 3f80: 0000ffff 000a3d78 86db3fa4 86db3f98 8001e004 8001df4c 00000000 86db3fa8
> 3fa0: 8000e3e0 8001dff8 000a3d78 76ef1770 00000001 000a3d64 00000008 00000001
> 3fc0: 000a3d78 76ef1770 76ef1770 000000f8 76e1d248 00000000 00009ecc 7eb02954
> 3fe0: 76f2e000 7eb02908 76de14dc 76e4f3d4 60000010 00000001 00000000 00000000
> Backtrace: 
> [<802cd890>] (mx3_videobuf_release+0x0/0x10c) from [<802c8978>] (__vb2_queue_free+0x54/0x15c)
>  r8:00000000 r7:86ff56ac r6:00000002 r5:00000000 r4:86ff568c
> [<802c8924>] (__vb2_queue_free+0x0/0x15c) from [<802c9a1c>] (vb2_queue_release+0x28/0x2c)
> [<802c99f4>] (vb2_queue_release+0x0/0x2c) from [<802cca14>] (soc_camera_close+0x50/0xac)
>  r4:86ff5600 r3:802ce048
> [<802cc9c4>] (soc_camera_close+0x0/0xac) from [<802b936c>] (v4l2_release+0x4c/0x6c)
>  r7:86dc9a88 r6:00000008 r5:86dc9a80 r4:86ff5800
> [<802b9320>] (v4l2_release+0x0/0x6c) from [<80082f00>] (fput+0x11c/0x204)
>  r5:86ff6b20 r4:86dc9a80
> [<80082de4>] (fput+0x0/0x204) from [<8007ff58>] (filp_close+0x80/0x8c)
> [<8007fed8>] (filp_close+0x0/0x8c) from [<8001c72c>] (put_files_struct+0x84/0xd8)
>  r6:00000001 r5:00000000 r4:86d59000 r3:00000000
> [<8001c6a8>] (put_files_struct+0x0/0xd8) from [<8001c7a8>] (exit_files+0x28/0x2c)
>  r8:8000e564 r7:000000f8 r6:76ef1770 r5:00000100 r4:86d82000
> r3:86d59000
> [<8001c780>] (exit_files+0x0/0x2c) from [<8001dab4>] (do_exit+0x1fc/0x688)
> [<8001d8b8>] (do_exit+0x0/0x688) from [<8001dfc0>] (do_group_exit+0x80/0xac)
>  r7:000000f8
> [<8001df40>] (do_group_exit+0x0/0xac) from [<8001e004>] (sys_exit_group+0x18/0x24)
>  r4:000a3d78 r3:0000ffff
> [<8001dfec>] (sys_exit_group+0x0/0x24) from [<8000e3e0>] (ret_fast_syscall+0x0/0x30)
> Code: 05852024 e5941268 e5940264 e2842f99 (e5810000) 
> ument
> ---[ end trace 23ac1073b67b7fc0 ]---
> Fixing recursive fault but reboot is needed!
> 
> Unfortunately I do not have enough knowledge in this kind of problems, any help will be welcomed.
> 
> Regards,
> Alex
> 
> 
> 
> 
> 
> 
>  
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
