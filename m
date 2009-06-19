Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:41177 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbZFSLH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 07:07:28 -0400
Received: by an-out-0708.google.com with SMTP id d40so2681924and.1
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 04:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d088c61e0906182312j7cba9243sa49257e3f59782ff@mail.gmail.com>
References: <d088c61e0906182312j7cba9243sa49257e3f59782ff@mail.gmail.com>
Date: Fri, 19 Jun 2009 13:07:30 +0200
Message-ID: <d088c61e0906190407q2258c058wc7767ca4361419ca@mail.gmail.com>
Subject: LV5H clone
From: Mimmo Squillace <ms.v4lml@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

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
WXP  every time I wish to watch TV?

If needed I can run some test ...

Thanks in advance,

Mimmo
