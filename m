Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40279 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab0KOC2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 21:28:17 -0500
Received: by qwi4 with SMTP id 4so121797qwi.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 18:28:16 -0800 (PST)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Re: HVR900H : IR Remote Control
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4CE03704.4070300@free.fr>
Date: Sun, 14 Nov 2010 21:28:13 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <E36252C7-6CBF-4271-9B1D-3152E450C6E8@wilsonet.com>
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr>
To: LMML Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 14, 2010, at 2:22 PM, Massis Sirapian wrote:

> Le 14/11/2010 16:47, Stefan Ringel a écrit :
>> Am 14.11.2010 15:37, schrieb Massis Sirapian:
>>> Hi,
>>> 
>>> I have discovered, upgrading my old WinTV PCI Hauppauge card to a
>>> HVR-900H USB stick how much the IR userspace has evolved.
>>> 
>>> I'm using the 2.6.36 kernel provided by Debian in its experimental
>>> repository.
>>> 
>>> Loading the tm6000_dvb works fine (even if it takes a while when I
>>> modprobe it while the USB stick is already plugged). Kaffeine sees and
>>> uses correctly the device.
>>> 
>>> However, I'd like to use the IR remote control. It seems to be
>>> recognized, as dmesg | grep -i lirc gives :
>>> 
>>> [ 123.306153] lirc_dev: IR Remote Control driver registered, major 250
>>> [ 123.306932] IR LIRC bridge handler initialized
>>> 
>>> I have no event nor input device created. I've understood from Jarod's
>>> pages that the new IR userspace doesn't necessarily require lirc, but
>>> sees the IR receiver as a "keyboard". No such device is present in
>>> /proc/bus/input/devices
>>> 
>>> inputlirc + irw don't show anything.
>>> 
>>> Am I missing something here ? Do I have to load a specific module ?
>>> 
>>> I have found a lot of information concerning imon, but none I can
>>> apply to my HVR-900H/tm6000 case.
>>> 
>>> Thanks in advance
>>> 
>>> Massis
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> HVR900H doesn't use lirc. It generates an input device, if a rc_map is
>> present for this device.
>> 
> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the kernel source directory, but nothing seems to fit my remote, which is a DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.
> 
> Were you talking about these rc_"map" modules? If so and if there is corresponding module for my remote, how can I contribute as I have one?

Your device doesn't appear to have IR wired up. The driver that
drives it is likely requesting the IR modules be loaded, but your
particular board's support isn't implemented -- thus no input or
lirc devices that have shown up.

-- 
Jarod Wilson
jarod@wilsonet.com



