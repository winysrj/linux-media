Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail01.syd.optusnet.com.au ([211.29.132.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JyfjN-0007uU-RQ
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 06:15:17 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail01.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4L4EuZV026788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 14:14:58 +1000
Received: from pjama.net (localhost [127.0.0.1])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4L4E6II014197
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 14:14:07 +1000 (EST)
Message-ID: <27514.203.9.185.254.1211343247.squirrel@pjama.net>
In-Reply-To: <483232A9.6010609@iki.fi>
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
	<48320E91.3010306@iki.fi>
	<57913.192.168.200.51.1211245507.squirrel@pjama.net>
	<4832259A.6050101@iki.fi> <483232A9.6010609@iki.fi>
Date: Wed, 21 May 2008 14:14:07 +1000 (EST)
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


>
> Load driver with debug=2 (rmmod dvb-usb-af9015; modprobe dvb-usb-af9015
> debug=2) and tail -f /var/log/messages to see if there is now some bytes
> coming from remote.

As mentioned in an earlier response to this post, the above trashes the
device /dev/input/event7. Is there any way I can boot with debug set?

>
>>> This looks promising....
>>> $ evtest /dev/input/event7
>>> Input driver version is 1.0.0
>>> Input device ID: bus 0x3 vendor 0x13d3 product 0x3226 version 0x200
>>> Input device name: "IR-receiver inside an USB DVB receiver"
>>
>> Thats the correct one.

Doing evtest on /dev/input/event7 then pushing remote buttons give me
nothing. I have confirmed remote/receiver works by booting into windows
and using vendor supplied app.

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
