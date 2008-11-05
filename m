Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kxo4m-0006Tr-Af
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 20:30:01 +0100
From: Darron Broad <darron@kewl.org>
To: Steve Thro <stevthro@hotmail.fr>
In-reply-to: <BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl> 
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
	<14964.1225909409@kewl.org>
	<BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>
	<15308.1225910609@kewl.org>
	<BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl>
Date: Wed, 05 Nov 2008 19:29:56 +0000
Message-ID: <15933.1225913396@kewl.org>
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

In message <BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl>, Steve Thro wrote:

lo

>> Ok. I just tested here:
>>=20
>>> szap-s2 -x -c ./channels.conf "BSkyB Discovery HD"
>> reading channels from file './channels.conf'
>> zapping to 975 'BSkyB Discovery HD':
>> delivery DVB-S2=2C modulation QPSK
>> sat 1=2C frequency 12324 MHz V=2C symbolrate 29500000=2C coderate 3/4=2C =
>rolloff 0.35
>> vpid 0x0202=2C apid 0x1fff=2C sid 0x0edb
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> status 1f | signal d200 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
>_LOCK
>>=20
>> it seems to work.
>
>There are some difference between your output and mine:
>yours:
>rolloff 0.35
>sid 0x0edb
>
>mine=3B
>rolloff auto
>sid 0x0000
>
>
>Could you post your channels.conf?

you can roll your own if you have a universal LNB ?

hg clone http://hg.kewl.org/xmldvb/

refer to the README file for setup and use. this util is only 3
days old so is mostly untested.

BTW, If you don't have universal LNB then please forward a patch :-)
I can e-mail my conf seperately in any case but it's not VDR ? is
that ok ?

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
