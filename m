Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.elion.ee ([88.196.160.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1Kpha6-0005jP-Cl
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 12:56:53 +0200
Message-ID: <48F47ACE.5060807@gmail.com>
Date: Tue, 14 Oct 2008 13:56:14 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: klaas de waal <klaas.de.waal@gmail.com>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>	<1223598995.4825.12.camel@pc10.localdom.local>	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>	<48F3A113.50805@gmail.com>
	<7b41dd970810140027h41924a98oe343fb5d8c2ef485@mail.gmail.com>
In-Reply-To: <7b41dd970810140027h41924a98oe343fb5d8c2ef485@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
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

klaas de waal wrote:
> Question: which provider do you have?
I have local cable provider Starman.

> 
> Assuming you use "zap" to tune, you have a configuration file like this 
> (valid for some Dutch UPC regio's):
> Ned1:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2001:2012:12141
> Ned2:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2301:2312:12142
> Ned3:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2601:2612:12143

Sample of my channels.conf:
TV3:386000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:703:803:1003
ETV:386000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:704:804:1001
Kanal11:386000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:58:769:1006

I have 2 dvb-c cards KNC1 and Technotrend C-1501. KNC1 works flawlessly on all 
frequency's  with same channels.conf

It strange that at some time czap has lock, but picture missing.

C-1501:
~/szap# czap -a3 -c /root/szap/Starman TV3
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/root/szap/Starman'
   1 TV3:386000000:INVERSION_AUTO:6875000:FEC_AUTO:QAM_64:703:803:1003
   1 TV3: f 386000000, s 6875000, i 2, fec 9, qam 3, v 0x2bf, a 0x323
status 00 | signal 8f8f | snr b8b8 | ber 000fffff | unc 00000027 |
status 00 | signal 8f8f | snr b6b6 | ber 000fffff | unc 00000027 |
status 00 | signal 8f8f | snr b5b5 | ber 000fffff | unc 00000028 |
status 00 | signal 8f8f | snr b7b7 | ber 000fffff | unc 00000027 |
status 00 | signal 8f8f | snr b8b8 | ber 000fffff | unc 00000027 |
status 00 | signal 8f8f | snr b6b6 | ber 000fffff | unc 00000027 |
status 1f | signal e7e7 | snr e4e4 | ber 000fffff | unc 0000022e | FE_HAS_LOCK
status 1f | signal e7e7 | snr ecec | ber 0000000c | unc 00000000 | FE_HAS_LOCK
status 1f | signal e7e7 | snr eaea | ber 00000009 | unc 000009f3 | FE_HAS_LOCK
status 1f | signal e7e7 | snr eded | ber 00000009 | unc 00000000 | FE_HAS_LOCK
status 1f | signal e7e7 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal e7e7 | snr eded | ber 00000000 | unc 00000000 | FE_HAS_LOCK

KNC1:
~/szap# czap -a2 -c /root/szap/Starman TV3
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/root/szap/Starman'
   1 TV3:386000000:INVERSION_AUTO:6875000:FEC_AUTO:QAM_64:703:803:1003
   1 TV3: f 386000000, s 6875000, i 2, fec 9, qam 3, v 0x2bf, a 0x323
status 1f | signal 7d7d | snr f6f6 | ber 00000000 | unc 0000003b | FE_HAS_LOCK
status 1f | signal 7d7d | snr f6f6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7d7d | snr f6f6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7d7d | snr f5f5 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7d7d | snr f6f6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7d7d | snr f6f6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK



Thank You for response.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
