Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:42162 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbcGMNNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:13:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] drivers: misc: ti-st: Use int instead of fuzzy char for callback status
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1465203723-16928-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 13 Jul 2016 14:12:36 +0100
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pavan Savoy <pavan_savoy@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CE4AC59B-9138-4415-99AD-8C359ACFB5C7@holtmann.org>
References: <1465203723-16928-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

> On mips and parisc:
> 
>    drivers/bluetooth/btwilink.c: In function 'ti_st_open':
>    drivers/bluetooth/btwilink.c:174:21: warning: overflow in implicit constant conversion [-Woverflow]
>       hst->reg_status = -EINPROGRESS;
> 
>    drivers/nfc/nfcwilink.c: In function 'nfcwilink_open':
>    drivers/nfc/nfcwilink.c:396:31: warning: overflow in implicit constant conversion [-Woverflow]
>      drv->st_register_cb_status = -EINPROGRESS;
> 
> There are actually two issues:
>  1. Whether "char" is signed or unsigned depends on the architecture.
>     As the completion callback data is used to pass a (negative) error
>     code, it should always be signed.
>  2. EINPROGRESS is 150 on mips, 245 on parisc.
>     Hence -EINPROGRESS doesn't fit in a signed 8-bit number.
> 
> Change the callback status from "char" to "int" to fix these.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Compile-tested only.
> ---
> drivers/bluetooth/btwilink.c              | 4 ++--
> drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
> drivers/misc/ti-st/st_core.c              | 2 +-
> drivers/nfc/nfcwilink.c                   | 4 ++--
> include/linux/ti_wilink_st.h              | 2 +-
> 5 files changed, 7 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

