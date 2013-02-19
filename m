Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52799 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab3BSUqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 15:46:14 -0500
Date: Tue, 19 Feb 2013 21:36:01 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sean Young <sean@mess.org>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] mceusb: move check earlier to make smatch happy
Message-ID: <20130219203601.GB15909@hardeman.nu>
References: <20130212122208.GA19045@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130212122208.GA19045@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 12, 2013 at 03:22:08PM +0300, Dan Carpenter wrote:
>Smatch complains that "cmdbuf[cmdcount - length]" might go past the end
>of the array.  It's an easy warning to silence by moving the limit
>check earlier.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks ok. I'll leave the signing off to Jarod though. I've just dabbled
in the driver but I'm not the maintainer.

>diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
>index bdd1ed8..5b5b6e6 100644
>--- a/drivers/media/rc/mceusb.c
>+++ b/drivers/media/rc/mceusb.c
>@@ -828,16 +828,16 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
> 			 (txbuf[i] -= MCE_MAX_PULSE_LENGTH));
> 	}
> 
>-	/* Fix packet length in last header */
>-	length = cmdcount % MCE_CODE_LENGTH;
>-	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
>-
> 	/* Check if we have room for the empty packet at the end */
> 	if (cmdcount >= MCE_CMDBUF_SIZE) {
> 		ret = -EINVAL;
> 		goto out;
> 	}
> 
>+	/* Fix packet length in last header */
>+	length = cmdcount % MCE_CODE_LENGTH;
>+	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
>+
> 	/* All mce commands end with an empty packet (0x80) */
> 	cmdbuf[cmdcount++] = MCE_IRDATA_TRAILER;
> 
>

-- 
David Härdeman
