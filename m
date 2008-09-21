Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KhREc-0003Rp-VM
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 17:52:32 +0200
Received: by ey-out-2122.google.com with SMTP id 25so311050eya.17
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 08:52:27 -0700 (PDT)
Date: Sun, 21 Sep 2008 17:52:11 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Jonathan Coles <jcoles0727@rogers.com>
In-Reply-To: <48D658BF.7040807@rogers.com>
Message-ID: <alpine.DEB.1.10.0809211744070.13969@ybpnyubfg.ybpnyqbznva>
References: <48D658BF.7040807@rogers.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Still unclear how to use Hauppage HVR-950 and
 v4l-dvb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, 21 Sep 2008, Jonathan Coles wrote:

> [   17.247610] usb 5-2: new high speed USB device using ehci_hcd and 
> address 2
> [   17.380387] usb 5-2: unable to read config index 0 descriptor/all
> [   17.380434] usb 5-2: can't read configurations, error -71

This is a problem (I see it from time to time) when the USB
stack or hardware wets itself.  Some of my solutions have been
*  disconnect and reconnect the device...
*  use a different USB port
*  if an external USB hub is involved, disconnect and reconnect
   that (sometimes certain ports fly south for no obvious reason)
*  if needed, disconnect and reconnect power to any USB hubs or
   other devices (like if your device gets powered elsewhere)
*  if nothing else works, reboot your machine,
*  if that fails, completely power-cycle your machine, so that
   all hardware has a chance to reset and start from cold state.

In exceptional cases, your hardware could have somehow been
damaged, if a particular USB port always gives this type of error.


hope that's useful
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
