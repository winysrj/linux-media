Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1JvRpR-0007ev-I9
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 08:48:14 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1785769fga.25
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 23:48:05 -0700 (PDT)
Message-ID: <4827E81A.1080807@gmail.com>
Date: Mon, 12 May 2008 08:47:54 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>		<200805101717.23199@orion.escape-edv.de>		<200805101727.55810@orion.escape-edv.de>		<1210456421.7632.29.camel@palomino.walls.org>	<48261EB5.2090604@gmail.com>	<1210463068.7632.102.camel@palomino.walls.org>	<48268EB9.6060000@gmail.com>
	<4827851D.2000104@gmx.net>
In-Reply-To: <4827851D.2000104@gmx.net>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
 stv0297
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

P. van Gaans schrieb:
> Not necessarily. Here some femon output from my Technotrend T-1500:
> 
> status SCVYL | signal  54% | snr  99% | ber 188 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 230 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 240 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 228 | unc 21 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 248 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 280 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK
...
> I see the standalones hickup as well. So a very short 
> error will cause unc, but no higher BER.

You may not see a higher BER, because the corrupted signal doesn't hit the BER measuring 
period. Femon asks every 1 second for new values. The UNC counting interval is this 1 
second, but the BER measuring interval is shorter (50..200ms). For a stv0297, it is 150ms 
for QAM256 modulation and 200ms for QAM64. The real measuring interval for the BER is a 
fixed number of bits.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
