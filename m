Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1HaTui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 15:50:38 -0400
Message-ID: <4E5E9089.8030804@redhat.com>
Date: Wed, 31 Aug 2011 16:50:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/21] [staging] tm6000: Remove artificial delay.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-8-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-8-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 04:14, Thierry Reding escreveu:
> ---
>  drivers/staging/tm6000/tm6000-core.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index e14bd3d..2c156dd 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -86,9 +86,6 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
>  	}
>  
>  	kfree(data);
> -
> -	msleep(5);
> -
>  	return ret;
>  }
>  

This delay is needed by some tm5600/6000 devices. Maybe it is due to
some specific chipset revision, but I can't remember anymore what
device(s) were affected.

The right thing to do seems to whitelist the devices that don't need
any delay there.

Thanks,
Mauro
