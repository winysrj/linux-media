Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50875 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 13:04:49 -0500
Received: by mail-wi0-f170.google.com with SMTP id cb5so1337864wib.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 10:04:47 -0800 (PST)
Subject: Re: hdpvr driver and VIDIOC_G_FMT
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?David_R=F6thlisberger?= <david@rothlis.net>
In-Reply-To: <201210011109.23099.hverkuil@xs4all.nl>
Date: Thu, 15 Nov 2012 18:04:43 +0000
Cc: linux-media@vger.kernel.org,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Janne Grunau <j@jannau.net>, will@williammanley.net
Content-Transfer-Encoding: 8BIT
Message-Id: <23C1C67D-7173-4DF5-BB2E-B961C90CAAD5@rothlis.net>
References: <76F043BB-BCE9-4521-A17E-5246BA2E812E@rothlis.net> <201210011109.23099.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 Oct 2012, at 10:09, Hans Verkuil wrote:
> On Sun September 30 2012 14:51:36 David Röthlisberger wrote:
>> I am using the Hauppauge HD PVR video-capture device with a GStreamer
>> "v4l2src". The HD PVR has an upstream driver called "hdpvr":
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=tree;f=drivers/media/video/hdpvr
>> 
>> When the HD PVR device does not have any video on its capture input, the
>> VIDIOC_G_FMT ioctl fails. GStreamer ignores the error (and doesn't
>> report it to my application); the HD PVR fails to start up so even if
>> video is later established on the HD PVR's input, the GStreamer pipeline
>> never receives video. (Bear with me, linuxtv folks; I have plenty of
>> non-GStreamer questions for you.) :-)
>> 
>> It seems to me that the only reason the hdpvr's vidioc_g_fmt_vid_cap [1]
>> fails, is because it doesn't know the video width & height until it
>> has video on its input:
>> 
>>    vid_info = get_video_info(dev);
>>    if (!vid_info)
>>    	return -EFAULT;
>> 
>>    f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>    f->fmt.pix.pixelformat	= V4L2_PIX_FMT_MPEG;
>>    f->fmt.pix.width	= vid_info->width;
>>    f->fmt.pix.height	= vid_info->height;
>>    f->fmt.pix.sizeimage	= dev->bulk_in_size;
>>    f->fmt.pix.colorspace	= 0;
>>    f->fmt.pix.bytesperline	= 0;
>>    f->fmt.pix.field	= V4L2_FIELD_ANY;
>> 
>> Note that the v4l2 documentation for VIDIOC_G_FMT [2] says:
>> 
>>    Drivers should not return an error code unless the type field is
>>    invalid, this is a mechanism to fathom device capabilities and to
>>    approach parameters acceptable for both the application and driver.
>> 
>> The above discusses "device capabilities" whereas what the hdpvr driver
>> does in this case describes properties of the input data. The difficulty
>> is that the capabilities of the hardware include a whole bunch of
>> different resolutions and frame-rates but these modes seem only
>> available if they match the incoming signal.
>> 
>> Question 1: Is this [return -EFAULT] a bug in the hdpvr driver?
> 
> Yes.
> 
>> If the
>> format is mpeg, why do we need to fill in width & height -- isn't this
>> something the container or codec will tell you?
> 
> For devices with a hardware scaler width and height represent the scaler
> output size. For devices without a scaler width and height are set based
> on the selected standard.
> 
>> It seems to me that all
>> the other fields can be determined even without video on the device's
>> capture input, so this function doesn't need to fail.
> 
> Agreed.
> 
>> Now looking at v4l2_fd_open: [3]
>> 
>>    /* Get current cam format */
>>    fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>    if (dev_ops->ioctl(dev_ops_priv, fd, VIDIOC_G_FMT, &fmt)) {
>>            int saved_err = errno;
>>            V4L2_LOG_ERR("getting pixformat: %s\n", strerror(errno));
>>            v4l2_plugin_cleanup(plugin_library, dev_ops_priv, dev_ops);
>>            errno = saved_err;
>>            return -1;
>>    }
>> 
>> Question 2: Is v4l2 mostly designed towards webcams (as the comment in
>> the above code implies)?
> 
> libv4l2 is generic, although webcams are the primary use-case. It was initially
> developed with a focus on webcams, which is the reason you see them mentioned.
> But it works just as well with non-webcams.
> 
>> What about capturing a continuous video stream
>> from a video-capture device, where I want to continue capturing even
>> when the capture device loses video input? (Say, it's connected to a
>> set-top box that reboots, and I want to capture the video from the
>> set-top box before it reboots and after it reboots, with a blank image
>> during the time the video was lost.)
> 
> Whether that's possible will depend on the hardware. Some hardware will stop
> streaming if sync is lost, although for analog sources (especially composite
> and S-Video inputs) this is generally not a problem. You usually receive
> static, though, not a blank image.
> 
>> Now to GStreamer: gst_v4l2_open [4] ignores the error from v4l2_fd_open:
>> 
>>    libv4l2_fd = v4l2_fd_open (v4l2object->video_fd,
>>        V4L2_ENABLE_ENUM_FMT_EMULATION);
>>    /* Note the v4l2_xxx functions are designed so that if they get passed an
>>       unknown fd, the will behave exactly as their regular xxx counterparts, so
>>       if v4l2_fd_open fails, we continue as normal (missing the libv4l2 custom
>>       cam format to normal formats conversion). Chances are big we will still
>>       fail then though, as normally v4l2_fd_open only fails if the device is not
>>       a v4l2 device. */
>>    if (libv4l2_fd != -1)
>>      v4l2object->video_fd = libv4l2_fd;
>> 
>> Again a comment mentioning "cams".
>> 
>> Question 3: If "chances are big we will still fail" anyway, could we
>> instead report the error up to the GStreamer pipeline/application?
> 
> The problem is that there are still drivers like hdpvr that do not conform to
> the V4L2 API. While the error really should be reported, the consequence today
> might be that it will stop working for drivers like this.
> 
>> Thanks for your help, and I hope my ignorance doesn't show through too
>> much in my questions. :-) What we haven't tried yet is just removing the
>> call to get_video_info from VIDIOC_G_FMT and related calls in the kernel
>> to avoid the failure condition, and see what happens; but in parallel
>> with that task I thought I'd write to you for some guidance.
> 
> The whole driver needs to be seriously cleaned up. There is a v4l2 compliance
> tools in the v4l2-utils git repository (http://git.linuxtv.org/v4l-utils.git,
> use the master branch) which this driver will fail completely.
> 
> Regards,
> 
> 	Hans


Hans, thank you very much for your reply, it was very helpful.

For what it's worth, the output of the v4l2-compliance tool against the
hdpvr driver is pasted below. (I'm not expecting anybody on this list to
do anything about it -- it's just for the record. I haven't had time to
do any work on the hdpvr driver myself.)

A few things I've learned since my previous email:

+ Hauppauge didn't write the hdpvr Linux driver; it was written by
  someone in the open-source community.

+ Hauppauge are now producing an "HD PVR 2" model[1] with a different
  H.264 encoder chip, different firmware, different USB protocol...
  The hdpvr Linux driver does not work at all with the HD PVR 2.

--Dave.

[1] http://www.hauppauge.com/site/products/data_hdpvr2-gaming.html

--

v4l2-compliance tool output:

Driver Info:
	Driver name   : hdpvr
	Card type     : Hauppauge HD PVR
	Bus info      : usb-0000:00:1d.7-1.4.1
	Driver version: 3.6.6
	Capabilities  : 0x01020001
		Video Capture
		Audio
		Read/Write

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(293): !(caps & V4L2_CAP_DEVICE_CAPS)
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second video open: OK
		fail: v4l2-compliance.cpp(293): !(caps & V4L2_CAP_DEVICE_CAPS)
	test VIDIOC_QUERYCAP: FAIL
		fail: v4l2-compliance.cpp(334): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 3 Audio Inputs: 3 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		fail: v4l2-test-controls.cpp(145): can do querymenu on a non-menu control
		fail: v4l2-test-controls.cpp(201): invalid control 00980900
	test VIDIOC_QUERYCTRL/MENU: FAIL
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(511): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
		fail: v4l2-test-formats.cpp(382): !pix.colorspace
	test VIDIOC_G_FMT: FAIL
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 38, Succeeded: 32, Failed: 6, Warnings: 0

