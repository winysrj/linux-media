Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:44637 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752964Ab1DPTHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Apr 2011 15:07:12 -0400
Message-ID: <4DA9E8DC.5040107@gmx.net>
Date: Sat, 16 Apr 2011 21:07:08 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RE: stb0899 signal strength value in dvb-s2l
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi everyone,
> 
> Using a KNC-1 DVB-S2 board I noticed stb0899_read_signal_strength() 
> in stb0899_drv.c always return the same value (1450) in dvb-s2 whatever
> the signal power is.
> 
> It seems STB0899_READ_S2REG(STB0899_DEMOD, IF_AGC_GAIN) macro always
> returns zero.
> 
> Any idea of what is causing this ?

Try

-                       reg = STB0899_READ_S2REG(STB0899_DEMOD,
IF_AGC_GAIN);
+                       reg = STB0899_READ_S2REG(STB0899_S2DEMOD,
IF_AGC_GAIN);

Than it is working,

Johns
