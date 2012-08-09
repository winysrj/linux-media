Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab2HIL2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 07:28:08 -0400
Message-ID: <50239EE8.2060805@redhat.com>
Date: Thu, 09 Aug 2012 13:28:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] gspca: dubious one-bit signed bitfield
References: <1344170066-19727-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1344170066-19727-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, I've added it to my tree for 3.7:
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.7-wip

Regards,

Hans



On 08/05/2012 02:34 PM, Emil Goode wrote:
> This patch changes some signed integers to unsigned because
> they are not intended for negative values and sparse
> is making noise about it.
>
> Sparse gives eight of these errors:
> drivers/media/video/gspca/ov519.c:144:29: error: dubious one-bit signed bitfield
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>   drivers/media/video/gspca/ov519.c |   16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
> index bfc7cef..c1a21bf 100644
> --- a/drivers/media/video/gspca/ov519.c
> +++ b/drivers/media/video/gspca/ov519.c
> @@ -141,14 +141,14 @@ enum sensors {
>
>   /* table of the disabled controls */
>   struct ctrl_valid {
> -	int has_brightness:1;
> -	int has_contrast:1;
> -	int has_exposure:1;
> -	int has_autogain:1;
> -	int has_sat:1;
> -	int has_hvflip:1;
> -	int has_autobright:1;
> -	int has_freq:1;
> +	unsigned int has_brightness:1;
> +	unsigned int has_contrast:1;
> +	unsigned int has_exposure:1;
> +	unsigned int has_autogain:1;
> +	unsigned int has_sat:1;
> +	unsigned int has_hvflip:1;
> +	unsigned int has_autobright:1;
> +	unsigned int has_freq:1;
>   };
>
>   static const struct ctrl_valid valid_controls[] = {
>
