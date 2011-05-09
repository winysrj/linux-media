Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:52800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1EISZf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 14:25:35 -0400
Message-ID: <4DC831A6.7090408@redhat.com>
Date: Mon, 09 May 2011 14:25:42 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: =?UTF-8?B?SnVhbiBKZXPDunMgR2FyY8OtYSBkZSBTb3JpYQ==?=
	<skandalfo@gmail.com>
Subject: Re: [PATCH] [media] ite-cir: make IR receive work after resume
References: <1304953686-21805-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1304953686-21805-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Jarod Wilson wrote:
> Just recently acquired an Asus Eee Box PC with an onboard IR receiver
> driven by ite-cir (ITE8713 sub-variant). Works out of the box with the
> ite-cir driver in 2.6.39, but stops working after a suspend/resume
> cycle. Its fixed by simply reinitializing registers after resume,
> similar to what's done in the nuvoton-cir driver. I've not tested with
> any other ITE variant, but code inspection suggests this should be safe
> on all variants.
>
> Reported-by: Stephan Raue<sraue@openelec.tv>
> CC: Juan Jesús García de Soria<skandalfo@gmail.com>
> Signed-off-by: Jarod Wilson<jarod@redhat.com>
> ---
>   drivers/media/rc/ite-cir.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 43908a7..8488e53 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -1684,6 +1684,8 @@ static int ite_resume(struct pnp_dev *pdev)
>   		/* wake up the transmitter */
>   		wake_up_interruptible(&dev->tx_queue);
>   	} else {
> +		/* reinitialize hardware config registers */
> +		itdev->params.init_hardware(itdev);
>   		/* enable the receiver */
>   		dev->params.enable_rx(dev);


Gah. I've obviously screwed this one up. Tested a locally built version 
of the module on the machine itself, then did a copy/paste of the 
init_hardware line from elsewhere in the driver where struct ite_dev was 
called itdev instead of just dev. v2 momentarily.

-- 
Jarod Wilson
jarod@redhat.com


