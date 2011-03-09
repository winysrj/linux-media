Return-path: <mchehab@pedra>
Received: from web33508.mail.mud.yahoo.com ([68.142.206.157]:22187 "HELO
	web33508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932317Ab1CIOmg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 09:42:36 -0500
Message-ID: <738177.69799.qm@web33508.mail.mud.yahoo.com>
Date: Wed, 9 Mar 2011 06:35:55 -0800 (PST)
From: Patrick Cairns <patrick_cairns@yahoo.com>
Subject: TT-budget S-1500b card support
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

I'm working with a new version of TT-budget S-1500 card; I think the old one is 
going end of life.

Technotrend Systemtechnik GmbH Device 101b

I took a stab at getting it working with a guessy patch and help finding the 
correct tuner i2c address from another fellow who has this card 
(http://linuxtv.org/pipermail/linux-dvb/2011-February/032815.html)

I achieved lock and was able to capture sensible transport stream data from the 
transponder however nearly half of it is being consistently being lost 
somewhere.

I'll add a bit more info below but would anyone be able help me diagnose what is 
wrong or point me in the right direction?

The main board chips are the same as before (SAA7146AH, LNBP21PD) though the 
tuner board is different now making use of STx0228 & STB6000 and now provides a 
loop through; the tuner casing has a label with BSBE1-D01A on it.  (an older 
1500 I have uses stv0299b,tsa5059t,tda8060ts with a BSBE1-502A label on it).

Does the following patch make sense?

diff -Naur budget-ci.c.orig budget-ci.c
--- budget-ci.c.orig    2011-03-09 13:20:28.000000000 +0000
+++ budget-ci.c 2011-03-09 13:23:37.000000000 +0000
@@ -48,6 +48,8 @@
 #include "stb0899_cfg.h"
 #include "stb6100.h"
 #include "stb6100_cfg.h"
+#include "stv0288.h"
+#include "stb6000.h"
 #include "lnbp21.h"
 #include "bsbe1.h"
 #include "bsru6.h"
@@ -217,6 +219,7 @@
        case 0x1017:
        case 0x1019:
        case 0x101a:
+       case 0x101b:
                /* for the Technotrend 1500 bundled remote */
                ir_codes = RC_MAP_TT_1500;
                break;
@@ -1303,6 +1306,11 @@
        .refclock       = 27000000,
 };
 
+static struct stv0288_config tt1500_stv0288_config = {
+    .demod_address = 0x68,
+    .min_delay_ms = 100,
+};
+
 static void frontend_init(struct budget_ci *budget_ci)
 {
        switch (budget_ci->budget.dev->pci->subsystem_device) {
@@ -1372,6 +1380,22 @@
                }
                break;
 
+    case 0x101b:            // TT S-1500B PCI
+        budget_ci->budget.dvb_frontend = dvb_attach(stv0288_attach, 
&tt1500_stv0288_config, &budget_ci->budget.i2c_adap);
+        if (budget_ci->budget.dvb_frontend) {
+            if (dvb_attach(stb6000_attach, budget_ci->budget.dvb_frontend, 
0x63, &budget_ci->budget.i2c_adap) != NULL) {
+                if (!dvb_attach(lnbp21_attach, budget_ci->budget.dvb_frontend, 
&budget_ci->budget.i2c_adap, 0, 0)) {
+                    printk("%s: No LNBP21 found!\n", __func__);
+                    dvb_frontend_detach(budget_ci->budget.dvb_frontend);
+                    budget_ci->budget.dvb_frontend = NULL;
+                }
+            } else {
+                dvb_frontend_detach(budget_ci->budget.dvb_frontend);
+                budget_ci->budget.dvb_frontend = NULL;
+            }
+        }
+        break;
+
        case 0x101a: /* TT Budget-C-1501 (philips tda10023/philips tda8274A) */
                budget_ci->budget.dvb_frontend = dvb_attach(tda10023_attach, 
&tda10023_config, &budget_ci->budget.i2c_adap, 0x48);
                if (budget_ci->budget.dvb_frontend) {
@@ -1513,6 +1537,7 @@
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(tt3200, "TT-Budget S2-3200 PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(ttbs1500b, "TT-Budget/S-1500B PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
        MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1523,6 +1548,7 @@
        MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
        MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101a),
        MAKE_EXTENSION_PCI(tt3200, 0x13c2, 0x1019),
+       MAKE_EXTENSION_PCI(ttbs1500b, 0x13c2, 0x101b), 
        {
         .vendor = 0,
         }


I consistently get FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER 
FE_HAS_VITERBI and when tuned correctly the BER and UCBLOCK count remain zero.

There are no errors in dmesg with respect to buffers overflowing and enabling 
7146 driver debug didn't reveal any DMA transfer errors.

--------

echo 0 > /sys/module/dvb_core/parameters/dvb_powerdown_on_sleep
dvbtune -f 10847000 -s 22000 -p V -I 2 -c 3
Using DVB card "ST STV0288 DVB-S"
tuning DVB-S to L-Band:0, Pol:V Srate=22000000, 22kHz=off
polling….
...
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
dvbsnoop -dvr /dev/dvb/adapter$A/dvr0 -demux /dev/dvb/adapter$A/demux0 -frontend 
/dev/dvb/adapter$A/frontend0 -s ts -tsraw -s bandwidth

new 1500 with STV0288 showing loss of almost half the data
packets read: 189/(125497)   d_time:  0.014 s  = 20304.000 kbit/s   (Avrg: 
18686.020 kbit/s) [bad: 0]
packets read: 199/(125696)   d_time:  0.016 s  = 18706.000 kbit/s   (Avrg: 
18686.052 kbit/s) [bad: 0]
packets read: 197/(125893)   d_time:  0.015 s  = 19752.533 kbit/s   (Avrg: 
18687.630 kbit/s) [bad: 0]

old 1500 with STV0299 on same transponder
packets read: 349/(465593)   d_time:  0.015 s  = 34993.067 kbit/s   (Avrg: 
33763.350 kbit/s) [bad: 0]
packets read: 327/(465920)   d_time:  0.015 s  = 32787.200 kbit/s   (Avrg: 
33762.644 kbit/s) [bad: 0]
packets read: 348/(466268)   d_time:  0.015 s  = 34892.800 kbit/s   (Avrg: 
33763.460 kbit/s) [bad: 0]
--------
data loss looks evenly spread throughout the stream:-

dvbsnoop -dvr /dev/dvb/adapter$A/dvr0 -demux /dev/dvb/adapter$A/demux0 -frontend 
/dev/dvb/adapter$A/frontend0 -s ts -tsraw -b -N 100000  > /tmp/test; dvbsnoop 
-if /tmp/test -s ts -tsraw
...
continuity_counter: 5 (0x05)  [= (sequence ok)]
continuity_counter: 3 (0x03)  [= (sequence ok)]
continuity_counter: 2 (0x02)  [= (continuity error!)]
continuity_counter: 5 (0x05)  [= (continuity error!)]
continuity_counter: 4 (0x04)  [= (sequence ok)]
continuity_counter: 1 (0x01)  [= (continuity error!)]
continuity_counter: 5 (0x05)  [= (sequence ok)]
continuity_counter: 0 (0x00)  [= (duplicate packet)]
continuity_counter: 6 (0x06)  [= (sequence ok)]
continuity_counter: 7 (0x07)  [= (sequence ok)]
continuity_counter: 4 (0x04)  [= (continuity error!)]
continuity_counter: 3 (0x03)  [= (continuity error!)]
continuity_counter: 8 (0x08)  [= (sequence ok)]
continuity_counter: 5 (0x05)  [= (sequence ok)]
continuity_counter: 9 (0x09)  [= (sequence ok)]
continuity_counter: 0 (0x00)  [= (duplicate packet)]
continuity_counter: 0 (0x00)  [= (duplicate packet)]
continuity_counter: 6 (0x06)  [= (continuity error!)]
continuity_counter: 15 (0x0f)  [= (continuity error!)]
continuity_counter: 7 (0x07)  [= (sequence ok)]
continuity_counter: 8 (0x08)  [= (continuity error!)]
--------

What kind of things can cause this, where should I start looking?

I've been looking at timing settings in stv0228 module but I'm a bit out of my 
depth and don't know where the data is getting lost yet.

If I do somehow get this working I'll submit patch.

Thanks

Patrick


      
