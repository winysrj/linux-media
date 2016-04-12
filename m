Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:33074 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbcDLIX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 04:23:26 -0400
Subject: Re: gstreamer: v4l2videodec plugin
To: =?UTF-8?B?VsOtY3RvciBNLiBKw6FxdWV6IEwu?= <vjaquez@igalia.com>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <20160411125556.eij4jaibs36zizav@mir.local.igalia.com>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	nicolas.dufresne@collabora.com, Rob Clark <robdclark@gmail.com>
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <570CB07A.1020308@mm-sol.com>
Date: Tue, 12 Apr 2016 11:23:22 +0300
MIME-Version: 1.0
In-Reply-To: <20160411125556.eij4jaibs36zizav@mir.local.igalia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Victor,

On 04/11/2016 03:55 PM, Víctor M. Jáquez L. wrote:
> On 04/11/16 at 03:11pm, Stanimir Varbanov wrote:
>> adding gstreamer-devel
>>
>> On 04/11/2016 03:03 PM, Stanimir Varbanov wrote:
>>> Hi,
>>>
>>> I'm working on QCOM v4l2 video decoder/encoder driver and in order to
>>> test its functionalities I'm using gstreamer v4l2videodec plugin. I am
>>> able to use the v4l2videodec plugin with MMAP, now I want to try the
>>> dmabuf export from v4l2 and import dmabuf buffers to glimagesink. I
>>> upgraded gst to 1.7.91 so that I have the dmabuf support in glimagesink.
>>> Mesa version is 11.1.2.
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
>>> gsteglimagememory.c:473:gst_egl_image_memory_from_dmabuf:<eglimageallocator0>
>>> eglCreateImage failed: EGL_BAD_MATCH
>>>
>>> which in Mesa is:
>>>
>>> libEGL debug: EGL user error 0x3009 (EGL_BAD_MATCH) in
>>> dri2_create_image_khr_texture
>>>
>>> Do someone know how the dmabuf import is tested when the support has
>>> been added to glimagesink? Or some pointers how to continue with
>>> debugging?
> 
> Perhaps this is not useful for your case, but there's a kmssink (a simple
> video sink that uses KMS/DRM kernel API)[1]. It supports dmabuf import and
> rendering, and the way it does it is heavily inspired on how glimagesink does
> it, obviously without the EGL burden, just the kernel's PRIME API.

Thanks for the info, I've searched few times for such an element in
gstreamer. I find it useful and will give it a try when it is merged.


-- 
regards,
Stan
