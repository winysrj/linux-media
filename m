Return-path: <mchehab@gaivota>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:45900 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749Ab0KTGNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 01:13:23 -0500
Subject: Re: [PATCH 06/10] saa7134: make module parameters boolean
From: hermann pitton <hermann-pitton@arcor.de>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jarod@wilsonet.com,
	mchehab@infradead.org
In-Reply-To: <20101119234307.3511.53565.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
	 <20101119234307.3511.53565.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 20 Nov 2010 07:10:15 +0100
Message-Id: <1290233415.3174.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Am Samstag, den 20.11.2010, 00:43 +0100 schrieb David Härdeman:
> int to bool conversion for module parameters which are truely boolean.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/video/saa7134/saa7134-input.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
> index 8b80efb..aea74e2 100644
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -29,12 +29,12 @@
>  
>  #define MODULE_NAME "saa7134"
>  
> -static unsigned int disable_ir;
> -module_param(disable_ir, int, 0444);
> +static bool disable_ir;
> +module_param(disable_ir, bool, 0444);
>  MODULE_PARM_DESC(disable_ir,"disable infrared remote support");
>  
> -static unsigned int ir_debug;
> -module_param(ir_debug, int, 0644);
> +static bool ir_debug;
> +module_param(ir_debug, bool, 0644);
>  MODULE_PARM_DESC(ir_debug,"enable debug messages [IR]");
>  
>  static int pinnacle_remote;
> 

Hi,

not exactly that one, but given all the previous changes,

I wonder if there will ever be some "tested-by:" from someone ...

Cheers,
Hermann


