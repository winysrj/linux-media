Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm23-vm2.bullet.mail.ird.yahoo.com ([212.82.109.231]:43623 "EHLO
	nm23-vm2.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756489Ab3FMUiG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 16:38:06 -0400
References: <51B26AF1.2000005@gmail.com> <1370876006.1569.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1370876948.45967.YahooMailNeo@web28904.mail.ir2.yahoo.com> <51B61143.3080307@iki.fi>
Message-ID: <1371155882.40503.YahooMailNeo@web28903.mail.ir2.yahoo.com>
Date: Thu, 13 Jun 2013 21:38:02 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: Re: rtl28xxu IR remote
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <51B61143.3080307@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> I think the most easiest way could be compile & install whole Kernel 

> from my tree. It is 3.10-rc4 + some fixes.

Ok, but I first tried the easier alternative you advised below.

> media_build.git has also option to fetch developer git tree from 
> linuxtv.org. Something like ./build --git 
> git://linuxtv.org/anttip/media_tree.git rtl28xxu . That approach seem to 
> be not documented on wiki:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Thanks for the suggestion. It is documented only in ./build --help, it seems.
I tried this latter way, it built succesfully, but the modules won't work: modprobe --force dvb_usb_rtl28xxu gives

err kernel: dvb_core: exports duplicate symbol dvb_ca_en50221_camchange_irq (owned by kernel)
