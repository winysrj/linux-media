Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KsaAH-000595-G0
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 11:38:08 +0200
Message-ID: <48FEF474.50803@iki.fi>
Date: Wed, 22 Oct 2008 12:37:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Darron Broad <darron@kewl.org>
References: <48FE2872.3070105@podzimek.org>
	<48FE3553.5080009@iki.fi>	<48FE6351.2000805@podzimek.org>
	<10307.1224636523@kewl.org>
In-Reply-To: <10307.1224636523@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
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

Darron Broad kirjoitti:
> In message <48FE6351.2000805@podzimek.org>, Andrej Podzimek wrote:
>> One more little note about the firmware:
>>
>> 	[andrej@xandrej firmware]$ sha1sum dvb-usb-af9015.fw
>> 	6a0edcc65f490d69534d4f071915fc73f5461560  dvb-usb-af9015.fw
>>
>> That file can be found here: http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>>
>> Is it the right one? Shell I try something else?
> 
> Lo
> 
> try this patch (WARNING, although I have one of these devices
> and this looked to fix it, I have no idea what this actually means).

Your patch means it does not reconnect stick on USB-bus after firmware 
download. Anyhow, it should reconnect, there is reconnect command in 
af9015 driver after firmware download. I have no idea why functionality 
seems to be changed (stick does not reconnect anymore).

Is that problem coming from after new Kernel?

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
