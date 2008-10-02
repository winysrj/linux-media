Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KlOqC-00029T-Q5
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 16:07:41 +0200
Received: by qw-out-2122.google.com with SMTP id 9so234018qwb.17
	for <linux-dvb@linuxtv.org>; Thu, 02 Oct 2008 07:07:36 -0700 (PDT)
Message-ID: <c74595dc0810020707h6fdfb9aex498a3b5ecfd5d7c1@mail.gmail.com>
Date: Thu, 2 Oct 2008 17:07:36 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: newspaperman_germany@yahoo.com
In-Reply-To: <395581.38574.qm@web23201.mail.ird.yahoo.com>
MIME-Version: 1.0
References: <1a18e9e80810011521o35f59ba5k658ab5f2c70cbfeb@mail.gmail.com>
	<395581.38574.qm@web23201.mail.ird.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0116188234=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0116188234==
Content-Type: multipart/alternative;
	boundary="----=_Part_38815_3552618.1222956456742"

------=_Part_38815_3552618.1222956456742
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have 2 "bad" transponders, one with 30000 2/3 and another with 27500 2/3

So I don't think its symbol rate related. Although there is a problem with
FEC lock, I don't think modulation (2/3 or 3/4) is related either.

Since DVB-S scan algorithm also had problems with FEC lock I have a feeling
the same problem exist in S2 scan.
I'll try to play with it when I'll have time.

On Thu, Oct 2, 2008 at 4:52 PM, Newsy Paper
<newspaperman_germany@yahoo.com>wrote:

> I didn't experience any differences with dvb-s2 channels.
> Those problematic transponders always produces corrupted video streams.
> It's always DVB-s2 30000 3/4. When entering SR of 29999 I get constant lo=
ck,
> but the stream is corrupted. 1 HD channel has only a VideoRate of 4,5 MBi=
t
> and audio 77 kbit/s :(
>
>
> kind regards
>
> Newsy
>
> --- Meysam Hariri <meysam.hariri@gmail.com> schrieb am Do, 2.10.2008:
>
> > Von: Meysam Hariri <meysam.hariri@gmail.com>
> > Betreff: [linux-dvb]  Re : Re : TT S2-3200 driver
> > An: linux-dvb@linuxtv.org
> > Datum: Donnerstag, 2. Oktober 2008, 0:21
>  > Hi,
> >
> > thanks for your update. i used a TT-3200 device and
> > here's the results:
> > - i couldn't lock on some S2 channels or those
> > 'bad' channels, although i
> > could get unstable lock on these channels using the
> > unpatched version, but
> > resulting in corrupted data. so the unpatched version still
> > works a bit
> > better.
> > - the lock on QPSK S2 channels is fast and stable as it was
> > with the
> > unpatched version
> > - locking on dvb-s channels is also fast and stable
> >
> > i'm ready to test any further updates.
> >
> > Regards,
> >
> >
> > 2008/10/1 Alex Betis <alex.betis@gmail.com>
> >
> > Hi all,
> > >
> > > My description of the solution is here:
> > >
> > http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> > >
> > > I've also attaching the patches to this thread.
> > >
> > > Several people reported better lock on DVB-S channels.
> > >
> > > Just to clarify it, the changes mostly affect DVB-S
> > channels scanning, it
> > > doesn't help with DVB-S2 locking problem since the
> > code is totally different
> > > for S and S2 signal search.
> > >
> > > I've increased a timer for S2 signal search and
> > decreased the search step,
> > > this helps to lock on "good" S2 channels
> > that were locked anyway with
> > > several attempts, but this time it locks from first
> > attempt. The "bad"
> > > channels finds the signal, but the FEC is unable to
> > lock.
> > > Since searching of S2 channels is done in the card and
> > not in the driver,
> > > its pretty hard to know what is going on there.
> > >
> > > Can't say what happens with the lock on
> > "good" channels since I don't have
> > > any S2 FTA in my sight.
> > >
> > > If anyone has any progress with S2 lock, let me know,
> > I'd like to join the
> > > forces.
> > >
> > >
> > >
> > > On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis
> > <alex.betis@gmail.com> wrote:
> > >
> > >> I'll send the patches to the list as soon as
> > I'll finish some more
> > >> debugging and clean the code from all the garbage
> > I've added there.
> > >>
> > >> Meanwhile I'd also like to wait for few people
> > responses who test those
> > >> patches. So far one person with Twinhan 1041 card
> > confirmed that the changes
> > >> "improved a lot" the locking. Waiting
> > for few more people with TT S2-3200 to
> > >> confirm it.
> > >>
> > >>
> > >> On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper <
> > >> newspaperman_germany@yahoo.com> wrote:
> > >>
> > >>> Hi Alex!
> > >>>
> > >>> This souds like good news!
> > >>> Hope you could help us with a patch from you.
> > >>>
> > >>> kind regards
> > >>>
> > >>>
> > >>> Newsy
> > >>>
> > >>>
> > >>> --- Alex Betis <alex.betis@gmail.com>
> > schrieb am Mo, 29.9.2008:
> > >>>
> > >>> > Von: Alex Betis
> > <alex.betis@gmail.com>
> > >>> > Betreff: Re: [linux-dvb] Re : Re : TT
> > S2-3200 driver
> > >>> > An: "Jelle De Loecker"
> > <skerit@kipdola.com>
> > >>> > CC: "linux-dvb"
> > <linux-dvb@linuxtv.org>
> > >>> > Datum: Montag, 29. September 2008, 16:13
> > >>> > Does that card use stb0899 drivers as
> > Twinhan 1041?
> > >>> >
> > >>> > I've done some changes to the
> > algorithm that provide
> > >>> > constant lock.
> > >>> >
> > >>> > 2008/9/29 Jelle De Loecker
> > <skerit@kipdola.com>
> > >>> >
> > >>> > >
> > >>> > > manu schreef:
> > >>> > >
> > >>> > > Le 13.09.2008 19:10:31, Manu Abraham
> > a =E9crit :
> > >>> > >
> > >>> > >
> > >>> > >  manu wrote:
> > >>> > >
> > >>> > >
> > >>> > >  I forgot the logs...
> > >>> > >
> > >>> > >
> > >>> > >  Taking a look at it. Please do note
> > that, i will have
> > >>> > to go through
> > >>> > > it
> > >>> > > very patiently.
> > >>> > >
> > >>> > > Thanks for the logs.
> > >>> > >
> > >>> > >
> > >>> > >
> > >>> > >  You're more than welcome. I
> > tried to put some
> > >>> > printk's but the only
> > >>> > > thing I got is that even when the
> > carrier is correctly
> > >>> > detected, the
> > >>> > > driver does not detect the data
> > (could that be related
> > >>> > to the different
> > >>> > > FEC?).
> > >>> > > Anyway let me know if you need more
> > testing.
> > >>> > > Bye
> > >>> > > Manu
> > >>> > >
> > >>> > >
> > >>> > > I'm unable to scan the channels
> > on the Astra 23,5
> > >>> > satellite
> > >>> > > Frequency 11856000
> > >>> > > Symbol rate 27500000
> > >>> > > Vertical polarisation
> > >>> > > FEC 5/6
> > >>> > >
> > >>> > > Is this because of the same bug? I
> > should be getting
> > >>> > Discovery Channel HD,
> > >>> > > National Geographic Channel HD,
> > Brava HDTV and Voom HD
> > >>> > International, but
> > >>> > > I'm only getting a time out.
> > >>> > >
> > >>> > >
> > >>> > > *Met vriendelijke groeten,*
> > >>> > >
> > >>> > > *Jelle De Loecker*
> > >>> > > Kipdola Studios - Tomberg
> > >>> > >
> > >>> > >
> > >>> > >
> > >>> > >
> > _______________________________________________
> > >>> > > linux-dvb mailing list
> > >>> > > linux-dvb@linuxtv.org
> > >>> > >
> > >>> >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >>> > >
> > >>> >
> > _______________________________________________
> > >>> > linux-dvb mailing list
> > >>> > linux-dvb@linuxtv.org
> > >>> >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >>>
> > >>>
> > >>>
> > >>>
> > >>>
> > >>>
> > _______________________________________________
> > >>> linux-dvb mailing list
> > >>> linux-dvb@linuxtv.org
> > >>>
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >>>
> > >>
> > >>
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>      __________________________________________________________
> Gesendet von Yahoo! Mail.
> Dem pfiffigeren Posteingang.
> http://de.overview.mail.yahoo.com
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_38815_3552618.1222956456742
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div>I have 2 &quot;bad&quot; transponders, one with 30000=
 2/3 and another with 27500 2/3</div>
<div>&nbsp;</div>
<div>So I don&#39;t think its symbol rate related. Although there is a prob=
lem with FEC lock, I don&#39;t think modulation (2/3 or 3/4) is related eit=
her.</div>
<div>&nbsp;</div>
<div>Since DVB-S scan algorithm also had problems with FEC lock I have a fe=
eling the same problem exist in S2 scan.</div>
<div>I&#39;ll try to play with it when I&#39;ll have time.<br><br></div>
<div class=3D"gmail_quote">On Thu, Oct 2, 2008 at 4:52 PM, Newsy Paper <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:newspaperman_germany@yahoo.com">newspap=
erman_germany@yahoo.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">I didn&#39;t experience any diff=
erences with dvb-s2 channels.<br>Those problematic transponders always prod=
uces corrupted video streams. It&#39;s always DVB-s2 30000 3/4. When enteri=
ng SR of 29999 I get constant lock, but the stream is corrupted. 1 HD chann=
el has only a VideoRate of 4,5 MBit and audio 77 kbit/s :(<br>
<br><br>kind regards<br><br>Newsy<br><br>--- Meysam Hariri &lt;<a href=3D"m=
ailto:meysam.hariri@gmail.com">meysam.hariri@gmail.com</a>&gt; schrieb am D=
o, 2.10.2008:<br><br>&gt; Von: Meysam Hariri &lt;<a href=3D"mailto:meysam.h=
ariri@gmail.com">meysam.hariri@gmail.com</a>&gt;<br>
&gt; Betreff: [linux-dvb] &nbsp;Re : Re : TT S2-3200 driver<br>&gt; An: <a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>&gt; Dat=
um: Donnerstag, 2. Oktober 2008, 0:21<br>
<div>
<div></div>
<div class=3D"Wj3C7c">&gt; Hi,<br>&gt;<br>&gt; thanks for your update. i us=
ed a TT-3200 device and<br>&gt; here&#39;s the results:<br>&gt; - i couldn&=
#39;t lock on some S2 channels or those<br>&gt; &#39;bad&#39; channels, alt=
hough i<br>
&gt; could get unstable lock on these channels using the<br>&gt; unpatched =
version, but<br>&gt; resulting in corrupted data. so the unpatched version =
still<br>&gt; works a bit<br>&gt; better.<br>&gt; - the lock on QPSK S2 cha=
nnels is fast and stable as it was<br>
&gt; with the<br>&gt; unpatched version<br>&gt; - locking on dvb-s channels=
 is also fast and stable<br>&gt;<br>&gt; i&#39;m ready to test any further =
updates.<br>&gt;<br>&gt; Regards,<br>&gt;<br>&gt;<br>&gt; 2008/10/1 Alex Be=
tis &lt;<a href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt=
;<br>
&gt;<br>&gt; Hi all,<br>&gt; &gt;<br>&gt; &gt; My description of the soluti=
on is here:<br>&gt; &gt;<br>&gt; <a href=3D"http://www.linuxtv.org/pipermai=
l/linux-dvb/2008-September/029361.html" target=3D"_blank">http://www.linuxt=
v.org/pipermail/linux-dvb/2008-September/029361.html</a><br>
&gt; &gt;<br>&gt; &gt; I&#39;ve also attaching the patches to this thread.<=
br>&gt; &gt;<br>&gt; &gt; Several people reported better lock on DVB-S chan=
nels.<br>&gt; &gt;<br>&gt; &gt; Just to clarify it, the changes mostly affe=
ct DVB-S<br>
&gt; channels scanning, it<br>&gt; &gt; doesn&#39;t help with DVB-S2 lockin=
g problem since the<br>&gt; code is totally different<br>&gt; &gt; for S an=
d S2 signal search.<br>&gt; &gt;<br>&gt; &gt; I&#39;ve increased a timer fo=
r S2 signal search and<br>
&gt; decreased the search step,<br>&gt; &gt; this helps to lock on &quot;go=
od&quot; S2 channels<br>&gt; that were locked anyway with<br>&gt; &gt; seve=
ral attempts, but this time it locks from first<br>&gt; attempt. The &quot;=
bad&quot;<br>
&gt; &gt; channels finds the signal, but the FEC is unable to<br>&gt; lock.=
<br>&gt; &gt; Since searching of S2 channels is done in the card and<br>&gt=
; not in the driver,<br>&gt; &gt; its pretty hard to know what is going on =
there.<br>
&gt; &gt;<br>&gt; &gt; Can&#39;t say what happens with the lock on<br>&gt; =
&quot;good&quot; channels since I don&#39;t have<br>&gt; &gt; any S2 FTA in=
 my sight.<br>&gt; &gt;<br>&gt; &gt; If anyone has any progress with S2 loc=
k, let me know,<br>
&gt; I&#39;d like to join the<br>&gt; &gt; forces.<br>&gt; &gt;<br>&gt; &gt=
;<br>&gt; &gt;<br>&gt; &gt; On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis<br=
>&gt; &lt;<a href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&=
gt; wrote:<br>
&gt; &gt;<br>&gt; &gt;&gt; I&#39;ll send the patches to the list as soon as=
<br>&gt; I&#39;ll finish some more<br>&gt; &gt;&gt; debugging and clean the=
 code from all the garbage<br>&gt; I&#39;ve added there.<br>&gt; &gt;&gt;<b=
r>
&gt; &gt;&gt; Meanwhile I&#39;d also like to wait for few people<br>&gt; re=
sponses who test those<br>&gt; &gt;&gt; patches. So far one person with Twi=
nhan 1041 card<br>&gt; confirmed that the changes<br>&gt; &gt;&gt; &quot;im=
proved a lot&quot; the locking. Waiting<br>
&gt; for few more people with TT S2-3200 to<br>&gt; &gt;&gt; confirm it.<br=
>&gt; &gt;&gt;<br>&gt; &gt;&gt;<br>&gt; &gt;&gt; On Tue, Sep 30, 2008 at 12=
:35 PM, Newsy Paper &lt;<br>&gt; &gt;&gt; <a href=3D"mailto:newspaperman_ge=
rmany@yahoo.com">newspaperman_germany@yahoo.com</a>&gt; wrote:<br>
&gt; &gt;&gt;<br>&gt; &gt;&gt;&gt; Hi Alex!<br>&gt; &gt;&gt;&gt;<br>&gt; &g=
t;&gt;&gt; This souds like good news!<br>&gt; &gt;&gt;&gt; Hope you could h=
elp us with a patch from you.<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; kin=
d regards<br>
&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; Newsy<br>&gt; &=
gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; --- Alex Betis &lt;<a=
 href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt;<br>&gt; =
schrieb am Mo, 29.9.2008:<br>
&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; &gt; Von: Alex Betis<br>&gt; &lt;<a =
href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt;<br>&gt; &=
gt;&gt;&gt; &gt; Betreff: Re: [linux-dvb] Re : Re : TT<br>&gt; S2-3200 driv=
er<br>
&gt; &gt;&gt;&gt; &gt; An: &quot;Jelle De Loecker&quot;<br>&gt; &lt;<a href=
=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a>&gt;<br>&gt; &gt;&gt;&=
gt; &gt; CC: &quot;linux-dvb&quot;<br>&gt; &lt;<a href=3D"mailto:linux-dvb@=
linuxtv.org">linux-dvb@linuxtv.org</a>&gt;<br>
&gt; &gt;&gt;&gt; &gt; Datum: Montag, 29. September 2008, 16:13<br>&gt; &gt=
;&gt;&gt; &gt; Does that card use stb0899 drivers as<br>&gt; Twinhan 1041?<=
br>&gt; &gt;&gt;&gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; I&#39;ve done some chan=
ges to the<br>
&gt; algorithm that provide<br>&gt; &gt;&gt;&gt; &gt; constant lock.<br>&gt=
; &gt;&gt;&gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; 2008/9/29 Jelle De Loecker<br=
>&gt; &lt;<a href=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a>&gt;<=
br>
&gt; &gt;&gt;&gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; =
&gt; &gt; manu schreef:<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt;=
 &gt; &gt; Le 13.09.2008 19:10:31, Manu Abraham<br>&gt; a =E9crit :<br>&gt;=
 &gt;&gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; &nbsp;manu wrote=
:<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt=
;&gt;&gt; &gt; &gt; &nbsp;I forgot the logs...<br>&gt; &gt;&gt;&gt; &gt; &g=
t;<br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; &nbsp;Taking a l=
ook at it. Please do note<br>&gt; that, i will have<br>&gt; &gt;&gt;&gt; &g=
t; to go through<br>&gt; &gt;&gt;&gt; &gt; &gt; it<br>&gt; &gt;&gt;&gt; &gt=
; &gt; very patiently.<br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; Thanks for the l=
ogs.<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; =
&gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; &nbsp;You&#39;re more=
 than welcome. I<br>
&gt; tried to put some<br>&gt; &gt;&gt;&gt; &gt; printk&#39;s but the only<=
br>&gt; &gt;&gt;&gt; &gt; &gt; thing I got is that even when the<br>&gt; ca=
rrier is correctly<br>&gt; &gt;&gt;&gt; &gt; detected, the<br>&gt; &gt;&gt;=
&gt; &gt; &gt; driver does not detect the data<br>
&gt; (could that be related<br>&gt; &gt;&gt;&gt; &gt; to the different<br>&=
gt; &gt;&gt;&gt; &gt; &gt; FEC?).<br>&gt; &gt;&gt;&gt; &gt; &gt; Anyway let=
 me know if you need more<br>&gt; testing.<br>&gt; &gt;&gt;&gt; &gt; &gt; B=
ye<br>
&gt; &gt;&gt;&gt; &gt; &gt; Manu<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt=
;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; I&#39;m unable to scan t=
he channels<br>&gt; on the Astra 23,5<br>&gt; &gt;&gt;&gt; &gt; satellite<b=
r>
&gt; &gt;&gt;&gt; &gt; &gt; Frequency 11856000<br>&gt; &gt;&gt;&gt; &gt; &g=
t; Symbol rate 27500000<br>&gt; &gt;&gt;&gt; &gt; &gt; Vertical polarisatio=
n<br>&gt; &gt;&gt;&gt; &gt; &gt; FEC 5/6<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt;&gt; &gt; &gt; Is this because of the same bug? I<br>&gt; shou=
ld be getting<br>&gt; &gt;&gt;&gt; &gt; Discovery Channel HD,<br>&gt; &gt;&=
gt;&gt; &gt; &gt; National Geographic Channel HD,<br>&gt; Brava HDTV and Vo=
om HD<br>
&gt; &gt;&gt;&gt; &gt; International, but<br>&gt; &gt;&gt;&gt; &gt; &gt; I&=
#39;m only getting a time out.<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&=
gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; *Met vriendelijke groeten,=
*<br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt; *Jelle De Loecke=
r*<br>&gt; &gt;&gt;&gt; &gt; &gt; Kipdola Studios - Tomberg<br>&gt; &gt;&gt=
;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt; &g=
t;<br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; _______________________________________=
________<br>&gt; &gt;&gt;&gt; &gt; &gt; linux-dvb mailing list<br>&gt; &gt;=
&gt;&gt; &gt; &gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linux=
tv.org</a><br>
&gt; &gt;&gt;&gt; &gt; &gt;<br>&gt; &gt;&gt;&gt; &gt;<br>&gt; <a href=3D"ht=
tp://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">=
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>&gt; &gt;&=
gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt;&gt; &gt;<br>&gt; ____________________________________________=
___<br>&gt; &gt;&gt;&gt; &gt; linux-dvb mailing list<br>&gt; &gt;&gt;&gt; &=
gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &gt;&gt;&gt; &gt;<br>&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/ma=
ilman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/=
mailman/listinfo/linux-dvb</a><br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br=
>
&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt=
;&gt;<br>&gt; _______________________________________________<br>&gt; &gt;&=
gt;&gt; linux-dvb mailing list<br>&gt; &gt;&gt;&gt; <a href=3D"mailto:linux=
-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &gt;&gt;&gt;<br>&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman=
/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailm=
an/listinfo/linux-dvb</a><br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;<br>&gt; &gt=
;&gt;<br>
&gt; &gt;<br>&gt; &gt; _______________________________________________<br>&=
gt; &gt; linux-dvb mailing list<br>&gt; &gt; <a href=3D"mailto:linux-dvb@li=
nuxtv.org">linux-dvb@linuxtv.org</a><br>&gt; &gt;<br>&gt; <a href=3D"http:/=
/www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http=
://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &gt;<br>&gt; _______________________________________________<br>&gt; l=
inux-dvb mailing list<br>&gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linu=
x-dvb@linuxtv.org</a><br>&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mai=
lman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/m=
ailman/listinfo/linux-dvb</a><br>
<br><br></div></div>
<div class=3D"WgoR0d">&nbsp; &nbsp; &nbsp;_________________________________=
_________________________<br>Gesendet von Yahoo! Mail.<br>Dem pfiffigeren P=
osteingang.<br><a href=3D"http://de.overview.mail.yahoo.com/" target=3D"_bl=
ank">http://de.overview.mail.yahoo.com</a><br>
</div>
<div>
<div></div>
<div class=3D"Wj3C7c"><br><br>_____________________________________________=
__<br>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb@linuxtv.org">li=
nux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.org/cgi-bin/mailma=
n/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mail=
man/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_38815_3552618.1222956456742--


--===============0116188234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0116188234==--
