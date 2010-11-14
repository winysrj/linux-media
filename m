Return-path: <mchehab@pedra>
Received: from mx1.polytechnique.org ([129.104.30.34]:54564 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0KNOqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 09:46:36 -0500
Received: from [192.168.0.1] (mic92-4-82-224-132-174.fbx.proxad.net [82.224.132.174])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ssl.polytechnique.org (Postfix) with ESMTPSA id BC17414000634
	for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 15:37:55 +0100 (CET)
Message-ID: <4CDFF446.2000403@free.fr>
Date: Sun, 14 Nov 2010 15:37:58 +0100
From: Massis Sirapian <msirapian@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR900H : IR Remote Control
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I have discovered, upgrading my old WinTV PCI Hauppauge card to a 
HVR-900H USB stick how much the IR userspace has evolved.

I'm using the 2.6.36 kernel provided by Debian in its experimental 
repository.

Loading the tm6000_dvb works fine (even if it takes a while when I 
modprobe it while the USB stick is already plugged). Kaffeine sees and 
uses correctly the device.

However, I'd like to use the IR remote control. It seems to be 
recognized, as dmesg | grep -i lirc gives :

[  123.306153] lirc_dev: IR Remote Control driver registered, major 250
[  123.306932] IR LIRC bridge handler initialized

I have no event nor input device created. I've understood from Jarod's 
pages that the new IR userspace doesn't necessarily require lirc, but 
sees the IR receiver as a "keyboard". No such device is present in 
/proc/bus/input/devices

inputlirc + irw don't show anything.

Am I missing something here ? Do I have to load a specific module ?

I have found a lot of information concerning imon, but none I can apply 
to my HVR-900H/tm6000 case.

Thanks in advance

Massis
