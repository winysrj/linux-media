Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759234AbcAULA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 06:00:29 -0500
Subject: Re: [PATCH v4l-utils] libv4lconvert: only expose jpeg_mem_*()
 protoypes when JPEG_LIB_VERSION < 80
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-media@vger.kernel.org
References: <1453369987-12428-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <56A0BA46.5020106@redhat.com>
Date: Thu, 21 Jan 2016 12:00:22 +0100
MIME-Version: 1.0
In-Reply-To: <1453369987-12428-1-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21-01-16 10:53, Thomas Petazzoni wrote:
> The jpeg_memsrcdest.c file implements jpeg_mem_src() and
> jpeg_mem_dest() when JPEG_LIB_VERSION < 80 in order to provide those
> functions to libv4lconvert when the libjpeg library being used is too
> old.
>
> However, the jpeg_memsrcdest.h file exposes the prototypes of those
> functions unconditionally. Until now, the prototype was matching the
> one of the functions exposed by libjpeg (when JPEG_LIB_VERSION >= 80),
> so there was no problem.
>
> But since the release of libjpeg 9b (in January 2016), they changed
> the second argument of jpeg_mem_src() from "unsigned char *" to "const
> unsigned char*". Therefore, there are two prototypes for the
> jpeg_mem_src() function: one from libjpeg, one from libv4l, and they
> conflict with each other.
>
> To resolve this situation, this patch modifies jpeg_memsrcdest.h to
> only expose the prototypes when libv4l is implementing the functions
> (i.e when JPEG_LIB_VERSION < 80). When JPEG_LIB_VERSION >= 80, the
> prototypes will come from <jpeglib.h>.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thanks, applied and pushed,

Regards,

Hans


> ---
>   lib/libv4lconvert/jpeg_memsrcdest.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/lib/libv4lconvert/jpeg_memsrcdest.h b/lib/libv4lconvert/jpeg_memsrcdest.h
> index e971182..28a6477 100644
> --- a/lib/libv4lconvert/jpeg_memsrcdest.h
> +++ b/lib/libv4lconvert/jpeg_memsrcdest.h
> @@ -1,5 +1,7 @@
>   #include <jpeglib.h>
>
> +#if JPEG_LIB_VERSION < 80
> +
>   void
>   jpeg_mem_src (j_decompress_ptr cinfo, unsigned char * buffer,
>   	unsigned long bufsize);
> @@ -7,3 +9,5 @@ jpeg_mem_src (j_decompress_ptr cinfo, unsigned char * buffer,
>   void
>   jpeg_mem_dest (j_compress_ptr cinfo, unsigned char ** outbuffer,
>   	unsigned long * outsize);
> +
> +#endif
>
