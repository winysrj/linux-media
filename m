Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755128AbZGOOXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 10:23:46 -0400
From: Cedric Laczny <cedric.laczny@gmx.de>
To: linux-media@vger.kernel.org
Subject: kernel-2.6.30 and TechnoTrend S2-3600 USB
Date: Wed, 15 Jul 2009 16:23:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907151623.44440.cedric.laczny@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I saw in the linux-tv wiki that there is some way to get the TT S2-3600 to 
work under linux using the s2liplianin-drivers. Also there is confirmation by 
the following thread: 
http://www.gentooforum.de/artikel/16632/technotrend-tt-connect-s2-3600-und-gentoo.html?s=ad37010b8eba15db1b12328a5013865e96856778

However, since the S2API now is also contained in the kernel, I would prefer 
to use this directly and not the ones from the repository.

In fact, when searching through the kernel-config, I found all drivers 
(dvb-core.ko, dvb-usb.ko, stb0899.ko, stb6100.ko) when looking for 
CONFIG_DVB_BUDGET_CI (-> SAA7146 DVB cards (aka Budget, Nova-PCI) ),
except for dvb-usb-pctv452e.ko and lnbp22.ko. For the latter one, I found 
lnbp21.ko and I think this is also working, especially since the wiki 
states "STMicroelectronics LNBP21 LNB supply and control IC. "
So the only thing that is missing is dvb-usb-pctv452e.ko!

And therefore I was wondering if this was perhaps renamed when being moved to 
the kernel? Actually, I was thinking that it might have become budget_ci.ko, 
as all the other modules are also listed there under "Selects".
Or maybe rather dvb-usb-ttusb2.ko (-> Pinnacle 400e DVB-S USB2.0 support), as 
this is for Pinnacle?

Did someone get the TechnoTrend S2-3600 USB to work with standard 
kernel-2.6.30 and without using the extra drivers from s2-liplianin or could 
help with any information about the dvb-usb-pctv452e.ko module?

Best regards,

Cedric
