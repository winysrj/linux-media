Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Kkbq4-00039N-1u
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 11:48:16 +0200
Received: by qw-out-2122.google.com with SMTP id 9so355553qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 02:48:12 -0700 (PDT)
Message-ID: <c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
Date: Tue, 30 Sep 2008 12:48:11 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: newspaperman_germany@yahoo.com
In-Reply-To: <909452.76198.qm@web23201.mail.ird.yahoo.com>
MIME-Version: 1.0
References: <c74595dc0809290713i7ca11bdfw3424c8347e9a6d9e@mail.gmail.com>
	<909452.76198.qm@web23201.mail.ird.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2121173405=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2121173405==
Content-Type: multipart/alternative;
	boundary="----=_Part_23508_25360546.1222768091635"

------=_Part_23508_25360546.1222768091635
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'll send the patches to the list as soon as I'll finish some more debuggin=
g
and clean the code from all the garbage I've added there.

Meanwhile I'd also like to wait for few people responses who test those
patches. So far one person with Twinhan 1041 card confirmed that the change=
s
"improved a lot" the locking. Waiting for few more people with TT S2-3200 t=
o
confirm it.

On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper <
newspaperman_germany@yahoo.com> wrote:

> Hi Alex!
>
> This souds like good news!
> Hope you could help us with a patch from you.
>
> kind regards
>
>
> Newsy
>
>
> --- Alex Betis <alex.betis@gmail.com> schrieb am Mo, 29.9.2008:
>
> > Von: Alex Betis <alex.betis@gmail.com>
> > Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver
> > An: "Jelle De Loecker" <skerit@kipdola.com>
> > CC: "linux-dvb" <linux-dvb@linuxtv.org>
> > Datum: Montag, 29. September 2008, 16:13
> > Does that card use stb0899 drivers as Twinhan 1041?
> >
> > I've done some changes to the algorithm that provide
> > constant lock.
> >
> > 2008/9/29 Jelle De Loecker <skerit@kipdola.com>
> >
> > >
> > > manu schreef:
> > >
> > > Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :
> > >
> > >
> > >  manu wrote:
> > >
> > >
> > >  I forgot the logs...
> > >
> > >
> > >  Taking a look at it. Please do note that, i will have
> > to go through
> > > it
> > > very patiently.
> > >
> > > Thanks for the logs.
> > >
> > >
> > >
> > >  You're more than welcome. I tried to put some
> > printk's but the only
> > > thing I got is that even when the carrier is correctly
> > detected, the
> > > driver does not detect the data (could that be related
> > to the different
> > > FEC?).
> > > Anyway let me know if you need more testing.
> > > Bye
> > > Manu
> > >
> > >
> > > I'm unable to scan the channels on the Astra 23,5
> > satellite
> > > Frequency 11856000
> > > Symbol rate 27500000
> > > Vertical polarisation
> > > FEC 5/6
> > >
> > > Is this because of the same bug? I should be getting
> > Discovery Channel HD,
> > > National Geographic Channel HD, Brava HDTV and Voom HD
> > International, but
> > > I'm only getting a time out.
> > >
> > >
> > > *Met vriendelijke groeten,*
> > >
> > > *Jelle De Loecker*
> > > Kipdola Studios - Tomberg
> > >
> > >
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
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_23508_25360546.1222768091635
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">I&#39;ll send the patches to the list as soon as I&#39;ll =
finish some more debugging and clean the code from all the garbage I&#39;ve=
 added there.<br><br>Meanwhile I&#39;d also like to wait for few people res=
ponses who test those patches. So far one person with Twinhan 1041 card con=
firmed that the changes &quot;improved a lot&quot; the locking. Waiting for=
 few more people with TT S2-3200 to confirm it.<br>
<br><div class=3D"gmail_quote">On Tue, Sep 30, 2008 at 12:35 PM, Newsy Pape=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:newspaperman_germany@yahoo.com">n=
ewspaperman_germany@yahoo.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0=
pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Alex!<br>
<br>
This souds like good news!<br>
Hope you could help us with a patch from you.<br>
<br>
kind regards<br>
<br>
<br>
Newsy<br>
<br>
<br>
--- Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail=
.com</a>&gt; schrieb am Mo, 29.9.2008:<br>
<br>
&gt; Von: Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com">alex.betis=
@gmail.com</a>&gt;<br>
&gt; Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver<br>
&gt; An: &quot;Jelle De Loecker&quot; &lt;<a href=3D"mailto:skerit@kipdola.=
com">skerit@kipdola.com</a>&gt;<br>
&gt; CC: &quot;linux-dvb&quot; &lt;<a href=3D"mailto:linux-dvb@linuxtv.org"=
>linux-dvb@linuxtv.org</a>&gt;<br>
&gt; Datum: Montag, 29. September 2008, 16:13<br>
<div><div></div><div class=3D"Wj3C7c">&gt; Does that card use stb0899 drive=
rs as Twinhan 1041?<br>
&gt;<br>
&gt; I&#39;ve done some changes to the algorithm that provide<br>
&gt; constant lock.<br>
&gt;<br>
&gt; 2008/9/29 Jelle De Loecker &lt;<a href=3D"mailto:skerit@kipdola.com">s=
kerit@kipdola.com</a>&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; manu schreef:<br>
&gt; &gt;<br>
&gt; &gt; Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;manu wrote:<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;I forgot the logs...<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;Taking a look at it. Please do note that, i will have<br>
&gt; to go through<br>
&gt; &gt; it<br>
&gt; &gt; very patiently.<br>
&gt; &gt;<br>
&gt; &gt; Thanks for the logs.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;You&#39;re more than welcome. I tried to put some<br>
&gt; printk&#39;s but the only<br>
&gt; &gt; thing I got is that even when the carrier is correctly<br>
&gt; detected, the<br>
&gt; &gt; driver does not detect the data (could that be related<br>
&gt; to the different<br>
&gt; &gt; FEC?).<br>
&gt; &gt; Anyway let me know if you need more testing.<br>
&gt; &gt; Bye<br>
&gt; &gt; Manu<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m unable to scan the channels on the Astra 23,5<br>
&gt; satellite<br>
&gt; &gt; Frequency 11856000<br>
&gt; &gt; Symbol rate 27500000<br>
&gt; &gt; Vertical polarisation<br>
&gt; &gt; FEC 5/6<br>
&gt; &gt;<br>
&gt; &gt; Is this because of the same bug? I should be getting<br>
&gt; Discovery Channel HD,<br>
&gt; &gt; National Geographic Channel HD, Brava HDTV and Voom HD<br>
&gt; International, but<br>
&gt; &gt; I&#39;m only getting a time out.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; *Met vriendelijke groeten,*<br>
&gt; &gt;<br>
&gt; &gt; *Jelle De Loecker*<br>
&gt; &gt; Kipdola Studios - Tomberg<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; _______________________________________________<br>
&gt; &gt; linux-dvb mailing list<br>
&gt; &gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a=
><br>
&gt; &gt;<br>
&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</a><br>
&gt; &gt;<br>
&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</a><br>
<br>
<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br></div>

------=_Part_23508_25360546.1222768091635--


--===============2121173405==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2121173405==--
