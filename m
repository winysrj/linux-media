Return-path: <mchehab@pedra>
Received: from smtp1.mtw.ru ([93.95.97.34]:60881 "EHLO smtp1.mtw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1EEWaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 18:30:09 -0400
Date: Fri, 6 May 2011 01:00:09 +0400
From: Andrew Junev <a-j@a-j.ru>
Reply-To: Andrew Junev <a-j@a-j.ru>
Message-ID: <16110382789.20110506010009@a-j.ru>
To: Josu Lazkano <josu.lazkano@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
In-Reply-To: <BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com>
References: <1908281867.20110505213806@a-j.ru> <BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



Thursday, May 5, 2011, 11:56:07 PM, you wrote:

> Hello Andrew, I have same DVB-S2 card on a Debian Squeeze system, I
> have installed this way:

> mkdir /usr/local/src/dvb
> cd /usr/local/src/dvb
> wget http://tevii.com/100315_Beta_linux_tevii_ds3000.rar
> unrar x 100315_Beta_linux_tevii_ds3000.rar
> cp dvb-fe-ds3000.fw /lib/firmware/
> tar xjvf linux-tevii-ds3000.tar.bz2
> cd linux-tevii-ds3000
> make && make install

> It works for me, sometimes I have those message on /var/log/messages:

> May  4 13:43:14 htpc kernel: [11575.306168] ds3000_firmware_ondemand:
> Waiting for firmware upload (dvb-fe-ds3000.fw)...
> May  4 13:43:14 htpc kernel: [11575.306181] cx23885 0000:05:00.0:
> firmware: requesting dvb-fe-ds3000.fw
> May  4 13:43:14 htpc kernel: [11575.358334] ds3000_firmware_ondemand:
> Waiting for firmware upload(2)...

> But it works well, I use it with MythTV, SD and HD channels.

> Let me know if you need some test.


Hello Josu,

Thanks a lot for your response!

What kernel version do you have?
Do  you  see  your  card's  MAC  address in the /var/log/messages when
the    driver   is  loading?  I'm not sure if it matters, but I see my
old  TT S-1401 cards' MAC addresses in the logs, but I don't see the
MAC of S470 anywhere... Maybe it just a specific of the driver...


As Igor wrote earlier, I probably need to upgrade my kernel. Well, I'm
not   really   looking  forward  to   do  that,  since it is likely to
break  other things  for me. But if that's the only way - I guess I'll
have to give it a try.

Thanks again!

