Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2887 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2JVORf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 10:17:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH 1/2] [media] vivi: Kill BUFFER_TIMEOUT macro
Date: Mon, 22 Oct 2012 16:16:54 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
In-Reply-To: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221616.54270.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 22 2012 15:54:43 Kirill Smelkov wrote:
> Usage of BUFFER_TIMEOUT has gone in 2008 in 78718e5d (V4L/DVB (7492):
> vivi: Simplify the vivi driver and avoid deadlocks), but the macro
> remains. Say goodbye to it.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/vivi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index b366b05..3e6902a 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -39,7 +39,6 @@
>  /* Wake up at about 30 fps */
>  #define WAKE_NUMERATOR 30
>  #define WAKE_DENOMINATOR 1001
> -#define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
>  
>  #define MAX_WIDTH 1920
>  #define MAX_HEIGHT 1200
> 
