Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52425 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752373AbZJTPHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 11:07:07 -0400
Date: Tue, 20 Oct 2009 11:07:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4ADD74FE.4040406@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910201101220.2887-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> > Hi. First the backtrace:
> >
> > [  149.510272] uvcvideo: Found UVC 1.00 device BisonCam, NB Pro (5986:0203)
> > [  149.515017] input: BisonCam, NB Pro as
> > /devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input10
> > [  149.515588] usbcore: registered new interface driver uvcvideo
> > [  149.516247] USB Video Class driver (v0.1.0)
> > [  149.658012] Pid: 1137, comm: hald-probe-vide Tainted: G         C
> > 2.6.31.4-128 #2
> > [  149.658012] Call Trace:
> > [  149.658012]  [<c0373f62>] handshake_on_error_set_halt+0x36/0x65
> > [  149.658012]  [<c0374073>] enable_periodic+0x32/0x72
> > [  149.658012]  [<c03741c9>] qh_link_periodic+0x116/0x11e
> > [  149.658012]  [<c0374665>] qh_schedule+0x120/0x12c
> > [  149.658012]  [<c03775d0>] intr_submit+0x8c/0x124
> > [  149.658012]  [<c0377d2a>] ehci_urb_enqueue+0x7a/0xa5
...
> > [  149.658012] ehci_hcd 0000:00:1d.7: force halt; handhake f7c66024
> > 00004000 00000000 -> -110
> >
> > And the usbmon trace during "modprobe uvcvideo" can be found at:
> >
> > http://cekirdek.pardus.org.tr/~ozan/ivir/logs/usbmon.trace.bad
> >
> > I also manage to not reproduce the problem so it's kinda racy. You can
> > find good/bad dmesg/usbmon traces at:
> >
> > http://cekirdek.pardus.org.tr/~ozan/ivir/logs
> >   
> ping! in case it's got lost between high traffic :)

Yes, sorry, my email client tends to hide messages with non-ASCII 
characters in the From: address.  It's unforunate.  :-(

I can't tell exactly what's wrong, but I've got a hunch that the patch 
below might help.  If it doesn't, send another dmesg log but this time 
with CONFIG_USB_DEBUG enabled in the kernel.

Alan Stern


Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -818,6 +818,9 @@ qh_make (
 				dbg ("intr period %d uframes, NYET!",
 						urb->interval);
 				goto done;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
 			}
 		} else {
 			int		think_time;
@@ -840,6 +843,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 

