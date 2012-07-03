Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38563 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2GCU1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 16:27:04 -0400
Date: Tue, 3 Jul 2012 22:18:47 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Anton Blanchard <anton@samba.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] winbond-cir: Fix txandrx module info
Message-ID: <20120703201847.GA29839@hardeman.nu>
References: <20120702115800.1275f944@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120702115800.1275f944@kryten>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 02, 2012 at 11:58:00AM +1000, Anton Blanchard wrote:
>
>We aren't getting any module info for the txandx option because
>of a typo:
>
>parm:           txandrx:bool
>
>Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: David Härdeman <david@hardeman.nu>

>---
>
>Index: linux-2.6/drivers/media/rc/winbond-cir.c
>===================================================================
>--- linux-2.6.orig/drivers/media/rc/winbond-cir.c	2011-11-20 20:30:57.831906589 +1100
>+++ linux-2.6/drivers/media/rc/winbond-cir.c	2011-11-20 20:32:13.472362123 +1100
>@@ -232,7 +232,7 @@ MODULE_PARM_DESC(invert, "Invert the sig
> 
> static int txandrx; /* default = 0 */
> module_param(txandrx, bool, 0444);
>-MODULE_PARM_DESC(invert, "Allow simultaneous TX and RX");
>+MODULE_PARM_DESC(txandrx, "Allow simultaneous TX and RX");
> 
> static unsigned int wake_sc = 0x800F040C;
> module_param(wake_sc, uint, 0644);
>

