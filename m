Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm8.bullet.mail.ne1.yahoo.com ([98.138.90.71]:33684 "HELO
	nm8.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757211Ab2DDXGU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Apr 2012 19:06:20 -0400
Message-ID: <1333580430.41460.YahooMailNeo@web121705.mail.ne1.yahoo.com>
Date: Wed, 4 Apr 2012 16:00:30 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Is xine DVB broken with Linux 3.3.1?
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi,

Is anyone else having difficulty watching DVB-T with xine and a 3.3.1 kernel? I have tried the following with several different USB adapters:

1) Plug in the device
2) Launch xine.
3) Select DVB-T channel.


and each time, the results are the same. Namely, xine refuses to acknowledge any of my channels. However, if I execute scandvb before running xine then xine suddenly realises that the exact same channels.conf file is OK after all.

It looks as if scandvb is initialising a piece of the USB DVB device's internal "state", and xine cannot tune the adapter into any channel until it has.

Can anyone else reproduce this, please?
Thanks,
Chris

