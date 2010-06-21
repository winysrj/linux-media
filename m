Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:57247 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0FULXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 07:23:39 -0400
Received: from [93.196.55.196] (helo=db1ras.afulinux.de)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <andi@afulinux.de>)
	id 1OQf6F-0003YL-DT
	for linux-media@vger.kernel.org; Mon, 21 Jun 2010 13:23:35 +0200
Received: from localhost.afulinux.de ([127.0.0.1] helo=localhost)
	by db1ras.afulinux.de with esmtp (Exim 4.69)
	(envelope-from <andi@afulinux.de>)
	id 1OQf6E-0008Md-Or
	for linux-media@vger.kernel.org; Mon, 21 Jun 2010 13:23:34 +0200
From: Andreas Stempfhuber <andi@afulinux.de>
To: linux-media@vger.kernel.org
Subject: Re: WinTV-NOVA HD-S2 unable to load firmware since register 0x20 is allways 0
Date: Mon, 21 Jun 2010 13:17:45 +0200
References: <201006200311.46367.andi@afulinux.de>
In-Reply-To: <201006200311.46367.andi@afulinux.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006211317.46016.andi@afulinux.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Sonntag, 20. Juni 2010 schrieb Andreas Stempfhuber:
> Hello,
>
> I bought a brandnew Hauppauge WinTV-NOVA HD-S2 which does not load the
> firmware since the value of register 0x20 is allways 0x00. After changing
> the cx24116 driver to not check register 0x20, the firmware is loaded and
> the card works as expected (DVB-S, audio and remote control).
[...]

I did a few additional tests and there seems to be only an issue with brandnew 
cards which have never before got a firmware uploaded. As on my card register 
0x20 allways returned 0 with different kernel and driver versions and several 
reboots.

After forcing a firmware upload by modifying the driver to not check the state 
of register 0x20, the issue no longer exists. If I now reboot or power cycle 
the PC, register 0x20 returns values unequal 0 and the original driver works 
as expected.

It seems to me that relying on register 0x20 for firmware uploads is not 
stable as a brandnew card may return 0 until it got the first firmware 
uploaded.

Regards,

Andreas

-- 
