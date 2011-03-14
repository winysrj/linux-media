Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:21303 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1CNHyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 03:54:18 -0400
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LI1007EOF9LHL50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 16:53:45 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LI100DCFF9H6H@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 16:53:45 +0900 (KST)
Date: Mon, 14 Mar 2011 08:53:39 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [git:v4l-dvb/for_v2.6.39] [media] v4l: Documentation for the
 NV12MT format
In-reply-to: <E1Py9XV-0005wZ-Eb@www.linuxtv.org>
To: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>
Message-id: <002201cbe21c$f1436a80$d3ca3f80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <E1Py9XV-0005wZ-Eb@www.linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

I have noticed that two files from this commit are missing.
These are two images: nv12mt.gif and nv12mt_example.gif.

This is the original commit:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/3e087ac2834b9
0c876fc1dbdb9e7d0b2c475d43c

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: 11 March 2011 21:54
> To: linuxtv-commits@linuxtv.org
> Cc: Kamil Debski; Kyungmin Park
> Subject: [git:v4l-dvb/for_v2.6.39] [media] v4l: Documentation for the
> NV12MT format
> 
> This is an automatic generated email to let you know that the following
> patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] v4l: Documentation for the NV12MT format
> Author:  Kamil Debski <k.debski@samsung.com>
> Date:    Fri Mar 11 06:16:22 2011 -0300
> 
> Added documentation for V4L2_PIX_FMT_NV12MT format. This is a YUV 4:2:0
> format with macro block size of 64x32 and specific order of macro
> blocks
> in the memory.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  Documentation/DocBook/media-entities.tmpl   |    1 +
>  Documentation/DocBook/v4l/pixfmt-nv12mt.xml |   74
> +++++++++++++++++++++++++++
>  Documentation/DocBook/v4l/pixfmt.xml        |    1 +
>  3 files changed, 76 insertions(+), 0 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=a023f131f386cb56de
> 8083d8de9deb2c6d010cdf
> 
> diff --git a/Documentation/DocBook/media-entities.tmpl
> b/Documentation/DocBook/media-entities.tmpl
> index 40158ee..5d259c6 100644
> --- a/Documentation/DocBook/media-entities.tmpl
> +++ b/Documentation/DocBook/media-entities.tmpl
> @@ -272,6 +272,7 @@
>  <!ENTITY sub-grey SYSTEM "v4l/pixfmt-grey.xml">
>  <!ENTITY sub-nv12 SYSTEM "v4l/pixfmt-nv12.xml">
>  <!ENTITY sub-nv12m SYSTEM "v4l/pixfmt-nv12m.xml">
> +<!ENTITY sub-nv12mt SYSTEM "v4l/pixfmt-nv12mt.xml">
>  <!ENTITY sub-nv16 SYSTEM "v4l/pixfmt-nv16.xml">
>  <!ENTITY sub-packed-rgb SYSTEM "v4l/pixfmt-packed-rgb.xml">
>  <!ENTITY sub-packed-yuv SYSTEM "v4l/pixfmt-packed-yuv.xml">
> diff --git a/Documentation/DocBook/v4l/pixfmt-nv12mt.xml
> b/Documentation/DocBook/v4l/pixfmt-nv12mt.xml
> new file mode 100644
> index 0000000..5cb5bec
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/pixfmt-nv12mt.xml
> @@ -0,0 +1,74 @@
> +    <refentry>
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_NV12MT ('TM12')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname id="V4L2-PIX-FMT-NV12MT"><constant>V4L2_PIX_FMT_NV12MT
> +</constant></refname>
> +	<refpurpose>Formats with &frac12; horizontal and vertical
> +chroma resolution. This format has two planes - one for luminance and
> one for
> +chrominance. Chroma samples are interleaved. The difference to
> +<constant>V4L2_PIX_FMT_NV12</constant> is the memory layout. Pixels
> are
> +grouped in macroblocks of 64x32 size. The order of macroblocks in
> memory is
> +also not standard.
> +	</refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>This is the two-plane versions of the YUV 4:2:0 format
> where data
> +is grouped into 64x32 macroblocks. The three components are separated
> into two
> +sub-images or planes. The Y plane has one byte per pixel and pixels
> are grouped
> +into 64x32 macroblocks. The CbCr plane has the same width, in bytes,
> as the Y
> +plane (and the image), but is half as tall in pixels. The chroma plane
> is also
> +grouped into 64x32 macroblocks.</para>
> +	<para>Width of the buffer has to be aligned to the multiple of
> 128, and
> +height alignment is 32. Every four adjactent buffers - two
> horizontally and two
> +vertically are grouped together and are located in memory in Z or
> flipped Z
> +order. </para>
> +	<para>Layout of macroblocks in memory is presented in the
> following
> +figure.</para>
> +	<para><figure id="nv12mt">
> +	    <title><constant>V4L2_PIX_FMT_NV12MT</constant> macroblock Z
> shape
> +memory layout</title>
> +	    <mediaobject>
> +	      <imageobject>
> +		<imagedata fileref="nv12mt.gif" format="GIF" />
> +	      </imageobject>
> +	    </mediaobject>
> +	</figure>
> +	The requirement that width is multiple of 128 is implemented
> because,
> +the Z shape cannot be cut in half horizontally. In case the vertical
> resolution
> +of macroblocks is odd then the last row of macroblocks is arranged in
> a linear
> +order.  </para>
> +	<para>In case of chroma the layout is identical. Cb and Cr
> samples are
> +interleaved. Height of the buffer is aligned to 32.
> +	</para>
> +	<example>
> +	  <title>Memory layout of macroblocks in
> <constant>V4L2_PIX_FMT_NV12
> +</constant> format pixel image - extreme case</title>
> +	<para>
> +	<figure id="nv12mt">
> +	    <title>Example <constant>V4L2_PIX_FMT_NV12MT</constant>
> memory
> +layout of macroblocks</title>
> +	    <mediaobject>
> +	      <imageobject>
> +		<imagedata fileref="nv12mt_example.gif" format="GIF" />
> +	      </imageobject>
> +	    </mediaobject>
> +	</figure>
> +	Memory layout of macroblocks of <constant>V4L2_PIX_FMT_NV12MT
> +</constant> format in most extreme case.
> +	</para>
> +	</example>
> +      </refsect1>
> +    </refentry>
> +
> +  <!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "pixfmt.sgml"
> +indent-tabs-mode: nil
> +End:
> +  -->
> diff --git a/Documentation/DocBook/v4l/pixfmt.xml
> b/Documentation/DocBook/v4l/pixfmt.xml
> index f8436dc..c6fdcbb 100644
> --- a/Documentation/DocBook/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/v4l/pixfmt.xml
> @@ -709,6 +709,7 @@ information.</para>
>      &sub-yuv411p;
>      &sub-nv12;
>      &sub-nv12m;
> +    &sub-nv12mt;
>      &sub-nv16;
>    </section>
> 

