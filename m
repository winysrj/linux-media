Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:56204 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbZLGLt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 06:49:59 -0500
Date: Mon, 7 Dec 2009 12:49:46 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Marcelo Blanes <marcelo_blanes@yahoo.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New DibCom based ISDB-T device
In-Reply-To: <969712.5508.qm@web54205.mail.re2.yahoo.com>
Message-ID: <alpine.LRH.2.00.0912071248380.13793@pub6.ifh.de>
References: <4B02B3B3.5050502@redhat.com> <969712.5508.qm@web54205.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696143-1505823041-1260186586=:13793"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579696143-1505823041-1260186586=:13793
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Marcelo,

On Tue, 17 Nov 2009, Marcelo Blanes wrote:
> Dear Mauro and Patrick,
> 
> This log may help you. It appears when I insert the usb tv stick tunner into one of my usb interfaces:
> 
> [  759.573180] usb 8-1: new high speed USB device using ehci_hcd and address 4
> [  759.714026] usb 8-1: configuration #1 chosen from 1 choice
> [  759.717155] usb 8-1: New USB device found, idVendor=10b8, idProduct=1fa0
> [  759.717155] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  759.717155] usb 8-1: Product: STK8096GP
> [  759.717155] usb 8-1: Manufacturer: DiBcom
> [  759.717155] usb 8-1: SerialNumber: 1
> 
> Also a more detail information using lsusb -D


Can you please test your device using the driver from here:

http://linuxtv.org/hg/~pb/v4l-dvb/

?

thanks,

--

Patrick
http://www.kernellabs.com/
--579696143-1505823041-1260186586=:13793--
