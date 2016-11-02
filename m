Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:6147 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752165AbcKBQdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 12:33:49 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 2 Nov 2016 17:33:44 +0100
Subject: Re: YUV444 contradicting wikipedia
Message-ID: <8225474f-68f3-5571-366b-df022c903c31@st.com>
References: <Pine.LNX.4.64.1610270806540.21294@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1610270806540.21294@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


"4:x:y" refers to chroma subsampling, details here: 
https://en.wikipedia.org/wiki/Chroma_subsampling. With "YUV 4:4:4" each 
pixel has 1 Luma information and 1 Chroma information: 1 Y + 1 Cb + 1 Cr 
= 24 bits per pixel.


In top of that, each of the three components (Y, Cb, Cr) can be stored 
in a single memory plane (packed format), just like usual RGB formats 
are. Or components can be stored in 2 (Y + Cb-Cr) or 3 (Y + Cb + Cr) 
memory planes.


The combination of the chroma subsampling and the number of planes, 
defines a pixel format. The problem is that each sub-system (DRM, V4L2, 
GStreamer, ...) uses its own constants with unfortunately unconsistent 
names across them.


Let's consider the YUV 4:4:4 with three planes format:

DRM =    DRM_FORMAT_YUV444

V4L2 =   V4L2_PIX_FMT_YUV444M

GStreamer = GST_VIDEO_FORMAT_Y444

As you can see, although all of them specify the same pixel format, the 
names are quite different.

And regarding V4L2_PIX_FMT_YUV444 (not ending with "M"), it defines 
another format with the following specifications:

- YUV packed

- 4:4:4 chroma sampling

- Alpha (when supported by driver)

- 4 (not 8) bits per component

Very different from the "standard" YUV 4:4:4 pixel format.

I agree that its name is confusing, but since it is part of the API, we 
shall consider that it won't be updated.

 From what I have seen, DRM (maybe because it is a relatively recent 
'framework') has a clear definition of the pixel formats.


Fabien


On 10/27/2016 08:16 AM, Guennadi Liakhovetski wrote:
> Hi,
>
> Looks like the Linux definition of the (packed) YUV444 format contradicts
> wikipedia. According to
> https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-packed-yuv.html
> The Linux V4L2_PIX_FMT_YUV444 format takes 16 bits per pixel, whereas the
> wikipedia
> https://en.wikipedia.org/wiki/YUV#Converting_between_Y.E2.80.B2UV_and_RGB
> says it's 24 bits per pixel. I understand that the wikipedia doesn't have
> an absolute authority, but I also saw other sources using the same
> definition. So, looks like some confusion is possible.
>
> Thanks
> Guennadi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
