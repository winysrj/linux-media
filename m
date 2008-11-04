Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1KxL1p-0000Wo-A5
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 13:29:03 +0100
Message-ID: <00cf01c93e79$0f3f6e70$f4c6a5c1@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: "Ruediger Dohmhardt" <ruediger.dohmhardt@freenet.de>
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
	<490E19B3.9090701@freenet.de>
	<001201c93d80$a9df4620$7f79a8c0@tommy>
	<490F732A.8060505@freenet.de>
Date: Tue, 4 Nov 2008 13:30:02 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT DVB-C 2300 and CAM,
	Was: Any DVB-C tuner with working CAM?
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

Dear Ruediger,
thanks for the reply!

I tried to upgrade from vdr 1.4.7 to 1.6.0 and see some difference:
Nov  4 12:00:45 pvr vdr: [4375] CAM 1: module present
Nov  4 12:01:23 pvr vdr: [4375] CAM 1: no module present
Nov  4 12:01:23 pvr vdr: [4375] CAM 1: module present
Nov  4 12:02:01 pvr vdr: [4375] CAM 1: no module present
Nov  4 12:02:02 pvr vdr: [4375] CAM 1: module present
Nov  4 12:02:14 pvr vdr: [4375] CAM 1: no module present
.... and so on.

And still no output from the scrambled channels. I saw some CAM timeout fix
in the 1.6.0-1 patch but no change when applied. Also 1.6.0-2 didn't help.

Regards,
Tomas

> Dear Tomas
> 
> Attached you find part of my
> /var/log/boot.msg
> 
> and
> 
> /var/log/messages
> 
> One hint: When switching from vdr 1.4.x to 1.5/1.6/1.7  the channel.conf
> must be adapted with respect to decrypted channels.
> 
> Ciao Ruediger D.
> 
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
