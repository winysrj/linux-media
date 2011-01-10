Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:57299 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1AJOAl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 09:00:41 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PcIIZ-0000Jk-3H
	for linux-media@vger.kernel.org; Mon, 10 Jan 2011 15:00:39 +0100
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 15:00:39 +0100
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 15:00:39 +0100
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 03/16] ngene: Firmware 18 support
Date: Mon, 10 Jan 2011 15:00:18 +0100
Message-ID: <8762twyi31.fsf@nemi.mork.no>
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de>
	<1294652184-12843-4-git-send-email-o.endriss@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Oliver Endriss <o.endriss@gmx.de> writes:

> +	case 18:
> +		size = 0;
> +		fw_name = "ngene_18.fw";
> +		break;
>  	}
>  
>  	if (request_firmware(&fw, fw_name, &dev->pci_dev->dev) < 0) {
> @@ -1266,6 +1270,8 @@ static int ngene_load_firm(struct ngene *dev)
>  			": Copy %s to your hotplug directory!\n", fw_name);
>  		return -1;
>  	}
> +	if (size == 0)
> +		size = fw->size;
>  	if (size != fw->size) {
>  		printk(KERN_ERR DEVICE_NAME
>  			": Firmware %s has invalid size!", fw_name);


Just a stupid question:  Why remove the size verification for version 18
while keeping it for the other firmware revisions?


Bjørn

