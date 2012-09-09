Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab2IIVUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:20:20 -0400
Message-ID: <504D085B.3050006@redhat.com>
Date: Sun, 09 Sep 2012 23:21:31 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] libv4lconvert: fix format of the error messages concerning
 jpeg frame size mismatch
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, applied (and will be pushed to the official repo soon).

On 09/09/2012 08:36 PM, Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>   lib/libv4lconvert/jpeg.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/libv4lconvert/jpeg.c b/lib/libv4lconvert/jpeg.c
> index e088a90..aa9cace 100644
> --- a/lib/libv4lconvert/jpeg.c
> +++ b/lib/libv4lconvert/jpeg.c
> @@ -56,7 +56,7 @@ int v4lconvert_decode_jpeg_tinyjpeg(struct v4lconvert_data *data,
>   	}
>
>   	if (header_width != width || header_height != height) {
> -		V4LCONVERT_ERR("unexpected width / height in JPEG header"
> +		V4LCONVERT_ERR("unexpected width / height in JPEG header: "
>   			       "expected: %ux%u, header: %ux%u\n",
>   			       width, height, header_width, header_height);
>   		errno = EIO;
> @@ -288,7 +288,7 @@ int v4lconvert_decode_jpeg_libjpeg(struct v4lconvert_data *data,
>
>   	if (data->cinfo.image_width  != width ||
>   	    data->cinfo.image_height != height) {
> -		V4LCONVERT_ERR("unexpected width / height in JPEG header"
> +		V4LCONVERT_ERR("unexpected width / height in JPEG header: "
>   			       "expected: %ux%u, header: %ux%u\n", width,
>   			       height, data->cinfo.image_width,
>   			       data->cinfo.image_height);
>
