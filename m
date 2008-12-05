Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L8WYb-0000mY-0p
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 10:01:06 +0100
Received: by qyk9 with SMTP id 9so5692035qyk.17
	for <linux-dvb@linuxtv.org>; Fri, 05 Dec 2008 01:00:30 -0800 (PST)
Message-ID: <c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
Date: Fri, 5 Dec 2008 11:00:30 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Michel Verbraak" <michel@verbraak.org>
In-Reply-To: <4938C8BB.5040406@verbraak.org>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan (possible diseqc
	problem)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1772631566=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1772631566==
Content-Type: multipart/alternative;
	boundary="----=_Part_24539_13646465.1228467630776"

------=_Part_24539_13646465.1228467630776
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/12/5 Michel Verbraak <michel@verbraak.org>

>  Alex,
>
> I have the following problem. I'm not able to rotate my rotor with my HD2
> card and any of the drivers (liplianin, v4l-dvb, Manu). I tried GotoX diseqc
> commands as well as the goto position used by scan-s2.
> As Pavel also has problems with diseqc (switch with A B input) I think it
> is not in the scan-s2 an szap-s2 utilities but in the driver.
>
I don't have a rotor nor HD2 card, so I can't help with that.
I do have 8-1 disecq that works fine with Igor's drivers (previously worked
fine with Manu's drivers as well) and scan-s2 utility using Twinhan 1041
card.

Few weeks ago Hans Werner applied changes for scan-s2 to work with his
rotor. Please take a look on rotor.conf file and "-r" option.
Maybe it will help.


>
> I changed the subject because I do not know if Pavels problem is only due
> to diseqc problems.
>
> I have another card (twinhan vp-1034 mantis) which should be able to rotate
> my rotor and I will try it next weekend to see if my rotor is not broken and
> I will also have a look into the driver but this will be not easy beacuse I
> do not have schematics or any documentation.
>
My 1027 card worked fine with multiproto drivers few months ago (replaced it
with 1041 card)


>
>
> Regards,
>
> Michel.
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_24539_13646465.1228467630776
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">2008/12/5 Michel Verbraak <span dir="ltr">&lt;<a href="mailto:michel@verbraak.org">michel@verbraak.org</a>&gt;</span><br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div bgcolor="#ffffff" text="#000000">


  
  

<blockquote type="cite">
</blockquote>  
Alex,<br>
<br>
I have the following problem. I&#39;m not able to rotate my rotor with my
HD2 card and any of the drivers (liplianin, v4l-dvb, Manu). I tried
GotoX diseqc commands as well as the goto position used by scan-s2.<br>
As Pavel also has problems with diseqc (switch with A B input) I think
it is not in the scan-s2 an szap-s2 utilities but in the driver.</div></blockquote><div>I don&#39;t have a rotor nor HD2 card, so I can&#39;t help with that.<br>I do have 8-1 disecq that works fine with Igor&#39;s drivers (previously worked fine with Manu&#39;s drivers as well) and scan-s2 utility using Twinhan 1041 card.<br>
<br>Few weeks ago Hans Werner applied changes for scan-s2 to work with his rotor. Please take a look on rotor.conf file and &quot;-r&quot; option.<br>Maybe it will help.<br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div bgcolor="#ffffff" text="#000000"><br>
<br>
I changed the subject because I do not know if Pavels problem is only
due to diseqc problems.<br>
<br>
I have another card (twinhan vp-1034 mantis) which should be able to
rotate my rotor and I will try it next weekend to see if my rotor is
not broken and I will also have a look into the driver but this will be
not easy beacuse I do not have schematics or any documentation.</div></blockquote><div>My 1027 card worked fine with multiproto drivers few months ago (replaced it with 1041 card)<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div bgcolor="#ffffff" text="#000000"><br>
<br>
Regards,<br>
<br>
Michel.<br>
<br>
</div>

<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br></div>

------=_Part_24539_13646465.1228467630776--


--===============1772631566==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1772631566==--
