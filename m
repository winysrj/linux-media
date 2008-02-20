Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JRpkE-0006pT-J1
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 15:16:22 +0100
Received: by an-out-0708.google.com with SMTP id d18so1105330and.125
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 06:16:15 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Matthew Vermeulen <mattvermeulen@gmail.com>
In-Reply-To: <950c7d180802200543w31d157eag6e3d8277d60fa412@mail.gmail.com>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
	<950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
	<1203513814.6682.30.camel@acropora>
	<950c7d180802200543w31d157eag6e3d8277d60fa412@mail.gmail.com>
Date: Wed, 20 Feb 2008 15:15:21 +0100
Message-Id: <1203516921.6602.11.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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

Il giorno mer, 20/02/2008 alle 22.43 +0900, Matthew Vermeulen ha
scritto:
> Feb 20 22:39:53 matthew-desktop kernel: [39334.832815] dib0700:
> Unknown remote controller key: 13 7E  1  0
> Feb 20 22:39:53 matthew-desktop kernel: [39334.908277] dib0700:
> Unknown remote controller key: 13 7E  1  0
> Feb 20 22:39:53 matthew-desktop kernel: [39335.060139] dib0700:
> Unknown remote controller key: 13 7E  1  0
> Feb 20 22:39:53 matthew-desktop kernel: [39335.136473] dib0700:
> Unknown remote controller key: 13 7E  1  0
> Feb 20 22:39:53 matthew-desktop kernel: [39335.211810] dib0700:
> Unknown remote controller key: 13 7E  1  0
> Feb 20 22:39:54 matthew-desktop kernel: [39335.364108] dib0700:
> Unknown remote controller key: 13 7E  1  0
> 
> Not sure if that's what we were hoping for...

It seems that your remote does not use the toggle bit. I don't know why
since afaik it is a feature of the rc5 protocol.
By the way you can try to make some test writing the keymap on your own.
Just edit dib0700_devices.c about at line 400, look at the other keymaps
to have a model:
for example if the key you logged was the UP key you have to add a line
like: 
{ 0x13, 0x7E, KEY_UP },
and so on for the other keys, after that see if the keymap works with
evtest.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
