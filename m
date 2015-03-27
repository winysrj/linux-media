Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbbC0NnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 09:43:05 -0400
Message-ID: <55155E60.6080505@redhat.com>
Date: Fri, 27 Mar 2015 14:42:56 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4lconvert: Fix support for Y16 pixel format
References: <1427386654-31906-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1427386654-31906-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26-03-15 17:17, Ricardo Ribalda Delgado wrote:
> Y16 is a little-endian format. The original implementation assumed that
> it was big-endian.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Thanks merged upstream, both into master and stable-1.6 branches.

Regards,

Hans

> ---
>   lib/libv4lconvert/rgbyuv.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
> index 0f30192..75c42aa 100644
> --- a/lib/libv4lconvert/rgbyuv.c
> +++ b/lib/libv4lconvert/rgbyuv.c
> @@ -591,6 +591,9 @@ void v4lconvert_y16_to_rgb24(const unsigned char *src, unsigned char *dest,
>   		int width, int height)
>   {
>   	int j;
> +
> +	src++; /*Y16 is little endian*/
> +
>   	while (--height >= 0) {
>   		for (j = 0; j < width; j++) {
>   			*dest++ = *src;
> @@ -606,6 +609,8 @@ void v4lconvert_y16_to_yuv420(const unsigned char *src, unsigned char *dest,
>   {
>   	int x, y;
>
> +	src++; /*Y16 is little endian*/
> +
>   	/* Y */
>   	for (y = 0; y < src_fmt->fmt.pix.height; y++)
>   		for (x = 0; x < src_fmt->fmt.pix.width; x++){
>
