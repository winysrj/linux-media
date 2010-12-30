Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:9691 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab0L3Nws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:52:48 -0500
Subject: Re: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D1C8972.4050907@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
	 <20101230094509.2ecbf089@gaivota>
	 <1293712568.2056.25.camel@morgan.silverblock.net>
	 <4D1C8972.4050907@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 08:53:21 -0500
Message-ID: <1293717201.4084.29.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 2010-12-30 at 11:30 -0200, Mauro Carvalho Chehab wrote:
> Em 30-12-2010 10:36, Andy Walls escreveu:


> Thanks for the review. Version 3 of the patch enclosed.

Still one little mistake that matters, otherwise it looks good.
See below...

> commit 8576bd14361ec75c91ddfb49cc2df389143cf06a
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Thu Dec 30 09:31:10 2010 -0200
> 
>     [media] ivtv: Add Adaptec Remote Controller
>     

>  
>  /* This array should match the IVTV_HW_ defines */
> @@ -143,8 +145,34 @@ static const char * const hw_devicenames[] = {
>  	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
>  	"ir_tx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
>  	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
> +	"ir_adaptec",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
>  };
 
This either needs to be "ir_video", or you need to add "ir_adaptec" to
the i2c_device_id[] array in ir-kbd-i2c.c.  Otherwise ir-kbd-i2c.c won't
claim the device and use it.

Upon fixing that

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Andy Walls <awalls@md.metrocast.net>


Regards,
Andy

