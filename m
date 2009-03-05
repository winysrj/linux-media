Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCESfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:35:04 -0500
Date: Thu, 5 Mar 2009 15:34:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] firedtv: fix printk format mismatch
Message-ID: <20090305153430.40e86905@pedra.chehab.org>
In-Reply-To: <tkrat.89b6c7e0ebef51fe@s5r6.in-berlin.de>
References: <tkrat.89b6c7e0ebef51fe@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009 19:13:43 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Eliminate
> drivers/media/dvb/firewire/firedtv-avc.c: In function 'debug_fcp':
> drivers/media/dvb/firewire/firedtv-avc.c:156: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> 
> Mauro, if you don't mind I queue it up in linux1394-2.6.git for after
> 2.6.29, before 2.6.30-rc1.  There may be firewire subsystem related
> changes of firedtv coming together until then.

Seems fine for me.

> 
>  drivers/media/dvb/firewire/firedtv-avc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/media/dvb/firewire/firedtv-avc.c
> ===================================================================
> --- linux.orig/drivers/media/dvb/firewire/firedtv-avc.c
> +++ linux/drivers/media/dvb/firewire/firedtv-avc.c
> @@ -115,7 +115,7 @@ static const char *debug_fcp_ctype(unsig
>  }
>  
>  static const char *debug_fcp_opcode(unsigned int opcode,
> -				    const u8 *data, size_t length)
> +				    const u8 *data, int length)
>  {
>  	switch (opcode) {
>  	case AVC_OPCODE_VENDOR:			break;
> @@ -141,7 +141,7 @@ static const char *debug_fcp_opcode(unsi
>  	return "Vendor";
>  }
>  
> -static void debug_fcp(const u8 *data, size_t length)
> +static void debug_fcp(const u8 *data, int length)
>  {
>  	unsigned int subunit_type, subunit_id, op;
>  	const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
> 




Cheers,
Mauro
