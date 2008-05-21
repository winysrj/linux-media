Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JymhD-0003ek-EZ
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 13:41:28 +0200
Message-ID: <48340A29.6030505@iki.fi>
Date: Wed, 21 May 2008 14:40:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pjama@optusnet.com.au
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>	<48320E91.3010306@iki.fi>	<57913.192.168.200.51.1211245507.squirrel@pjama.net>	<4832259A.6050101@iki.fi>
	<483232A9.6010609@iki.fi>
	<27514.203.9.185.254.1211343247.squirrel@pjama.net>
In-Reply-To: <27514.203.9.185.254.1211343247.squirrel@pjama.net>
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
>> Load driver with debug=2 (rmmod dvb-usb-af9015; modprobe dvb-usb-af9015
>> debug=2) and tail -f /var/log/messages to see if there is now some bytes
>> coming from remote.
> 
> As mentioned in an earlier response to this post, the above trashes the
> device /dev/input/event7. Is there any way I can boot with debug set?

1) unplug your device
2) make sure new drivers are installed
3) reboot your machine
4) modprobe dvb-usb-af9015 debug=2
5) tail -f /var/log/messages
6) plug stick (now it should start pushing lines to /var/log/messages 
(or /var/log/debug) ?)

Remote buttons should now recognized in debug dumps.

> Doing evtest on /dev/input/event7 then pushing remote buttons give me
> nothing. I have confirmed remote/receiver works by booting into windows
> and using vendor supplied app.

It does not work because driver does not have mappings to your remote 
controller buttons yet. You should find correct mappings from debug dump 
described above.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
