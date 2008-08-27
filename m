Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KYKZf-00070N-7j
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 14:56:37 +0200
Date: Wed, 27 Aug 2008 14:56:01 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20080826201530.47fd3bb7@bk.ru>
Message-ID: <20080827125601.62260@gmx.net>
MIME-Version: 1.0
References: <200808252156.52323.ajurik@quick.cz>
	<E1KXq2s-0007z3-00.goga777-bk-ru@f25.mail.ru>	<1219735725.3886.6.camel@HTPC>
	<20080826201530.47fd3bb7@bk.ru>
To: Goga777 <goga777@bk.ru>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for VDR
	1.7.0
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


> could you show your logs from szap2 
> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/szap2/
> 
> hereafter is my logs with channels.conf and szap2 from Igor
> 
> goga:/usr/src/szap2# ./szap2 -c19 -H -S1 -C910 -M2 -n5
> reading channels from file '19'
> zapping to 5 'ASTRA HD+;BetaDigital':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11914 MHz H, symbolrate 27500000, coderate 9/10, rolloff
> 0.35
> vpid 0x04ff, apid 0x1fff, sid 0x0000
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal  96% | snr  41% | ber 0 | unc 0 | FE_HAS_LOCK
> status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
> status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
> status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
> status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
> 
> channels.conf for vdr 170 and szap2 from Igor
> 
> ORF 1
> HD;ORF:10832:hC56M2O0S0:S19.2E:22000:1920:1921=deu,1922=eng;1923=deu:1925:D05,1702,1801,648,D95,9C4,1833:61920:1:1057:0
> ANIXE
> HD;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1535:0;1539=deu:0:0:132:133:6:0
> arte
> HD;ZDFvision:11361:hC23M5O0S1:S19.2E:22000:6210:6221=deu,6222=fra:6230:0:11120:1:1011:0
> ASTRA
> HD+;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1279:0;1283=deu:0:0:131:133:6:0
> PREMIERE HD,PREM
> HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:767:0;771=deu,772=eng:32:1830,1831,1833,1834,9C4,1801:129:133:6:0
> DISCOVERY HD,DISC
> HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:1023:0;1027=deu:32:1830,1831,1833,1834,9C4,1801:130:133:6:0
> CINE PREMIER
> HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:160:0;82=fra,83=eng:0:100:9301:1:1110:0
> 13EME RUE
> HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:161:0;86=fra:0:100:9302:1:1110:0

Goga,
as you can see in your own log above, szap2 does not correctly parse the APID and SID from 
your channels.conf file. This does matter if you want to use the szap2 -p option [add pat and pmt
to TS recording (which also implies the -r option)]. get_pmt_pid does not get the correct
value.

The following channels.conf.fixed works better (format VPID:APID:SID) , but perhaps it would
be best to fix the parsing in szap2 instead.

ANIXE HD:11914:hC910M2O35S1:S19.2E:27500:1535:1539:132:133:6:0
arte HD:11361:hC23M5O0S1:S19.2E:22000:6210:6221:11120:1:1011:0
ASTRA HD+:11914:hC910M2O35S1:S19.2E:27500:1279:1283:131:133:6:0

$ szap2 -c ~/channels.conf.fixed -H -p -n3

reading channels from file '/home/hans/channels.conf.fixed'
zapping to 3 'ASTRA HD+':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11914 MHz H, symbolrate 27500000, coderate 9/10, rolloff 0.35
vpid 0x04ff, apid 0x0503, sid 0x0083
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
** get_pmt_pid returned : 100
status 1f | signal  77% | snr  50% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  77% | snr  50% | ber 0 | unc 0 | FE_HAS_LOCK
...

then watch the channel with:
$ mplayer - < /dev/dvb/adapter0/dvr0

Hans
-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
