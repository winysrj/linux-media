Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KrGcC-00019I-Fa
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 20:33:30 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1242673wfd.17
	for <linux-dvb@linuxtv.org>; Sat, 18 Oct 2008 11:33:22 -0700 (PDT)
Message-ID: <854d46170810181133x13e44446g31dc02422446911d@mail.gmail.com>
Date: Sat, 18 Oct 2008 20:33:22 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200810181714.52505.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200810181405.42620.dkuhlen@gmx.net>
	<854d46170810180708l5d109c9chdd97399f2f3c60e0@mail.gmail.com>
	<200810181714.52505.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API pctv452e stb0899 simples2apitune
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

>> Dominik are you too facing packet losses from TS?
> Not in the streams i have tested so far.
> how often and on which channels do you get errors?
> what is the SNR for them?

I get image distortions on all channels.
I have tested with vdr, kaffeine and szap-s2 + mplayer/vlc/xine.

Is the same problem we had before back in February/March and then you
fixed in the final release.

[faruk@archer szap-s2]$ ./szap-s2 -r -p -V -c ~/.vdr/channels.conf -n 115
reading channels from file '/home/faruk/.vdr/channels.conf'
zapping to 115 'FOLKLOR TV;EUTELSAT':
delivery DVB-S, modulation QPSK
sat 0, frequency 11304 MHz V, symbolrate 30000000, coderate auto, rolloff auto
vpid 0x0dc1, apid 0x0dc2, sid 0x0005
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 011e | snr 0080 | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal 0122 | snr 007f | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal 011e | snr 007e | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal 0122 | snr 0081 | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal 0122 | snr 0080 | ber 00000000 | unc fffffffe | FE_HAS_LOCK

[faruk@archer ~]$ femon
FE: STB0899 Multistandard (DVBS)
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 011e | snr 008a | ber 00000000 | unc bff876cc |
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 0122 | snr 0087 | ber 00000000 | unc bff876cc |
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 011e | snr 0087 | ber 00000000 | unc bff876cc |
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 0122 | snr 008c | ber 00000000 | unc bff876cc |
FE_HAS_LOCK

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
