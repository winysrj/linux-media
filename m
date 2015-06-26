Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50148 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbbFZJWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 05:22:16 -0400
Date: Fri, 26 Jun 2015 06:22:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Unembossed Name" <severe.siberian.man@mail.ru>
Cc: <linux-media@vger.kernel.org>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
Subject: Re: XC5000C 0x14b4 status
Message-ID: <20150626062210.6ee035ec@recife.lan>
In-Reply-To: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Jun 2015 03:58:48 +0700
"Unembossed Name" <severe.siberian.man@mail.ru> escreveu:

> Hi,
> 
> I was working on a Linux driver for a hybrid TV-tuner with SAA7134 PCI bridge, XC5000C RF tuner and Si2168 DVB demodulator by a
> "combining" all existent at that time drivers together.
> During that work, I had an issue with XC5000C.
> Episodically, after attaching to DVB and reading XREG_PRODUCT_ID register, it
> was possible to receive 0x14b4 instead of usual 0x1388 status. And as a result get a "xc5000: Device not found at addr 0x%02x 
> (0x%x)\n" in dmesg.
> To workaround these, I added a few strings to a source of a driver to make it's behaviour the same for 0x14b4, as for 0x1388.
> After that RF tuner identification became always successful.
> I had a conversation with a hardware vendor.
> Now I can say, that such behaviour, most likely, because of  "early" firmware for XC5000C.
> This hardware vendor is using for his Windows driver a latest firmware, and reading Product ID register always gives 0x14b4 status.
> As he says, 0x1388 status is only for previous XC5000 IC. (Without C at end of a P/N)
> Is this possible to patch xc5000.c with something like this:
> 
>  #define XC_PRODUCT_ID_FW_LOADED 0x1388
> +#define XC_PRODUCT_ID_FW_LOADED_XC5000C 0x14b4
> 
>   case XC_PRODUCT_ID_FW_LOADED:
> + case XC_PRODUCT_ID_FW_LOADED_XC5000C:
>    printk(KERN_INFO
>     "xc5000: Successfully identified at address 0x%02x\n",
> 
> Or to try to get a chip vendor's permission for using a latest firmware for XC5000C in Linux, and then anyway, patch the driver?

IMHO, the best is to get the latest firmware licensed is the best
thing to do.

Does that "new" xc5000c come with a firmware pre-loaded already?

Regards,
Mauro
