Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <linuxtv@nzbaxters.com>) id 1P65nb-0000mx-40
	for linux-dvb@linuxtv.org; Wed, 13 Oct 2010 20:11:35 +0200
Received: from auth-1.ukservers.net ([217.10.138.154])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P65nY-000523-0T; Wed, 13 Oct 2010 20:11:32 +0200
Received: from wlgl04017 (203-97-171-185.cable.telstraclear.net
	[203.97.171.185])
	by auth-1.ukservers.net (Postfix smtp) with ESMTPA id C7E8B358F6B
	for <linux-dvb@linuxtv.org>; Wed, 13 Oct 2010 19:11:30 +0100 (BST)
Message-ID: <03343A8259204982822E355D4FA87F72@telstraclear.tclad>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 14 Oct 2010 07:11:26 +1300
MIME-Version: 1.0
Subject: Re: [linux-dvb] dm1105 scan but won't tune? [RESOLVED]
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

> OK, progress (idiot error?)
>
> My problem was OptusB1 requires a 45 degree skew on the LNB on the dish
> itself.
>
> So now I can do an szap as follows:
> TV3:12456:h:0:22500:512:650:1920
>
> ./szap -l 11300 -c channels-conf/dvb-s/OptusD1E160 TV3
> reading channels from file 'channels-conf/dvb-s/OptusD1E160'
> zapping to 1 'TV3':
> sat 0, frequency = 12456 MHz H, symbolrate 22500000, vpid = 0x0200, apid =
> 0x028a sid = 0x0780
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal cd82 | snr be5c | ber 0000ff00 | unc fffffffe |
> FE_HAS_LOCK
> status 1f | signal cd07 | snr be9e | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
> status 1f | signal cd07 | snr be4a | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
>
>
> New problem though - I can now no longer scan with the LNB skewed!!
> S 12456000 V 22500000 AUTO
> S 12456000 H 22500000 AUTO
>
> ./scan dvb-s/OptusB1-NZ -l 11300
> scanning dvb-s/OptusB1-NZ
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12456000 V 22500000 9
> initial transponder 12456000 H 22500000 9
>>>> tune to: 12456:v:0:22500
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:v:0:22500 (tuning failed)
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:h:0:22500
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:h:0:22500 (tuning failed)
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
>
> Any ideas?

Things to note when you install your own satellite dish and card:
1) Make sure you understand the LNB requirements for your satellite.  I
needed to skew mine on the dish by 45 degrees - wasted a lot of time getting
odd results from a vertically mounted LNB
2) Understand your LNB specs.  Mine had a 11300Mhz LSOF, which needed
allowance for when szapping, scanning and in VDR

My system:
Fedora 13 on a dual core intel platform.
combination of DVB-C (TT-1501 and TT-2300), PVR-500 and DVB-S (dm1105 based
and TT-1401) cards
Used on New Zealand cable TV, Freeview TV and Sky TV

my most recent fixes:
Use the '-r' switch in szap, to set the front end up for TS recording.
Use the '-l 11300' in szap to configure for the LNB
Use diseqc.conf file and "setup>LNB>DiSeqc ON" in VDR to set the LNB
settings




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
