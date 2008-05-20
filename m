Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JyGQ0-0006gM-KP
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 03:13:33 +0200
Message-ID: <4832259A.6050101@iki.fi>
Date: Tue, 20 May 2008 04:12:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pjama@optusnet.com.au
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>	<48320E91.3010306@iki.fi>
	<57913.192.168.200.51.1211245507.squirrel@pjama.net>
In-Reply-To: <57913.192.168.200.51.1211245507.squirrel@pjama.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] IR for Afatech 901x
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

pjama wrote:
>> Probably there is wrong ir-table loaded to the device by the driver.
>> Ir-table in device and ir-codes from remote should match. Otherwise it
>> will not work.
> 
> How do I confirm this? Should there be something in dmesg?

I can try to look correct tables from sniffs I have... but it can take 
some time. Maybe tomorrow.

> This looks promising....
> $ evtest /dev/input/event7
> Input driver version is 1.0.0
> Input device ID: bus 0x3 vendor 0x13d3 product 0x3226 version 0x200
> Input device name: "IR-receiver inside an USB DVB receiver"

Thats the correct one.


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
