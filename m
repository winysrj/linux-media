Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50641 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2JBMKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 08:10:21 -0400
Received: by bkcjk13 with SMTP id jk13so5448979bkc.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 05:10:20 -0700 (PDT)
Message-ID: <506AD9A9.3090506@gmail.com>
Date: Tue, 02 Oct 2012 14:10:17 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: Tom Cooksey <tom.cooksey@arm.com>
CC: mesa-dev@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org,
	'Jesse Barker' <jesse.barker@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC] New dma_buf -> EGLImage EGL extension
References: <503f7244.1180cd0a.7c47.ffffed02SMTPIN_ADDED@mx.google.com>
In-Reply-To: <503f7244.1180cd0a.7c47.ffffed02SMTPIN_ADDED@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

Bit late reply, hopefully not too late.

Op 30-08-12 16:00, Tom Cooksey schreef:
> Hi All,
>
> Over the last few months I've been working on & off with a few people from
> Linaro on a new EGL extension. The extension allows constructing an EGLImage
> from a (set of) dma_buf file descriptors, including support for multi-plane
> YUV. I envisage the primary use-case of this extension to be importing video
> frames from v4l2 into the EGL/GLES graphics driver to texture from.
> Originally the intent was to develop this as a Khronos-ratified extension.
> However, this is a little too platform-specific to be an officially
> sanctioned Khronos extension. It also goes against the general "EGLStream"
> direction the EGL working group is going in. As such, the general feeling
> was to make this an EXT "multi-vendor" extension with no official stamp of
> approval from Khronos. As this is no-longer intended to be a Khronos
> extension, I've re-written it to be a lot more Linux & dma_buf specific. It
> also allows me to circulate the extension more widely (I.e. To those outside
> Khronos membership).
>
> ARM are implementing this extension for at least our Mali-T6xx driver and
> likely earlier drivers too. I am sending this e-mail to solicit feedback,
> both from other vendors who might implement this extension (Mesa3D?) and
> from potential users of the extension. However, any feedback is welcome.
> Please find the extension text as it currently stands below. There several
> open issues which I've proposed solutions for, but I'm not really happy with
> those proposals and hoped others could chip-in with better ideas. There are
> likely other issues I've not thought about which also need to be added and
> addressed.
>
> Once there's a general consensus or if no-one's interested, I'll update the
> spec, move it out of Draft status and get it added to the Khronos registry,
> which includes assigning values for the new symbols.
>
>
> Cheers,
>
> Tom
>
>
> ---------8<---------
>
>
> Name
>
>     EXT_image_dma_buf_import
>
> Name Strings
>
>     EGL_EXT_image_dma_buf_import
>
> Contributors
>
>     Jesse Barker
>     Rob Clark
>     Tom Cooksey
>
> Contacts
>
>     Jesse Barker (jesse 'dot' barker 'at' linaro 'dot' org)
>     Tom Cooksey (tom 'dot' cooksey 'at' arm 'dot' com)
>
> Status
>
>     DRAFT
>
> Version
>
>     Version 3, August 16, 2012
>
> Number
>
>     EGL Extension ???
>
> Dependencies
>
>     EGL 1.2 is required.
>
>     EGL_KHR_image_base is required.
>
>     The EGL implementation must be running on a Linux kernel supporting the
>     dma_buf buffer sharing mechanism.
>
>     This extension is written against the wording of the EGL 1.2
> Specification.
>
> Overview
>
>     This extension allows creating an EGLImage from a Linux dma_buf file
>     descriptor or multiple file descriptors in the case of multi-plane YUV
>     images.
>
> New Types
>
>     None
>
> New Procedures and Functions
>
>     None
>
> New Tokens
>
>     Accepted by the <target> parameter of eglCreateImageKHR:
>
>         EGL_LINUX_DMA_BUF_EXT
>
>     Accepted as an attribute in the <attrib_list> parameter of
>     eglCreateImageKHR:
>
>         EGL_LINUX_DRM_FOURCC_EXT
>         EGL_DMA_BUF_PLANE0_FD_EXT
>         EGL_DMA_BUF_PLANE0_OFFSET_EXT
>         EGL_DMA_BUF_PLANE0_PITCH_EXT
>         EGL_DMA_BUF_PLANE1_FD_EXT
>         EGL_DMA_BUF_PLANE1_OFFSET_EXT
>         EGL_DMA_BUF_PLANE1_PITCH_EXT
>         EGL_DMA_BUF_PLANE2_FD_EXT
>         EGL_DMA_BUF_PLANE2_OFFSET_EXT
>         EGL_DMA_BUF_PLANE2_PITCH_EXT
You might want to add PLANE3 just in case someone wants to import a AYUV image.
> Additions to Chapter 2 of the EGL 1.2 Specification (EGL Operation)
>
>     Add to section 2.5.1 "EGLImage Specification" (as defined by the
>     EGL_KHR_image_base specification), in the description of
>     eglCreateImageKHR:
>
>    "Values accepted for <target> are listed in Table aaa, below.
>
>  
> +-------------------------+--------------------------------------------+
>       |  <target>               |  Notes
> |
>  
> +-------------------------+--------------------------------------------+
>       |  EGL_LINUX_DMA_BUF_EXT  |   Used for EGLImages imported from Linux
> |
>       |                         |   dma_buf file descriptors
> |
>  
> +-------------------------+--------------------------------------------+
>        Table aaa.  Legal values for eglCreateImageKHR <target> parameter
>
>     ...
>
>     If <target> is EGL_LINUX_DMA_BUF_EXT, <dpy> must be a valid display,
> <ctx>
>     must be EGL_NO_CONTEXT, and <buffer> must be NULL, cast into the type
>     EGLClientBuffer. The details of the image is specified by the attributes
>     passed into eglCreateImageKHR. Required attributes and their values are
> as
>     follows:
>
>         * EGL_WIDTH & EGL_HEIGHT: The logical dimensions of the buffer in
> pixels
>
>         * EGL_LINUX_DRM_FOURCC_EXT: The pixel format of the buffer, as
> specified
>           by drm_fourcc.h and used as the pixel_format parameter of the
>           drm_mode_fb_cmd2 ioctl.
>
>         * EGL_DMA_BUF_PLANE0_FD_EXT: The dma_buf file descriptor of plane 0
> of
>           the image.
>
>         * EGL_DMA_BUF_PLANE0_OFFSET_EXT: The offset from the start of the
>           dma_buf of the first sample in plane 0, in bytes.
>  
>         * EGL_DMA_BUF_PLANE0_PITCH_EXT: The number of bytes between the
> start of
>           subsequent rows of samples in plane 0. May have special meaning
> for
>           non-linear formats.
>
>     For images in an RGB color-space or those using a single-plane YUV
> format,
>     only the first plane's file descriptor, offset & pitch should be
> specified.
>     For semi-planar YUV formats, the chroma samples are stored in plane 1
> and
>     for fully planar formats, U-samples are stored in plane 1 and V-samples
> are
>     stored in plane 2. Planes 1 & 2 are specified by the following
> attributes,
>     which have the same meanings as defined above for plane 0:
>
Nitpick, Y'CbCr not YUV.

How do you want to deal with the case where Y' and CbCr are different hardware buffers?
Could some support for 2d arrays be added in case Y' and CbCr are separated into top/bottom fields?
How are semi-planar/planar formats handled that have a different width/height for Y' and CbCr? (YUV420)

~Maarten

