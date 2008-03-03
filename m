Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JWIi9-0003Ug-00
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 23:00:41 +0100
Message-ID: <47CC7504.9040600@philpem.me.uk>
Date: Mon, 03 Mar 2008 22:00:36 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <47A98F3D.9070306@raceme.org>	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	<47C4661C.4030408@philpem.me.uk>	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>	<47C7076B.6060903@philpem.me.uk>
	<47C879BA.7080002@philpem.me.uk>	<1204356192.6583.0.camel@youkaida>
	<47CA609F.3010209@philpem.me.uk>	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>	<47CAB51F.9030103@philpem.me.uk>
	<1204479088.6236.32.camel@youkaida>	<47CAEFC3.2020305@philpem.me.uk>
	<47CB20ED.5070403@philpem.me.uk>	<4F7F67AF4C%linux@youmustbejoking.demon.co.uk>
	<1204503495.6236.45.camel@youkaida>
In-Reply-To: <1204503495.6236.45.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

Nicolas Will wrote:
> As much as I understand your position, where it's coming from, and the
> reasoning behind it (and I'm not necessarily against it, trust me on
> that), blaming it all on the closed parts is maybe just as bad as
> blaming a USB vendor or open source coders and giving up.

It seems to be able to handle one or two recordings, then on the third it 
falls flat on its face. I told it to record Jurassic Park, and as soon as the 
recording was due to start, I got this in dmesg:

Mar  3 21:00:03 dragon kernel: [51071.390905] mt2060 I2C write failed
Mar  3 21:00:03 dragon kernel: [51071.390907] >>> 03 14 04 07 ff ff
Mar  3 21:00:03 dragon kernel: [51071.390910] ep 0 write error (status = -19, 
len: 6)
Mar  3 21:00:03 dragon kernel: [51071.390912] >>> 03 14 04 08 ff ff
Mar  3 21:00:03 dragon kernel: [51071.390915] ep 0 write error (status = -19, 
len: 6)
Mar  3 21:00:03 dragon kernel: [51071.390917] >>> 03 14 04 09 ff f0
Mar  3 21:00:03 dragon kernel: [51071.390920] ep 0 write error (status = -19, 
len: 6)
Mar  3 21:28:02 dragon -- MARK --
Mar  3 21:48:02 dragon -- MARK --
Mar  3 21:52:31 dragon kernel: [54213.772868] modifying (0) streaming state for 0
Mar  3 21:52:31 dragon kernel: [54213.772874] data for streaming: 0 10
Mar  3 21:52:31 dragon kernel: [54213.772876] >>> 0f 00 10 00
Mar  3 21:52:31 dragon kernel: [54213.772881] ep 0 write error (status = -19, 
len: 4)
Mar  3 21:52:31 dragon kernel: [54213.773463] dvb-usb: Hauppauge Nova-T 500 
Dual DVB-T successfully deinitialized and disconnected.
Mar  3 21:52:31 dragon kernel: [54214.011201] usb 2-1: new high speed USB 
device using ehci_hcd and address 3
Mar  3 21:52:31 dragon kernel: [54214.144020] usb 2-1: configuration #1 chosen 
from 1 choice
Mar  3 21:52:31 dragon kernel: [54214.144429] FW GET_VERSION length: 16
Mar  3 21:52:31 dragon kernel: [54214.144431] cold: 0
Mar  3 21:52:31 dragon kernel: [54214.144433] dvb-usb: found a 'Hauppauge 
Nova-T 500 Dual DVB-T' in warm state.
Mar  3 21:52:31 dragon kernel: [54214.144457] dvb-usb: will pass the complete 
MPEG2 transport stream to the software demuxer.
Mar  3 21:52:31 dragon kernel: [54214.144638] DVB: registering new adapter 
(Hauppauge Nova-T 500 Dual DVB-T)
Mar  3 21:52:31 dragon kernel: [54214.144806] >>> 0c 08 80
Mar  3 21:52:31 dragon kernel: [54214.158937] >>> 0c 08 c0
Mar  3 21:52:31 dragon kernel: [54214.178924] >>> 0c 0f 80

[.....]

I'm beginning to suspect a power supply or cooling issue; it seems to get 
worse the longer the machine is running... 15 hours uptime and the T500 is 
basically dead now, and a reboot only brings it back into the land of the 
living for a couple of hours at most...

Now where did I put that 500W junker that came with the case...

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
