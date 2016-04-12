Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37806 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbcDLMAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 08:00:06 -0400
Received: by mail-wm0-f43.google.com with SMTP id n3so24954567wmn.0
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2016 05:00:05 -0700 (PDT)
Subject: Re: gstreamer: v4l2videodec plugin
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <570CE342.1060002@linaro.org>
Date: Tue, 12 Apr 2016 15:00:02 +0300
MIME-Version: 1.0
In-Reply-To: <570CB882.4090805@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

>>>>
>>>> I'm using the following pipeline:
>>>>
>>>> GST_GL_PLATFORM=egl GST_GL_API=gles2 gst-launch-1.0 $GSTDEBUG
>>>> $GSTFILESRC ! qtdemux name=m m.video_0 ! h264parse ! v4l2video32dec
>>>> capture-io-mode=dmabuf ! glimagesink
>>>>
>>>> I stalled on this error:
>>>>
>>>> eglimagememory
>>>> gsteglimagememory.c:473:gst_egl_image_memory_from_dmabuf:<eglimagea
>>>> llocator0>
>>>> eglCreateImage failed: EGL_BAD_MATCH
>>>>
>>>> which in Mesa is:
>>>>
>>>> libEGL debug: EGL user error 0x3009 (EGL_BAD_MATCH) in
>>>> dri2_create_image_khr_texture
>>>>
>>>> Do someone know how the dmabuf import is tested when the support
>>>> has
>>>> been added to glimagesink? Or some pointers how to continue with
>>>> debugging?
>>
>> So far the DMABuf support in glimagesink has been tested on Intel/Mesa
>> and libMALI. There is work in progress in Gallium/Mesa, but until
>> recently there was no support for offset in imported buffer, which
>> would result in BAD_MATCH error. I cannot guaranty this is the exact
>> reason here, BAD_MATCH is used for a very wide variety of reason in
>> those extensions. The right place to dig into this issue would be
>> through the Mesa list and/or Mesa code. Find out what is missing for
>> you driver in Mesa and then I may help you further.
> 
> I came down to these conditions
> 
> https://cgit.freedesktop.org/mesa/mesa/tree/src/gallium/state_trackers/dri/dri2.c?h=11.2#n1063
> 
> but I don't know how this is related. The gstreamer
> (gst_egl_image_memory_from_dmabuf) doesn't set this "level" so it will
> be zero.

That was wrong assumption, the error comes from another Mesa function.
I'm not sure still which one dri2_from_dma_bufs() or
dri2_create_image_dma_buf(). Will try to rebuild Mesa.

-- 
regards,
Stan
