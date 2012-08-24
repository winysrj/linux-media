Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39827 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2HXWKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 18:10:46 -0400
Date: Sat, 25 Aug 2012 00:10:38 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: fix buffer overrun
Message-ID: <20120824221038.GB19354@hardeman.nu>
References: <1345756705-17576-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345756705-17576-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2012 at 10:18:25PM +0100, Sean Young wrote:
>"[media] rc-core: move timeout and checks to lirc" introduced a buffer
>overrun by passing the number of bytes, rather than the number of samples,
>to the transmit function.
>
>Signed-off-by: Sean Young <sean@mess.org>
Acked-by: David Härdeman <david@hardeman.nu>

Thanks for noticing

>---
> drivers/media/rc/ir-lirc-codec.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>index 6ad4a07..569124b 100644
>--- a/drivers/media/rc/ir-lirc-codec.c
>+++ b/drivers/media/rc/ir-lirc-codec.c
>@@ -140,7 +140,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
> 		goto out;
> 	}
> 
>-	ret = dev->tx_ir(dev, txbuf, (u32)n);
>+	ret = dev->tx_ir(dev, txbuf, count);
> 	if (ret < 0)
> 		goto out;
> 
>-- 
>1.7.11.4
>

-- 
David Härdeman
