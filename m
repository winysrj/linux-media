Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JXamm-0001EA-95
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 12:30:49 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JXWio-0002z8-Jm
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 07:10:26 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id 1E2041AFDBF5
	for <linux-dvb@linuxtv.org>; Fri,  7 Mar 2008 07:11:15 +0000 (GMT)
Message-ID: <47D0EA5B.8040105@philpem.me.uk>
Date: Fri, 07 Mar 2008 07:10:19 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Updated scan file for uk-EmleyMoor
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

Here's a scan file for Emley Moor with the correct frequencies and tuning 
parameters... Seems the one in the linux-dvb distribution has frequencies with 
a -133kHz or so offset, and without the correct QAM parameters. Probably my 
fault, because IIRC I submitted that tuning file...

Data sourced from www.ukfree.tv, and works fine on my HVR-3000.

# Emley Moor, West Yorkshire
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 626000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
T 650000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
T 674000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
T 698000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
T 706000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
T 722000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE


-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
