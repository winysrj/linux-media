Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KxnLp-0003U9-Cd
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 19:43:34 +0100
From: Darron Broad <darron@kewl.org>
To: Steve Thro <stevthro@hotmail.fr>
In-reply-to: <BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl> 
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
	<14964.1225909409@kewl.org>
	<BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>
Date: Wed, 05 Nov 2008 18:43:29 +0000
Message-ID: <15308.1225910609@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] no lock on 3/4 with cx24116
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>, Steve Thro wrote:

Lo

>
>> I don't know what a s2-liplianin-8c4f85bfc115 driver is but
>
>It's the latest one from http://mercurial.intuxication.org/hg/s2-liplianin
>
>> if you apply this patch:
>> http://hg.kewl.org/v4l-dvb/raw-rev/8d6d8974b33d=20
>applied with no reject
>
>> then it may solve your problem?
>
>Same problem no lock :(

Ok. I just tested here:

> szap-s2 -x -c ./channels.conf "BSkyB Discovery HD"
reading channels from file './channels.conf'
zapping to 975 'BSkyB Discovery HD':
delivery DVB-S2, modulation QPSK
sat 1, frequency 12324 MHz V, symbolrate 29500000, coderate 3/4, rolloff 0.35
vpid 0x0202, apid 0x1fff, sid 0x0edb
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal d200 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

it seems to work.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
