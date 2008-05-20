Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail11.syd.optusnet.com.au ([211.29.132.192])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JyJ3i-000463-8k
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 06:02:45 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail11.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4K42Ymm025900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 14:02:35 +1000
Received: from pjama.net (localhost [127.0.0.1])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4K420sK007977
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 14:02:00 +1000 (EST)
Message-ID: <59114.192.168.200.51.1211256120.squirrel@pjama.net>
In-Reply-To: <483232A9.6010609@iki.fi>
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
	<48320E91.3010306@iki.fi>
	<57913.192.168.200.51.1211245507.squirrel@pjama.net>
	<4832259A.6050101@iki.fi> <483232A9.6010609@iki.fi>
Date: Tue, 20 May 2008 14:02:00 +1000 (EST)
From: "pjama" <pjama@optusnet.com.au>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] IR for Afatech 901x
Reply-To: pjama@optusnet.com.au
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

> Antti Palosaari wrote:
>> pjama wrote:
>>>> Probably there is wrong ir-table loaded to the device by the driver.
>>>> Ir-table in device and ir-codes from remote should match. Otherwise it
>>>> will not work.
>>> How do I confirm this? Should there be something in dmesg?
>>
>> I can try to look correct tables from sniffs I have... but it can take
>> some time. Maybe tomorrow.
>
> I did it. Please test
> http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/

That's got to be the quickest "Maybe tomorrow." I've ever come across. :)

>
> For a little luck some buttons may work.
>
> I think all buttons you have makes events and can see in usb-transfers.
> But there is still mappings to do...
>
> Load driver with debug=2 (rmmod dvb-usb-af9015; modprobe dvb-usb-af9015
> debug=2) and tail -f /var/log/messages to see if there is now some bytes
> coming from remote.

OK linux lesson time here but when I do "rmmod dvb-usb-af9015" I loose the
/dev/input/event7 and associated links files. When I do "modprobe
dvb-usb-af9015 debug=2" the files don't come back. There's probably
something really obvious I'm supposed to do here but I've no idea what it
is...

from /var/log/messages
May 20 13:51:41 SunU20 kernel: [  420.212086] usbcore: deregistering
interface driver dvb_usb_af9015
May 20 13:51:41 SunU20 kernel: [  420.212305] af9015_usb_device_exit:
May 20 13:51:41 SunU20 kernel: [  420.212310] af9015_i2c_exit:
May 20 13:51:41 SunU20 kernel: [  420.240392] dvb-usb: DigitalNow TinyTwin
DVB-T Receiver successfully deinitialized and disconnected.

May 20 13:53:21 SunU20 kernel: [  519.937166] >>> 22 00 a1 00 31 00 01 01
May 20 13:53:22 SunU20 kernel: [  520.936533] dvb_usb_af9015: probe of
2-2:1.0 failed with error -110
May 20 13:53:22 SunU20 kernel: [  520.936782] usbcore: registered new
interface driver dvb_usb_af9015


Once again I'm not "at" my PC so I can't press any buttons on the remote
but I suspect it won't work at this point.

Cheers
Peter


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
