Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JbCh0-0006jA-8j
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 11:35:47 +0100
Received: by rv-out-0910.google.com with SMTP id b22so3856246rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 03:35:32 -0700 (PDT)
Message-ID: <617be8890803170335w3ad53687g6d118357edec4a88@mail.gmail.com>
Date: Mon, 17 Mar 2008 11:35:32 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <617be8890803170334oe1135deje5312ca01b64a919@mail.gmail.com>
MIME-Version: 1.0
References: <617be8890803151400h397f7573v29876748cee0d085@mail.gmail.com>
	<200803161135.06523.zzam@gentoo.org>
	<617be8890803170334oe1135deje5312ca01b64a919@mail.gmail.com>
Subject: [linux-dvb] Fwd: Any progress on the Avermedia DVB-S (A700)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1296467942=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1296467942==
Content-Type: multipart/alternative;
	boundary="----=_Part_1312_6991086.1205750132309"

------=_Part_1312_6991086.1205750132309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It seems so. The problem is finding that f.... piece :D.

Well, anyway if you think I might be of any help just contact me as usual.
Unfortunately I think I can only provide some testing under Linux or
Windows, but less more... I've tried several times to digg into the code an=
d
even change some values (like the gain parameters for the tuner), but no
luck. The thing that most annoys me is that both the GPIO status and EEPROM
contents are somewhat different between cards tat should be the same

(by the way, later at home I'll upgrade the entries listed for my card, as
they are wrong).

Best regards,
  Eduard



2008/3/16, Matthias Schwarzott <zzam@gentoo.org>:
>
> On Saturday 15 March 2008, you wrote:
> > Hi, Matthias
> >    I've seen you have new patches available on your repository. =BFHave
> you
> > made any progress lately on the driver? I tested the patches, but the
> > results were the habitual ones...
> >
> >   Seems this card is really hard to support... :(
> >
>
> Well, maybe it is just one little piece missing, who knows!?
>
> For now I added support of Hybrid+FM card + untested analog tuner input
> there.
> Maybe we can at least get this patch commited.
>
> Second: I must debug my cabling here, maybe this is the reason I cannot
> get a
> lock now.
>
> Matthias
>
>
> --
> Matthias Schwarzott (zzam)
>

------=_Part_1312_6991086.1205750132309
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It seems so. The problem is finding that f.... piece :D.<br><br>Well, anywa=
y if you think I might be of any help just contact me as usual. Unfortunate=
ly I think I can only provide some testing under Linux or Windows, but less=
 more... I&#39;ve tried several times to digg into the code and even change=
 some values (like the gain parameters for the tuner), but no luck. The thi=
ng that most annoys me is that both the GPIO status and EEPROM contents are=
 somewhat different between cards tat should be the same<br>

<br>(by the way, later at home I&#39;ll upgrade the entries listed for my c=
ard, as they are wrong).<br><br>Best regards, <br>&nbsp; Eduard<br><br><br>=
<br><div><span class=3D"gmail_quote">2008/3/16, Matthias Schwarzott &lt;<a =
href=3D"mailto:zzam@gentoo.org" target=3D"_blank" onclick=3D"return top.js.=
OpenExtLink(window,event,this)">zzam@gentoo.org</a>&gt;:</span><div>
<span class=3D"e" id=3D"q_118bc4df61fcd728_1"><blockquote class=3D"gmail_qu=
ote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0p=
t 0.8ex; padding-left: 1ex;">
On Saturday 15 March 2008, you wrote:<br> &gt; Hi, Matthias<br> &gt;&nbsp;&=
nbsp;&nbsp;&nbsp;I&#39;ve seen you have new patches available on your repos=
itory. =BFHave you<br> &gt; made any progress lately on the driver? I teste=
d the patches, but the<br>

 &gt; results were the habitual ones...<br> &gt;<br> &gt;&nbsp;&nbsp; Seems=
 this card is really hard to support... :(<br> &gt;<br> <br>Well, maybe it =
is just one little piece missing, who knows!?<br> <br> For now I added supp=
ort of Hybrid+FM card + untested analog tuner input there.<br>

 Maybe we can at least get this patch commited.<br> <br> Second: I must deb=
ug my cabling here, maybe this is the reason I cannot get a<br> lock now.<b=
r> <br> Matthias<br> <br><br> --<br> Matthias Schwarzott (zzam)<br> </block=
quote>

</span></div></div><br>

------=_Part_1312_6991086.1205750132309--


--===============1296467942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1296467942==--
