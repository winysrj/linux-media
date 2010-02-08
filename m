Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab0BHCed (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 21:34:33 -0500
Message-ID: <4B6F7830.20905@redhat.com>
Date: Mon, 08 Feb 2010 00:34:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 1/12] tm6000: add Terratec Cinergy Hybrid XE
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index c4db903..7f594a2 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -44,6 +44,10 @@
>  #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
>  #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
>  #define TM6010_BOARD_HAUPPAUGE_900H		9
> +#define TM6010_BOARD_BEHOLD_WANDER		10
> +#define TM6010_BOARD_BEHOLD_VOYAGER		11
> +#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
> +

This patch is addins just Cinergy Hybrid XE. I'll commit it, by removing the entries for Behold
cards and renumbering the card to 10.



Cheers,
Mauro
