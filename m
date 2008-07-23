Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1KLbyv-0004Rc-Ge
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 12:54:07 +0200
Received: from server42.ukservers.net (localhost.localdomain [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with ESMTP id C8F21A72E5
	for <linux-dvb@linuxtv.org>; Wed, 23 Jul 2008 11:53:30 +0100 (BST)
Received: from sy7608 (203-97-171-185.cable.telstraclear.net [203.97.171.185])
	by server42.ukservers.net (Postfix smtp) with SMTP id 93C3FA70AF
	for <linux-dvb@linuxtv.org>; Wed, 23 Jul 2008 11:53:29 +0100 (BST)
Message-ID: <003001c8ecb2$57b93af0$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
References: <008401c8ebe5$4e09ea90$450011ac@ad.sytec.com>
Date: Wed, 23 Jul 2008 22:53:27 +1200
MIME-Version: 1.0
Subject: Re: [linux-dvb] ANYONE?? 682Mhz problem with TT-1501 driver in
	v4l-dvb
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

Can anyone help??


> Hi - please help!!!!
>
> I have patched the v4l-dvb driver with Sigmund Augdal's changes to support
> C-1501.  I can't get channels to work on all but one frequency - 682Mhz.
> Frequencies which work:  578, 586, 594, 602, 610, 626, 634, 642, 666, 674
> Mhz.
>
> I have some channels at 674Mhz and at 682Mhz.  My initial is:
> # Initial Testing
> # freq sr fec mod
> # freq sr fec mod
> C 674000000 6900000 AUTO QAM64
> C 682000000 6900000 AUTO QAM64
>
>
> Scanning gives me:
> ./scan -A 2 test_initial
> initial transponder 674000000 6900000 9 3
> initial transponder 682000000 6900000 9 3
>>>> tune to: 674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64
> 0x0000 0x0321: pmt_pid 0x0029 T -- Sky Movies (running, scrambled)
> 0x0000 0x0322: pmt_pid 0x002a T -- Sky Movies Greats (running, scrambled)
> 0x0000 0x0323: pmt_pid 0x002b T -- Trackside (running, scrambled)
>>>> tune to: 682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0030
> WARNING: filter timeout pid 0x002d
> WARNING: filter timeout pid 0x0029
> WARNING: filter timeout pid 0x002f
> WARNING: filter timeout pid 0x002a
>
> -------------->>  What does this pid timeout mean??
>
>
>
> I end up with channels:
>
> Living
> Channel:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1309:1409:809
> UKTV:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1310:1410:810
> The Cheese:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:1420:820
> [0385]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:901
> [0386]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:902
> [0387]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1303:1403:903
> [0388]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:904
> [0389]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:905
>
>
> -------------->>  Has picked up the pids, but missing information??
>
>
>
> When I try and czap them, I get:
>
> [root@freddy scan]# czap -c ~/.channels.conf.tmp TV3
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/root/.channels.conf.tmp'
>  2 TV3:578000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1303:1403:1003
>  2 TV3: f 578000000, s 6900000, i 2, fec 9, qam 3, v 0x517, a 0x57b
> status 00 | signal 9090 | snr b9b9 | ber 000fffff | unc 00000032 |
> status 1f | signal e1e1 | snr f2f2 | ber 000005e8 | unc 000001ec |
> FE_HAS_LOCK
> status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal e1e1 | snr f3f3 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
>
> but with 682Mhz, I get a lock but loads of errors:
>
> [root@freddy scan]# czap -c ~/.channels.conf.tmp [0385]
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/root/.channels.conf.tmp'
>  1 [0385]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:901
>  1 [0385]: f 682000000, s 6900000, i 2, fec 9, qam 3, v 0, a 0
> status 03 | signal 8f8f | snr b9b9 | ber 000fffff | unc 00000032 |
> status 1f | signal cfcf | snr dcdc | ber 000005e8 | unc 000061a7 |
> FE_HAS_LOCK
> status 1f | signal cfcf | snr dcdc | ber 000005e8 | unc 000061e8 |
> FE_HAS_LOCK
> status 1f | signal cfcf | snr dede | ber 000006c0 | unc 00006234 |
> FE_HAS_LOCK
> status 1f | signal cfcf | snr e0e0 | ber 000006a9 | unc 0000627f |
> FE_HAS_LOCK
> status 1f | signal cfcf | snr dbdb | ber 000006a5 | unc 000062b6 |
> FE_HAS_LOCK
>
>
>
> Any ideas???
>


--------------------------------------------------------------------------------


> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
