Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.wnex.hu ([87.229.43.150] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <szab100@bytestorm.hu>) id 1JTxV3-00028E-Sx
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 11:57:29 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.wnex.hu (Postfix) with ESMTP id 336511A9D352
	for <linux-dvb@linuxtv.org>; Tue, 26 Feb 2008 11:57:26 +0100 (CET)
Received: from mail.wnex.hu ([127.0.0.1])
	by localhost (mail.wnex.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QkGKFhKeNRpG for <linux-dvb@linuxtv.org>;
	Tue, 26 Feb 2008 11:57:23 +0100 (CET)
Received: from [152.66.146.156] (dhcp-156.i.wlan.bme.hu [152.66.146.156])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.wnex.hu (Postfix) with ESMTP id 215CB1A9D34D
	for <linux-dvb@linuxtv.org>; Tue, 26 Feb 2008 11:57:23 +0100 (CET)
Message-ID: <47C3F093.9030902@bytestorm.hu>
Date: Tue, 26 Feb 2008 11:57:23 +0100
From: =?ISO-8859-2?Q?Fr=FChwald_Szabolcs?= <szab100@bytestorm.hu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] cx88-input: leadtek tv200xp global
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

hi there,

i've a leadtek tv2000xp global pci card
it's running OK (with some errors, but works) with current developement
v4l-dvb branch
i tried to enable it's IR remote control too in cx88-input.c
just copied tv2000xp expert switch entry:

case CX88_BOARD_WINFAST2000XP_EXPERT:
                 ir_codes = ir_codes_winfast;
                 ir->gpio_addr = MO_GP0_IO;
                 ir->mask_keycode = 0x8f8;
                 ir->mask_keyup = 0x100;
                 ir->polling = 1; /* ms */
                 break;

but the result of this was: IR recognized well by kernel, dev/input
device attached
but when i pressed a button on remote, it printed its character, waited
a sec and started to repeat this character forever
so, i pressed '6', out was:
6<1sec_delay>666666666666666666666666666666666666666666666666666 .... etc..
could anybody help me to correct this?
it would be cool if i could paste a patch to the mailing list to enable
this functionality for this card
i figured out the main problem is with "ir->mask_keyup=0x100", so maybe
it isn't there... but i didnt find it at 0x60,0x80 too and don't know
where could it be??

ps: I also tried to comment out this line of code (as i saw some other
entrys without this option), the repeats are stopped but when i pressed
a button more than once it's only showed up once. So, i pressed 6,
printed 6 but when i pressed 6 again, it didnt print anything. After i
pressed other button (printed once too), and pressed again 6, prints 6
again).

Thanks for your help...

bye,
Szab



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
