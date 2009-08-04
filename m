Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma06.mx.aol.com ([64.12.78.142]:62037 "EHLO
	imr-ma06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZHDMxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 08:53:39 -0400
Received: from imo-da01.mx.aol.com (imo-da01.mx.aol.com [205.188.169.199])
	by imr-ma06.mx.aol.com (8.14.1/8.14.1) with ESMTP id n74Cl0Ml009838
	for <linux-media@vger.kernel.org>; Tue, 4 Aug 2009 08:47:00 -0400
Received: from samankaya@netscape.net
	by imo-da01.mx.aol.com  (mail_out_v40_r1.5.) id x.c83.42316f56 (34942)
	 for <linux-media@vger.kernel.org>; Tue, 4 Aug 2009 08:46:58 -0400 (EDT)
Message-ID: <4A782DC0.2080905@netscape.net>
Date: Tue, 04 Aug 2009 13:46:56 +0100
From: Kaya Saman <SamanKaya@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV usb 1 not working?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I hope I'm in the right place!!

I have a Hauppauge WinTV usb 1.1 tuner but I don't seem to be able to 
get it working.

I am running Kubuntu 9.04 64-bit edition.

The tuner detects in the kernel as:
Bus 006 Device 002: ID 0573:4d22 Zoran Co. Personal Media Division 
(Nogatech) Hauppauge WinTV-USB II (PAL) Model 566

Using the USBVision driver.

In the kernel using dmesg the tuner is detected as a WinTV Pro??

I have tried various apps to watch tv including tvtime, xawtv, and Zapping.

Running tvtime-scanner gives this output:

Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/kaya/.tvtime/tvtime.xml
Scanning using TV standard PAL.
/home/kaya/.tvtime/stationlist.xml: No existing PAL station list "Custom".

   Your capture card driver: USBVision [Hauppauge WinTV USB Pro (PAL 
I)/6-2/2313]
   does not support full size studio-quality images required by tvtime.
   This is true for many low-quality webcams.  Please select a
   different video device for tvtime to use with the command line
   option --device.

And xawtv and zapping seg fault each time I run them....??

I have an ancient Hauppauge WinTV/Radio PCI card which uses the bttv 
driver and xawtv works fine on it so I'm not sure why this one isn't 
working.

Can anyone help at all or suggest something??

Many thanks,

Kaya


