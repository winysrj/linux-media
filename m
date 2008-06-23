Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KAqYd-0007OT-AC
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 20:14:28 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id 6CF6819E6508
	for <linux-dvb@linuxtv.org>; Mon, 23 Jun 2008 22:13:53 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id EBCD619E6359
	for <linux-dvb@linuxtv.org>; Mon, 23 Jun 2008 22:13:52 +0400 (MSD)
Date: Mon, 23 Jun 2008 22:18:51 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080623221851.3b0599e9@bk.ru>
In-Reply-To: <loom.20080623T150749-54@post.gmane.org>
References: <18643.82.95.219.165.1214055480.squirrel@webmail.xs4all.nl>
	<loom.20080623T150749-54@post.gmane.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] s2-3200 fec problem?
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

I have the hvr4000 card with vdr 170 + multiproto_Plus + hvr4000 patch from Gregoire and I don't have any reception problem
with dvb-s2 channels on Astar 19.2E  The LOCK on dvb-s2 channels is very fast and stable.

CINE PREMIER HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:160:0;82=fra,83=eng:0:100:9301:1:1110:0
13EME RUE HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:161:0;86=fra:0:100:9302:1:1110:0
DISNEY MAGIC HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:162:0;90=fra,91=eng:0:100:9303:1:1110:0
M6 HD;CSAT:12580:vC23M5O35S1:S19.2E:22000:170:0;122=fra:0:100:9310:1:1110:0
CANAL+ HI-TECH HD;CSAT:12522:vC23M5O35S1:S19.2E:22000:160:0;82=fra,83=eng:0:100:9201:1:1106:0
NATIONAL GEO HD;CSAT:12522:vC23M5O35S1:S19.2E:22000:161:0;86=fra:0:100:9202:1:1106:0
TF1 HD;CSAT:12522:vC23M5O35S1:S19.2E:22000:163:0;94=fra:0:100:9204:1:1106:0
CANAL HD TEST 3;IMEDIA:12522:vC23M5O35S1:S19.2E:22000:164+163:0;98=fra,99=eng:0:100:9220:1:1106:0
ORF 1 HD;ORF:10832:HO0S0:S19.2E:22000:1920:1921=deu,1922=eng;1923=deu:1925:D05,1702,1801:61920:1:1057:0
ASTRA HD+;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1279:0;1283=deu:0:0:131:133:6:0
PREMIERE HD,PREM HD;PREMIERE:11914:hC910I1M2O35S1:S19.2E:27500:767:0;771=deu,772=eng:32:1830,1833,9C4,1801:129:133:6:0
DISCOVERY HD,DISC HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:1023:0;1027=deu:32:1830,1833,9C4,1801:130:133:6:0
ANIXE HD;BetaDigital:11914:hC910I1M2O35S1:S19.2E:27500:1535:0;1539=deu:0:0:132:133:6:0


> > I know the following (Swedish, but we all speak code!) guide seems to work:
> > 
> >http://www.minhembio.com/forum/index.php?s=344f35e74353fb173446a5c7d3250854&showtopic=172770&st=30&start=30
> >  
> > It's a combine of multiproto and the mantis or v4l tree if I've got it
> > right. The last revisions of multiproto didn't seem to work for me (a lot
> > of lock problems on DVB-S2 transponders with H264 channles). I have to use
> > the revisions from March to get it working.
> > 
> > 
> > Niels Wagenaar
> > 
> 
> 
> I am the one who put those guidelines in swedish together and can report that
> they don't work at this moment since they changed the fec from 2/3 to 3/4 and
> turned pilot of on the DVB-S2 channels with 8PSK modulation.
> Niels, do you have any DVB-S2 channels with 8PSK modulation and fec 3/4 or
> higher that you could try to get a lock on? Becuse the channels with QPSK
> modulation all seem to work.
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
