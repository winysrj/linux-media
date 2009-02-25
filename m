Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:60368
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755676AbZBYVlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 16:41:23 -0500
Received: from e4.eyal.emu.id.au (really [192.168.3.4]) by eyal.emu.id.au
	via in.smtpd with esmtp
	id <m1LcRLH-001ILHC@eyal.emu.id.au> (Debian Smail3.2.0.115)
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 08:30:59 +1100 (EST)
Message-ID: <49A5B891.5050409@eyal.emu.id.au>
Date: Thu, 26 Feb 2009 08:30:57 +1100
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
MIME-Version: 1.0
To: list linux-dvb <linux-media@vger.kernel.org>
Subject: saa716x: fedora 10 missing spi in kernels?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I find that the latest drivers for the saa716x require spi but the necessary symbols
are unresolved. My f10 kernel .config shows CONFIG_SPI=n.

Is this correct? How can I load the saa driver?

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
