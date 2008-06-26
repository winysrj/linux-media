Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KBxXC-0004q8-3w
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 21:53:35 +0200
Date: Thu, 26 Jun 2008 23:58:12 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080626235812.7c969a03@bk.ru>
In-Reply-To: <200806211920.25821.ajurik@quick.cz>
References: <200805122042.43456.ajurik@quick.cz>
	<200806211552.41278.ajurik@quick.cz>
	<200806211840.47025.dkuhlen@gmx.net>
	<200806211920.25821.ajurik@quick.cz>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
 with TT S2-3200/linux
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

> > The other 13.0 8PSK (11278V and 11449H) are tougher:  they take a few
> > seconds to lock and sometimes they don't lock at all according to the NIT
> > they use roll-off factor 0.2 (the other channels use 0.35) This is
> > interesting: I'll check why this takes so much longer
> 
> Yes, these transponders are those I couldn't lock. Other transponders with the 
> same problem are transponders from Thor5 (0.8W) - 11341MHz V, 11421MHz H, 
> 11434MHz V, 12015MHz H and 12128MHz H. 
> 
> Changig RollOff to any value didn't get me any result.

with my hvr4000 card and vdr 170 I could lock these and other dvb-s2 channels from 13e without any problem

ESP HD Russian;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3204=rus:0:500,B00,1803,100:13064:318:400:0
ESP HD Dutch;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3205=ndl:0:0:13065:318:400:0
ESP HD Czech;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3206=CZK:0:500,B00,1803,100:13066:318:400:0
ESP HD German;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3207=deu;3208=deu:0:500,B00,1803,100:13067:318:400:0
ESP HD Portuguese;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3209=por:0:500,B00,1803,100:13069:318:400:0
ESP HD Polish;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3210=pol:0:500,B00,1803,100:13070:318:400:0
ESP HD Hungarian;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3211=hun:0:500,B00,1803,100:13071:318:400:0
ESP HD Spanish;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:3000:3212=esl:0:500,B00,1803,100:13072:318:400:0
EUSP PL AUDIO;CYFRA +:11278:vC23M5O35S1:S13.0E:27500:0:407=pol:0:0:13035:318:400:0
Nsport 58;ITI:11258:hC23M5O35S1:S13.0E:27500:518:0;718=pol:0:B01:15107:318:1400:0
Nsport 59;TVN:11258:hC23M5O35S1:S13.0E:27500:525:0;725=pol:0:B01:15114:318:1400:0
HBO HD;ITI:11258:hC23M5O35S1:S13.0E:27500:536:0;736=pol,636=eng:0:B01:15201:318:1400:0
nSport;ITI:11449:hC23M5O35S1:S13.0E:27500:530:730=pol:0:B01:15033:318:1300:0
Wojna i Pokoj;ITI:11449:hC23M5O35S1:S13.0E:27500:512:0;712=pol,612=rus:0:B01:15001:318:1300:0
nTalk;ITI:11449:hC23M5O35S1:S13.0E:27500:513:0;613=pol,713=eng:0:B01:15002:318:1300:0
TVN Lingua;ITI:11449:hC23M5O35S1:S13.0E:27500:514:0;714=pol:0:B01:15003:318:1300:0
MGM;ITI:11449:hC23M5O35S1:S13.0E:27500:528:728=pol;628=eng:0:B01:15031:318:1300:0
Discovery HD;ITI:11449:hC23M5O35S1:S13.0E:27500:529:0;729=pol:0:0:15032:318:1300:0
Initial;ITI:11449:hC23M5O35S1:S13.0E:27500:519:0:0:0:15100:318:1300:0
FILMBOX HD;ITI:11449:hC23M5O35S1:S13.0E:27500:531:0;731=pol,631=cze:0:B01:15034:318:1300:0
TVP 1;ITI:11258:hC23M5O35S1:S13.0E:27500:512:0;712=pol:576:B01:15101:318:1400:0
TVP 2;ITI:11258:hC23M5O35S1:S13.0E:27500:513:0;713=pol:577:B01:15102:318:1400:0
TVP 3;ITI:11258:hC23M5O35S1:S13.0E:27500:514:0;714=pol:578:B01:15103:318:1400:0
TVP Sport;ITI:11258:hC23M5O35S1:S13.0E:27500:517:0;717=pol:0:B01:15106:318:1400:0
Sport Klub +;ITI:11258:hC23M5O35S1:S13.0E:27500:519:0;719=pol:0:B01:15108:318:1400:0
Cartoon TCM;ITI:11258:hC23M5O35S1:S13.0E:27500:520:0;720=pol:0:B01:15109:318:1400:0
Sport Klub;ITI:11258:hC23M5O35S1:S13.0E:27500:521:0;721=pol:0:B01:15110:318:1400:0
TVN Med;TVN:11258:hC23M5O35S1:S13.0E:27500:522:0;722=pol:599:B01:15111:318:1400:0
MTV2;ITI:11258:hC23M5O35S1:S13.0E:27500:523:0;723=pol:0:B01:15112:318:1400:0
NASN;TVN:11258:hC23M5O35S1:S13.0E:27500:524:724=eng:0:B01:15113:318:1400:0
Boomerang;ITI:11258:hC23M5O35S1:S13.0E:27500:526:0;726=pol:0:B01:15115:318:1400:0
Cinemax 1;ITI:11258:hC23M5O35S1:S13.0E:27500:527:0;727=pol:0:B01:15116:318:1400:0
Cinemax 2;ITI:11258:hC23M5O35S1:S13.0E:27500:528:0;728=pol:0:B01:15117:318:1400:0
KidsCo;ITI:11258:hC23M5O35S1:S13.0E:27500:529:0;729=pol:0:B01:15118:318:1400:0
DA VINCI;ITI:11258:hC23M5O35S1:S13.0E:27500:530:0;730=pol:0:B01:15119:318:1400:0
OTV;ITI:11258:hC23M5O35S1:S13.0E:27500:531:0;731=pol:0:B01:15120:318:1400:0
Jetix;ITI:11258:hC23M5O35S1:S13.0E:27500:532:0;732=pol:0:B01:15121:318:1400:0
ITVN EU;ITI:11258:hC23M5O35S1:S13.0E:27500:535:735=pol:600:B01:15124:318:1400:0
R1;ITI:11258:hC23M5O35S1:S13.0E:27500:0:0;741=pol:0:B01:15131:318:1400:0
R2;ITI:11258:hC23M5O35S1:S13.0E:27500:0:0;742=pol:0:B01:15132:318:1400:0
SKY Sport HD 1;SkyItalia:11996:vC23M5O35S1:S13.0E:27500:164:0;416=ita,417=eng:0:919,93B:11020:64511:6400:0
Next HD;SkyItalia:11996:vC23M5O35S1:S13.0E:27500:160:0;400=ita,401=eng:0:919,93B:11030:64511:6400:0
SKY Cinema HD;SkyItalia:11996:vC23M5O35S1:S13.0E:27500:161:0;404=ita,405=eng:0:919,93B:11031:64511:6400:0
NationalGeo HD;SkyItalia:11996:vC23M5O35S1:S13.0E:27500:163:0;412=ita,413=eng:0:919,93B:11032:64511:6400:0
SKY Sport HD 2;SkyItalia:11996:vC23M5O35S1:S13.0E:27500:165:0;420=eng,421=ita:0:919,93B:11033:64511:6400:0



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
