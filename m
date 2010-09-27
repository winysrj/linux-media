Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab0I0DBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 23:01:00 -0400
Message-ID: <4CA008E6.2000501@redhat.com>
Date: Mon, 27 Sep 2010 00:00:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Daniel Moraes <daniel.b.moraes@gmail.com>
CC: linux-media@vger.kernel.org,
	Fernando Henrique <fernandohbc@gmail.com>
Subject: Re: Webcam Driver Bug while using two Multilaser Cameras simultaneously
References: <AANLkTi=TjOKMRQk1spGFVnt1ycu48eZudiWh-hc0a8vp@mail.gmail.com> <AANLkTikWL10Tjb1BnmESGKvq1edZJXoe60pEdJUzMsLx@mail.gmail.com> <AANLkTimRw9=K5D51iejuVv2Duphu0tqCt8_nH2X2eOyL@mail.gmail.com> <4C990C08.9050504@redhat.com> <AANLkTinO4Wm0vHYv2nDP25bar-ASSvgGgO_7ONF-MNmh@mail.gmail.com> <4C9CA90A.50204@redhat.com> <AANLkTi=ArE-em7wBXAne2Lnr0CoVW6oG_o=gkFvRBUgT@mail.gmail.com>
In-Reply-To: <AANLkTi=ArE-em7wBXAne2Lnr0CoVW6oG_o=gkFvRBUgT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-09-2010 21:29, Daniel Moraes escreveu:
> Mauro,
> 
> first of all I would like to thank you. By using the commands that you
> told me, I was able to find the problem. Now I need to find a
> solution.
> 
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 005: ID 04fc:2001 Sunplus Technology Co., Ltd
> Bus 003 Device 004: ID 04fc:2001 Sunplus Technology Co., Ltd
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 002: ID 04f2:b015 Chicony Electronics Co., Ltd VGA
> 24fps UVC Webcam
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> As I showed above, I have 4 USB buses here (two usb 2.0 and two usb
> 1.1). However, all three external USB ports from my notebook seem to
> use the same USB bus (Bus 003) and the HP Webcam the Bus 002.
> 
> When I turn one of the Multilaser cameras on, in one port, the Bus 003
> stream uses 80% of the limit. When I turn the another camera on, in a
> different port, it doesn't work because it uses the same USB bus.
> 
> Is there a way to change the USB bus from any of my external usb ports?

In general, you can't. They're hardwired. You'll need to buy an extra 
USB adapter. There are a few PCMCIA ones, like:

http://www.byterunner.com/byterunner/category=PCMCIA+USB+and+Firewire+Cards
http://shopping.uol.com.br/pcmcia-usb.html?nortrk=1&url=/index.html&lout=47,49&psid=1#rmcl

There are also some models for Express Card bus. Just be sure to buy one
that will work with your notebook (if you're in doubt, you may see 
http://en.wikipedia.org/wiki/ExpressCard).

> 
> Att,
>  Daniel Bastos Moraes
>  Graduando em Ciência da Computação - Universidade Tiradentes
>  +55 79 88455531
