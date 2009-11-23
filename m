Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52882 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZKWQEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 11:04:16 -0500
Received: by yxe17 with SMTP id 17so4785223yxe.33
        for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 08:04:22 -0800 (PST)
Message-ID: <4B0AB281.4080802@gmail.com>
Date: Mon, 23 Nov 2009 14:04:17 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Luk=E1=9A_Karas?= <lukas.karas@centrum.cz>
CC: linux-media@vger.kernel.org, Petr Fiala <petr.fiala@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [PATCH] Multifrontend support for saa7134
References: <200910312121.21926.lukas.karas@centrum.cz>
In-Reply-To: <200910312121.21926.lukas.karas@centrum.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lukáš/Hermann,

Any news about this patch? I'll mark it as RFC at the patchwork, since it seems that this is not finished yet. Please let me know if you make some progress.

> @@ -1352,6 +1353,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		 .mpeg           = SAA7134_MPEG_DVB,
> +		 .num_frontends  = 1,
>  		 .inputs         = {{
>  			 .name = name_tv,
>  			 .vmux = 1,

Just one suggestion here: it is a way better to assume that an "uninitialized" value (e. g. num_frontends = 0) for num_frontends to mean that just one frontend exists. This saves space at the initialization segment
of the module and avoids the risk of someone forget to add num_frontends=0.

cheers,
Mauro.
