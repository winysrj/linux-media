Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:15243 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1AEMyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 07:54:07 -0500
Date: Wed, 5 Jan 2011 13:53:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/3] ir-kbd-i2c: Add HD PVR IR Rx support to ir-kbd-i2c
Message-ID: <20110105135319.610b65bc@endymion.delvare>
In-Reply-To: <1293587266.3098.14.camel@localhost>
References: <1293587067.3098.10.camel@localhost>
	<1293587266.3098.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 28 Dec 2010 20:47:46 -0500, Andy Walls wrote:
> 
> Add HD PVR IR Rx support to ir-kbd-i2c
> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> 
> ---
>  drivers/media/video/ir-kbd-i2c.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index dd54c3d..c87b6bc 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -449,6 +449,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
>  	{ "ir_video", 0 },
>  	/* IR device specific entries should be added here */
>  	{ "ir_rx_z8f0811_haup", 0 },
> +	{ "ir_rx_z8f0811_hdpvr", 0 },
>  	{ }
>  };
>  

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
