Return-path: <mchehab@pedra>
Received: from sysphere.org ([97.107.129.246]:39689 "EHLO mail.sysphere.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1EUHEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 03:04:14 -0400
Date: Sat, 21 May 2011 09:04:14 +0200
From: "Adrian C." <anrxc@sysphere.org>
To: Christoph Pinkl <christoph.pinkl@gmail.com>
cc: abraham.manu@gmail.com, linux-media@vger.kernel.org
Subject: Re: AW: Remote control not working for Terratec Cinergy C (2.6.37
 Mantis driver)
In-Reply-To: <alpine.LNX.2.00.1105210314230.26477@flfcurer.bet>
Message-ID: <alpine.LNX.2.00.1105210900160.31652@flfcurer.bet>
References: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet> <4DC431C6.1010605@kolumbus.fi> <alpine.LNX.2.00.1105102329290.12340@flfcurer.bet> <4dcd3ef7.dc06df0a.52b1.5d88@mx.google.com> <alpine.LNX.2.00.1105210314230.26477@flfcurer.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, I got 2.6.39 so I tried this, on Technisat SkyStar2 HD2.

Device showed up as /dev/input/event3. ir-keytable does not show any 
protocols for it: 

Found /sys/class/rc/rc0/ (/dev/input/event3) with:
        Driver mantis_core, table rc-terratec-cinergy-s2-hd
        Supported protocols: 
        Enabled protocols: 
        Repeat delay = 500 ms, repeat period = 33 ms


I moved lircd to devinput driver, and downloaded this[1] to use as 
lircd.conf. Restarted lircd and started irw. Only half of the buttons on 
my universal remote control (very suitable for VDR) show up. Then I 
tried the original Technisat TTS35AI and almost all keys registered, all 
but button "0". 


1. http://lirc.sourceforge.net/remotes/devinput/lircd.conf.devinput


-- 
Adrian C. (anrxc) | anrxc..sysphere.org | PGP ID: D20A0618
PGP FP: 02A5 628A D8EE 2A93 996E  929F D5CB 31B7 D20A 0618
