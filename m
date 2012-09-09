Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab2IIVZf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:25:35 -0400
Message-ID: <504D0996.6010405@redhat.com>
Date: Sun, 09 Sep 2012 23:26:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] libv4lconvert: update the list of pac7302 webcams
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com> <1347215768-9843-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347215768-9843-3-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/09/2012 08:36 PM, Frank Schäfer wrote:
> All pac7302 webcams need image rotation, so synchronize the list with the driver.
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>   lib/libv4lconvert/control/libv4lcontrol.c |   13 ++++++++++++-
>   1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index 3d7a816..6eea121 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -202,10 +202,21 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
>   	{ 0x145f, 0x013a, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
>   	{ 0x2001, 0xf115, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
>   	/* Pac7302 based devices */
> -	{ 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },

The 0x0f here is a mask, so this one entry covers all device ids from
0x2620 - 0x262f, so...

>   	{ 0x06f8, 0x3009, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>   	{ 0x06f8, 0x301b, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2611, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2622, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2624, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2625, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2626, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2627, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2628, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x2629, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x262a, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x093a, 0x262c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },

The addition of all these is not necessary.

>   	{ 0x145f, 0x013c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
> +	{ 0x1ae7, 0x2001, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },

This one is necessary, I'll go and add it right away.

Regards,

Hans
