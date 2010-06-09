Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab0FIHte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jun 2010 03:49:34 -0400
Message-ID: <4C0F47FD.7020505@redhat.com>
Date: Wed, 09 Jun 2010 09:51:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Balint Reczey <balint@balintreczey.hu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4l1: support up to 256 different frame sizes
References: <1276018618-12162-1-git-send-email-balint@balintreczey.hu>
In-Reply-To: <1276018618-12162-1-git-send-email-balint@balintreczey.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch I've applied it to the v4l-utils tree.

Regards,

Hans


On 06/08/2010 07:36 PM, Balint Reczey wrote:
> Logitech, Inc. Webcam Pro 9000 supports 18 wich is more than the the originally
> supported 16. 256 should be enough for a while.
> ---
>   lib/libv4lconvert/libv4lconvert-priv.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index 6e880f8..b3e4c4e 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -29,7 +29,7 @@
>   #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
>
>   #define V4LCONVERT_ERROR_MSG_SIZE 256
> -#define V4LCONVERT_MAX_FRAMESIZES 16
> +#define V4LCONVERT_MAX_FRAMESIZES 256
>
>   #define V4LCONVERT_ERR(...) \
>   	snprintf(data->error_msg, V4LCONVERT_ERROR_MSG_SIZE, \
