Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Kd1vj-0007fi-NE
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 14:02:49 +0200
Date: Tue, 9 Sep 2008 05:02:13 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1220923070.2663.46.camel@pc10.localdom.local>
MIME-Version: 1.0
Message-ID: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: free_beer_for_all@yahoo.com
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

--- On Tue, 9/9/08, hermann pitton <hermann-pitton@arcor.de> wrote:

> following your thoughts, you are likely right. DVB-T2 likely indicates
> that you need new hardware, like it is for sure on DVB-S2.

Servus,

Disclaimer:  I'm only an outsider, not a programmer, and not
familiar with the digital broadcast specs or the DVB API, so
I will both not know what I'm talking about, and be asking
stupid questions.


I decided to look again at DVB-T2, as it's likely to be the
next change that will be in need of Linux support in a year
or so, at least in the UK, when hardware becomes available.

My stupid question is, will DVB-T2, in Transport Stream mode,
be similar enough to existing DVB-T, apart from the extended
modulation parameters, that it can be fit into the existing
API, or am I overlooking something in my ignorance of the API?

This seems to me somewhat like the case of existing DVB-C,
where some hardware is incapable of 256QAM and so cannot tune
all the carriers, but I really haven't tried to understand
the API or how it can be extended without breaking things...


In looking at the Wikipedia article on DVB-T, it appears that
at least the following diffs to include/dvb/frontend.h might
be needed to support the additional possibilities that a DVB-T2
tuner would be likely to support -- diff against the S2API, as
this file is unchanged in multiproto, while S2API already has
the additional FEC values present...

goto Disclaimer;


--- /lost+found/CVSUP/SRC/HG-src/dvb-s2-api/linux/include/linux/dvb/frontend.h  2008-09-04 15:21:59.000000000 +0200
+++ /tmp/frontend.h     2008-09-09 13:10:29.574976974 +0200
@@ -171,24 +171,34 @@ typedef enum fe_modulation {
 } fe_modulation_t;
 
 typedef enum fe_transmit_mode {
+       TRANSMISSION_MODE_1K,
        TRANSMISSION_MODE_2K,
+       TRANSMISSION_MODE_4K,
        TRANSMISSION_MODE_8K,
+       TRANSMISSION_MODE_16K,
+       TRANSMISSION_MODE_32K,
        TRANSMISSION_MODE_AUTO
 } fe_transmit_mode_t;
 
 typedef enum fe_bandwidth {
+       BANDWIDTH_10_MHZ,
        BANDWIDTH_8_MHZ,
        BANDWIDTH_7_MHZ,
        BANDWIDTH_6_MHZ,
+       BANDWIDTH_5_MHZ,
+       BANDWIDTH_1.7_MHZ,
        BANDWIDTH_AUTO
 } fe_bandwidth_t;
 
 
 typedef enum fe_guard_interval {
+       GUARD_INTERVAL_1_128,
        GUARD_INTERVAL_1_32,
        GUARD_INTERVAL_1_16,
        GUARD_INTERVAL_1_8,
        GUARD_INTERVAL_1_4,
+       GUARD_INTERVAL_19_256,
+       GUARD_INTERVAL_19_128,
        GUARD_INTERVAL_AUTO
 } fe_guard_interval_t;
 
@@ -324,6 +334,7 @@ typedef enum fe_delivery_system {
        SYS_DVBC_ANNEX_AC,
        SYS_DVBC_ANNEX_B,
        SYS_DVBT,
+       SYS_DVBT2,
        SYS_DVBS,
        SYS_DVBS2,
        SYS_DVBH,
@@ -335,6 +346,7 @@ typedef enum fe_delivery_system {
        SYS_DMBTH,
        SYS_CMMB,
        SYS_DAB,
+       SYS_TDMB,       /* XXX is different from DMB-TH, no?  */
 } fe_delivery_system_t;
 
 struct tv_cmds_h {


 The reason I became interested in this is due to the choice of
 naming -- S2API sounded to me like the focus would be on DVB-S2,
 possibly ignoring -T2 and eventually -C2, not to mention the
 other existing alternatives to DVB, rather than a Second Generation
 (as the specs I've looked at refer to the update) DVB-API, but
 then, I really don't know what I'm talking about.


 thanks,
 barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
