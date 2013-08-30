Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33954 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3H3JXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 05:23:36 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so1376079wes.33
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 02:23:35 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: usb: b2c2: Kconfig: add PCI dependancy to DVB_B2C2_FLEXCOP_USB
Date: Fri, 30 Aug 2013 11:23:33 +0200
Message-ID: <4349562.usGhpbsYS5@dibcom294>
In-Reply-To: <5220021C.2050700@asianux.com>
References: <5220021C.2050700@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi (sending again due to HTML-nonsense in Mail),

On Friday 30 August 2013 10:23:24 Chen Gang wrote:
> DVB_B2C2_FLEXCOP_USB need depend on PCI, or can not pass compiling with
> allmodconfig for h8300.
> 
> The related error:
> 
>   drivers/media/usb/b2c2/flexcop-usb.c: In function
> 'flexcop_usb_transfer_exit': drivers/media/usb/b2c2/flexcop-usb.c:393:3:
> error: implicit declaration of function 'pci_free_consistent'
> [-Werror=implicit-function-declaration] pci_free_consistent(NULL,
> 
> [..]
> 
>  config DVB_B2C2_FLEXCOP_USB
>  	tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
> -	depends on DVB_CORE && I2C
> +	depends on DVB_CORE && I2C && PCI
>  	help
>  	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by
> Technisat/B2C2,

Instead of selecting PCI we could/should use usb_alloc_coherent() and 
usb_free_cohrerent(), shouldn't we?

--
Patrick 
