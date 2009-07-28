Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out9.libero.it ([212.52.84.109]:49364 "EHLO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZG1XiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 19:38:18 -0400
Received: from [192.168.1.21] (151.59.218.16) by cp-out9.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A5DDABA01619388 for linux-media@vger.kernel.org; Wed, 29 Jul 2009 01:32:54 +0200
Message-ID: <4A6F8AA5.3040900@iol.it>
Date: Wed, 29 Jul 2009 01:32:53 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy HibridT XS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi all,

I own a Terratec Cinergy HibridT XS
with lsusb ID:
Bus 001 Device 007:
ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS

With past kernel and a patch as suggested here:
http://www.linuxtv.org/wiki/index.php/TerraTec
that link to:
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
that link to:
http://mcentral.de/wiki/index.php5/Main_Page
and some troubles for Ubuntu kernel that I solved here:
https://bugs.launchpad.net/bugs/322732
worked well for a year or more.

With last Ubuntu 9.04, kernel 2.6.28-13 seems have native support for 
the tuner, but from dmesg a file is missing: xc3028-v27.fw
(maybe manage I2C for IR?)
I found it on a web site, copied in /lib/firmware
and now Kaffeine work, but ... no more IR remote command work.

More bad now:
http://mcentral.de/wiki/index.php5/Installation_Guide
sell TV tuner, and do not support anymore the Terratec tuner, the source 
repository is disappeared, and install instruction is a commercial.


Any chanches?

thanks in advace,
Valerio
