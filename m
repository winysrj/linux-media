Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38582 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0KOV1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 16:27:25 -0500
Received: by fxm6 with SMTP id 6so2164447fxm.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 13:27:24 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 15 Nov 2010 22:27:22 +0100
Message-ID: <AANLkTimWiSPyo3j04TQHXAUs=jopdwG4QxO6MZG8GK8y@mail.gmail.com>
Subject: s2-liplianin on Tevii S470
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everybody!

I have a Tevii S470 DVB-S2 PCIe tunner and I want to use it to watch
some channels on MythTV. I want to use it with a Debian Squeeze system
on a 2.6.32-5-686 kernel.

On Tevii web site are some firmware/drivers:

http://www.tevii.com/100315_Beta_linux_tevii_ds3000.rar
http://www.tevii.com/tevii_ds3000.tar.gz

I copy the dvb-fe-ds3000.fw file on /lib/firmware, I having some
problems with s2-liplianin installation, I use the script from
http://www.linuxtv.org/wiki/index.php/TeVii_S470:

  echo "TeVii S470"
       # checking firmware
       if [ ! -f /lib/firmware/dvb-fe-ds3000.fw ]; then
           wget -c http://tevii.com/tevii_ds3000.tar.gz
           tar zxfv tevii_ds3000.tar.gz
           sudo cp tevii_ds3000/dvb-fe-ds3000.fw /lib/firmware/
           rm -rf tevii_ds3000
       fi
       # checking driver
       if [ -d "s2-liplianin" ]; then
           cd "s2-liplianin"
           make distclean
           make update
       else
           hg clone http://mercurial.intuxication.org/hg/s2-liplianin
           cd "s2-liplianin"
       fi
       make
       sudo make install
       sudo depmod
       sudo make rmmod
       sudo modprobe cx23885
       sleep 1
       ls -R /dev/dvb/

And this is the result: http://dl.dropbox.com/u/1541853/tevii_sh

I am getting some warnings and errors.

How can I install it?

Thanks for all and best regards.


-- 
Josu Lazkano
