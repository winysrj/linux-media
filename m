Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:3280 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFWFlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 01:41:08 -0400
Received: by an-out-0708.google.com with SMTP id d40so7489929and.1
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 22:41:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jun 2009 07:41:10 +0200
Message-ID: <d088c61e0906222241g1cdaa970g9158cb1933495d2b@mail.gmail.com>
Subject: LV5H under Jaunty
From: Mimmo Squillace <ms.v4lml@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've a LV5H clone marketed in Italy under Extreme Technology brand
which does not work under Ubuntu Jaunty (kernel version 2.6.30 used to
solve intel graphics video card performance issue).
It is identified by:
       idVendor=eb1a, idProduct=2883
I tried to use it using the following em28xx.conf (in /etc/modprobe.d
directory):
       options em28xx card=1
in order to use generic 28xx driver; it is attached as /dev/video0 and
/dev/vbi0 but tvtime says that it could not recognize video input,
xawtv hangs and scantv says that there is no tuner!
After modprobe em28xx_dvb (dmesg says succefull initialized...)
Kaffeine doesn't recognize it and scan returns a "Fatal error
/dev/dvb/adapter0 etc..." ...

There are some chanches to use it under Ubuntu or I've to switch to
WXP  every time I wish to watch TV?

If needed I can run some test ...

Thanks in advance,
