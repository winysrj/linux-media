Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KIrF9-0007hB-7c
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 22:35:30 +0200
Message-ID: <487D0A0A.7060303@iki.fi>
Date: Tue, 15 Jul 2008 23:35:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: postfix@au-79.de
References: <20080715064346.01ACC1BC39@agathe>
	<487C85ED.8060303@iki.fi>	<487CD260.80102@iki.fi>
	<487D0178.3000908@au-79.de>
In-Reply-To: <487D0178.3000908@au-79.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unknown dvbt device 1ae7:0381 Xtensions 380U
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

postfix@au-79.de wrote:
> Hello Antti,
> 
> thanks for your work. I tryed your patched files and according to dmesg, 
> it looks like a good initialisation. But after init there are endless 
> failures like:
> dvb-usb: error while querying for an remote control event.
> af9015: af9015_rw_udev: sending failed: -110 (8/0)
> af9015: af9015_rw_udev: receiving failed: -110

I have no idea what IR-mode is 0x04 but hopefully it will start working 
now when remote polling is disabled.
Please test again.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
