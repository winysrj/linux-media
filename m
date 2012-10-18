Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59650 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2JRWDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 18:03:23 -0400
Date: Fri, 19 Oct 2012 00:03:13 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] winbond-cir: do not rename input name
Message-ID: <20121018220313.GB18904@hardeman.nu>
References: <1350488301-10767-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350488301-10767-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2012 at 04:38:21PM +0100, Sean Young wrote:
>"54fd321 [media] winbond: remove space from driver name" inadvertently
>renamed the input device name.
>
>Signed-off-by: Sean Young <sean@mess.org>
Acked-by: David Härdeman <david@hardeman.nu>

>---
> drivers/media/rc/winbond-cir.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
>index de48a79..ce3ffc5 100644
>--- a/drivers/media/rc/winbond-cir.c
>+++ b/drivers/media/rc/winbond-cir.c
>@@ -184,7 +184,7 @@ enum wbcir_txstate {
> };
> 
> /* Misc */
>-#define WBCIR_NAME	"winbond-cir"
>+#define WBCIR_NAME	"Winbond CIR"
> #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
> #define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
> #define INVALID_SCANCODE   0x7FFFFFFF /* Invalid with all protos	*/
>@@ -987,7 +987,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
> 	}
> 
> 	data->dev->driver_type = RC_DRIVER_IR_RAW;
>-	data->dev->driver_name = WBCIR_NAME;
>+	data->dev->driver_name = DRVNAME;
> 	data->dev->input_name = WBCIR_NAME;
> 	data->dev->input_phys = "wbcir/cir0";
> 	data->dev->input_id.bustype = BUS_HOST;
>-- 
>1.7.11.7
>

-- 
David Härdeman
