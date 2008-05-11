Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1JvLF1-0007Qn-7Q
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 01:46:08 +0200
Message-ID: <4827851D.2000104@gmx.net>
Date: Mon, 12 May 2008 01:45:33 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <482560EB.2000306@gmail.com>		<200805101717.23199@orion.escape-edv.de>		<200805101727.55810@orion.escape-edv.de>		<1210456421.7632.29.camel@palomino.walls.org>	<48261EB5.2090604@gmail.com>	<1210463068.7632.102.camel@palomino.walls.org>
	<48268EB9.6060000@gmail.com>
In-Reply-To: <48268EB9.6060000@gmail.com>
Cc: linux-dvb@linuxtv.org
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

On 05/11/2008 08:14 AM, Manu Abraham wrote:
>>> Absolute errors are used very scantily, but have been used to see how
>>> good/bad the whole system is.
>> Except for in safety critical systems (fire suppression system,
>> automobile brakes, etc.), how can a "good/bad" determination based on an
>> error count be separated from a time interval over which that error
>> count occurred?
> 
> 
> It defines whether the FEC engine worked as expected. eg: Just looking
> at a UNC counter counting up with a high BER shows a bad channel.
> looking at a UNC counter going up with a low BER shows a bad error
> correction scheme. looking at a very low BER and a high number of
> uncorrectables imply a bad FEC engine/scheme.

Not necessarily. Here some femon output from my Technotrend T-1500:

status SCVYL | signal  54% | snr  99% | ber 188 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 230 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 240 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 228 | unc 21 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 248 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 280 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK

Nothing special for the BER levels, just a fairly good signal (need to 
get into tens of thousands before it drops). But there, all of a sudden, 
unc 21 (meaning the picture gets garbled for a moment). I still don't 
know who or what is bullying me with those, but it seems to be caused by 
sparks. I sometimes get it when I flick a light on or off. At night I 
usually don't get these much (or not at all!), in the weekends usually 
have less as well. At day, and especially in the evening though, 
disaster (several each hour or even minute). It's no fault in the shemes 
or FEC engine, I see the standalones hickup as well. So a very short 
error will cause unc, but no higher BER.

P.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
