Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:6247 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbcGMLBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:01:00 -0400
Date: Wed, 13 Jul 2016 13:00:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pavan Savoy <pavan_savoy@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: misc: ti-st: Use int instead of fuzzy char for
 callback status
Message-ID: <20160713110045.GA10530@zurbaran.home>
References: <1465203723-16928-1-git-send-email-geert@linux-m68k.org>
 <20160713074114.76c35d04@recife.lan>
 <32897348-2AC5-4AB7-BF58-B1E36FC19CF2@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32897348-2AC5-4AB7-BF58-B1E36FC19CF2@holtmann.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marcel,

On Wed, Jul 13, 2016 at 11:56:02AM +0100, Marcel Holtmann wrote:
> Hi Mauro,
> 
> >> On mips and parisc:
> >> 
> >>    drivers/bluetooth/btwilink.c: In function 'ti_st_open':
> >>    drivers/bluetooth/btwilink.c:174:21: warning: overflow in implicit constant conversion [-Woverflow]
> >>       hst->reg_status = -EINPROGRESS;
> >> 
> >>    drivers/nfc/nfcwilink.c: In function 'nfcwilink_open':
> >>    drivers/nfc/nfcwilink.c:396:31: warning: overflow in implicit constant conversion [-Woverflow]
> >>      drv->st_register_cb_status = -EINPROGRESS;
> >> 
> >> There are actually two issues:
> >>  1. Whether "char" is signed or unsigned depends on the architecture.
> >>     As the completion callback data is used to pass a (negative) error
> >>     code, it should always be signed.
> >>  2. EINPROGRESS is 150 on mips, 245 on parisc.
> >>     Hence -EINPROGRESS doesn't fit in a signed 8-bit number.
> >> 
> >> Change the callback status from "char" to "int" to fix these.
> >> 
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Patch looks sane to me, but who will apply it?
> > 
> > Anyway:
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> I can take it through bluetooth-next if there is no objection.
> 
> Samuel, are you fine with that?
Yes, please go ahead.

Cheers,
Samuel.
