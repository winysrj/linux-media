Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out7.libero.it ([212.52.84.107]:39932 "EHLO
	cp-out7.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZG3Gmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 02:42:38 -0400
Received: from [192.168.1.21] (151.59.218.157) by cp-out7.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A700F43001703A6 for linux-media@vger.kernel.org; Thu, 30 Jul 2009 08:42:38 +0200
Message-ID: <4A7140DD.7040405@iol.it>
Date: Thu, 30 Jul 2009 08:42:37 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it> <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
In-Reply-To: <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> With past kernel and a patch as suggested here:
>> http://www.linuxtv.org/wiki/index.php/TerraTec
>> that link to:
>> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
>> that link to:
>> http://mcentral.de/wiki/index.php5/Main_Page
 >> More bad now:
 >> http://mcentral.de/wiki/index.php5/Installation_Guide
 >> sell TV tuner, and do not support anymore the Terratec tuner, the source
 >> repository is disappeared, and install instruction is a commercial.

I do not know if is correct that linuxtv.org link to a web site with 
unsupported product/commercial.
Please change the link in page:
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS

>> and some troubles for Ubuntu kernel that I solved here:
>> https://bugs.launchpad.net/bugs/322732
>> worked well for a year or more.

the Ubuntu kernel bug is fixed in 9.04

Devin Heitmueller ha scritto:
> That device, including full support for the IR, is now supported in
> the mainline v4l-dvb tree (and will appear in kernel 2.6.31).  Just
> follow the directions here to get the code:
> http://linuxtv.org/repo

yesterday evening I downloaded the sources with mercurial, compiled and 
installed.
Same result, from dmesg the firmware file 'xc3028-v27.fw' is missing.
When I put it in /lib/firmware Kaffeine video/audio work, but no IR.

ready to help in debugging,
Valerio
