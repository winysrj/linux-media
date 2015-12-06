Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35878 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbbLFLJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2015 06:09:37 -0500
Received: from mobile-access-5d6ab8-153.dhcp.inet.fi ([93.106.184.153] helo=[192.168.1.2])
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <timo.helkio@kapsi.fi>)
	id 1a5XCB-0004pP-Df
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 13:09:35 +0200
From: =?UTF-8?Q?Timo_Helki=c3=b6?= <timo.helkio@kapsi.fi>
Subject: DVBSky T980C ci not working with kernel 4.x
Reply-To: timo.helkio@kapsi.fi
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <5664176E.9090705@kapsi.fi>
Date: Sun, 6 Dec 2015 13:09:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi


Common interface in Dvbsky T980C is not working with Ubuntu 15.10 kernel 
4.2.0 and vanilla kernel 4.6 and latest dvb-drivers from Linux-media 
git. With Ubuntu 15.04 and kernel 3.19 it is working. I have tryid to 
find differences in drivers, but my knolege of c it is not possible. 
Erros message is "invalid PC-card".

I have also Tevii S470 with same PCIe bridge Conexant cx23885.

How to debug this? I can do minor changes to drivers for testing it.

   Timo Helkiö
