Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1DKUoV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 16:44:21 -0400
Message-ID: <4DA3681E.7080700@redhat.com>
Date: Mon, 11 Apr 2011 22:44:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4lconvert-priv.h: indent with tabs, not spaces
References: <1302191845-7506-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1302191845-7506-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks, applied.

On 04/07/2011 05:57 PM, Antonio Ospite wrote:
> Indent wrapped lines with tabs, just like it is done for the other
> functions in the same file.
>
> Signed-off-by: Antonio Ospite<ospite@studenti.unina.it>
> ---
>   lib/libv4lconvert/libv4lconvert-priv.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index 30d1cfe..84c706e 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -131,7 +131,7 @@ void v4lconvert_grey_to_rgb24(const unsigned char *src, unsigned char *dest,
>   		int width, int height);
>
>   void v4lconvert_grey_to_yuv420(const unsigned char *src, unsigned char *dest,
> -                const struct v4l2_format *src_fmt);
> +		const struct v4l2_format *src_fmt);
>
>   void v4lconvert_rgb565_to_rgb24(const unsigned char *src, unsigned char *dest,
>   		int width, int height);
