Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Kqe14-0001Gn-2z
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 03:20:35 +0200
Date: Fri, 17 Oct 2008 03:20:00 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081013232338.239630@gmx.net>
Message-ID: <20081017012000.66050@gmx.net>
MIME-Version: 1.0
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48CE7838.2060702@linuxtv.org> <23602.1221904652@kewl.org>
	<48D51000.3060006@linuxtv.org> <25577.1221924224@kewl.org>
	<20080921234339.18450@gmx.net> <8002.1222068668@kewl.org>
	<20080922124908.203800@gmx.net> <10822.1222089271@kewl.org>
	<48D7C15E.5060509@linuxtv.org> <20080922164108.203780@gmx.net>
	<20022.1222162539@kewl.org> <20080923142509.86330@gmx.net>
	<4025.1222264419@kewl.org> <4284.1222265835@kewl.org>
	<20080925145223.47290@gmx.net> <18599.1222354652@kewl.org>
	<Pine.LNX.4.64.0809261117150.21806@trider-g7>	<21180.1223610119@kewl.org>
	<20081010132352.273810@gmx.net> <48EF7E78.6040102@linuxtv.org>
	<30863.1223711672@kewl.org> <48F0AA35.6020005@linuxtv.org>
	<773.1223732259@kewl.org> <48F0AEA3.50704@linuxtv.org>
	<989.1223733525@kewl.org> <48F0B6C5.5090505@linuxtv.org>
	<1506.1223737964@kewl.org> <48F0E516.303@linuxtv.org>
	<20081011190015.175420@gmx.net> <48F36B32.5060006@linuxtv.org>
	<20744.1223914043@kewl.org> <48F374D8.7000902@linuxtv.org>
	<20081013232338.239630@gmx.net>
To: "Hans Werner" <HWerner4@gmx.de>, darron@kewl.org, stoth@linuxtv.org
Cc: fabbione@fabbione.net, linux-dvb@linuxtv.org, scarfoglio@arpacoop.it
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
 Re: [PATCH] S2API: add multifrontend
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

> > >> darron@kewl.org
> > > 
> > > The test machine I have here utilises an HVR-4000 and AVERMEDIA
> > > SUPER 007.
> > > 
> > > Multi-frontend works with both adapters with the HVR-4000 containing
> > > analogue, DVB-S and DVB-T frontends, the AVERMEDIA solely DVB-T.
> > > 
> > > At this time with some further FM updates (see:
> > http://hg.kewl.org/s2-mfe-fm/)
> > > I can now reliably and consitently receive DVB-S/S2, DVB-T, analogue
> TV
> > > and FM radio on the HVR-4000. DVB-T works on the AVERMEDIA as per
> > > normal.
> > > 
> 
> I have tested with the HVR4000 on many iterations of the MFE drivers and
> retested with
> the latest s2-mfe tree yesterday. I found no problems for DVB-S, DVB-S2
> (both QPSK
> and PSK_8), DVB-T and analogue TV.
> 
> I will test the latest FM radio patch.

Just an update on this: I have now tested Darron's latest FM radio patch from
with the HVR4000 and it is working well for me. I have the FMD1216MEX tuner
variant of this card.

I am tuning the radio with fm-tools and playing sound with ALSA arecord and aplay
(standard distro versions, no changes necessary). Tuning takes around 2 seconds.
Sound is heard in stereo.

Regards,
Hans


-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
