Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:52836 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0ATNAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 08:00:17 -0500
MIME-Version: 1.0
In-Reply-To: <4B5652A2.8060500@gmail.com>
References: <4B5652A2.8060500@gmail.com>
Date: Wed, 20 Jan 2010 08:00:16 -0500
Message-ID: <83bcf6341001200500h24cb3238rfee89297dae7f8f1@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Wrong command printed in cmd_to_str()
From: Steven Toth <stoth@kernellabs.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Roel.

Acked-By: Steven Toth <stoth@kernellabs.com>

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

On Tue, Jan 19, 2010 at 7:47 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The wrong command was printed for case CX2341X_ENC_SET_DNR_FILTER_MODE,
> and a typo in case CX2341X_ENC_SET_PCR_ID.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or is this intended?
>
> diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
> index 88c0d24..2ab97ad 100644
> --- a/drivers/media/video/cx23885/cx23885-417.c
> +++ b/drivers/media/video/cx23885/cx23885-417.c
> @@ -681,7 +681,7 @@ static char *cmd_to_str(int cmd)
>        case CX2341X_ENC_SET_VIDEO_ID:
>                return  "SET_VIDEO_ID";
>        case CX2341X_ENC_SET_PCR_ID:
> -               return  "SET_PCR_PID";
> +               return  "SET_PCR_ID";
>        case CX2341X_ENC_SET_FRAME_RATE:
>                return  "SET_FRAME_RATE";
>        case CX2341X_ENC_SET_FRAME_SIZE:
> @@ -693,7 +693,7 @@ static char *cmd_to_str(int cmd)
>        case CX2341X_ENC_SET_ASPECT_RATIO:
>                return  "SET_ASPECT_RATIO";
>        case CX2341X_ENC_SET_DNR_FILTER_MODE:
> -               return  "SET_DNR_FILTER_PROPS";
> +               return  "SET_DNR_FILTER_MODE";
>        case CX2341X_ENC_SET_DNR_FILTER_PROPS:
>                return  "SET_DNR_FILTER_PROPS";
>        case CX2341X_ENC_SET_CORING_LEVELS:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
