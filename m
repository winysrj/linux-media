Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34814 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbcB2Vkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 16:40:51 -0500
Received: by mail-qk0-f180.google.com with SMTP id x1so62121148qkc.1
        for <linux-media@vger.kernel.org>; Mon, 29 Feb 2016 13:40:50 -0800 (PST)
Date: Mon, 29 Feb 2016 18:40:45 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Subject: Re: [PATCH v2] media: Support Intersil/Techwell TW686x-based video
 capture cards
Message-ID: <20160229214045.GA14121@laptop.cereza>
References: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 25 January 2016 at 02:23, Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> wrote:
> This commit introduces the support for the Techwell TW686x video
> capture IC. This hardware supports a few DMA modes, including
> scatter-gather and frame (contiguous).
>
> This commit makes little use of the DMA engine and instead has
> a memcpy based implementation. DMA frame and scatter-gather modes
> support may be added in the future.
>
> Currently supported chips:
> - TW6864 (4 video channels),
> - TW6865 (4 video channels, not tested, second generation chip),
> - TW6868 (8 video channels but only 4 first channels using
>            built-in video decoder are supported, not tested),
> - TW6869 (8 video channels, second generation chip).
>
> Cc: Krzysztof Hałasa <khalasa@piap.pl>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
> Changes from v1 as per Hans' review:
>
>   * Kconfig should select VIDEOBUF2_VMALLOC, instead of VIDEOBUF2_DMA_CONTIG.
>   * Use strlcpy and strncpy.
>   * Unline and move tw686x_{enable,disable}_channel to tw686x-core.c
>   * Define macros for BIT(31) and BIT(17).
>   * Fix wrong indentation and space usage.
>   * Use lower case hex values.
>   * Use static const modifiers for static const arrays.
>   * Remove unused s_parm and g_parm ioctls.
>   * Add parameter check to s_input.
>   * Make video_register_device the last call when a channel
>     is registered.
>   * Return vb2 buffers if start_streaming fails.
>   * Document the reasons for using memcpy-based implementation.
>   * Document the reason for caring about device hot-unplugging.
>
> This patchset superseeds Krzysztof's original patch:
> https://patchwork.linuxtv.org/patch/30448/
>
> Tested on a custom TW6869-based capture card.
> Latest v4l2-compliance test pass:
>

As per Hans request on IRC, here's the full output of v4l2-compliance,
since it was previoulsy snipped:

v4l2-compliance -f -s
Driver Info:
	Driver name   : tw686x
	Card type     : tw6869
	Bus info      : PCI:0000:04:00.0
	Driver version: 4.4.0
	Capabilities  : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 4 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 1:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 2:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 3:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK
	test MMAP: OK                                     
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
	test MMAP for Format UYVY, Frame Size 360x240:
		Stride 720, Field Interlaced: OK                            
	test MMAP for Format UYVY, Frame Size 720x480:
		Stride 1440, Field Interlaced: OK                           
	test MMAP for Format RGBP, Frame Size 360x240:
		Stride 720, Field Interlaced: OK                            
	test MMAP for Format RGBP, Frame Size 720x480:
		Stride 1440, Field Interlaced: OK                           
	test MMAP for Format YUYV, Frame Size 360x240:
		Stride 720, Field Interlaced: OK                            
	test MMAP for Format YUYV, Frame Size 720x480:
		Stride 1440, Field Interlaced: OK                           

Total: 114, Succeeded: 114, Failed: 0, Warnings: 0

Also, this patch needs the following small amendment:

--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -478,7 +478,8 @@ static int tw686x_querycap(struct file *file, void *priv,
        strlcpy(cap->card, dev->name, sizeof(cap->card));
        snprintf(cap->bus_info, sizeof(cap->bus_info),
                 "PCI:%s", pci_name(dev->pci_dev));
-       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+                          V4L2_CAP_READWRITE;
        cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
        return 0;
 }
@@ -837,7 +838,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
                                goto error;
                }
 
-               vc->vidq.io_modes = VB2_MMAP | VB2_DMABUF;
+               vc->vidq.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
                vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                vc->vidq.drv_priv = vc;
                vc->vidq.buf_struct_size = sizeof(struct tw686x_v4l2_buf);

I was having some trouble with read() [1], and so was doing some debugging
and accidentally commited the VB2_READ and V4L2_CAP_READWRITE removal,
before submitting the patch.

[1] Most likely, it was the issue fixed by commit fac710e45d
"[media] vb2: fix nasty vb2_thread regression"
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
