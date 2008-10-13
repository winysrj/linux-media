Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Darron Broad <darron@kewl.org>
To: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48F36B32.5060006@linuxtv.org> 
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48CD87B1.5010702@linuxtv.org> <20080915121606.111520@gmx.net>
	<48CE7838.2060702@linuxtv.org> <23602.1221904652@kewl.org>
	<48D51000.3060006@linuxtv.org> <25577.1221924224@kewl.org>
	<20080921234339.18450@gmx.net> <8002.1222068668@kewl.org>
	<20080922124908.203800@gmx.net> <10822.1222089271@kewl.org>
	<48D7C15E.5060509@linuxtv.org> <20080922164108.203780@gmx.net>
	<20022.1222162539@kewl.org> <20080923142509.86330@gmx.net>
	<4025.1222264419@kewl.org> <4284.1222265835@kewl.org>
	<20080925145223.47290@gmx.net> <18599.1222354652@kewl.org>
	<Pine.LNX.4.64.0809261117150.21806@trider-g7>
	<21180.1223610119@kewl.org> <20081010132352.273810@gmx.net>
	<48EF7E78.6040102@linuxtv.org> <30863.1223711672@kewl.org>
	<48F0AA35.6020005@linuxtv.org> <773.1223732259@kewl.org>
	<48F0AEA3.50704@linuxtv.org> <989.1223733525@kewl.org>
	<48F0B6C5.5090505@linuxtv.org> <1506.1223737964@kewl.org>
	<48F0E516.303@linuxtv.org> <20081011190015.175420@gmx.net>
	<48F36B32.5060006@linuxtv.org>
Date: Mon, 13 Oct 2008 17:07:23 +0100
Message-ID: <20744.1223914043@kewl.org>
Cc: Hans Werner <HWerner4@gmx.de>, fabbione@fabbione.net,
	linux-dvb <linux-dvb@linuxtv.org>, scarfoglio@arpacoop.it
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
	Re: [PATCH] S2API: add multifrontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <48F36B32.5060006@linuxtv.org>, Steven Toth wrote:

hi.

<snip>
>> 
>> Hi guys,
>> 
>> thank you Steve and Darron for your work on the repositories today!
>> 
>> I have pulled the latest s2-mfe and retested with the HVR4000 on DVB-T, 
>> DVB-S, DVB-S2 and analogue TV. 
>> 
>> No problems so far.
>
>I'm mutating the subject thread, and cc'ing the public mailing list into 
>this conversion. Now is the time to announce the intension to merge 
>multi-frontend patches, and show that we have tested and are satisfied 
>with it's reliability across many trees.
>
>(For those of you not familiar with the patch set, it adds 
>'multiple-frontends to a single transport bus' support for the HVR3000 
>and HVR4000, and potentially another 7134 based design (the 6 way medion 
>board?).
>
>For my part, I was asked to test the cx23885 changes and I responded to 
>that with a series of patches to fix some OOPS initialisation errors. 
>The MFE patches work correctly with the cx23885 tree now.
>
>Over time I've heard constant suggestions that the patches are ready for 
>merge, the cx88 and saa7134 trees are working correctly. Now is the time 
>that I need you all to announce this. I need you each in turn to 
>describe you testing, and state whether you think the patches are ready 
>for merge.
>
>Hans Werner <HWerner4@gmx.de>
>darron@kewl.org

The test machine I have here utilises an HVR-4000 and AVERMEDIA
SUPER 007.

Multi-frontend works with both adapters with the HVR-4000 containing
analogue, DVB-S and DVB-T frontends, the AVERMEDIA solely DVB-T.

At this time with some further FM updates (see: http://hg.kewl.org/s2-mfe-fm/)
I can now reliably and consitently receive DVB-S/S2, DVB-T, analogue TV
and FM radio on the HVR-4000. DVB-T works on the AVERMEDIA as per
normal.

Applications which have been under test by include the command
line dvb-utils, dvbtraffic, dvbsnoop, GUI apps kaffeine and
mythtv. No obvious side effects have been witnessed of using
MFE and the applications themselves do not see any difference
except that they are unable to simultaneously open multiple
frontends due to the hardware limitation of such cards.

A couple of problems exist which may be present in all hybrid cards
is that you are able to concurrently open analogue and DVB-T where
these share the same tuner section. Another issue with shared
tuners is where both analogue and digital sections share a sleep
method which in some circumstances is incompatible.

At this time I am happy with the performance of this MFE card
(HVR-4000) and to be honest, I am looking at attending to other
activities. Bugs where present ought to be picked up by others,
I have done all that has been reasonable to test and determine
that MFE works.

>scarfoglio@arpacoop.it
>fabbione@fabbione.net
>
>If you're not normally members of this list then please say so, I'll 
>ensure your response is cc'd back to the list.

Thanks, cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
