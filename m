Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:4081 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0ADW0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 17:26:06 -0500
Message-ID: <4B426A8F.2030808@toaster.net>
Date: Mon, 04 Jan 2010 14:24:15 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
References: <Pine.LNX.4.44L0.1001041538140.3180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001041538140.3180-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> ...
>
> All right.  Let's try this patch in place of all the others, then.
>
> Alan Stern
>
>
> Index: usb-2.6/drivers/usb/host/ohci-q.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ohci-q.c
> +++ usb-2.6/drivers/usb/host/ohci-q.c
> @@ -505,6 +505,7 @@ td_fill (struct ohci_hcd *ohci, u32 info
>  	struct urb_priv		*urb_priv = urb->hcpriv;
>  	int			is_iso = info & TD_ISO;
>  	int			hash;
> +	volatile struct td	* volatile td1, * volatile td2;
>  
>  	// ASSERT (index < urb_priv->length);
>  
> @@ -558,11 +559,30 @@ td_fill (struct ohci_hcd *ohci, u32 info
>  
>  	/* hash it for later reverse mapping */
>  	hash = TD_HASH_FUNC (td->td_dma);
> +
> +	td1 = ohci->td_hash[hash];
> +	td2 = NULL;
> +	if (td1) {
> +		td2 = td1->td_hash;
> +		if (td2 == td1 || td2 == td) {
> +			ohci_err(ohci, "Circular hash: %d %p %p %p\n",
> +					hash, td1, td2, td);
> +			td2 = td1->td_hash = NULL;
> +		}
> +	}
> +
>  	td->td_hash = ohci->td_hash [hash];
>  	ohci->td_hash [hash] = td;
>  
>  	/* HC might read the TD (or cachelines) right away ... */
>  	wmb ();
> +
> +	if (td1 && td1->td_hash != td2) {
> +		ohci_err(ohci, "Hash value changed: %d %p %p %p\n",
> +					hash, td1, td2, td);
> +		td1->td_hash = (struct td *) td2;
> +	}
> +
>  	td->ed->hwTailP = td->hwNextTD;
>  }
>  
>
>   
Alan,
This last patch seems to do the job. Thanks so much for your help! Where 
do I donate/send beer?

Sean
