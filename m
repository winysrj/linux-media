Return-path: <linux-media-owner@vger.kernel.org>
Received: from er-systems.de ([46.4.18.139]:43546 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbaIVVol (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 17:44:41 -0400
Date: Mon, 22 Sep 2014 23:44:35 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7146: generate device name early
In-Reply-To: <1411421261-9076-1-git-send-email-daniel-gl@gmx.net>
Message-ID: <alpine.LNX.2.00.1409222342590.8517@er-systems.de>
References: <alpine.LNX.2.00.1409222115570.2699@er-systems.de> <1411421261-9076-1-git-send-email-daniel-gl@gmx.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="70159122-726014229-1411422276=:8517"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--70159122-726014229-1411422276=:8517
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 22 Sep 2014, Daniel Glöckner wrote:

> It is needed when requesting the irq.
>
> Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
> ---
> drivers/media/common/saa7146/saa7146_core.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
> index 97afee6..4418119 100644
> --- a/drivers/media/common/saa7146/saa7146_core.c
> +++ b/drivers/media/common/saa7146/saa7146_core.c
> @@ -364,6 +364,9 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
> 		goto out;
> 	}
>
> +	/* create a nice device name */
> +	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
> +
> 	DEB_EE("pci:%p\n", pci);
>
> 	err = pci_enable_device(pci);
> @@ -438,9 +441,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
>
> 	/* the rest + print status message */
>
> -	/* create a nice device name */
> -	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
> -
> 	pr_info("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x)\n",
> 		dev->mem, dev->revision, pci->irq,
> 		pci->subsystem_vendor, pci->subsystem_device);
>


No warning anymore, this fixes it for me.

Thank you,

Thomas

--70159122-726014229-1411422276=:8517--

