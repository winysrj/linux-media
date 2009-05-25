Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:36053 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZEYRfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 13:35:09 -0400
Message-ID: <4A1AD62C.8070907@unsolicited.net>
Date: Mon, 25 May 2009 18:32:28 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
References: <Pine.LNX.4.44L0.0905251121370.23874-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905251121370.23874-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> Okay, here's a patch for you to try.  It refreshes the toggle setting 
> in a linked but otherwise idle QH when a new URB is queued.
>
> Alan Stern
>
>
> Index: usb-2.6/drivers/usb/host/ehci-q.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-q.c
> +++ usb-2.6/drivers/usb/host/ehci-q.c
> @@ -88,7 +88,7 @@ static inline void
>  qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
>  {
>  	/* writes to an active overlay are unsafe */
> -	BUG_ON(qh->qh_state != QH_STATE_IDLE);
> +	BUG_ON(qh->qh_state != QH_STATE_IDLE && !list_empty(&qh->qtd_list));
>  
>  	qh->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
>  	qh->hw_alt_next = EHCI_LIST_END(ehci);
> @@ -971,7 +971,13 @@ static struct ehci_qh *qh_append_tds (
>  		/* can't sleep here, we have ehci->lock... */
>  		qh = qh_make (ehci, urb, GFP_ATOMIC);
>  		*ptr = qh;
> +	} else if (list_empty(&qh->qtd_list)) {
> +		/* There might have been a Clear-Halt while the QH
> +		 * was linked but empty.
> +		 */
> +		qh_refresh(ehci, qh);
>  	}
> +
>  	if (likely (qh != NULL)) {
>  		struct ehci_qtd	*qtd;
>  
>
>   
No luck I'm afraid (although there now appear to be 2 timeouts, not
one). I'm going to follow up on the laptop and get a USB log.

[  118.017016] usb 1-10: new high speed USB device using ehci_hcd and
address 5
[  118.148589] usb 1-10: configuration #1 chosen from 1 choice
[  118.452964] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold
state, will try to load a firmware
[  118.452972] usb 1-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[  118.488474] dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
[  118.550946] usbcore: registered new interface driver dvb_usb_ttusb2
[  118.552553] usb 1-10: USB disconnect, address 5
[  118.561083] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[  120.313020] usb 1-10: new high speed USB device using ehci_hcd and
address 6
[  120.444942] usb 1-10: configuration #1 chosen from 1 choice
[  120.445886] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm
state.
[  120.446672] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  120.447014] DVB: registering new adapter (Technotrend TT-connect S-2400)
[  120.455026] DVB: registering adapter 0 frontend 129197120 (Philips
TDA10086 DVB-S)...
[  120.458383] LNBx2x attached on addr=8<3>dvb-usb: recv bulk message
failed: -110
[  122.457126] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[  124.456109] dvb-usb: recv bulk message failed: -110
[  124.456117] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[  124.456122] dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.


David

