Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KV9Bj-00005a-3o
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 20:10:44 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5T00HMK6GVOGR0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 18 Aug 2008 14:10:07 -0400 (EDT)
Date: Mon, 18 Aug 2008 14:10:06 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200808181427.36988.ajurik@quick.cz>
To: ajurik@quick.cz
Message-id: <48A9BAFE.8020501@linuxtv.org>
MIME-version: 1.0
References: <200808181427.36988.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 driver problems - i2c error
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

Ales Jurik wrote:
> Hi,
> 
> I've got a HVR-4000, but I have now some very strange problems.
> I have Debian Leeny with 2.6.25-2 kernel and multiproto from Igor Lipianin hg 
> running at Athlon64 X2 2700+ and Asus M2N-DVI mobo. 
> Whole multiproto tree compiled without any problem.
> 
> - when starting system I got this message:
> 
> [   24.658572] tda9887 0-0043: i2c i/o error: rc == -121 (should be 4)
> [   24.659047] tuner-simple 0-0061: i2c i/o error: rc == -121 (should be 4)
> [   23.609971] tda9887 0-0043: i2c i/o error: rc == -121 (should be 4)
> 
> - the firmware is loaded into the card at first time the card is opened - it 
> is okay?
> 
> [  917.660620] cx24116_firmware_ondemand: Waiting for firmware upload 
> (dvb-fe-cx24116.fw)...
> [  917.703010] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
> [  922.703870] cx24116_load_firmware: FW version 1.22.82.0
> [  922.703889] cx24116_firmware_ondemand: Firmware upload complete
> 
> The result is that only for some channels it is possible to get lock with 
> szap2. VDR is hanging (or starting) when trying to tune to initial channel, 
> even when this channel is set to channel at which is szap2 successfull. I'm 
> not able to say criteria which channels are possible to lock.
> 
> Any hints are appreciated.

I fixed an issue with cx88 sometime ago where a value of 0 (taken from 
the cards struct) was being written to the GPIO register, resulting in 
the same i2c issues.

It looks a lot like this.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
