Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZIMNmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 09:42:03 -0400
Date: Sun, 13 Sep 2009 10:41:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Emanoil Kotsev <emanoil.kotsev@sicherundsicher.de>
Cc: emanoil.kotsev@sicherundsicher.at,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec T USB XXS 0ccd:00ab device
Message-ID: <20090913104129.189fa15e@caramujo.chehab.org>
In-Reply-To: <200909131457.05286.emanoil.kotsev@sicherundsicher.at>
References: <200909131457.05286.emanoil.kotsev@sicherundsicher.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Sep 2009 14:56:56 +0200
Emanoil Kotsev <emanoil.kotsev@sicherundsicher.at> escreveu:

> Hello, I've just subscribed this list. I'm normally using knode to read news, 
> but somehow I can not pull the groups etc from the vger server.
> 
> I also tried to post to linux-dvb mailing list, but found out that it moved 
> here. If you think I need to know something explicitly about participating to 
> the list, please let me know.
> 
> The issue I'm facing is that my old TV card (HVR900) stopped working, so I 
> googled around and decided to buy Terratec T USB XXS, reading it was 
> supported in dvb_usb_dib0700
> 
> However after installing the card (usb-stick) it was not recognized (my one 
> has product id 0x00ab and not 0x0078), so I googled again and found a hint to 
> change the device id in dvb_usb_ids.h which was working for other Terratec 
> card.
> 
> I pulled the latest v4l-dvb code and did it (perhaps I could have done it in 
> the kernel 2.6.31), compiled, installed and it started working.
> 
> However I can not handle udev to get the remote control links created 
> correctly. Can someone help me with it? How can I provide useful output to 
> developers to solve the issues with ir? I read and saw that ir control keys 
> are coded in the driver, so if the ir part of the 0x00ab card is different, 
> how can I get a useful information that can be coded for this card? Who is 
> doing the work at linux-dvb?
> 
> I read there are other people, returning the cards to the seller, because it's 
> not working/supported by linux, which does not seem to be really true.
> 
> Luckilly I have a bit kernel experience and good C knowledge and could do 
> testing if somebody can have a look at the issues - the code is completely 
> new to me so that I prefer to be an alpha tester for the device.
> 
> thanks for patience in advance and kind regards

Basically, all you need to do is to enable IR debug, when loading em28xx module
and see what's the scan code for each pressed key on the IR. Then edit
ir-keycodes.c, adding a new table there, and edit em28xx-cards.c to add a new
board entry with the new code, with the new IR table.
There's a page for Remote Controllers at linuxtv.org wiki showing what keycode
names should be used for each key.



Cheers,
Mauro
