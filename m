Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:17831 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZKBVZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 16:25:29 -0500
Received: by ey-out-2122.google.com with SMTP id d26so500733eyd.19
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 13:25:33 -0800 (PST)
MIME-Version: 1.0
From: Charles <landemaine@gmail.com>
Date: Mon, 2 Nov 2009 22:25:13 +0100
Message-ID: <e6575a30911021325v4932269fp63ad529871874b45@mail.gmail.com>
Subject: No transponders found when using Linux
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a Terratec Cinergy HT PCI MKII that I'm using with Ubuntu
Karmic Koala. I have a dual boot with Windows and the DVB-T board
works very well. I tried scanning channels in Linux but I have no
results: http://pastebin.ca/1653762

Here's more info on my board: http://pastebin.ca/1653771
uname -r
2.6.31-14-generic

'dmesg | grep dvb' doesn't return anything

I tried also w_scan but with no results after a few minutes:
http://pastebin.ca/1653775
Any idea to troubleshoot this problem?
Thanks,

Charles.
