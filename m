Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60205 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab3FTFON (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 01:14:13 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MckQB-1UYHKP1OnB-00Hxac for
 <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 07:14:12 +0200
Message-ID: <51C28FA2.70004@gmx.net>
Date: Thu, 20 Jun 2013 07:14:10 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: EM28xx - MSI Digivox Trio - almost working.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

(device: http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio)

Thanks to the message from Philip Pemberton I was able to try loading 
the em28xx driver myself using:

sudo modprobe em28xx card=NUMBER
echo eb1a 2885 | sudo tee /sys/bus/usb/drivers/em28xx/new_id

Here are the results for NUMBER:

Card=79 (Terratec Cinergy H5): works, less corruption than card=87, just 
some blocks every few seconds. Attenuators didn't help.
Card=81 (Hauppauge WinTV HVR 930C): doesn't work, no /dev/dvb adapter
Card=82 (Terratec Cinergy HTC Stick): similar to card=87
Card=85 (PCTV QuatroStick (510e)): constantly producing i2c read errors, 
doesn't work
Card=86 (PCTV QuatroStick nano (520e): same
Card=87 (Terratec Cinergy HTC USB XS): stick works and scans channels, 
but reception is bugged with corruption. It's like having a DVB-T 
antenna that's just not good enough, except this is DVB-C and my signal 
is excellent. Attenuators didn't help.
Card=88 (C3 Tech Digital Duo HDTV/SDTV USB): doesn't work, no /dev/dvb 
adapter

So with card=79 it's really close to working. What else can I do?

Best regareds,

P. van Gaans
