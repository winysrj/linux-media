Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab1IWXeb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 19:34:31 -0400
Message-ID: <4E7D1782.30209@redhat.com>
Date: Fri, 23 Sep 2011 20:34:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH RESEND 1/4] davinci vpbe: remove unused macro.
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com> <1316410529-14744-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1316410529-14744-2-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-09-2011 02:35, Manjunath Hadli escreveu:
> remove VPBE_DISPLAY_SD_BUF_SIZE as it is no longer used.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  drivers/media/video/davinci/vpbe_display.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
> index ae7add1..09a659e 100644
> --- a/drivers/media/video/davinci/vpbe_display.c
> +++ b/drivers/media/video/davinci/vpbe_display.c
> @@ -43,7 +43,6 @@
>  
>  static int debug;
>  
> -#define VPBE_DISPLAY_SD_BUF_SIZE (720*576*2)
>  #define VPBE_DEFAULT_NUM_BUFS 3
>  
>  module_param(debug, int, 0644);

This is really trivial. I won't wait for your pull request to
merge this one ;)

Thanks,
Mauro
