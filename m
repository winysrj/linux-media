Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1Jy47m-00006o-NW
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 14:05:56 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1646286rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 05:05:49 -0700 (PDT)
Message-ID: <617be8890805190505i1d4d9857y8220ee6b5e48c214@mail.gmail.com>
Date: Mon, 19 May 2008 14:05:48 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200805191344.14445.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890805171034t539f9c67qe339f7b4f79d8e62@mail.gmail.com>
	<36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
	<200805191344.14445.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1172766344=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1172766344==
Content-Type: multipart/alternative;
	boundary="----=_Part_12857_5954506.1211198748743"

------=_Part_12857_5954506.1211198748743
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks for your clarification, Matthias.
For your information, I've been tested extensively the driver these last
days and I can say it has been working really fine  for me. I've had no
glitches while using it inside MythTV, changing channels works fine, also
recording shows, etc... No issues on this part.

The only minor issue is the one I yet mentioned in a previous mail: I can't
find any channels on Astra 19.2 when using the default frequency table file
located in /usr/share/dvb/dvb-s/Astra 19.2, but ir works fine when using th=
e
alternative file obtained from
http://joshyfun.peque.org/transponders/kaffeine.html.

Regards,
  Eduard




2008/5/19, Matthias Schwarzott <zzam@gentoo.org>:
>
> On Samstag, 17. Mai 2008, bvidinli wrote:
> > Hi,
> > thank you for your answer,
> >
> > may i ask,
> >
> > what is meant by "analog  input", it is mentioned on logs that:" only
> > analog inputs supported yet.." like that..
> > is that mean: s-video, composit ?
> >
>
> Yeah. The patch already merged into v4l-dvb repository and also merged in=
to
> kernel 2.6.26 does only support s-video and compite input of both A700
> cards
> (Avermedia AverTV dvb-s Pro and AverTV DVB-S Hybrid+FM).
>
> The other pending patches do add support for DVB-S input to both card
> versions. But this is not yet ready for being merged.
> At least here the tuning is not yet reliable for some frequencies (or doe=
s
> get
> no lock depending very hardly on some tuner gain settings). But most
> transponders of Astra-19.2=B0E I can get a good lock.
>
> This is the latest version of the patch:
> http://dev.gentoo.org/~zzam/dvb/a700_full_20080519.diff
>
>
> About RF analog input I cannot do much, as I do not have the hardware, an=
d
> for
> XC2028 tuner one needs to check out the GPIO configuration.
>
> If you would like to help you could try out or trace gpio lines some way =
to
> get RF input running. As far as I know to get XC2028 running you need to
> find
> out which pin does reset the tuner to finish firmware uploading.
>
> Regards
>
> Matthias
>

------=_Part_12857_5954506.1211198748743
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks for your clarification, Matthias.<br>For your information, I&#39;ve =
been tested extensively the driver these last days and I can say it has bee=
n working really fine&nbsp; for me. I&#39;ve had no glitches while using it=
 inside MythTV, changing channels works fine, also recording shows, etc... =
No issues on this part.<br>
<br>The only minor issue is the one I yet mentioned in a previous mail: I c=
an&#39;t find any channels on Astra 19.2 when using the default frequency t=
able file located in /usr/share/dvb/dvb-s/Astra 19.2, but ir works fine whe=
n using the alternative file obtained from <a href=3D"http://joshyfun.peque=
.org/transponders/kaffeine.html">http://joshyfun.peque.org/transponders/kaf=
feine.html</a>.<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br><br><div><span class=3D"gmail=
_quote">2008/5/19, Matthias Schwarzott &lt;<a href=3D"mailto:zzam@gentoo.or=
g">zzam@gentoo.org</a>&gt;:</span><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
On Samstag, 17. Mai 2008, bvidinli wrote:<br> &gt; Hi,<br> &gt; thank you f=
or your answer,<br> &gt;<br> &gt; may i ask,<br> &gt;<br> &gt; what is mean=
t by &quot;analog&nbsp;&nbsp;input&quot;, it is mentioned on logs that:&quo=
t; only<br>
 &gt; analog inputs supported yet..&quot; like that..<br> &gt; is that mean=
: s-video, composit ?<br> &gt;<br> <br>Yeah. The patch already merged into =
v4l-dvb repository and also merged into<br> kernel 2.6.26 does only support=
 s-video and compite input of both A700 cards<br>
 (Avermedia AverTV dvb-s Pro and AverTV DVB-S Hybrid+FM).<br> <br> The othe=
r pending patches do add support for DVB-S input to both card<br> versions.=
 But this is not yet ready for being merged.<br> At least here the tuning i=
s not yet reliable for some frequencies (or does get<br>
 no lock depending very hardly on some tuner gain settings). But most<br> t=
ransponders of Astra-19.2=B0E I can get a good lock.<br> <br> This is the l=
atest version of the patch:<br> <a href=3D"http://dev.gentoo.org/~zzam/dvb/=
a700_full_20080519.diff">http://dev.gentoo.org/~zzam/dvb/a700_full_20080519=
.diff</a><br>
 <br> <br> About RF analog input I cannot do much, as I do not have the har=
dware, and for<br> XC2028 tuner one needs to check out the GPIO configurati=
on.<br> <br> If you would like to help you could try out or trace gpio line=
s some way to<br>
 get RF input running. As far as I know to get XC2028 running you need to f=
ind<br> out which pin does reset the tuner to finish firmware uploading.<br=
> <br> Regards<br> <br>Matthias<br> </blockquote></div><br>

------=_Part_12857_5954506.1211198748743--


--===============1172766344==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1172766344==--
