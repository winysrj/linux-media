Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:37753 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZGaGhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 02:37:13 -0400
Received: from [192.168.1.21] (151.59.219.29) by cp-out8.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A5EF7510185ADDC for linux-media@vger.kernel.org; Fri, 31 Jul 2009 08:37:12 +0200
Message-ID: <4A729117.6010001@iol.it>
Date: Fri, 31 Jul 2009 08:37:11 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it>	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>	 <4A7140DD.7040405@iol.it> <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
In-Reply-To: <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> How are you testing the IR support?

starting Kaffeine with a Digital TV channel, pressing numeric key of the 
remote in front of IR receiver connected to Terratec Cinergy Hybrid T XS.

> And are you using the Terratec
> remote control that came with the product?

yes, the one showed in this picture:
http://www.terratec.it/prodotti/schede_tv/TerraTec%20Cinergy%20Hybrid%20T%20USB%20XS/CinergyHybridTUSBXSscope.jpg

> Have you tried opening a
> text editor, hitting the "1" key, and seeing if the character appears?

I tried last evening, and no, does not appear any digit.

My lsusb ID is:
Bus 001 Device 007:
ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS

Note: with Ubuntu 8.04 K2.6.24-21-generic the TV and IR always worked.
With Ubuntu 8.10 and kernel
2.6.27.7-generic, 2.6.27.9-generic, 2.6.27.11-generic, 2.6.27-14-generic
I needed to add some media Kheaders, but then TV and IR always worked.
The problem appear just after upgrade to Ubuntu 9.04 kernel
2.6.28-13-generic and happen the same for 2.6.28-14-generic

Valerio

