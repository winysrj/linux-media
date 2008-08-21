Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx00.csee.securepod.com ([66.232.128.196]
	helo=cseeapp00.csee.securepod.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KWDn9-0000IY-DZ
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 19:17:48 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	by smtp00.csee.securepod.com (Postfix) with ESMTP id 2EBFA22C413
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 18:17:12 +0100 (BST)
Message-ID: <48ADA318.6020704@beardandsandals.co.uk>
Date: Thu, 21 Aug 2008 18:17:12 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TT 3200 S2 and CI - "PC card did not respond"
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

Has anyone managed to get a TT 3200 cam interface working with a recent 
clone of the repository at http://jusst.de/hg/multiproto?

I have got the TT3200 card itself working with the recent scan patches, 
but cannot get the CAM to initialise, it gets as far as "PC card did not 
respond". I searched back through the list and found some patches for 
the I2C stuff, but these appear to be already in the repository I 
cloned. I cannot see any other threads on this issue that reach a 
conclusion. As far as I know the CAM I am using is OK as I can talk to 
it via a CI emulator on a windows PC.

Any suggestions and further pointers gratefully received.

Thanks,

Roger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
