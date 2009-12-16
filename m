Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:3802 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbZLPXcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 18:32:50 -0500
Message-ID: <4B296D84.7090603@toaster.net>
Date: Wed, 16 Dec 2009 15:30:12 -0800
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
References: <Pine.LNX.4.44L0.0912031601420.4795-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912031601420.4795-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, that patch definitely traps the bug. Unfortunately there are so 
many debug messages that the capture-example.c times out trying to 
connect to the webcam. The debug messages slow down the process enough 
to make that happen. But if I modify your patch and take out the extra 
debug messages, it works well. The modified patch is below.

Reproducing the bug in four separate instances I got:
ohci_hcd 0000:00:0a.0: poisoned hash at c67a285c 
ohci_hcd 0000:00:0a.0: poisoned hash at c67b875c
ohci_hcd 0000:00:0a.0: poisoned hash at c67a179c
ohci_hcd 0000:00:0a.0: poisoned hash at c679c79c

Sean Lazar

--- ohci-mem.c.orig    2009-12-16 22:57:49.000000000 +0000
+++ ohci-mem.c    2009-12-16 22:49:37.000000000 +0000
@@ -103,8 +103,13 @@
 {
     struct td    **prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
 
-    while (*prev && *prev != td)
+    while (*prev && *prev != td) {
+        if ((unsigned long) *prev == 0xa7a7a7a7) {
+            ohci_info(hc, "poisoned hash at %p\n", prev);
+            return;
+        }
         prev = &(*prev)->td_hash;
+    }
     if (*prev)
         *prev = td->td_hash;
     else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
 

Alan Stern wrote:
> On Wed, 2 Dec 2009, Sean wrote:
>
>   
>> Is there anything I can do to help? This is a show stopping bug for me.
>>     
>
> Here's a patch you can try.  It will add a _lot_ of debugging
> information to the system log.  Maybe it will help pin down the source
> of the problem.
>
> Alan Stern
>
>
>
> Index: 2.6.31/drivers/usb/host/ohci-hcd.c
> ===================================================================
> --- 2.6.31.orig/drivers/usb/host/ohci-hcd.c
> +++ 2.6.31/drivers/usb/host/ohci-hcd.c
> @@ -197,7 +197,7 @@ static int ohci_urb_enqueue (
>  
>  	/* allocate the TDs (deferring hash chain updates) */
>  	for (i = 0; i < size; i++) {
> -		urb_priv->td [i] = td_alloc (ohci, mem_flags);
> +		urb_priv->td [i] = td_alloc (ohci, mem_flags, urb->dev, urb->ep);
>  		if (!urb_priv->td [i]) {
>  			urb_priv->length = i;
>  			urb_free_priv (ohci, urb_priv);
> Index: 2.6.31/drivers/usb/host/ohci-mem.c
> ===================================================================
> --- 2.6.31.orig/drivers/usb/host/ohci-mem.c
> +++ 2.6.31/drivers/usb/host/ohci-mem.c
> @@ -82,7 +82,8 @@ dma_to_td (struct ohci_hcd *hc, dma_addr
>  
>  /* TDs ... */
>  static struct td *
> -td_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
> +td_alloc (struct ohci_hcd *hc, gfp_t mem_flags, struct usb_device *udev,
> +	struct usb_host_endpoint *ep)
>  {
>  	dma_addr_t	dma;
>  	struct td	*td;
> @@ -94,6 +95,8 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem
>  		td->hwNextTD = cpu_to_hc32 (hc, dma);
>  		td->td_dma = dma;
>  		/* hashed in td_fill */
> +		ohci_info(hc, "td alloc for %s ep%x: %p\n",
> +			udev->devpath, ep->desc.bEndpointAddress, td);
>  	}
>  	return td;
>  }
> @@ -103,8 +106,14 @@ td_free (struct ohci_hcd *hc, struct td 
>  {
>  	struct td	**prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
>  
> -	while (*prev && *prev != td)
> +	ohci_info(hc, "td free %p\n", td);
> +	while (*prev && *prev != td) {
> +		if ((unsigned long) *prev == 0xa7a7a7a7) {
> +			ohci_info(hc, "poisoned hash at %p\n", prev);
> +			return;
> +		}
>  		prev = &(*prev)->td_hash;
> +	}
>  	if (*prev)
>  		*prev = td->td_hash;
>  	else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
> Index: 2.6.31/drivers/usb/host/ohci-q.c
> ===================================================================
> --- 2.6.31.orig/drivers/usb/host/ohci-q.c
> +++ 2.6.31/drivers/usb/host/ohci-q.c
> @@ -403,7 +403,7 @@ static struct ed *ed_get (
>  		}
>  
>  		/* dummy td; end of td list for ed */
> -		td = td_alloc (ohci, GFP_ATOMIC);
> +		td = td_alloc (ohci, GFP_ATOMIC, udev, ep);
>  		if (!td) {
>  			/* out of memory */
>  			ed_free (ohci, ed);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
