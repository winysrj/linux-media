Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:3015 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZA1OKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 09:10:50 -0500
Message-ID: <49806755.9000902@ingegneria.unime.it>
Date: Wed, 28 Jan 2009 15:10:29 +0100
From: Giancarlo Iannizzotto <ianni@ingegneria.unime.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: empire USB portable media station
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I recently bought the USB hybrid card named "empire USB portable media
station". My Ubuntu 8.10 linux box does not recognize it:

dmesg:
...
[ 377.610947] usb 4-1: new high speed USB device using ehci_hcd and
address 4
[ 377.743974] usb 4-1: configuration #1 chosen from 1 choice

the lsusb command returns:
...
Bus 004 Device 004: ID 1b80:e025

and the detailed information about the chips inside the card (as
described in http://forum.html.it/forum/showthread/t-1263514.html)
are:
Tuner: NXP TDA18271
Demod： NXP TDA10048
A/V Decoder: NXP SAA7136E
USB Bridge:Cypress 68013A

I really would like to keep and use this device. Please, could anyone
give me some hints?

Thank you in advance
ianni

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJgGdUj3XLa/GpYwkRAlf9AJ4y9izhZ9/ovGiGe3e1TB605tJFBQCfdZLZ
vJjIY13qLEegpSLR3V9Qv+8=
=Vk1g
-----END PGP SIGNATURE-----
