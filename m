Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:50680 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1GDLso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 07:48:44 -0400
Date: Mon, 04 Jul 2011 13:48:39 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Oliver Endriss <o.endriss@gmx.de>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 15/16] ngene: Update for latest cxd2099
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Mime-Version: 1.0
Message-ID: <867PgDLvn1088S01.1309780119@web01.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Oliver Endriss <o.endriss@gmx.de>

> Modifications for latest cxd2099.
> 
> Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
> ---
>  drivers/media/dvb/ngene/ngene-core.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/ngene/ngene-core.c
b/drivers/media/dvb/ngene/ngene-core.c
> index fa4b3eb..df0f0bd 100644
> --- a/drivers/media/dvb/ngene/ngene-core.c
> +++ b/drivers/media/dvb/ngene/ngene-core.c
> @@ -1582,11 +1582,18 @@ static int init_channels(struct ngene *dev)
>  	return 0;
>  }
>  
> +static struct cxd2099_cfg cxd_cfg = {
> +	.bitrate = 62000,


bitrate's never used anywhere (yet ?), why keeping it ?

