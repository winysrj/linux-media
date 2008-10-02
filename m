Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KlGt5-0004UQ-K3
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 07:38:08 +0200
Received: by qw-out-2122.google.com with SMTP id 9so207778qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 01 Oct 2008 22:38:03 -0700 (PDT)
Message-ID: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
Date: Thu, 2 Oct 2008 08:38:03 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: "Emmanuel ALLAUD" <eallaud@yahoo.fr>
In-Reply-To: <1222890066l.12772l.2l@manu-laptop>
MIME-Version: 1.0
References: <c74595dc0810010721h2dceb13ega11f8525be8cfe5a@mail.gmail.com>
	<1222890066l.12772l.2l@manu-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : Twinhan 1041 (SP 400) lock and scan problems -
	the solution [not quite :(]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1308252151=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1308252151==
Content-Type: multipart/alternative;
	boundary="----=_Part_36549_26541871.1222925883265"

------=_Part_36549_26541871.1222925883265
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Manu,

Please specify what sattelite and what frequency cause problems.
Specify also a "good" transponder that locks.
Can you send me the stb0899 module logs (with debug severity)?

The tests I did are scanning all the satelites I have (5 in count) and see
that the same transponders are constantly locked every scan.
The results are compared to Twinhan 1027 card as well (that's actualy was
the trigger for me to start digging in the code since 1027 found more
channels than 1041 and with 1041 channels were randomly
dissapearing/reappearing every scan).

One of my sats is on edge recepition where many transponders are not locked=
,
while my settop box shows then. But I actually didn't really expect the car=
d
to lock on them. So please check the sat coverage in your area. Its also
known that some transponders are considered as weak and give poor signal
even if they are supposed to be received.

Thanks.

On Wed, Oct 1, 2008 at 10:41 PM, Emmanuel ALLAUD <eallaud@yahoo.fr> wrote:

> Le 01.10.2008 10:21:00, Alex Betis a =E9crit :
> > Patch files are attached.
> > Several people reported better lock on DVB-S channels.
> >
> > Just to clarify it, the changes mostly affect DVB-S channels
> > scanning,
> > it
> > doesn't help with DVB-S2 locking problem since the code is totally
> > different
> > for S and S2 signal search.
>
> Test report: it looks like good transponders (FEC 3/4, vertical
> polarisation, SR 30M) that used to lock will lock a bit faster, so I'd
> say that good things are now even more reliable and fast.
> BUT the bad transponder (same charact but different FEC, 5/6) still
> does not lock, at least not in 30s. So there still is something fishy.
> And the problem is in data search as I can see several CARRIEROK during
> the search but each time the data search (I'd guess FEC lock) fails and
> after some time the freq is too far away and status becomes NOCARRIER.
> I'd be glad to test further.
> Bye
> Manu
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_36549_26541871.1222925883265
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div>Manu,</div>
<div>&nbsp;</div>
<div>Please specify what sattelite and what frequency cause problems.</div>
<div>Specify also a &quot;good&quot; transponder that locks.</div>
<div>Can you send me the stb0899 module logs (with debug severity)?</div>
<div>&nbsp;</div>
<div>The tests I did are scanning all the satelites I have (5 in count) and=
 see that the same transponders are constantly locked every scan.</div>
<div>The results are compared to Twinhan 1027 card as well (that&#39;s actu=
aly was the trigger for me to start digging in the code since 1027 found mo=
re channels than 1041 and with 1041 channels were randomly dissapearing/rea=
ppearing every scan).</div>

<div>&nbsp;</div>
<div>One of my sats is on edge recepition where many transponders are not l=
ocked, while my settop box shows then. But I actually didn&#39;t really exp=
ect the card to lock on them. So please check the sat coverage in your area=
. Its also known that some transponders are considered as weak and give poo=
r signal even if they are supposed to be received.</div>

<div>&nbsp;</div>
<div>Thanks.<br><br></div>
<div class=3D"gmail_quote">On Wed, Oct 1, 2008 at 10:41 PM, Emmanuel ALLAUD=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:eallaud@yahoo.fr">eallaud@yahoo.fr=
</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Le 01.10.2008 10:21:00, Alex Bet=
is a =E9crit&nbsp;:<br>&gt; Patch files are attached.<br>&gt; Several peopl=
e reported better lock on DVB-S channels.<br>
&gt;<br>&gt; Just to clarify it, the changes mostly affect DVB-S channels<b=
r>&gt; scanning,<br>&gt; it<br>&gt; doesn&#39;t help with DVB-S2 locking pr=
oblem since the code is totally<br>&gt; different<br>&gt; for S and S2 sign=
al search.<br>
<br>Test report: it looks like good transponders (FEC 3/4, vertical<br>pola=
risation, SR 30M) that used to lock will lock a bit faster, so I&#39;d<br>s=
ay that good things are now even more reliable and fast.<br>BUT the bad tra=
nsponder (same charact but different FEC, 5/6) still<br>
does not lock, at least not in 30s. So there still is something fishy.<br>A=
nd the problem is in data search as I can see several CARRIEROK during<br>t=
he search but each time the data search (I&#39;d guess FEC lock) fails and<=
br>
after some time the freq is too far away and status becomes NOCARRIER.<br>I=
&#39;d be glad to test further.<br>Bye<br>Manu<br><br><br>_________________=
______________________________<br>linux-dvb mailing list<br><a href=3D"mail=
to:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

------=_Part_36549_26541871.1222925883265--


--===============1308252151==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1308252151==--
