Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34279 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbcDKMLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 08:11:06 -0400
Received: by mail-wm0-f47.google.com with SMTP id l6so142997323wml.1
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2016 05:11:04 -0700 (PDT)
Subject: Re: gstreamer: v4l2videodec plugin
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	nicolas.dufresne@collabora.com, Rob Clark <robdclark@gmail.com>,
	gstreamer-devel@lists.freedesktop.org
References: <570B9285.9000209@linaro.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <570B9454.6020307@linaro.org>
Date: Mon, 11 Apr 2016 15:11:00 +0300
MIME-Version: 1.0
In-Reply-To: <570B9285.9000209@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

adding gstreamer-devel

On 04/11/2016 03:03 PM, Stanimir Varbanov wrote:
> Hi,
> 
> I'm working on QCOM v4l2 video decoder/encoder driver and in order to
> test its functionalities I'm using gstreamer v4l2videodec plugin. I am
> able to use the v4l2videodec plugin with MMAP, now I want to try the
> dmabuf export from v4l2 and import dmabuf buffers to glimagesink. I
> upgraded gst to 1.7.91 so that I have the dmabuf support in glimagesink.
> Mesa version is 11.1.2.
> 
> I'm using the following pipeline:
> 
> GST_GL_PLATFORM=egl GST_GL_API=gles2 gst-launch-1.0 $GSTDEBUG
> $GSTFILESRC ! qtdemux name=m m.video_0 ! h264parse ! v4l2video32dec
> capture-io-mode=dmabuf ! glimagesink
> 
> I stalled on this error:
> 
> eglimagememory
> gsteglimagememory.c:473:gst_egl_image_memory_from_dmabuf:<eglimageallocator0>
> eglCreateImage failed: EGL_BAD_MATCH
> 
> which in Mesa is:
> 
> libEGL debug: EGL user error 0x3009 (EGL_BAD_MATCH) in
> dri2_create_image_khr_texture
> 
> Do someone know how the dmabuf import is tested when the support has
> been added to glimagesink? Or some pointers how to continue with debugging?
> 
> Thanks for the answers.
> 


-- 
regards,
Stan
