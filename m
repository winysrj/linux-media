Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.wnex.hu ([87.229.43.150] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <szab100@bytestorm.hu>) id 1JUHsh-0004vQ-7r
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 09:43:15 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.wnex.hu (Postfix) with ESMTP id 46CE11A9D3EA
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 09:43:11 +0100 (CET)
Received: from mail.wnex.hu ([127.0.0.1])
	by localhost (mail.wnex.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id snC4jpDyQ8cG for <linux-dvb@linuxtv.org>;
	Wed, 27 Feb 2008 09:42:57 +0100 (CET)
Received: from [192.168.0.101] (catv-5984812d.catv.broadband.hu
	[89.132.129.45])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.wnex.hu (Postfix) with ESMTP id BEE581A9D3E1
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 09:42:57 +0100 (CET)
Message-ID: <47C52292.9060104@bytestorm.hu>
Date: Wed, 27 Feb 2008 09:42:58 +0100
From: =?ISO-8859-1?Q?Fr=FChwald_Szabolcs?= <szab100@bytestorm.hu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47C3F093.9030902@bytestorm.hu>
In-Reply-To: <47C3F093.9030902@bytestorm.hu>
Subject: Re: [linux-dvb] cx88-input: leadtek tv200xp global - ??
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


anybody?? please..


Fr=FChwald Szabolcs =EDrta:
> hi there,
>
> i've a leadtek tv2000xp global pci card
> it's running OK (with some errors, but works) with current developement
> v4l-dvb branch
> i tried to enable it's IR remote control too in cx88-input.c
> just copied tv2000xp expert switch entry:
>
> case CX88_BOARD_WINFAST2000XP_EXPERT:
>                  ir_codes =3D ir_codes_winfast;
>                  ir->gpio_addr =3D MO_GP0_IO;
>                  ir->mask_keycode =3D 0x8f8;
>                  ir->mask_keyup =3D 0x100;
>                  ir->polling =3D 1; /* ms */
>                  break;
>
> but the result of this was: IR recognized well by kernel, dev/input
> device attached
> but when i pressed a button on remote, it printed its character, waited
> a sec and started to repeat this character forever
> so, i pressed '6', out was:
> 6<1sec_delay>666666666666666666666666666666666666666666666666666 .... etc=
..
> could anybody help me to correct this?
> it would be cool if i could paste a patch to the mailing list to enable
> this functionality for this card
> i figured out the main problem is with "ir->mask_keyup=3D0x100", so maybe
> it isn't there... but i didnt find it at 0x60,0x80 too and don't know
> where could it be??
>
> ps: I also tried to comment out this line of code (as i saw some other
> entrys without this option), the repeats are stopped but when i pressed
> a button more than once it's only showed up once. So, i pressed 6,
> printed 6 but when i pressed 6 again, it didnt print anything. After i
> pressed other button (printed once too), and pressed again 6, prints 6
> again).
>
> Thanks for your help...
>
> bye,
> Szab
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
