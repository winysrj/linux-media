Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33342 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab1JOQiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 12:38:12 -0400
Subject: Re: [git:v4l-dvb/for_v3.2] [media] cx25840: enable raw cc
 processing only for the cx23885 hardware
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org, Steven Toth <stoth@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 15 Oct 2011 12:39:55 -0400
In-Reply-To: <E1REoKG-0005xF-GE@www.linuxtv.org>
References: <E1REoKG-0005xF-GE@www.linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1318696796.3274.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-10-14 at 22:10 +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:

Ummm...

> Subject: [media] cx25840: enable raw cc processing only for the cx23885 hardware
                                                                  ^^^^^^^^^^^^^^^^   

> diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> index b7ee2ae..8896999 100644
> --- a/drivers/media/video/cx25840/cx25840-core.c
> +++ b/drivers/media/video/cx25840/cx25840-core.c
> @@ -702,6 +702,13 @@ static void cx231xx_initialize(struct i2c_client *client)
                                   ^^^^^^^^^^^^^^^^^^

Is this what was intended?

>  	/* start microcontroller */
>  	cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +
> +	/* CC raw enable */
> +	cx25840_write(client, 0x404, 0x0b);
> +
> +	/* CC on */
> +	cx25840_write(client, 0x42f, 0x66);
> +	cx25840_write4(client, 0x474, 0x1e1e601a);
>  }


Regards,
Andy

