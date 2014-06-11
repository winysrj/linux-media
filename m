Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaFKIFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 04:05:04 -0400
Date: Wed, 11 Jun 2014 10:05:18 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-media@vger.kernel.org
Cc: Jason.Dong@ite.com.tw
Subject: Re: AF9033 / IT913X: Avermedia A835B(1835) only works sporadically
Message-ID: <20140611080518.GA1664@wolfgang>
References: <20140610125059.GA1930@wolfgang>
 <97D30D57D08C2C49A26A3312F17290483B008B5E@TPEMAIL2.internal.ite.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97D30D57D08C2C49A26A3312F17290483B008B5E@TPEMAIL2.internal.ite.com.tw>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:31:47AM +0000, Jason.Dong@ite.com.tw wrote:
> Dear Sebastian,
> 
> There is a RF performance issue in the af9033 driver of kernel 3.15.
> It is no problem in the it913x driver of kernel 3.14.  There were some
> initial sequences not correct after the it913x driver was integrated
> into af9033 driver.
> 
> BRs, Jason

Hello Jason,

Thank you very much for your reply!

So I guess this RF performance issue is not yet fixed. I was using fairly
recent media driver sources (linux-media-2014-05-26).

I'm using kernel 3.10.42. This morning I rebuilt it from scratch, only relying
on the in-kernel drivers instead of the experimental external ones. On the
first try it worked fine.  The (reported) signal strength was lower than with
linux-media-2014-05-26. But no uncorrectable errors occurred.

To test, I shut down the computer and cold started it with the USB stick
attached. Unfortunately it failed.

Maybe my USB stick and computer aren't meant to get along :-)

...
Jun 11 09:28:03 meiner kernel: usb 1-2: new high-speed USB device number 2 using xhci_hcd
...
Jun 11 09:28:03 meiner kernel: usbcore: registered new interface driver dvb_usb_it913x
Jun 11 09:28:03 meiner kernel: it913x: Chip Version=02 Chip Type=9135
Jun 11 09:28:03 meiner kernel: it913x: Remote propriety (raw) modeit913x: Dual mode=0 Tuner Type=38
Jun 11 09:28:03 meiner kernel: it913x: Unknown tuner ID applying default 0x60<6>usb 1-2: dvb_usb_v2: found a 'Avermedia A835B(1835)' in cold state
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
...
Jun 11 09:28:03 meiner kernel: it913x: FRM Starting Firmware Download
Jun 11 09:28:03 meiner kernel: it913x: FRM Firmware Download Completed - Resetting Device<6>usb 5-2: new low-speed USB device number 2 using uhci_hcd
...
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: it913x: FRM Device not responding to reboot
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
Jun 11 09:28:03 meiner kernel: it913x: Failed to identify chip version applying 1
Jun 11 09:28:03 meiner kernel: it913x: FRM Failed to reboot device<6>usb 1-2: dvb_usb_v2: 'Avermedia A835B(1835)' error while loading driver (-19)
Jun 11 09:28:03 meiner kernel: usb 1-2: dvb_usb_v2: 'Avermedia A835B(1835)' successfully deinitialized and disconnected
...

Kind regards,
Sebastian
