Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42630 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3HYMXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Aug 2013 08:23:23 -0400
Message-ID: <5219F736.2010706@gmail.com>
Date: Sun, 25 Aug 2013 14:23:18 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: sylvester.nawrocki@gmail.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera
 interface
References: <20130823094647.GO31293@elgon.mountain>
In-Reply-To: <20130823094647.GO31293@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2013 11:46 AM, Dan Carpenter wrote:
> [ Going through some old warnings... ]
>
> Hello Sylwester Nawrocki,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch babde1c243b2: "[media] V4L: Add driver for S3C24XX/S3C64XX
> SoC series camera interface" from Aug 22, 2012, leads to the
> following Smatch complaint:
>
> drivers/media/platform/s3c-camif/camif-capture.c:463 queue_setup()
> 	 warn: variable dereferenced before check 'fmt' (see line 460)
>
> drivers/media/platform/s3c-camif/camif-capture.c
>     455          if (pfmt) {
>     456                  pix =&pfmt->fmt.pix;
>     457                  fmt = s3c_camif_find_format(vp,&pix->pixelformat, -1);
>     458                  size = (pix->width * pix->height * fmt->depth) / 8;
>                                                             ^^^^^^^^^^
> Dereference.
>
>     459		} else {
>     460			size = (frame->f_width * frame->f_height * fmt->depth) / 8;
>                                                                     ^^^^^^^^^^
> Dereference.
>
>     461		}
>     462	
>     463		if (fmt == NULL)
>                      ^^^^^^^^^^^
> Check.

Thanks for the bug report. This check of course should be before line 455.
Would you like to sent a patch for this or should I handle that ?

--
Regards,
Sylwester


