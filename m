Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L7vHo-0003b1-KI
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 18:13:17 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2517006fga.25
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 09:13:13 -0800 (PST)
Message-ID: <4936BE27.10800@googlemail.com>
Date: Wed, 03 Dec 2008 18:13:11 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>	
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>	
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>	
	<49358FE8.9020701@googlemail.com>	
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>	
	<4935B1B3.40709@googlemail.com>
	<c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>
In-Reply-To: <c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
 which outputs the wrong frequency if the current tuned transponder
 is scanned only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Alex Betis schrieb:
>>> If you use S2API driver, please try my scan-s2 from here:
>>> http://mercurial.intuxication.org/hg/scan-s2/
>> If I use 'scan-s2 -c -o vdr', the output is wrong. I get:
>>
>> Bayerisches FS S=FCd;ARD:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:4=
1985:1101:0
>>
>> I should get:
>>
>> Bayerisches FS
>> S=FCd;ARD:346:M256:C:6900:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:=
41985:0:0
>>
>> Frequency, modulation, DVB type and symbol rate are still missing.
> =

> That's interesting. That means the utility doesn't know what delivery sys=
tem
> is used. Probably because it didn't tune the driver.
> I'll check that. It should happen with DVB-S as well.

For the current transponder scanning, it isn't set any filter for NIT parsi=
ng. Since the
output format is zap and vdr only, it must be always setup a NIT filter:

diff -r 51eceb97c3bd scan.c
--- a/scan.c    Mon Dec 01 23:36:50 2008 +0200
+++ b/scan.c    Wed Dec 03 18:04:10 2008 +0100
@@ -2495,7 +2503,7 @@ static void scan_tp_dvb (void)
        add_filter (&s0);
        add_filter (&s1);

-       if (!current_tp_only) {
+       if (/*!current_tp_only*/1) {
                setup_filter (&s2, demux_devname, PID_NIT_ST, TID_NIT_ACTUA=
L, -1, 1, 0,
15); /* NIT */
                add_filter (&s2);
                if (get_other_nits) {

> Can you scan the same channel without "-c" and report if the dump is
> correct?

I need a little patch for tuning to DVB-C transponders:

diff -r 51eceb97c3bd scan.c
--- a/scan.c    Mon Dec 01 23:36:50 2008 +0200
+++ b/scan.c    Wed Dec 03 18:04:10 2008 +0100
@@ -1729,6 +1729,14 @@ static int __tune_to_transponder (int fr

        switch(t->delivery_system)
        {
+       case SYS_DVBC_ANNEX_AC:
+               if_freq =3D t->frequency;
+
+               if (verbosity >=3D 2){
+                       dprintf(1,"DVB-C frequency is %d\n", if_freq);
+               }
+               break;
+
        case SYS_DVBS:
        case SYS_DVBS2:
                if (lnb_type.high_val) {

It seems that the output is correct (currently not tested with vdr).

Regards,
Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
