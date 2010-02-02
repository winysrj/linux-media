Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab0BBKar (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 05:30:47 -0500
Message-ID: <4B67FEAF.8050603@redhat.com>
Date: Tue, 02 Feb 2010 11:30:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Luc Saillard <luc@saillard.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH ] libv4l: skip false Pixart markers
References: <4B67466F.1030301@freemail.hu> <4B6751F3.3040407@freemail.hu>
In-Reply-To: <4B6751F3.3040407@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/01/2010 11:13 PM, Németh Márton wrote:
> From: Márton Németh<nm127@freemail.hu>
>
> The byte sequence 0xff, 0xff, 0xff 0xff is not a real marker to skip, instead
> it is one byte from the image and the following three 0xff bytes might belong
> to a real marker. Modify pixart_fill_nbits() macro to pass the first 0xff byte
> as an image data.
>

Oh, good catch. I'm still seeing the occasional bad frame though :(

While on the subject of the pac7302. I've been playing around a bit, and I have the
feeling that if we were to go for a lower auto gain target (set autogain off and
lower exposure, you can do this ie with v4l2ucp), combined with a gamma correction of
1500 (again use ie v4l2ucp), the images is much better (less over exposed, more
contrast).

Do you agree ?

Regards,

Hans


> Signed-off-by: Márton Németh<nm127@freemail.hu>
> ---
> diff -r f23c5a878fb1 v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c
> --- a/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 13:32:46 2010 +0100
> +++ b/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 23:05:39 2010 +0100
> @@ -339,10 +339,15 @@
>   	    } \
>   	    break; \
>   	  case 0xff: \
> -	    if (stream[1] == 0xff&&  (stream[2]<  7 || stream[2] == 0xff)) { \
> -	      stream += 3; \
> -	      c = *stream++; \
> -	      break; \
> +	    if (stream[1] == 0xff) { \
> +		if (stream[2]<  7) { \
> +		    stream += 3; \
> +		    c = *stream++; \
> +		    break; \
> +		} else if (stream[2] == 0xff) { \
> +		    /* four 0xff in a row: the first belongs to the image data */ \
> +		    break; \
> +		}\
>   	    } \
>   	    /* Error fall through */ \
>   	  default: \
