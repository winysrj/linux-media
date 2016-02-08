Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35892 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbcBHJ65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 04:58:57 -0500
Subject: Re: [RFC PATCH v0] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
 <56938969.30104@xs4all.nl>
 <CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrey Utkin <andrey.od.utkin@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56B866D9.5070606@xs4all.nl>
Date: Mon, 8 Feb 2016 10:58:49 +0100
MIME-Version: 1.0
In-Reply-To: <CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

Hmm, it looks like I forgot to reply. Sorry about that.

On 01/15/2016 03:13 AM, Andrey Utkin wrote:
> On Mon, Jan 11, 2016 at 12:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Did you also test with v4l2-compliance? Before I accept the driver I want to see the
>> output of 'v4l2-compliance' and 'v4l2-compliance -s'. Basically there shouldn't be
>> any failures.
>>
>> I did a quick scan over the source and I saw nothing big. When you post the new
>> version I will go over it more carefully and do a proper review.
> 
> Thank you for review.
> You can find output of v4l2-compliance and v4l2-compliance -s tests
> below (v4l-utils-1.8.0-42-gf1348b4).
> There are some issues, I will work on them.
> Could you please advise how could I optimize high-volume data passing
> to userspace apps?
> In one installation with 16 boards, when all streams are set to be 30
> FPS all-I-frames (workaround for another P-frames quality issue), the
> host struggles from regular lockups, see message immediately below
> (4.2.0 kernel though, DKMS package with slightly modified code to
> match older API).
> I am not fully sure it is related to my driver, but I guess memcpy-ish
> approach to preparing video frames may be very CPU-expensive. 30 FPS
> all-I-frames video stream is like 3 megabytes per second.
> Of course this is not very good situation anyway, and I should either
> fix original issue or find some workarounds, at last to lower
> framerate. But still, optimization of data passing using some
> appropriate API like scatter-gather should be done I believe. I need
> hints how to do that right.
> Thanks in advance.

If I understand it correctly the problem is that you need to insert h264
headers in front of the data, and for that you need to do a memcpy, for now
at least. We are looking into mechanisms to pass the header separately from
the video frame data, but I don't dare give an ETA when that arrives in
the kernel.

That said, it makes no sense to use H264 with I frames only, it defeats
the purpose of H264. I would concentrate on making the encoder work correcly
as that will dramatically reduce the amount of data to memcpy. For SDTV
inputs you can get good quality using an MPEG-2 encoder with just 1 MB/s
in my experience. H264 should reduce that further. And doing a memcpy for
worst-case 4*16 = 64 MB/s should not be a problem at all for modern CPUs.

Frankly, even 3*64 = 192 MB/s as you have now shouldn't pose a problem.

I wouldn't change the memcpy: in my experience it is very useful to get a
well-formed compressed stream out of the hardware. And the overhead of
having to do a memcpy is a small price to pay and on modern CPUs should
be barely noticeable for SDTV inputs.

I don't believe that the lockups you see are related to the memcpy as
such. The trace says that a cpu is stuck for 22s, no way that is related
to something like that. It looks more like a deadlock somewhere.

Regarding the compliance tests: don't pass VB2_USERPTR (doesn't work well
with videobuf2-dma-contig). Also add vidioc_expbuf = vb2_ioctl_expbuf for
the DMABUF support. That should clear up some of the errors you see.

Regards,

	Hans

> 
> Jan 13 19:35:20 cctv kernel: [34202.715069] NMI watchdog: BUG: soft
> lockup - CPU#2 stuck for 22s! [khugepaged:69]
> Jan 13 19:35:20 cctv kernel: [34202.715071] Modules linked in: ib_iser
> rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi ast ttm drm_kms_helper drm
> syscopyarea sysfillrect sysimgblt xfs libcrc32c ipmi_ssif joydev
> input_leds intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul aesni_intel
> aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac
> edac_core lpc_ich mei_me mei shpchp wmi tw5864(OE) solo6x10
> videobuf2_dma_contig videobuf2_dma_sg videobuf2_memops videobuf2_core
> v4l2_common videodev media ipmi_si 8250_fintek ipmi_msghandler snd_pcm
> snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device
> snd_timer snd acpi_power_meter acpi_pad soundcore mac_hid parport_pc
> ppdev lp parport hid_generic usbhid hid igb i2c_algo_bit ahci dca ptp
> libahci megaraid_sas pps_core
> Jan 13 19:35:20 cctv kernel: [34202.715105] CPU: 2 PID: 69 Comm:
> khugepaged Tainted: G        W  OEL  4.2.0-23-generic
> #28~14.04.1-Ubuntu
> Jan 13 19:35:20 cctv kernel: [34202.715106] Hardware name: Supermicro
> Super Server/X10SRi-F, BIOS 2.0 12/17/2015
> Jan 13 19:35:20 cctv kernel: [34202.715107] task: ffff88046d7a6040 ti:
> ffff88046d0f4000 task.ti: ffff88046d0f4000
> Jan 13 19:35:20 cctv kernel: [34202.715108] RIP:
> 0010:[<ffffffff810f4c49>]  [<ffffffff810f4c49>]
> smp_call_function_many+0x1f9/0x250
> Jan 13 19:35:20 cctv kernel: [34202.715112] RSP: 0018:ffff88046d0f7b58
>  EFLAGS: 00000202
> Jan 13 19:35:20 cctv kernel: [34202.715112] RAX: 0000000000000003 RBX:
> 0000000000000000 RCX: ffff88047fd1a870
> Jan 13 19:35:20 cctv kernel: [34202.715113] RDX: 0000000000000004 RSI:
> 0000000000000100 RDI: ffff88047fc97788
> Jan 13 19:35:20 cctv kernel: [34202.715114] RBP: ffff88046d0f7b98 R08:
> 00000000000000fb R09: 0000000000000000
> Jan 13 19:35:20 cctv kernel: [34202.715114] R10: 0000000000000004 R11:
> 0000000000000000 R12: 0000000000000297
> Jan 13 19:35:20 cctv kernel: [34202.715115] R13: ffff88046d0f7b08 R14:
> 0000000000000202 R15: 0000000000000202
> Jan 13 19:35:20 cctv kernel: [34202.715116] FS:
> 0000000000000000(0000) GS:ffff88047fc80000(0000)
> knlGS:0000000000000000
> Jan 13 19:35:20 cctv kernel: [34202.715117] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Jan 13 19:35:20 cctv kernel: [34202.715118] CR2: 00007fae31dc0000 CR3:
> 0000000001c0d000 CR4: 00000000001406e0
> Jan 13 19:35:20 cctv kernel: [34202.715118] Stack:
> Jan 13 19:35:20 cctv kernel: [34202.715119]  0000000000017740
> 01ff880400000001 0000000000000009 ffffffff81fb4ec0
> Jan 13 19:35:20 cctv kernel: [34202.715120]  ffffffff8117d4c0
> 0000000000000000 0000000000000002 0000000000000100
> Jan 13 19:35:20 cctv kernel: [34202.715122]  ffff88046d0f7bc8
> ffffffff810f4e49 0000000000000100 0000000000000000
> Jan 13 19:35:20 cctv kernel: [34202.715123] Call Trace:
> Jan 13 19:35:20 cctv kernel: [34202.715127]  [<ffffffff8117d4c0>] ?
> page_alloc_cpu_notify+0x50/0x50
> Jan 13 19:35:20 cctv kernel: [34202.715128]  [<ffffffff810f4e49>]
> on_each_cpu_mask+0x29/0x70
> Jan 13 19:35:20 cctv kernel: [34202.715129]  [<ffffffff8117b513>]
> drain_all_pages+0xd3/0xf0
> Jan 13 19:35:20 cctv kernel: [34202.715131]  [<ffffffff8117f391>]
> __alloc_pages_nodemask+0x631/0x990
> Jan 13 19:35:20 cctv kernel: [34202.715134]  [<ffffffff811d5cb0>]
> khugepaged_scan_mm_slot+0x540/0xf50
> Jan 13 19:35:20 cctv kernel: [34202.715136]  [<ffffffff817b9b85>] ?
> schedule_timeout+0x165/0x2a0
> Jan 13 19:35:20 cctv kernel: [34202.715137]  [<ffffffff811d67dd>]
> khugepaged+0x11d/0x440
> Jan 13 19:35:20 cctv kernel: [34202.715139]  [<ffffffff810b73f0>] ?
> prepare_to_wait_event+0xf0/0xf0
> Jan 13 19:35:20 cctv kernel: [34202.715141]  [<ffffffff811d66c0>] ?
> khugepaged_scan_mm_slot+0xf50/0xf50
> Jan 13 19:35:20 cctv kernel: [34202.715143]  [<ffffffff810951b2>]
> kthread+0xd2/0xf0
> Jan 13 19:35:20 cctv kernel: [34202.715144]  [<ffffffff810950e0>] ?
> kthread_create_on_node+0x1c0/0x1c0
> Jan 13 19:35:20 cctv kernel: [34202.715146]  [<ffffffff817baedf>]
> ret_from_fork+0x3f/0x70
> Jan 13 19:35:20 cctv kernel: [34202.715147]  [<ffffffff810950e0>] ?
> kthread_create_on_node+0x1c0/0x1c0
> Jan 13 19:35:20 cctv kernel: [34202.715147] Code: 51 2c 00 3b 05 ad 82
> c3 00 89 c2 0f 8d 98 fe ff ff 48 98 49 8b 4d 00 48 03 0c c5 40 ae d2
> 81 8b 41 18 a8 01 74 ca f3 90 8b 41 18 <a8> 01 75 f7 eb bf 0f b6 4d c8
> 4c 89 fa 4c 89 f6 44 89 ef e8 7f
> 
> 
> 
>  # /src/v4l-utils/utils/v4l2-compliance/v4l2-compliance -d /dev/video6
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.4.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 fail: v4l2-test-buffers.cpp(386): node->s_std(std)
>                 fail: v4l2-test-buffers.cpp(500): testCanSetSameTimings(node)
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>                 test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> 
> Total: 42, Succeeded: 41, Failed: 1, Warnings: 0
> [ERR]
> 01:58:05root@localhost /usr/local/src/linux
>  # /src/v4l-utils/utils/v4l2-compliance/v4l2-compliance -s -d /dev/video6
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.4.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 fail: v4l2-test-buffers.cpp(386): node->s_std(std)
>                 fail: v4l2-test-buffers.cpp(500): testCanSetSameTimings(node)
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>                 test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
>                 fail: v4l2-test-buffers.cpp(959): ret != EINVAL
>         test MMAP: FAIL
>                 fail: v4l2-test-buffers.cpp(1043): buf.qbuf(node)
>                 fail: v4l2-test-buffers.cpp(1087): setupUserPtr(node, q)
>         test USERPTR: FAIL
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 45, Succeeded: 42, Failed: 3, Warnings: 0
> [ERR]
> 01:58:11root@localhost /usr/local/src/linux
>  # /src/v4l-utils/utils/v4l2-compliance/v4l2-compliance -s
> --expbuf-device=/dev/video6 -d /dev/video6
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.4.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 fail: v4l2-test-buffers.cpp(386): node->s_std(std)
>                 fail: v4l2-test-buffers.cpp(500): testCanSetSameTimings(node)
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>                 test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
>                 fail: v4l2-test-buffers.cpp(959): ret != EINVAL
>         test MMAP: FAIL
>                 fail: v4l2-test-buffers.cpp(1043): buf.qbuf(node)
>                 fail: v4l2-test-buffers.cpp(1087): setupUserPtr(node, q)
>         test USERPTR: FAIL
>                 fail: v4l2-test-buffers.cpp(1111):
> exp_q.reqbufs(expbuf_node, q.g_buffers())
>                 fail: v4l2-test-buffers.cpp(1200):
> setupDmaBuf(expbuf_node, node, q, exp_q)
>         test DMABUF: FAIL
> 
> 
> Total: 46, Succeeded: 42, Failed: 4, Warnings: 0
> [ERR]
> 

