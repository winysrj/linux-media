Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33783 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbcD1LdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 07:33:21 -0400
Received: by mail-wm0-f54.google.com with SMTP id g17so4113467wme.0
        for <linux-media@vger.kernel.org>; Thu, 28 Apr 2016 04:33:20 -0700 (PDT)
Subject: Re: gstreamer: v4l2videodec plugin
To: nicolas@ndufresne.ca, Rob Clark <robdclark@gmail.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
 <CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
 <1460736595.973.5.camel@ndufresne.ca>
Cc: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <5721F4FC.30001@linaro.org>
Date: Thu, 28 Apr 2016 14:33:16 +0300
MIME-Version: 1.0
In-Reply-To: <1460736595.973.5.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2016 07:09 PM, Nicolas Dufresne wrote:
> Le vendredi 15 avril 2016 à 11:58 -0400, Rob Clark a écrit :
>> The issue is probably the YUV format, which we cannot really deal
>> with
>> properly in gallium..  it's a similar issue to multi-planer even if
>> it
>> is in a single buffer.
>>
>> The best way to handle this would be to import the same dmabuf fd
>> twice, with appropriate offsets, to create one GL_RED eglimage for Y
>> and one GL_RG eglimage for UV, and then combine them in shader in a
>> similar way to how you'd handle separate Y and UV planes..
> 
> That's the strategy we use in GStreamer, as very few GL stack support
> implicit color conversions. For that to work you need to implement the
> "offset" field in winsys_handle, that was added recently, and make sure
> you have R8 and RG88 support (usually this is just mapping).

Thanks,

OK, I have made the relevant changes in Mesa and now I have image but
the U and V components are swapped (the format is NV12, the UV plane is
at the same buffer but at offset). Digging further and tracing gstreamer
with apitrace I'm observing something weird.

The gst import dmabuf with following call:

eglCreateImageKHR(dpy = 0x7fa8013030, ctx = NULL, target =
EGL_LINUX_DMA_BUF_EXT, buffer = NULL, attrib_list = {EGL_WIDTH, 640,
EGL_HEIGHT, 360, EGL_LINUX_DRM_FOURCC_EXT, 943215175,
EGL_DMA_BUF_PLANE0_FD_EXT, 29, EGL_DMA_BUF_PLANE0_OFFSET_EXT, 942080,
EGL_DMA_BUF_PLANE0_PITCH_EXT, 1280, EGL_NONE}) = 0x7f980027d0

the fourcc format is DRM_FORMAT_GR88 (943215175 decimal).

after that:

glTexImage2D(target = GL_TEXTURE_2D, level = 0, internalformat = GL_RG8,
width = 640, height = 360, border = 0, format = GL_RG, type =
GL_UNSIGNED_BYTE, pixels = NULL)

and finally on the fragment shader we have:

yuv.x=texture2D(Ytex, texcoord * tex_scale0).r;
yuv.yz=texture2D(UVtex, texcoord * tex_scale1).rg;

I was expecting to see DRM_FORMAT_RG88 / GL_RG and shader sampling
y <- r
z <- g

or DRM_FORMAT_GR88 / GL_RG and shader sampling
y <- g
z <- r

Also, browsing the code in Mesa for Intel i965 dri driver I found where
the __DRI_IMAGE_FORMAT_GR88 becomes MESA_FORMAT_R8G8_UNORM [1].

So I'm wondering is that intensional?

Depending on the answer I should make the same in the Gallium dri2 in
dri2_from_dma_bufs().

-- 
regards,
Stan

[1]
https://cgit.freedesktop.org/mesa/mesa/tree/src/mesa/drivers/dri/common/dri_util.c#n878

