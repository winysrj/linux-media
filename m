Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KY13j-0000xh-Co
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 18:06:20 +0200
Date: Tue, 26 Aug 2008 20:15:30 +0400
From: Goga777 <goga777@bk.ru>
To: Marek Hajduk <hajduk@francetech.sk>
Message-ID: <20080826201530.47fd3bb7@bk.ru>
In-Reply-To: <1219735725.3886.6.camel@HTPC>
References: <200808252156.52323.ajurik@quick.cz>
	<E1KXq2s-0007z3-00.goga777-bk-ru@f25.mail.ru>
	<1219735725.3886.6.camel@HTPC>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

> I have to confirm that with latest liplianindvb drivers I can't see
> Anixe HD, Premiere HD and discovery HD on Astra 19.2E.
> 
> Rest of channels are without problem.

could you show your logs from szap2 
http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/szap2/

hereafter is my logs with channels.conf and szap2 from Igor

goga:/usr/src/szap2# ./szap2 -c19 -H -S1 -C910 -M2 -n5
reading channels from file '19'
zapping to 5 'ASTRA HD+;BetaDigital':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11914 MHz H, symbolrate 27500000, coderate 9/10, rolloff 0.35
vpid 0x04ff, apid 0x1fff, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal  96% | snr  41% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  96% | snr  42% | ber 0 | unc 0 | FE_HAS_LOCK

channels.conf for vdr 170 and szap2 from Igor

ORF 1 HD;ORF:10832:hC56M2O0S0:S19.2E:22000:1920:1921=deu,1922=eng;1923=deu:1925:D05,1702,1801,648,D95,9C4,1833:61920:1:1057:0
ANIXE HD;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1535:0;1539=deu:0:0:132:133:6:0
arte HD;ZDFvision:11361:hC23M5O0S1:S19.2E:22000:6210:6221=deu,6222=fra:6230:0:11120:1:1011:0
ASTRA HD+;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1279:0;1283=deu:0:0:131:133:6:0
PREMIERE HD,PREM HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:767:0;771=deu,772=eng:32:1830,1831,1833,1834,9C4,1801:129:133:6:0
DISCOVERY HD,DISC HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:1023:0;1027=deu:32:1830,1831,1833,1834,9C4,1801:130:133:6:0
CINE PREMIER HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:160:0;82=fra,83=eng:0:100:9301:1:1110:0
13EME RUE HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:161:0;86=fra:0:100:9302:1:1110:0
 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
