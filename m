Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab0JOUCr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 16:02:47 -0400
Date: Fri, 15 Oct 2010 16:02:12 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] IR: ene_ir: few bugfixes
Message-ID: <20101015200212.GK9658@redhat.com>
References: <1287158799-21486-1-git-send-email-maximlevitsky@gmail.com>
 <1287158799-21486-4-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287158799-21486-4-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 15, 2010 at 06:06:37PM +0200, Maxim Levitsky wrote:
> This is a result of last round of debug with
> Sami R <maesesami@gmail.com>.
> 
> Thank you Sami very much!
> 
> The biggest bug I fixed is that,
> I was clobbering the CIRCFG register after it is setup
> That wasn't a good idea really
> 
> And some small refactoring, etc.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ene_ir.c |   43 ++++++++++++++++++++-----------------------
>  1 files changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
> index dc32509..8639621 100644
> --- a/drivers/media/IR/ene_ir.c
> +++ b/drivers/media/IR/ene_ir.c
...
> @@ -282,6 +287,7 @@ static void ene_rx_setup(struct ene_device *dev)
>  		ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
>  
>  		/* Enable carrier detection */
> +		ene_write_reg(dev, ENE_CIRCAR_PULS, 0x63);

Looks sane, though I'd prefer to see symbolic bit names or some such thing
here instead of 0x63. Not something to hold up the patch though.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

