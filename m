Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L7zHY-00056s-8E
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 22:29:16 +0100
Received: by qyk9 with SMTP id 9so4580311qyk.17
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 13:28:42 -0800 (PST)
Message-ID: <c74595dc0812031328i32bc9997t632e0f63a8849b03@mail.gmail.com>
Date: Wed, 3 Dec 2008 23:28:42 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: e9hack@googlemail.com
In-Reply-To: <9ac6f40e0812031104q1b3a419ub5c1a58d19f96239@mail.gmail.com>
MIME-Version: 1.0
References: <492168D8.4050900@googlemail.com>
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
	<49358FE8.9020701@googlemail.com>
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
	<4935B1B3.40709@googlemail.com>
	<c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>
	<4936BE27.10800@googlemail.com>
	<9ac6f40e0812031104q1b3a419ub5c1a58d19f96239@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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
Content-Type: multipart/mixed; boundary="===============1341024474=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1341024474==
Content-Type: multipart/alternative;
	boundary="----=_Part_129263_23964691.1228339722289"

------=_Part_129263_23964691.1228339722289
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/12/3 <e9hack@googlemail.com>

> 2008/12/3 e9hack <e9hack@googlemail.com>
>
>> For the current transponder scanning, it isn't set any filter for NIT
>> parsing. Since the
>> output format is zap and vdr only, it must be always setup a NIT filter:
>>
>> diff -r 51eceb97c3bd scan.c
>> --- a/scan.c    Mon Dec 01 23:36:50 2008 +0200
>> +++ b/scan.c    Wed Dec 03 18:04:10 2008 +0100
>> @@ -2495,7 +2503,7 @@ static void scan_tp_dvb (void)
>>        add_filter (&s0);
>>        add_filter (&s1);
>>
>> -       if (!current_tp_only) {
>> +       if (/*!current_tp_only*/1) {
>>                setup_filter (&s2, demux_devname, PID_NIT_ST,
>> TID_NIT_ACTUAL, -1, 1, 0,
>> 15); /* NIT */
>>                add_filter (&s2);
>>                if (get_other_nits) {
>>
>
> I forgot, frequency and modulation are wrong as in the original scan
> application. The values are from last parsed NIT entry, which isn't from the
> current transponder.

There is no need for NIT message. I've added query from driver for currently
tuned parameters - should work for DVB-T and DVB-C users. DVB-S/S2 will get
IF frequency, which is not the real transponder frequency.
Please update to latest version.
Your other patch for DVB-C scan is also there.

Let me know if it helps.

Regards,
Alex.

>
>
> Regards,
> Hartmut
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_129263_23964691.1228339722289
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">2008/12/3  <span dir="ltr">&lt;<a href="mailto:e9hack@googlemail.com">e9hack@googlemail.com</a>&gt;</span><br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
2008/12/3 e9hack <span dir="ltr">&lt;<a href="mailto:e9hack@googlemail.com" target="_blank">e9hack@googlemail.com</a>&gt;</span><div class="Ih2E3d"><br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

For the current transponder scanning, it isn&#39;t set any filter for NIT parsing. Since the<br>
output format is zap and vdr only, it must be always setup a NIT filter:<br>
<br>
diff -r 51eceb97c3bd scan.c<br>
--- a/scan.c &nbsp; &nbsp;Mon Dec 01 23:36:50 2008 +0200<br>
+++ b/scan.c &nbsp; &nbsp;Wed Dec 03 18:04:10 2008 +0100<br>
@@ -2495,7 +2503,7 @@ static void scan_tp_dvb (void)<br>
 &nbsp; &nbsp; &nbsp; &nbsp;add_filter (&amp;s0);<br>
 &nbsp; &nbsp; &nbsp; &nbsp;add_filter (&amp;s1);<br>
<br>
- &nbsp; &nbsp; &nbsp; if (!current_tp_only) {<br>
+ &nbsp; &nbsp; &nbsp; if (/*!current_tp_only*/1) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;setup_filter (&amp;s2, demux_devname, PID_NIT_ST, TID_NIT_ACTUAL, -1, 1, 0,<br>
15); /* NIT */<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;add_filter (&amp;s2);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (get_other_nits) {<br></blockquote></div><br></div>I forgot, frequency and modulation are wrong as in the original scan application. The values are from last parsed NIT entry, which isn&#39;t from the current transponder.</blockquote>
<div>There is no need for NIT message. I&#39;ve added query from driver for currently tuned parameters - should work for DVB-T and DVB-C users. DVB-S/S2 will get IF frequency, which is not the real transponder frequency.<br>
Please update to latest version.<br>Your other patch for DVB-C scan is also there.<br>&nbsp;<br>Let me know if it helps.<br><br>Regards,<br>Alex.<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>Regards,<br>Hartmut<br>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br></div>

------=_Part_129263_23964691.1228339722289--


--===============1341024474==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1341024474==--
