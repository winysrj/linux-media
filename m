Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60914 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0E2MhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 08:37:07 -0400
Received: by ywh36 with SMTP id 36so1384065ywh.4
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 05:37:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 29 May 2010 15:37:04 +0300
Message-ID: <AANLkTil_qTsY74eMoZTGIE6Q1hOeH4NOxAtTQnk57ddO@mail.gmail.com>
Subject: MSI TV@nywhere E-DUO driver for linux
From: Nikos Kalogridis <nikos.kalogridis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I recently purchased a MSI TV@nywhere E-DUO card that has 2 DVB-T
tuners and its a PCI-Express card. The card uses the SAA7160ET chip,
2x TDA10048 and of course 2 tuners which I cannot find their type as
those are covered with two metal shield for interference protection. I
found the work of Manu Abraham for SAA716x chipsets here
http://www.jusst.de/hg/saa716x/ and I modified the saa716x_hybrid.c
and .h files for the driver to recognize the specific card. I hence am
able to load the required code for saa7160et and tda10048 chips
successfully and now the missing link is to find what kind of tuner
chips this card uses to start testing the driver with this card.

Any help or pointer would be appreciated.

Thanks,
Nikos Kalogridis
