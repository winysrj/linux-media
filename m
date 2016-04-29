Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34095 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbcD2Lod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 07:44:33 -0400
Received: by mail-yw0-f180.google.com with SMTP id j74so158787398ywg.1
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2016 04:44:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5721F4FC.30001@linaro.org>
References: <570B9285.9000209@linaro.org>
	<570B9454.6020307@linaro.org>
	<1460391908.30296.12.camel@collabora.com>
	<570CB882.4090805@linaro.org>
	<CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
	<1460736595.973.5.camel@ndufresne.ca>
	<5721F4FC.30001@linaro.org>
Date: Fri, 29 Apr 2016 07:44:32 -0400
Message-ID: <CAF6AEGvEQ1VCt7FgB6Zk_b9J4Hz3rfrehWN2um8nyiAA0-0s3Q@mail.gmail.com>
Subject: Re: gstreamer: v4l2videodec plugin
From: Rob Clark <robdclark@gmail.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: nicolas@ndufresne.ca,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"mesa-dev@lists.freedesktop.org" <mesa-dev@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 28, 2016 at 7:33 AM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
> On 04/15/2016 07:09 PM, Nicolas Dufresne wrote:
>> Le vendredi 15 avril 2016 à 11:58 -0400, Rob Clark a écrit :
>>> The issue is probably the YUV format, which we cannot really deal
>>> with
>>> properly in gallium..  it's a similar issue to multi-planer even if
>>> it
>>> is in a single buffer.
>>>
>>> The best way to handle this would be to import the same dmabuf fd
>>> twice, with appropriate offsets, to create one GL_RED eglimage for Y
>>> and one GL_RG eglimage for UV, and then combine them in shader in a
>>> similar way to how you'd handle separate Y and UV planes..
>>
>> That's the strategy we use in GStreamer, as very few GL stack support
>> implicit color conversions. For that to work you need to implement the
>> "offset" field in winsys_handle, that was added recently, and make sure
>> you have R8 and RG88 support (usually this is just mapping).
>
> Thanks,
>
> OK, I have made the relevant changes in Mesa and now I have image but
> the U and V components are swapped (the format is NV12, the UV plane is
> at the same buffer but at offset). Digging further and tracing gstreamer
> with apitrace I'm observing something weird.
>
> The gst import dmabuf with following call:
>
> eglCreateImageKHR(dpy = 0x7fa8013030, ctx = NULL, target =
> EGL_LINUX_DMA_BUF_EXT, buffer = NULL, attrib_list = {EGL_WIDTH, 640,
> EGL_HEIGHT, 360, EGL_LINUX_DRM_FOURCC_EXT, 943215175,
> EGL_DMA_BUF_PLANE0_FD_EXT, 29, EGL_DMA_BUF_PLANE0_OFFSET_EXT, 942080,
> EGL_DMA_BUF_PLANE0_PITCH_EXT, 1280, EGL_NONE}) = 0x7f980027d0
>
> the fourcc format is DRM_FORMAT_GR88 (943215175 decimal).
>
> after that:
>
> glTexImage2D(target = GL_TEXTURE_2D, level = 0, internalformat = GL_RG8,
> width = 640, height = 360, border = 0, format = GL_RG, type =
> GL_UNSIGNED_BYTE, pixels = NULL)
>
> and finally on the fragment shader we have:
>
> yuv.x=texture2D(Ytex, texcoord * tex_scale0).r;
> yuv.yz=texture2D(UVtex, texcoord * tex_scale1).rg;
>
> I was expecting to see DRM_FORMAT_RG88 / GL_RG and shader sampling
> y <- r
> z <- g
>
> or DRM_FORMAT_GR88 / GL_RG and shader sampling
> y <- g
> z <- r

IIRC you are using gles?  Could you recompile glimagesink to use
desktop GL?  I'm wondering a bit, but just speculation since I don't
have a way to step through it, but the 'if (_mesa_is_gles())' case in
st_ChooseTextureFormat..  normally for gles the driver is more free to
choose the corresponding internal-format, which is maybe not the right
thing to do for textures which are imported eglimages.

(if recompiling mesa is easier, you could just change that to 'if (0)'
and see if it "fixes" things.. that ofc is not the proper fix, but it
would confirm whether this is what is going on..)

BR,
-R

> Also, browsing the code in Mesa for Intel i965 dri driver I found where
> the __DRI_IMAGE_FORMAT_GR88 becomes MESA_FORMAT_R8G8_UNORM [1].
>
> So I'm wondering is that intensional?
>
> Depending on the answer I should make the same in the Gallium dri2 in
> dri2_from_dma_bufs().
>
> --
> regards,
> Stan
>
> [1]
> https://cgit.freedesktop.org/mesa/mesa/tree/src/mesa/drivers/dri/common/dri_util.c#n878
>
