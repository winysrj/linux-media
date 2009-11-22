Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:60187 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZKVVII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 16:08:08 -0500
Received: from [10.1.1.4] (uranus.local [10.1.1.4])
	by sedna.local (Postfix) with ESMTP id C028C5C1B
	for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 21:08:13 +0000 (GMT)
Message-ID: <4B09A834.3000309@gmail.com>
Date: Sun, 22 Nov 2009 21:08:04 +0000
From: Stacey <cardcaptorstacey@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: V4L-DVB modules not loading
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I don't know who to send this to. Not sure if it is a bug or not.

I followed your very helpful tutorial perfectly:
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers 
  but it hasn't quite worked.

I've built the module okay. It installed correctly and copied the files
into /lib/modules/2.6.31-14-generic/kernel/drivers/media/dvb/dvb-usb.
After that I rebooted (since it was easier for me). Then I got to the
"If the Modules load correctly" section to find that nothing has worked
at all.

I've checked my system log and it's recognising the USB device when I
enter it but it isn't doing anything with it. The tutorial says you
should be able to see the modules in /proc/modules but the modules
folder doesn't even exist. The /dev/dvb/ folder has not been created
either.

I have a EyeTV Diversity and have the antenna plugged in.

I will provide as much information as you need. I really want to get
this working. :)

Thanks
~ Stacey
