Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:39788 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752332AbcJXE5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 00:57:30 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: mchehab@kernel.org, stable@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        maintainers@bluecherrydvr.com, andrey_utkin@fastmail.com,
        ismael@iodev.co.uk, hverkuil@xs4all.nl, hans.verkuil@cisco.com
Subject: Re: [PATCH v2] media: solo6x10: fix lockup by avoiding delayed register write
References: <20161022153436.12076-1-andrey.utkin@corp.bluecherry.net>
Date: Mon, 24 Oct 2016 06:57:25 +0200
In-Reply-To: <20161022153436.12076-1-andrey.utkin@corp.bluecherry.net> (Andrey
        Utkin's message of "Sat, 22 Oct 2016 16:34:36 +0100")
Message-ID: <m3zilu4a4q.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -284,7 +284,10 @@ static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
>  static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
>  				  u32 data)
>  {
> +	u16 val;
> +
>  	writel(data, solo_dev->reg_base + reg);
> +	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
>  }
>  
>  static inline void solo_irq_on(struct solo_dev *dev, u32 mask)

This is ok for now. I hope I will find some to refine this, so not all
register writes are done with the penalty - eventually.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
