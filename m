Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44733 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbaJUNmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 09:42:55 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so999962obc.37
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 06:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54465F34.1000400@xs4all.nl>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
 <54465F34.1000400@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 21 Oct 2014 15:42:39 +0200
Message-ID: <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
Subject: Re: [media] CODA960: Fails to allocate memory
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2014-10-21 15:27 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>
>
> On 10/21/2014 03:16 PM, Jean-Michel Hautbois wrote:
>>
>> Hi,
>>
>> I am trying to use the CODA960 driver on a 3.18 kernel.
>> It seems pretty good when the module is probed (appart from the
>> unsupported firmware version) but when I try using the encoder, it
>> fails allocating dma buffers.
>>
>> Here is the DT part I added :
>> &vpu {
>>      compatible = "fsl,imx6q-vpu";
>>      clocks = <&clks 168>, <&clks 140>, <&clks 142>;
>>      clock-names = "per", "ahb", "ocram";
>>      iramsize = <0x21000>;
>>      iram = <&ocram>;
>>      resets = <&src 1>;
>>      status = "okay";
>> };
>>
>> When booting, I see :
>> [    4.410645] coda 2040000.vpu: Firmware code revision: 46056
>> [    4.416312] coda 2040000.vpu: Initialized CODA960.
>> [    4.421123] coda 2040000.vpu: Unsupported firmware version: 3.1.1
>> [    4.483577] coda 2040000.vpu: codec registered as /dev/video[0-1]
>>
>> I can start v4l2-ctl and it shows that the device seems to be ok :
>>   v4l2-ctl --all -d /dev/video1
>> Driver Info (not using libv4l2):
>>          Driver name   : coda
>>          Card type     : CODA960
>>          Bus info      : platform:coda
>>          Driver version: 3.18.0
>>          Capabilities  : 0x84208000
>>                  Video Memory-to-Memory
>>                  Streaming
>>                  Extended Pix Format
>>                  Device Capabilities
>>          Device Caps   : 0x04208000
>>                  Video Memory-to-Memory
>>                  Streaming
>>                  Extended Pix Format
>> Priority: 2
>> Format Video Capture:
>>          Width/Height  : 1920/1088
>>          Pixel Format  : 'YU12'
>>          Field         : None
>>          Bytes per Line: 1920
>>          Size Image    : 3133440
>>          Colorspace    : HDTV and modern devices (ITU709)
>>          Flags         :
>> Format Video Output:
>>          Width/Height  : 1920/1088
>>          Pixel Format  : 'H264'
>>          Field         : None
>>          Bytes per Line: 0
>>          Size Image    : 1048576
>>          Colorspace    : HDTV and modern devices (ITU709)
>>          Flags         :
>> Selection: compose, Left 0, Top 0, Width 1920, Height 1088
>> Selection: compose_default, Left 0, Top 0, Width 1920, Height 1088
>> Selection: compose_bounds, Left 0, Top 0, Width 1920, Height 1088
>> Selection: compose_padded, Left 0, Top 0, Width 1920, Height 1088
>> Selection: crop, Left 0, Top 0, Width 1920, Height 1088
>> Selection: crop_default, Left 0, Top 0, Width 1920, Height 1088
>> Selection: crop_bounds, Left 0, Top 0, Width 1920, Height 1088
>>
>> User Controls
>>
>>                  horizontal_flip (bool)   : default=0 value=0
>>                    vertical_flip (bool)   : default=0 value=0
>>
>> Codec Controls
>>
>>                   video_gop_size (int)    : min=1 max=60 step=1
>> default=16 value=16
>>                    video_bitrate (int)    : min=0 max=32767000 step=1
>> default=0 value=0
>>      number_of_intra_refresh_mbs (int)    : min=0 max=8160 step=1
>> default=0 value=0
>>             sequence_header_mode (menu)   : min=0 max=1 default=1 value=1
>>         maximum_bytes_in_a_slice (int)    : min=1 max=1073741823 step=1
>> default=500 value=500
>>         number_of_mbs_in_a_slice (int)    : min=1 max=1073741823 step=1
>> default=1 value=1
>>        slice_partitioning_method (menu)   : min=0 max=2 default=0 value=0
>>            h264_i_frame_qp_value (int)    : min=0 max=51 step=1
>> default=25 value=25
>>            h264_p_frame_qp_value (int)    : min=0 max=51 step=1
>> default=25 value=25
>>            h264_maximum_qp_value (int)    : min=0 max=51 step=1
>> default=51 value=51
>>    h264_loop_filter_alpha_offset (int)    : min=0 max=15 step=1 default=0
>> value=0
>>     h264_loop_filter_beta_offset (int)    : min=0 max=15 step=1 default=0
>> value=0
>>            h264_loop_filter_mode (menu)   : min=0 max=1 default=0 value=0
>>           mpeg4_i_frame_qp_value (int)    : min=1 max=31 step=1 default=2
>> value=2
>>           mpeg4_p_frame_qp_value (int)    : min=1 max=31 step=1 default=2
>> value=2
>>                  horizontal_flip (bool)   : default=0 value=0
>>                    vertical_flip (bool)   : default=0 value=0
>>
>>
>>
>>
>> But when I try to get a file outputed, it fails :
>>
>> v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
>> [ 1197.292256] coda 2040000.vpu: dma_alloc_coherent of size 1048576 failed
>> VIDIOC_REQBUFS: failed: Cannot allocate memory
>>
>> Did I forget to do something ?
>
>
> I assume this is physically contiguous memory. Do you have that much phys.
> cont. memory
> available at all? If the memory is fragmented you won't be able to get it.
>
> Use cma (contiguous memory allocator). You probably have to do very little
> expect add
> a kernel option to assign enough memory for these buffers.

I added a cma=128M in order to reserve some meory, and it fails...
well, differently :).

~# v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
[   56.372023] alloc_contig_range test_pages_isolated(48400, 486fd) failed
[   56.459627] ------------[ cut here ]------------
[   56.464273] WARNING: CPU: 1 PID: 838 at
drivers/media/v4l2-core/videobuf2-core.c:1181
vb2_buffer_done+0x120/0x158()
[   56.474750] Modules linked in: snd_soc_sgtl5000 coda v4l2_mem2mem
[   56.480920] CPU: 1 PID: 838 Comm: v4l2-ctl Not tainted
3.18.0-rc1+yocto+gc943ff8 #1
[   56.488597] Backtrace:
[   56.491085] [<800130c0>] (dump_backtrace) from [<800133a0>]
(show_stack+0x18/0x1c)
[   56.498677]  r6:80ace2cc r5:00000000 r4:00000000 r3:00000000
[   56.504422] [<80013388>] (show_stack) from [<806cf624>]
(dump_stack+0x8c/0xa4)
[   56.511680] [<806cf598>] (dump_stack) from [<8002b870>]
(warn_slowpath_common+0x70/0x94)
[   56.519807]  r6:804c9554 r5:00000009 r4:00000000 r3:00000000
[   56.525563] [<8002b800>] (warn_slowpath_common) from [<8002b938>]
(warn_slowpath_null+0x24/0x2c)
[   56.534351]  r8:00000000 r7:b6a305e0 r6:b6a305e0 r5:b6a31800 r4:b56cb800
[   56.541166] [<8002b914>] (warn_slowpath_null) from [<804c9554>]
(vb2_buffer_done+0x120/0x158)
[   56.549732] [<804c9434>] (vb2_buffer_done) from [<7f009efc>]
(coda_start_streaming+0x100/0x1b0 [coda])
[   56.559058]  r8:00000012 r7:b56cbb18 r6:b6a305e0 r5:ffffffea
r4:b56cb800 r3:00000002
[   56.566913] [<7f009dfc>] (coda_start_streaming [coda]) from
[<804c95f0>] (vb2_start_streaming+0x64/0x160)
[   56.576498]  r7:b729a420 r6:b6a305e0 r5:b6a306e0 r4:b6a304b0
[   56.582237] [<804c958c>] (vb2_start_streaming) from [<804cb9cc>]
(vb2_internal_streamon+0xf4/0x150)
[   56.591312]  r7:b729a420 r6:40045612 r5:b6a30400 r4:b6a305e0
[   56.597072] [<804cb8d8>] (vb2_internal_streamon) from [<804cba5c>]
(vb2_streamon+0x34/0x58)
[   56.605442]  r5:b6a30400 r4:00000002
[   56.609074] [<804cba28>] (vb2_streamon) from [<7f0007d4>]
(v4l2_m2m_streamon+0x28/0x40 [v4l2_mem2mem])
[   56.618417] [<7f0007ac>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f000804>] (v4l2_m2m_ioctl_streamon+0x18/0x1c [v4l2_mem2mem])
[   56.630003]  r5:00000001 r4:b56cb9d8
[   56.633631] [<7f0007ec>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<804b5214>] (v4l_streamon+0x20/0x24)
[   56.643487] [<804b51f4>] (v4l_streamon) from [<804b7c5c>]
(__video_do_ioctl+0x280/0x2fc)
[   56.651610] [<804b79dc>] (__video_do_ioctl) from [<804b7690>]
(video_usercopy+0x168/0x498)
[   56.659895]  r10:804b79dc r9:7e8655b4 r8:b638d780 r7:00000000
r6:b61a1e18 r5:00000004
[   56.667825]  r4:40045612
[   56.670388] [<804b7528>] (video_usercopy) from [<804b79d4>]
(video_ioctl2+0x14/0x1c)
[   56.678149]  r10:00000000 r9:b61a0000 r8:b729a80c r7:b638d780
r6:7e8655b4 r5:40045612
[   56.686077]  r4:b729a420
[   56.688638] [<804b79c0>] (video_ioctl2) from [<804b3b8c>]
(v4l2_ioctl+0x14c/0x174)
[   56.696240] [<804b3a40>] (v4l2_ioctl) from [<8010a6a4>]
(do_vfs_ioctl+0x408/0x664)
[   56.703819]  r8:00000003 r7:8010a93c r6:b638d780 r5:7e8655b4
r4:b698cf90 r3:804b3a40
[   56.711689] [<8010a29c>] (do_vfs_ioctl) from [<8010a93c>]
(SyS_ioctl+0x3c/0x64)
[   56.719018]  r10:00000000 r9:b61a0000 r8:00000003 r7:40045612
r6:b638d780 r5:7e8655b4
[   56.726949]  r4:b638d780
[   56.729513] [<8010a900>] (SyS_ioctl) from [<8000f740>]
(ret_fast_syscall+0x0/0x48)
[   56.737104]  r8:8000f904 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e8619c8 r3:00000000
[   56.744946] ---[ end trace efcf1fd10e10c970 ]---
[   56.749753] ------------[ cut here ]------------
[   56.754389] WARNING: CPU: 1 PID: 838 at
drivers/media/v4l2-core/videobuf2-core.c:1181
vb2_buffer_done+0x120/0x158()
[   56.764849] Modules linked in: snd_soc_sgtl5000 coda v4l2_mem2mem
[   56.771021] CPU: 1 PID: 838 Comm: v4l2-ctl Tainted: G        W
3.18.0-rc1+yocto+gc943ff8 #1
[   56.779834] Backtrace:
[   56.782318] [<800130c0>] (dump_backtrace) from [<800133a0>]
(show_stack+0x18/0x1c)
[   56.789912]  r6:80ace2cc r5:00000000 r4:00000000 r3:00000000
[   56.795665] [<80013388>] (show_stack) from [<806cf624>]
(dump_stack+0x8c/0xa4)
[   56.802905] [<806cf598>] (dump_stack) from [<8002b870>]
(warn_slowpath_common+0x70/0x94)
[   56.811016]  r6:804c9554 r5:00000009 r4:00000000 r3:00000000
[   56.816768] [<8002b800>] (warn_slowpath_common) from [<8002b938>]
(warn_slowpath_null+0x24/0x2c)
[   56.825572]  r8:00000000 r7:b6a305e0 r6:b6a305e0 r5:b54d9800 r4:b56cb800
[   56.832370] [<8002b914>] (warn_slowpath_null) from [<804c9554>]
(vb2_buffer_done+0x120/0x158)
[   56.840934] [<804c9434>] (vb2_buffer_done) from [<7f009efc>]
(coda_start_streaming+0x100/0x1b0 [coda])
[   56.850263]  r8:00000012 r7:b56cbb18 r6:b6a305e0 r5:ffffffea
r4:b56cb800 r3:00000002
[   56.858123] [<7f009dfc>] (coda_start_streaming [coda]) from
[<804c95f0>] (vb2_start_streaming+0x64/0x160)
[   56.867708]  r7:b729a420 r6:b6a305e0 r5:b6a306e0 r4:b6a304b0
[   56.873445] [<804c958c>] (vb2_start_streaming) from [<804cb9cc>]
(vb2_internal_streamon+0xf4/0x150)
[   56.882511]  r7:b729a420 r6:40045612 r5:b6a30400 r4:b6a305e0
[   56.888261] [<804cb8d8>] (vb2_internal_streamon) from [<804cba5c>]
(vb2_streamon+0x34/0x58)
[   56.896629]  r5:b6a30400 r4:00000002
[   56.900261] [<804cba28>] (vb2_streamon) from [<7f0007d4>]
(v4l2_m2m_streamon+0x28/0x40 [v4l2_mem2mem])
[   56.909606] [<7f0007ac>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f000804>] (v4l2_m2m_ioctl_streamon+0x18/0x1c [v4l2_mem2mem])
[   56.921189]  r5:00000001 r4:b56cb9d8
[   56.924830] [<7f0007ec>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<804b5214>] (v4l_streamon+0x20/0x24)
[   56.934676] [<804b51f4>] (v4l_streamon) from [<804b7c5c>]
(__video_do_ioctl+0x280/0x2fc)
[   56.942797] [<804b79dc>] (__video_do_ioctl) from [<804b7690>]
(video_usercopy+0x168/0x498)
[   56.951077]  r10:804b79dc r9:7e8655b4 r8:b638d780 r7:00000000
r6:b61a1e18 r5:00000004
[   56.959015]  r4:40045612
[   56.961574] [<804b7528>] (video_usercopy) from [<804b79d4>]
(video_ioctl2+0x14/0x1c)
[   56.969337]  r10:00000000 r9:b61a0000 r8:b729a80c r7:b638d780
r6:7e8655b4 r5:40045612
[   56.977266]  r4:b729a420
[   56.979829] [<804b79c0>] (video_ioctl2) from [<804b3b8c>]
(v4l2_ioctl+0x14c/0x174)
[   56.987432] [<804b3a40>] (v4l2_ioctl) from [<8010a6a4>]
(do_vfs_ioctl+0x408/0x664)
[   56.995024]  r8:00000003 r7:8010a93c r6:b638d780 r5:7e8655b4
r4:b698cf90 r3:804b3a40
[   57.002860] [<8010a29c>] (do_vfs_ioctl) from [<8010a93c>]
(SyS_ioctl+0x3c/0x64)
[   57.010187]  r10:00000000 r9:b61a0000 r8:00000003 r7:40045612
r6:b638d780 r5:7e8655b4
[   57.018121]  r4:b638d780
[   57.020685] [<8010a900>] (SyS_ioctl) from [<8000f740>]
(ret_fast_syscall+0x0/0x48)
[   57.028273]  r8:8000f904 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e8619c8 r3:00000000
[   57.036142] ---[ end trace efcf1fd10e10c971 ]---
[   57.040770] ------------[ cut here ]------------
[   57.045418] WARNING: CPU: 1 PID: 838 at
drivers/media/v4l2-core/videobuf2-core.c:1181
vb2_buffer_done+0x120/0x158()
[   57.055873] Modules linked in: snd_soc_sgtl5000 coda v4l2_mem2mem
[   57.062041] CPU: 1 PID: 838 Comm: v4l2-ctl Tainted: G        W
3.18.0-rc1+yocto+gc943ff8 #1
[   57.070844] Backtrace:
[   57.073323] [<800130c0>] (dump_backtrace) from [<800133a0>]
(show_stack+0x18/0x1c)
[   57.080912]  r6:80ace2cc r5:00000000 r4:00000000 r3:00000000
[   57.086664] [<80013388>] (show_stack) from [<806cf624>]
(dump_stack+0x8c/0xa4)
[   57.093903] [<806cf598>] (dump_stack) from [<8002b870>]
(warn_slowpath_common+0x70/0x94)
[   57.102014]  r6:804c9554 r5:00000009 r4:00000000 r3:00000000
[   57.107762] [<8002b800>] (warn_slowpath_common) from [<8002b938>]
(warn_slowpath_null+0x24/0x2c)
[   57.116564]  r8:00000000 r7:b6a305e0 r6:b6a305e0 r5:b54d8c00 r4:b56cb800
[   57.123360] [<8002b914>] (warn_slowpath_null) from [<804c9554>]
(vb2_buffer_done+0x120/0x158)
[   57.131920] [<804c9434>] (vb2_buffer_done) from [<7f009efc>]
(coda_start_streaming+0x100/0x1b0 [coda])
[   57.141250]  r8:00000012 r7:b56cbb18 r6:b6a305e0 r5:ffffffea
r4:b56cb800 r3:00000002
[   57.149126] [<7f009dfc>] (coda_start_streaming [coda]) from
[<804c95f0>] (vb2_start_streaming+0x64/0x160)
[   57.158716]  r7:b729a420 r6:b6a305e0 r5:b6a306e0 r4:b6a304b0
[   57.164459] [<804c958c>] (vb2_start_streaming) from [<804cb9cc>]
(vb2_internal_streamon+0xf4/0x150)
[   57.173529]  r7:b729a420 r6:40045612 r5:b6a30400 r4:b6a305e0
[   57.179280] [<804cb8d8>] (vb2_internal_streamon) from [<804cba5c>]
(vb2_streamon+0x34/0x58)
[   57.187654]  r5:b6a30400 r4:00000002
[   57.191288] [<804cba28>] (vb2_streamon) from [<7f0007d4>]
(v4l2_m2m_streamon+0x28/0x40 [v4l2_mem2mem])
[   57.200631] [<7f0007ac>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f000804>] (v4l2_m2m_ioctl_streamon+0x18/0x1c [v4l2_mem2mem])
[   57.212224]  r5:00000001 r4:b56cb9d8
[   57.215870] [<7f0007ec>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<804b5214>] (v4l_streamon+0x20/0x24)
[   57.225728] [<804b51f4>] (v4l_streamon) from [<804b7c5c>]
(__video_do_ioctl+0x280/0x2fc)
[   57.233836] [<804b79dc>] (__video_do_ioctl) from [<804b7690>]
(video_usercopy+0x168/0x498)
[   57.242119]  r10:804b79dc r9:7e8655b4 r8:b638d780 r7:00000000
r6:b61a1e18 r5:00000004
[   57.250047]  r4:40045612
[   57.252609] [<804b7528>] (video_usercopy) from [<804b79d4>]
(video_ioctl2+0x14/0x1c)
[   57.260371]  r10:00000000 r9:b61a0000 r8:b729a80c r7:b638d780
r6:7e8655b4 r5:40045612
[   57.268306]  r4:b729a420
[   57.270866] [<804b79c0>] (video_ioctl2) from [<804b3b8c>]
(v4l2_ioctl+0x14c/0x174)
[   57.278468] [<804b3a40>] (v4l2_ioctl) from [<8010a6a4>]
(do_vfs_ioctl+0x408/0x664)
[   57.286054]  r8:00000003 r7:8010a93c r6:b638d780 r5:7e8655b4
r4:b698cf90 r3:804b3a40
[   57.293892] [<8010a29c>] (do_vfs_ioctl) from [<8010a93c>]
(SyS_ioctl+0x3c/0x64)
[   57.301225]  r10:00000000 r9:b61a0000 r8:00000003 r7:40045612
r6:b638d780 r5:7e8655b4
[   57.309164]  r4:b638d780
[   57.311730] [<8010a900>] (SyS_ioctl) from [<8000f740>]
(ret_fast_syscall+0x0/0x48)
[   57.319320]  r8:8000f904 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e8619c8 r3:00000000
[   57.327166] ---[ end trace efcf1fd10e10c972 ]---
[   57.331795] ------------[ cut here ]------------
[   57.336443] WARNING: CPU: 1 PID: 838 at
drivers/media/v4l2-core/videobuf2-core.c:1181
vb2_buffer_done+0x120/0x158()
[   57.346899] Modules linked in: snd_soc_sgtl5000 coda v4l2_mem2mem
[   57.353070] CPU: 1 PID: 838 Comm: v4l2-ctl Tainted: G        W
3.18.0-rc1+yocto+gc943ff8 #1
[   57.361874] Backtrace:
[   57.364356] [<800130c0>] (dump_backtrace) from [<800133a0>]
(show_stack+0x18/0x1c)
[   57.371945]  r6:80ace2cc r5:00000000 r4:00000000 r3:00000000
[   57.377705] [<80013388>] (show_stack) from [<806cf624>]
(dump_stack+0x8c/0xa4)
[   57.384965] [<806cf598>] (dump_stack) from [<8002b870>]
(warn_slowpath_common+0x70/0x94)
[   57.393066]  r6:804c9554 r5:00000009 r4:00000000 r3:00000000
[   57.398818] [<8002b800>] (warn_slowpath_common) from [<8002b938>]
(warn_slowpath_null+0x24/0x2c)
[   57.407622]  r8:00000000 r7:b6a305e0 r6:b6a305e0 r5:b54db400 r4:b56cb800
[   57.414419] [<8002b914>] (warn_slowpath_null) from [<804c9554>]
(vb2_buffer_done+0x120/0x158)
[   57.422985] [<804c9434>] (vb2_buffer_done) from [<7f009efc>]
(coda_start_streaming+0x100/0x1b0 [coda])
[   57.432318]  r8:00000012 r7:b56cbb18 r6:b6a305e0 r5:ffffffea
r4:b56cb800 r3:00000002
[   57.440179] [<7f009dfc>] (coda_start_streaming [coda]) from
[<804c95f0>] (vb2_start_streaming+0x64/0x160)
[   57.449765]  r7:b729a420 r6:b6a305e0 r5:b6a306e0 r4:b6a304b0
[   57.455519] [<804c958c>] (vb2_start_streaming) from [<804cb9cc>]
(vb2_internal_streamon+0xf4/0x150)
[   57.464568]  r7:b729a420 r6:40045612 r5:b6a30400 r4:b6a305e0
[   57.470325] [<804cb8d8>] (vb2_internal_streamon) from [<804cba5c>]
(vb2_streamon+0x34/0x58)
[   57.478697]  r5:b6a30400 r4:00000002
[   57.482328] [<804cba28>] (vb2_streamon) from [<7f0007d4>]
(v4l2_m2m_streamon+0x28/0x40 [v4l2_mem2mem])
[   57.491669] [<7f0007ac>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f000804>] (v4l2_m2m_ioctl_streamon+0x18/0x1c [v4l2_mem2mem])
[   57.503257]  r5:00000001 r4:b56cb9d8
[   57.506898] [<7f0007ec>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<804b5214>] (v4l_streamon+0x20/0x24)
[   57.516754] [<804b51f4>] (v4l_streamon) from [<804b7c5c>]
(__video_do_ioctl+0x280/0x2fc)
[   57.524876] [<804b79dc>] (__video_do_ioctl) from [<804b7690>]
(video_usercopy+0x168/0x498)
[   57.533146]  r10:804b79dc r9:7e8655b4 r8:b638d780 r7:00000000
r6:b61a1e18 r5:00000004
[   57.541078]  r4:40045612
[   57.543637] [<804b7528>] (video_usercopy) from [<804b79d4>]
(video_ioctl2+0x14/0x1c)
[   57.551398]  r10:00000000 r9:b61a0000 r8:b729a80c r7:b638d780
r6:7e8655b4 r5:40045612
[   57.559333]  r4:b729a420
[   57.561894] [<804b79c0>] (video_ioctl2) from [<804b3b8c>]
(v4l2_ioctl+0x14c/0x174)
[   57.569495] [<804b3a40>] (v4l2_ioctl) from [<8010a6a4>]
(do_vfs_ioctl+0x408/0x664)
[   57.577084]  r8:00000003 r7:8010a93c r6:b638d780 r5:7e8655b4
r4:b698cf90 r3:804b3a40
[   57.584939] [<8010a29c>] (do_vfs_ioctl) from [<8010a93c>]
(SyS_ioctl+0x3c/0x64)
[   57.592258]  r10:00000000 r9:b61a0000 r8:00000003 r7:40045612
r6:b638d780 r5:7e8655b4
[   57.600192]  r4:b638d780
[   57.602758] [<8010a900>] (SyS_ioctl) from [<8000f740>]
(ret_fast_syscall+0x0/0x48)
[   57.610346]  r8:8000f904 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e8619c8 r3:00000000
[   57.618191] ---[ end trace efcf1fd10e10c973 ]---
[   57.622820] ------------[ cut here ]------------
[   57.627467] WARNING: CPU: 1 PID: 838 at
drivers/media/v4l2-core/videobuf2-core.c:1781
vb2_start_streaming+0xc0/0x160()
[   57.638184] Modules linked in: snd_soc_sgtl5000 coda v4l2_mem2mem
[   57.644355] CPU: 1 PID: 838 Comm: v4l2-ctl Tainted: G        W
3.18.0-rc1+yocto+gc943ff8 #1
[   57.653159] Backtrace:
[   57.655650] [<800130c0>] (dump_backtrace) from [<800133a0>]
(show_stack+0x18/0x1c)
[   57.663222]  r6:80ace2cc r5:00000000 r4:00000000 r3:00000000
[   57.668979] [<80013388>] (show_stack) from [<806cf624>]
(dump_stack+0x8c/0xa4)
[   57.676233] [<806cf598>] (dump_stack) from [<8002b870>]
(warn_slowpath_common+0x70/0x94)
[   57.684333]  r6:804c964c r5:00000009 r4:00000000 r3:00000000
[   57.690097] [<8002b800>] (warn_slowpath_common) from [<8002b938>]
(warn_slowpath_null+0x24/0x2c)
[   57.698901]  r8:00000012 r7:ffffffea r6:b6a306f0 r5:b6a306e0 r4:b6a304b0
[   57.705715] [<8002b914>] (warn_slowpath_null) from [<804c964c>]
(vb2_start_streaming+0xc0/0x160)
[   57.714513] [<804c958c>] (vb2_start_streaming) from [<804cb9cc>]
(vb2_internal_streamon+0xf4/0x150)
[   57.723578]  r7:b729a420 r6:40045612 r5:b6a30400 r4:b6a305e0
[   57.729325] [<804cb8d8>] (vb2_internal_streamon) from [<804cba5c>]
(vb2_streamon+0x34/0x58)
[   57.737694]  r5:b6a30400 r4:00000002
[   57.741321] [<804cba28>] (vb2_streamon) from [<7f0007d4>]
(v4l2_m2m_streamon+0x28/0x40 [v4l2_mem2mem])
[   57.750660] [<7f0007ac>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f000804>] (v4l2_m2m_ioctl_streamon+0x18/0x1c [v4l2_mem2mem])
[   57.762244]  r5:00000001 r4:b56cb9d8
[   57.765886] [<7f0007ec>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<804b5214>] (v4l_streamon+0x20/0x24)
[   57.775741] [<804b51f4>] (v4l_streamon) from [<804b7c5c>]
(__video_do_ioctl+0x280/0x2fc)
[   57.783844] [<804b79dc>] (__video_do_ioctl) from [<804b7690>]
(video_usercopy+0x168/0x498)
[   57.792131]  r10:804b79dc r9:7e8655b4 r8:b638d780 r7:00000000
r6:b61a1e18 r5:00000004
[   57.800060]  r4:40045612
[   57.802621] [<804b7528>] (video_usercopy) from [<804b79d4>]
(video_ioctl2+0x14/0x1c)
[   57.810384]  r10:00000000 r9:b61a0000 r8:b729a80c r7:b638d780
r6:7e8655b4 r5:40045612
[   57.818316]  r4:b729a420
[   57.820876] [<804b79c0>] (video_ioctl2) from [<804b3b8c>]
(v4l2_ioctl+0x14c/0x174)
[   57.828473] [<804b3a40>] (v4l2_ioctl) from [<8010a6a4>]
(do_vfs_ioctl+0x408/0x664)
[   57.836063]  r8:00000003 r7:8010a93c r6:b638d780 r5:7e8655b4
r4:b698cf90 r3:804b3a40
[   57.843898] [<8010a29c>] (do_vfs_ioctl) from [<8010a93c>]
(SyS_ioctl+0x3c/0x64)
[   57.851227]  r10:00000000 r9:b61a0000 r8:00000003 r7:40045612
r6:b638d780 r5:7e8655b4
[   57.859160]  r4:b638d780
[   57.861723] [<8010a900>] (SyS_ioctl) from [<8000f740>]
(ret_fast_syscall+0x0/0x48)
[   57.869312]  r8:8000f904 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e8619c8 r3:00000000
[   57.877155] ---[ end trace efcf1fd10e10c974 ]---
VIDIOC_STREAMON: failed: Invalid argument

JM
