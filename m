Return-path: <mchehab@pedra>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:53796 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab0KNPrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 10:47:11 -0500
Message-ID: <4CE0047D.8060401@arcor.de>
Date: Sun, 14 Nov 2010 16:47:09 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Massis Sirapian <msirapian@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
References: <4CDFF446.2000403@free.fr>
In-Reply-To: <4CDFF446.2000403@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Am 14.11.2010 15:37, schrieb Massis Sirapian:
> Hi,
>
> I have discovered, upgrading my old WinTV PCI Hauppauge card to a 
> HVR-900H USB stick how much the IR userspace has evolved.
>
> I'm using the 2.6.36 kernel provided by Debian in its experimental 
> repository.
>
> Loading the tm6000_dvb works fine (even if it takes a while when I 
> modprobe it while the USB stick is already plugged). Kaffeine sees and 
> uses correctly the device.
>
> However, I'd like to use the IR remote control. It seems to be 
> recognized, as dmesg | grep -i lirc gives :
>
> [  123.306153] lirc_dev: IR Remote Control driver registered, major 250
> [  123.306932] IR LIRC bridge handler initialized
>
> I have no event nor input device created. I've understood from Jarod's 
> pages that the new IR userspace doesn't necessarily require lirc, but 
> sees the IR receiver as a "keyboard". No such device is present in 
> /proc/bus/input/devices
>
> inputlirc + irw don't show anything.
>
> Am I missing something here ? Do I have to load a specific module ?
>
> I have found a lot of information concerning imon, but none I can 
> apply to my HVR-900H/tm6000 case.
>
> Thanks in advance
>
> Massis
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
HVR900H doesn't use lirc. It generates an input device, if a rc_map is 
present for this device.
