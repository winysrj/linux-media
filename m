Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVCpI-0004kD-RZ
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 22:31:32 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JVCpB-00047r-Vv
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 21:31:26 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id 529F11AFDC77
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 21:32:14 +0000 (GMT)
Message-ID: <47C879BA.7080002@philpem.me.uk>
Date: Fri, 29 Feb 2008 21:31:38 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <47A98F3D.9070306@raceme.org>	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>	<1202330097.4825.3.camel@anden.nu>	<47AB1FC0.8000707@raceme.org>	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	<47C4661C.4030408@philpem.me.uk>	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk>
In-Reply-To: <47C7076B.6060903@philpem.me.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Ben Firshman wrote:
 > Mine has now been running for a couple of days now without problems, I will 
let you know if I lose a tuner.

Strange, mine's still crashing out after a couple of hours. Just out of 
curiosity...
   - What kernel are you running? Distribution? Driver version?
   - If you're using MythTV, do you have "Use this card for EIT scanning" 
enabled for the T-500?
   - What firmware?

   Answers are "2.6.24-8-generic", Mythbuntu 8.04 alpha 2, Hg 615ce349999, and 
yes (EIT scanning on) for me, and firmware is dvb-usb-dib0700-1.10.fw (in 
/lib/firmware/2.6.24-8-generic). I'm planning to try 
dvb-usb-dib0700-03-pre1.fw at some point -- is this older or newer than 1.10 
(it's listed on the Wiki as a possible solution to the disconnect issue).

   I'm also staring daggers at the VIA USB controller chip on the T500... I've 
had nothing but trouble from VIA USB chips, with the possible exception of the 
  K8T800 Pro on the motherboard in my desktop machine. FWIW, the PVR is based 
on a Biostar TA690G board, which uses the AMD/ATI 690G, but I've got a 
Gainward nVidia GeForce 8400GS PCIe-x16 card in there (because the 690G is a 
poor excuse for a graphics chip and only just works under Windows, let alone 
Linux!)

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
