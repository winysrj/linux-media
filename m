Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51883 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755382AbZJVOFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 10:05:20 -0400
Date: Thu, 22 Oct 2009 10:05:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4AE03477.1010902@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910220944100.989-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> Here's the outputs from /sys/kernel/debug/usb/ehci:
> 
> periodic:
> ----------------
> size = 1024
>    1:  qh1024-0001/f6ffe280 (h2 ep2 [1/0] q0 p8)

There's something odd about this.  I'd like to see this file again, 
after the patch below has been applied.

> registers:
> ----------------
> bus pci, device 0000:00:1d.7
> EHCI Host Controller
> EHCI 1.00, hcd state 0
> ownership 00000001
> SMI sts/enable 0x80080000
> structural params 0x00104208
> capability params 0x00016871
> status 6008 Periodic Recl FLR
> command 010000 (park)=0 ithresh=1 period=1024 HALT
> intrenable 00
> uframe 2fa0
> port 1 status 001000 POWER sig=se0
> port 2 status 001000 POWER sig=se0
> port 3 status 001000 POWER sig=se0
> port 4 status 001000 POWER sig=se0
> port 5 status 001005 POWER sig=se0 PE CONNECT
> port 6 status 001005 POWER sig=se0 PE CONNECT
> port 7 status 001000 POWER sig=se0
> port 8 status 001000 POWER sig=se0
> irq normal 60 err 0 reclaim 16 (lost 0)
> complete 60 unlink 1

This confirms that the periodic schedule was never disabled.

So first get another copy of the "periodic" file with the patch below.  
Then try changing the enable_periodic() routine in ehci-sched.c: Add

	udelay(2000);

just before the final "return 0;" line.  Let's see if that prevents the 
problem from occurring.

Alan Stern



--- usb-2.6.orig/drivers/usb/host/ehci-dbg.c
+++ usb-2.6/drivers/usb/host/ehci-dbg.c
@@ -591,18 +591,21 @@ static ssize_t fill_periodic_buffer(stru
 							qtd->hw_token) >> 8)) {
 						case 0: type = "out"; continue;
 						case 1: type = "in"; continue;
+						case 2: type = "?2"; continue;
+						case 3: type = "?3"; continue;
 						}
 					}
 
 					temp = scnprintf (next, size,
 						" (%c%d ep%d%s "
-						"[%d/%d] q%d p%d)",
+						"[%d/%d] q%d p%d) %08x",
 						speed_char (scratch),
 						scratch & 0x007f,
 						(scratch >> 8) & 0x000f, type,
 						p.qh->usecs, p.qh->c_usecs,
 						temp,
-						0x7ff & (scratch >> 16));
+						0x7ff & (scratch >> 16),
+						hc32_to_cpu(ehci, qtd->hw_token));
 
 					if (seen_count < DBG_SCHED_LIMIT)
 						seen [seen_count++].qh = p.qh;

