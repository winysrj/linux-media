Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63055 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1CXUbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:31:31 -0400
Received: by yxs7 with SMTP id 7so183697yxs.19
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 13:31:30 -0700 (PDT)
Date: Thu, 24 Mar 2011 23:31:08 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jarod Wilson <jarod@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] tm6000: fix vbuf may be used uninitialized
Message-ID: <20110324203108.GX2008@bicker>
References: <1300997220-4354-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300997220-4354-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 24, 2011 at 04:07:00PM -0400, Jarod Wilson wrote:
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Jarod, there is a lot of information missing from your change log...  :/

> CC: devel@driverdev.osuosl.org
> ---
>  drivers/staging/tm6000/tm6000-video.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index c80a316..bfebedd 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -228,7 +228,7 @@ static int copy_streams(u8 *data, unsigned long len,
>  	unsigned long header = 0;
>  	int rc = 0;
>  	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
> -	struct tm6000_buffer *vbuf;
> +	struct tm6000_buffer *vbuf = NULL;
>  	char *voutp = NULL;
>  	unsigned int linewidth;
>  

This looks like a real bug versus just a GCC warning.  It was introduced
in 8aff8ba95155df "[media] tm6000: add radio support to the driver".
I've added Dmitri to the CC list.

regards,
dan carpenter

