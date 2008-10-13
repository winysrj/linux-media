Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KpWlo-0004vl-F4
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 01:24:14 +0200
Date: Tue, 14 Oct 2008 01:23:38 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <48F374D8.7000902@linuxtv.org>
Message-ID: <20081013232338.239630@gmx.net>
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
To: Steven Toth <stoth@linuxtv.org>, darron@kewl.org
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


Hi,

> Darron Broad wrote:
> > In message <48F36B32.5060006@linuxtv.org>, Steven Toth wrote:
> > 
> > hi.
> > 
> > <snip>
> >>> Hi guys,
> >>>
> >>> thank you Steve and Darron for your work on the repositories today!
> >>>
> >>> I have pulled the latest s2-mfe and retested with the HVR4000 on
> DVB-T, 
> >>> DVB-S, DVB-S2 and analogue TV. 
> >>>
> >>> No problems so far.
> >> I'm mutating the subject thread, and cc'ing the public mailing list
> into 
> >> this conversion. Now is the time to announce the intension to merge 
> >> multi-frontend patches, and show that we have tested and are satisfied 
> >> with it's reliability across many trees.
> >>
> >> (For those of you not familiar with the patch set, it adds 
> >> 'multiple-frontends to a single transport bus' support for the HVR3000 
> >> and HVR4000, and potentially another 7134 based design (the 6 way
> medion 
> >> board?).
> >>
> >> For my part, I was asked to test the cx23885 changes and I responded to
> >> that with a series of patches to fix some OOPS initialisation errors. 
> >> The MFE patches work correctly with the cx23885 tree now.
> >>
> >> Over time I've heard constant suggestions that the patches are ready
> for 
> >> merge, the cx88 and saa7134 trees are working correctly. Now is the
> time 
> >> that I need you all to announce this. I need you each in turn to 
> >> describe you testing, and state whether you think the patches are ready
> >> for merge.
> >>
> >> Hans Werner <HWerner4@gmx.de>
> >> darron@kewl.org
> > 
> > The test machine I have here utilises an HVR-4000 and AVERMEDIA
> > SUPER 007.
> > 
> > Multi-frontend works with both adapters with the HVR-4000 containing
> > analogue, DVB-S and DVB-T frontends, the AVERMEDIA solely DVB-T.
> > 
> > At this time with some further FM updates (see:
> http://hg.kewl.org/s2-mfe-fm/)
> > I can now reliably and consitently receive DVB-S/S2, DVB-T, analogue TV
> > and FM radio on the HVR-4000. DVB-T works on the AVERMEDIA as per
> > normal.
> > 

I have tested with the HVR4000 on many iterations of the MFE drivers and retested with
the latest s2-mfe tree yesterday. I found no problems for DVB-S, DVB-S2 (both QPSK
and PSK_8), DVB-T and analogue TV.

I will test the latest FM radio patch.

> > Applications which have been under test by include the command
> > line dvb-utils, dvbtraffic, dvbsnoop, GUI apps kaffeine and
> > mythtv. No obvious side effects have been witnessed of using
> > MFE and the applications themselves do not see any difference
> > except that they are unable to simultaneously open multiple
> > frontends due to the hardware limitation of such cards.

I tested with Kaffeine with a version of Christophe's S2API patch. It recognises both
S/S2 and T frontends on startup, and reliably scans S/S2 and T channels and tunes
between channels. I have at various times done some testing with MythTV, VDR,
Steve's tune.c and Igor's szap-s2. Apps see two normal frontends but should not hold both
open as Darron said. Closing and opening frontends as necessary seems to work cleanly
from the userspace point of view.

> > 
> > A couple of problems exist which may be present in all hybrid cards
> > is that you are able to concurrently open analogue and DVB-T where
> > these share the same tuner section. Another issue with shared
> > tuners is where both analogue and digital sections share a sleep
> > method which in some circumstances is incompatible.
> 
> Some common hybrid issues we've seen across many cards, regardless of MFE.

It seems relatively benign : if you run say kaffeine and tvtime together, either a DVB-T
or an analogue channel is shown (the other is blank) but neither app crashes and either
takes over on a tune action.

> 
> > 
> > At this time I am happy with the performance of this MFE card
> > (HVR-4000) and to be honest, I am looking at attending to other
> > activities. Bugs where present ought to be picked up by others,
> > I have done all that has been reasonable to test and determine
> > that MFE works.

I am also happy with the performance of the card with the MFE driver and would 
like to see it released. It is in daily use in my household without any trouble.

Hans

> 
> Thanks Darron.
> 
> - Steve

-- 
Release early, release often.

GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/wasistshortview.php?mc=sv_ext_mf@gmx

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
