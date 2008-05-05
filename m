Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail04.syd.optusnet.com.au ([211.29.132.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1Jsvg1-0007Dl-DX
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 10:04:03 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail04.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4583rZH029590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 18:03:54 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4583lSA002000
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 18:03:48 +1000 (EST)
Message-ID: <481EBF63.2050601@optusnet.com.au>
Date: Mon, 05 May 2008 18:03:47 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
In-Reply-To: <481E91D8.7010404@wentink.de>
Subject: Re: [linux-dvb] probs with af901x on mythbuntu
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



Bastiaan Wentink wrote:
> Hi :)
> 
> have you stopped mythtvbackend?
> Command is afaik /etc/init.d/mythtvbackend stop.
> I had the same thing with mythbuntu
> 

Hi Bastiann,
Thanks for the reply. You are exactly right. Mythbuntu has locked the cardfor it's own selfish use. "sudo /etc/init.d/mythtv-backend stop" will kill it.

OK next problem. I now get:
peter@SunU20:~$ sudo scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 2 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 585625000 1 2 9 3 1 2 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)

< repeated several times with a different channel but similar failed message >

WARNING: >>> tuning failed!!!
>>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
peter@SunU20:~$


Now (while donning my flame proof suit), I must confess that I hadn't thoroughly gone through the mailing list (google failed me) but since posting I've discovered a few things....

1) in dmesg where it says "af9013: firmware version:4.73.0" Does this mean it found version 4.73.0 on the device or in the /lib/firmware/kernel<blah>/dvb_usb_af9015 file? I believe I installed version 4.95.0 (but being a binary file it's hard to confirm). Should they match, Can I upgrade the device or should I downgrade the dvb_usb_af9015 file?

2) A post from Antti back in the beginning of April (http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025267.html) says the driver works but tuning fails because of the MXL5005 tuner. Bummer! 
Antti, did you get the usb sniff that you were after? If not, can you recommend an application that can dump a suitable file?

Cheers
peter

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
