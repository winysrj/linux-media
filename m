Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38359 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbcDLI5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 04:57:41 -0400
Received: by mail-wm0-f51.google.com with SMTP id u206so18544542wme.1
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2016 01:57:41 -0700 (PDT)
Subject: Re: gstreamer: v4l2videodec plugin
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <570CB882.4090805@linaro.org>
Date: Tue, 12 Apr 2016 11:57:38 +0300
MIME-Version: 1.0
In-Reply-To: <1460391908.30296.12.camel@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 04/11/2016 07:25 PM, Nicolas Dufresne wrote:
> Le lundi 11 avril 2016 à 15:11 +0300, Stanimir Varbanov a écrit :
>> adding gstreamer-devel
>>
>> On 04/11/2016 03:03 PM, Stanimir Varbanov wrote:
>>>
>>> Hi,
>>>
>>> I'm working on QCOM v4l2 video decoder/encoder driver and in order
>>> to
>>> test its functionalities I'm using gstreamer v4l2videodec plugin. I
>>> am
>>> able to use the v4l2videodec plugin with MMAP, now I want to try
>>> the
>>> dmabuf export from v4l2 and import dmabuf buffers to glimagesink. I
>>> upgraded gst to 1.7.91 so that I have the dmabuf support in
>>> glimagesink.
>>> Mesa version is 11.1.2.
> 
> I'm very happy to see this report. So far, we only had report that this
> element works on Freescale IMX.6 (CODA) and Exynos 4/5.

In this context, I would be very happy to see v4l2videoenc merged soon :)

> 
>>>
>>> I'm using the following pipeline:
>>>
>>> GST_GL_PLATFORM=egl GST_GL_API=gles2 gst-launch-1.0 $GSTDEBUG
>>> $GSTFILESRC ! qtdemux name=m m.video_0 ! h264parse ! v4l2video32dec
>>> capture-io-mode=dmabuf ! glimagesink
>>>
>>> I stalled on this error:
>>>
>>> eglimagememory
>>> gsteglimagememory.c:473:gst_egl_image_memory_from_dmabuf:<eglimagea
>>> llocator0>
>>> eglCreateImage failed: EGL_BAD_MATCH
>>>
>>> which in Mesa is:
>>>
>>> libEGL debug: EGL user error 0x3009 (EGL_BAD_MATCH) in
>>> dri2_create_image_khr_texture
>>>
>>> Do someone know how the dmabuf import is tested when the support
>>> has
>>> been added to glimagesink? Or some pointers how to continue with
>>> debugging?
> 
> So far the DMABuf support in glimagesink has been tested on Intel/Mesa
> and libMALI. There is work in progress in Gallium/Mesa, but until
> recently there was no support for offset in imported buffer, which
> would result in BAD_MATCH error. I cannot guaranty this is the exact
> reason here, BAD_MATCH is used for a very wide variety of reason in
> those extensions. The right place to dig into this issue would be
> through the Mesa list and/or Mesa code. Find out what is missing for
> you driver in Mesa and then I may help you further.

I came down to these conditions

https://cgit.freedesktop.org/mesa/mesa/tree/src/gallium/state_trackers/dri/dri2.c?h=11.2#n1063

but I don't know how this is related. The gstreamer
(gst_egl_image_memory_from_dmabuf) doesn't set this "level" so it will
be zero.

> 
> For the reference, the importation strategy we use in GStreamer has
> been inspired of Kodi (xmbc). It consist of importing each YUV plane
> seperatly using R8 and RG88 textures and doing the color conversion
> using shaders. Though, if the frame is allocated as a single DMABuf,
> this requires using offset to access the frame data, and that support

Yep that is my case, the driver capture buffers has one plain, hence one
dmabuf will be exported per buffer.

> had only been recently added in Gallium base code and in Radeon driver
> recently. I don't know if Freedreno, VC4 have that, and I know nouveau
> don't.

Rob, do we need to add something in Freedreno Gallium driver to handle
dmabuf import?

-- 
regards,
Stan
