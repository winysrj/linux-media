Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.176.128.13] (helo=vxout-1.c.is)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eggert@hugsaser.is>) id 1JvvTX-0003t4-D1
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 16:28:01 +0200
Received: from mail.internet.is (mail.aknet.is [193.4.194.58])
	by vxout-1.c.is (Postfix) with ESMTP id 77D0C45BD74
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 13:51:05 +0000 (GMT)
Received: from eggert (unknown [81.15.36.125])
	by mail.internet.is (Postfix) with ESMTP id 26A8630659
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 13:51:05 +0000 (CUT)
From: Eggert =?iso-8859-1?q?J=F3hannesson?= <eggert@hugsaser.is>
To: linux-dvb@linuxtv.org
Date: Tue, 13 May 2008 13:51:04 +0000
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805131351.04770.eggert@hugsaser.is>
Subject: [linux-dvb] MSI tv(at)nywhere A/D
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

Hi.

I am a fortunate owner of a MSI tv(at)nywhere A/D hybrid tuner card.

lspci -v

02:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video 
Broadcast Decoder (rev d1)
        Subsystem: Unknown device 4e42:3306
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at fddfe000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2

Got it about a year ago and after a lot of trying this and that on my ubuntu 
systen I got it mostly working, by using v4l-dvb revision 98e80288b44b and 
giving option card=94 to saa7134 module.

Some time ago I decided to try a newer version of v4l-dvb to see if the card 
would work better, but to no luck, it only worked with this one revision.  
OK, just go back to 98e80288b44b and I'm all right.

Now after upgrading ubuntu to hardy heron ( now kernel 2.6.24 was 2.6.22 ) 
making this revision gives me errors, in bttv-driver on make all and after 
configuring to only the modules (I think) I need compiling dvb-core gives 
errors.

I have tried 3 different revisions of v4l-dvb more recent than this one and 
all of them make and install ok but none of them work for me.  Results vary 
from Segmentation fault to more commonly failing on uploading firmware 
depending on revision and module options.

Card types I have tried to use are : card=55 112 94 135 87

I'm quite the noob in this area so if anyone can help me that would be very 
much appreciated.  I'll gladly give any more information that is needed, just 
didn't want to make this long email any longer.

respectfully
Eggert Johannesson
~

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
