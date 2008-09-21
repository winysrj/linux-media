Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2-g19.free.fr ([212.27.42.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <luc.ferran@free.fr>) id 1KhR1i-00022O-NH
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 17:39:12 +0200
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 4F7F812B731
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 17:39:07 +0200 (CEST)
Received: from [192.168.0.5] (vau06-1-82-228-255-93.fbx.proxad.net
	[82.228.255.93])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 1E7D812B722
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 17:39:07 +0200 (CEST)
Message-ID: <48D66B3E.8010407@free.fr>
Date: Sun, 21 Sep 2008 17:41:50 +0200
From: Luc Ferran <luc.ferran@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Artec T14BR
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi All,

I own an Artect USB T14BR with a remote control (very simple one, 25 keys).
Following documentation, the DVB-T tunner is well handeled and no test 
had been done with the remote control.

I can confirm that tunner is working very well (I use kaffeine), 
unfortunately, the remote control is not working.
With dmesg, I can see that some keys are not known.
I assue that the 2 first values ares the key code, but I have no idea of 
what's represents the tzo last one (usually 1 0).

I really would like to contribute on this topic, I have some skills in C 
progrmaming, but none in kernel programming.

Does anybody could guide me to make this remote works ?

Up to now I've just uncommented the info line (L468) in 
dib0700_devices.c to get values for this remote to put in the 
dib0700_rc_keys[];
First notice is that some key codes already exists but not for the same 
keys that i'm pressing on the remote.
Could that cause any issue ? What is the releven tway to handle this ?

Thanks in advance for answers!
Regards

Luc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
