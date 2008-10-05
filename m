Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KmU4K-0003Vp-GG
	for linux-dvb@linuxtv.org; Sun, 05 Oct 2008 15:54:45 +0200
Received: by qw-out-2122.google.com with SMTP id 9so531282qwb.17
	for <linux-dvb@linuxtv.org>; Sun, 05 Oct 2008 06:54:39 -0700 (PDT)
Message-ID: <c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
Date: Sun, 5 Oct 2008 16:54:39 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: "Emmanuel ALLAUD" <eallaud@yahoo.fr>
In-Reply-To: <1223212383l.6064l.0l@manu-laptop>
MIME-Version: 1.0
References: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	<1223212383l.6064l.0l@manu-laptop>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Re : Re : Twinhan 1041 (SP 400) lock and scan
	problems - the solution [not quite :(]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0680987857=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0680987857==
Content-Type: multipart/alternative;
	boundary="----=_Part_17192_17012088.1223214879725"

------=_Part_17192_17012088.1223214879725
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

So where are the logs?

Can you give me the link to the sattelite you're using on lyngsat site?
There are many Atlantic (Birds) sats so I don't know which one you're
referring to.

I'm sure Manu knows much more about that driver than I am, but I think the
code takes the clock into consideration when calculating parameters for
search algorithm.



On Sun, Oct 5, 2008 at 4:13 PM, Emmanuel ALLAUD <eallaud@yahoo.fr> wrote:

> Le 02.10.2008 01:38:03, Alex Betis a =E9crit :
> > Manu,
> >
> > Please specify what sattelite and what frequency cause problems.
> > Specify also a "good" transponder that locks.
> > Can you send me the stb0899 module logs (with debug severity)?
>
> I loaded stb* with debug=3D5 IIRC.
> The sats are in western Atlantic (I live in the Caribbean Islands):
> good transponders: freqs=3D11093,11555,11675, bad one:11495.
>
> As I said Carrier is detected but the data search algo fails, and, as
> the only difference is th FEC, I guess that should be the problem.
> Moreover as you probably have already noticed, the init values are
> really different between mantis and TT-3200. Manu told me that it is
> because they use different freq (99MHz for TT and 108MHz for Mantis),
> but the handling of the registers are so different there might be other
> differences also. Anyway it seems that both cards have some problematic
> locking for some transponders so the fix might work for both.
> I could do some further testing (even spreading printks in the code is
> doable for me).
>  Bye
> Manu
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_17192_17012088.1223214879725
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div>So where are the logs?</div>
<div>&nbsp;</div>
<div>Can you give me the link to the sattelite you&#39;re using on lyngsat =
site? There are many Atlantic (Birds) sats so I don&#39;t know which one yo=
u&#39;re referring to.</div>
<div>&nbsp;</div>
<div>I&#39;m sure Manu knows much more about that driver than I am, but I t=
hink the code takes the clock into consideration when calculating parameter=
s for search algorithm.</div>
<div><br><br>&nbsp;</div>
<div class=3D"gmail_quote">On Sun, Oct 5, 2008 at 4:13 PM, Emmanuel ALLAUD =
<span dir=3D"ltr">&lt;<a href=3D"mailto:eallaud@yahoo.fr">eallaud@yahoo.fr<=
/a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Le 02.10.2008 01:38:03, Alex Bet=
is a =E9crit&nbsp;:<br>
<div class=3D"Ih2E3d">&gt; Manu,<br>&gt;<br>&gt; Please specify what sattel=
ite and what frequency cause problems.<br>&gt; Specify also a &quot;good&qu=
ot; transponder that locks.<br>&gt; Can you send me the stb0899 module logs=
 (with debug severity)?<br>
<br></div>I loaded stb* with debug=3D5 IIRC.<br>The sats are in western Atl=
antic (I live in the Caribbean Islands):<br>good transponders: freqs=3D1109=
3,11555,11675, bad one:11495.<br><br>As I said Carrier is detected but the =
data search algo fails, and, as<br>
the only difference is th FEC, I guess that should be the problem.<br>Moreo=
ver as you probably have already noticed, the init values are<br>really dif=
ferent between mantis and TT-3200. Manu told me that it is<br>because they =
use different freq (99MHz for TT and 108MHz for Mantis),<br>
but the handling of the registers are so different there might be other<br>=
differences also. Anyway it seems that both cards have some problematic<br>=
locking for some transponders so the fix might work for both.<br>I could do=
 some further testing (even spreading printks in the code is<br>
doable for me).<br>
<div>
<div></div>
<div class=3D"Wj3C7c">Bye<br>Manu<br><br><br>______________________________=
_________________<br>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb@=
linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.org=
/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.o=
rg/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_17192_17012088.1223214879725--


--===============0680987857==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0680987857==--
