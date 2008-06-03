Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from daedalus.castlecore.com ([67.215.231.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1K3eJw-0004ba-IM
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 23:45:37 +0200
Received: from 87-194-114-122.bethere.co.uk ([87.194.114.122]
	helo=wolf.philpem.me.uk)
	by daedalus.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1K3eJi-0003Ig-GV
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 22:45:18 +0100
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id 00F041AFD8AE
	for <linux-dvb@linuxtv.org>; Tue,  3 Jun 2008 22:45:25 +0100 (BST)
Message-ID: <4845BB33.9080508@philpem.me.uk>
Date: Tue, 03 Jun 2008 22:44:19 +0100
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] RC-6 remotes on dib0700 (Nova-T-500) and cx88 (HVR-3000)
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

Hi,
   Has anyone managed to get a remote using the Philips RC-6 protocol working 
with either the cx88 driver, or the dib0070 driver?

   The HVR-3000 (cx88) only works with the standard Hauppauge remote (RC-5 
protocol) and ignores everything else, though the hardware seems to be capable 
of decoding more than that (insofar as it's just an IR sensor wired to a GPIO).

   The Nova-T-500 appears to support three protocols -- RC-5, RC-6 and NEC. If 
I change the module parameters, I can get the RC-5 remote to work, but if I 
change the protocol to RC-6, neither the RC-6 remote nor the Hauppauge remote 
will work -- as in, there's nothing in /dev/input/event# (where # = 2 for the 
HVR, 3 for the T-500).

   The remotes I'm using for testing are a Sky Navigator keyboard remote and a 
Hauppauge new-style "silver-and-grey snowboard" remote. The lircrc file for 
the Navigator is here: http://lirc.sourceforge.net/remotes/sky/NAVIGATOR

   Out of curiosity, has anyone managed to get an RC-6 type remote working 
with either a CX88 or DiBCom based DVB card? Is there some hardware or driver 
limit that prevents this happening?

   Obviously I've got no problem with building a custom remote receiver for 
the HTPC, but I'd rather use the existing receivers if at all possible ("work 
smarter not harder" and all that).

Thanks.
-- 
Phil.
lists@philpem.me.uk
http://www.philpem.me.uk/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
