Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KulqY-0005yC-NJ
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 11:30:48 +0100
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id 302292FA899
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 11:30:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 207EC13000F7
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 11:30:41 +0100 (CET)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bHy--NJ0BULZ for <linux-dvb@linuxtv.org>;
	Tue, 28 Oct 2008 11:30:37 +0100 (CET)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 5144E1300084
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 11:30:37 +0100 (CET)
Message-ID: <4906E9CA.90003@anevia.com>
Date: Tue, 28 Oct 2008 11:30:34 +0100
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] cx88-blackbird mailbox timeout
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

Dear all,
I'm using one of the latest snapshots with my hauppauge hvr1300. I'm 
encoutering an issue, where randomly the mpeg ps device does not contain 
any sound track at all. I insist on the random side of the thing. If I 
completly power off my computer, no card can be affected by this bug, or 
any other card can be. But when a card is affected, it is until the 
computer is powered off. Unloading / reloading the modules won't fix.

Other thing, on closing an mpeg device affected by this bug, the dmesg 
will contain :

cx88[2]/2-bb: ERROR: API Mailbox timeout

then, opening the device again will show this message :
[62153.237112] cx88[2]/2-bb: ERROR: Mailbox appears to be in use (7)
[62155.868701] cx88[2]/2-bb: Firmware upload successful.
[62155.872299] cx88[2]/2-bb: Firmware version is 0x02060039

Any idea ?

-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
