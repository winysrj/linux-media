Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L9mAW-0001vw-Rh
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 20:53:25 +0100
Received: by qw-out-2122.google.com with SMTP id 9so278860qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 11:53:20 -0800 (PST)
Message-ID: <c74595dc0812081153l3b71c874y2b53123492293b24@mail.gmail.com>
Date: Mon, 8 Dec 2008 21:53:20 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Pavel Hofman" <pavel.hofman@insite.cz>
In-Reply-To: <493D69C8.2080904@insite.cz>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <493BE666.8030007@insite.cz>
	<c74595dc0812070822p73746bdel9894de34c87a733f@mail.gmail.com>
	<493D69C8.2080904@insite.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0208755901=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0208755901==
Content-Type: multipart/alternative;
	boundary="----=_Part_53646_5009204.1228766000523"

------=_Part_53646_5009204.1228766000523
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Dec 8, 2008 at 8:39 PM, Pavel Hofman <pavel.hofman@insite.cz> wrote:

> Alex,
>
> Thanks a lot for your patience. I am slowly starting to understand the
> whole thing.
>
>  ./scan-s2 -5 -o zap -x 0 -s 0   dvb-s/Ku-band/S19.2E.ini > channels.conf
>
> Works fine, finds many fta channels.
>
>  ./scan-s2 -5 -o zap -x 0 -s 1   dvb-s/Ku-band/S23.5E.ini >> channels.conf
>
> Even the second LNB works now, finds some ftas :)
>
> Results of the scan give very often zero APID, VPID:
>
> Sky Cust Ch:11934:v:0:27500:0:0:4505:5
> Cartoon Network Game 4:12012:v:0:27500:0:2603:8005:5
> Video Application Val:12012:v:0:27500:2518:2519:8015:5
> Sky Bingo:12012:v:0:27500:0:0:8032:5
> Sky Bet, Vegas & Sky Poker:12012:v:0:27500:0:0:8076:5
>
> Please see the attached screenshot for results of the scanner under windows
> - APID/VPID are almost never zero. Do the missing values have any negative
> effects?

Try to add "-k3" to the command line.

Next time please provide output of the utility, windows screenshots are not
that interesting in that case...
If "-k3" will not help, there might be a problem with ZAP output format
since I don't use it and never tested it.

>
>
> If I want to use e.g. kaffeine, should I just rename and install the new
> szap-s2/sca-s2 binaries systemwide?

Don't know. I use only VDR output format.

------=_Part_53646_5009204.1228766000523
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Mon, Dec 8, 2008 at 8:39 PM, Pavel Hofman <span dir="ltr">&lt;<a href="mailto:pavel.hofman@insite.cz">pavel.hofman@insite.cz</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Alex,<br>
<br>
Thanks a lot for your patience. I am slowly starting to understand the whole thing.<br>
<br>
&nbsp;./scan-s2 -5 -o zap -x 0 -s 0 &nbsp; dvb-s/Ku-band/S19.2E.ini &gt; channels.conf<br>
<br>
Works fine, finds many fta channels.<br>
<br>
&nbsp;./scan-s2 -5 -o zap -x 0 -s 1 &nbsp; dvb-s/Ku-band/S23.5E.ini &gt;&gt; channels.conf<br>
<br>
Even the second LNB works now, finds some ftas :)<br>
<br>
Results of the scan give very often zero APID, VPID:<br>
<br>
Sky Cust Ch:11934:v:0:27500:0:0:4505:5<br>
Cartoon Network Game 4:12012:v:0:27500:0:2603:8005:5<br>
Video Application Val:12012:v:0:27500:2518:2519:8015:5<br>
Sky Bingo:12012:v:0:27500:0:0:8032:5<br>
Sky Bet, Vegas &amp; Sky Poker:12012:v:0:27500:0:0:8076:5<br>
<br>
Please see the attached screenshot for results of the scanner under windows - APID/VPID are almost never zero. Do the missing values have any negative effects?</blockquote><div>Try to add &quot;-k3&quot; to the command line.<br>
<br>Next time please provide output of the utility, windows screenshots are not that interesting in that case...<br>If &quot;-k3&quot; will not help, there might be a problem with ZAP output format since I don&#39;t use it and never tested it.<br>
</div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
If I want to use e.g. kaffeine, should I just rename and install the new szap-s2/sca-s2 binaries systemwide?</blockquote><div>Don&#39;t know. I use only VDR output format.<br></div></div><br></div>

------=_Part_53646_5009204.1228766000523--


--===============0208755901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0208755901==--
