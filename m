Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1Jq5Gt-00022d-1y
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 13:42:21 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2945967rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 27 Apr 2008 04:42:14 -0700 (PDT)
Message-ID: <617be8890804270442t5318e322g8904e6e698c70a15@mail.gmail.com>
Date: Sun, 27 Apr 2008 13:42:14 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200804270540.29590.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
	<200804270540.29590.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] a700 support (was: [patch 5/5] mt312: add
	attach-time setting to invert lnb-voltage (Matthias Schwarzott))
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1983155659=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1983155659==
Content-Type: multipart/alternative;
	boundary="----=_Part_2182_23429818.1209296534079"

------=_Part_2182_23429818.1209296534079
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thank you very much, Matthias. I was going to try the patch right now,
however I'm finding that it doesn't apply clean to the current HG tree. Thi=
s
is what I'm getting:

patching file linux/drivers/media/dvb/frontends/Kconfig
Hunk #1 FAILED at 368.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/dvb/frontends/Kconfig.rej
patching file linux/drivers/media/dvb/frontends/Makefile
Hunk #1 succeeded at 23 (offset -2 lines).
patching file linux/drivers/media/dvb/frontends/zl10036.c
patching file linux/drivers/media/dvb/frontends/zl10036.h
patching file linux/drivers/media/video/saa7134/Kconfig
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #3 succeeded at 5716 (offset 42 lines).
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c

I've tried to manually patch Kconfig by adding the rejected lines, but I
suppose there must something I'm doing wrong: apparently it compiles fine,
but saa7134-dvb is not loaded and the frontend is not being created for the
card (although the card is detected and the video0 device for analog is
there).

I'll apreciate any hints you could give me, I'm impatient to test this.
Plus, I'm seing lately some cross posted messages regarding the chips on
this cards, so maybe there's some hope for it :D

Best regards,
  Eduard




2008/4/27 Matthias Schwarzott <zzam@gentoo.org>:

> On Montag, 14. April 2008, Eduard Huguet wrote:
> > > ---------- Missatge reenviat ----------
> > > From: Matthias Schwarzott <zzam@gentoo.org>
> > > To: linux-dvb@linuxtv.org
> > > Date: Sat, 12 Apr 2008 17:04:50 +0200
> > > Subject: [linux-dvb] [patch 5/5] mt312: add attach-time setting to
> invert
> > > lnb-voltage
> > > Add a setting to config struct for inversion of lnb-voltage.
> > > Needed for support of Avermedia A700 cards.
> > >
> > > Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> > > Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
> > > +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> > > @@ -422,11 +422,16 @@ static int mt312_set_voltage(struct dvb_
> > >   {
> > >         struct mt312_state *state =3D fe->demodulator_priv;
> > >         const u8 volt_tab[3] =3D { 0x00, 0x40, 0x00 };
> > > +       u8 val;
> > >
> > >         if (v > SEC_VOLTAGE_OFF)
> > >                 return -EINVAL;
> > >
> > > -       return mt312_writereg(state, DISEQC_MODE, volt_tab[v]);
> > > +       val =3D volt_tab[v];
> > > +       if (state->config->voltage_inverted)
> > > +               val ^=3D 0x40;
> > > +
> > > +       return mt312_writereg(state, DISEQC_MODE, val);
> > >   }
> > >
> > >   static int mt312_read_status(struct dvb_frontend *fe, fe_status_t
> *s)
> > > Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.h
> > > +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> > > @@ -31,6 +31,9 @@
> > >   struct mt312_config {
> > >         /* the demodulator's i2c address */
> > >         u8 demod_address;
> > > +
> > > +       /* inverted voltage setting */
> > > +       int voltage_inverted:1;
> > >   };
> > >
> > >   #if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312_MODULE)
> &&
> > > defined(MODULE))
> > > --
> >
> > Thanks for the patches. =BFIs your lastest unified diff on your page
> > (a700_full_20080412.diff) equivalent to these patches or must they be
> > applied separately?
> Another 2 weeks later. These patches already have been applied at hg
> level. So
> now the new remaining full patch (a700_full_20080427.diff) is to be
> applied
> on top.
>
> It contains a zl10036 driver and the changes to the glue code in
> saa7134-dvb.
> zl10036 works most of the time here, but I am not fully happy with its
> current
> design.
>
> Open issues:
> * Should set_params routine be kept spiltted as it is?
> * Is bandwidth handling sane?
> Now calc the needed bw by symbolrate and add 3MHz.
> Datasheet suggests to start at max setting and decrease as possible after
> the
> lock is established (using freq. offset info from demod).
> * The used gain values are found by try and error and do not work for all
> transponders here.
> The most difficult transponder here was RTL - and that now works for me
> with
> exactly these gain settings (rfg=3D0, ba=3D1, bg=3D1).
>
> >
> > I'll try to some tests tonight, if you have made some progress. By the
> way,
> > =BFcould you tell me if it's better to use use_frontend=3D0 or 1 for
> > saa7134-dvb module? I think that this changes the driver used for
> frontend,
> > but I'm not sure.
>
> use_frontend is intended to be used for choosing between dvb-s and dvb-t
> or
> similar if the frontend offers both exclusively. I abused this parameter
> to
> choose between the two driver for zl10313 demod. This is no longer used,
> so
> forget about this parameter.
>
> Regards
> Matthias
>

------=_Part_2182_23429818.1209296534079
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thank you very much, Matthias. I was going to try the patch right now, howe=
ver I&#39;m finding that it doesn&#39;t apply clean to the current HG tree.=
 This is what I&#39;m getting:<br><br><span style=3D"font-family: courier n=
ew,monospace;">patching file linux/drivers/media/dvb/frontends/Kconfig</spa=
n><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Hunk #1 FAILED at 368.<=
/span><br style=3D"font-family: courier new,monospace;"><span style=3D"font=
-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects t=
o file linux/drivers/media/dvb/frontends/Kconfig.rej</span><br style=3D"fon=
t-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">patching file linux/dri=
vers/media/dvb/frontends/Makefile</span><br style=3D"font-family: courier n=
ew,monospace;"><span style=3D"font-family: courier new,monospace;">Hunk #1 =
succeeded at 23 (offset -2 lines).</span><br style=3D"font-family: courier =
new,monospace;">
<span style=3D"font-family: courier new,monospace;">patching file linux/dri=
vers/media/dvb/frontends/zl10036.c</span><br style=3D"font-family: courier =
new,monospace;"><span style=3D"font-family: courier new,monospace;">patchin=
g file linux/drivers/media/dvb/frontends/zl10036.h</span><br style=3D"font-=
family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">patching file linux/dri=
vers/media/video/saa7134/Kconfig</span><br style=3D"font-family: courier ne=
w,monospace;"><span style=3D"font-family: courier new,monospace;">patching =
file linux/drivers/media/video/saa7134/saa7134-cards.c</span><br style=3D"f=
ont-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Hunk #3 succeeded at 57=
16 (offset 42 lines).</span><br style=3D"font-family: courier new,monospace=
;"><span style=3D"font-family: courier new,monospace;">patching file linux/=
drivers/media/video/saa7134/saa7134-dvb.c</span><br style=3D"font-family: c=
ourier new,monospace;">
<br>I&#39;ve tried to manually patch Kconfig by adding the rejected lines, =
but I suppose there must something I&#39;m doing wrong: apparently it compi=
les fine, but saa7134-dvb is not loaded and the frontend is not being creat=
ed for the card (although the card is detected and the video0 device for an=
alog is there).<br>
<br>I&#39;ll apreciate any hints you could give me, I&#39;m impatient to te=
st this. Plus, I&#39;m seing lately some cross posted messages regarding th=
e chips on this cards, so maybe there&#39;s some hope for it :D<br><br>
Best regards, <br>&nbsp; Eduard<br><br><br><br><br><div class=3D"gmail_quot=
e">2008/4/27 Matthias Schwarzott &lt;<a href=3D"mailto:zzam@gentoo.org">zza=
m@gentoo.org</a>&gt;:<br><blockquote class=3D"gmail_quote" style=3D"border-=
left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left=
: 1ex;">
On Montag, 14. April 2008, Eduard Huguet wrote:<br>
&gt; &gt; ---------- Missatge reenviat ----------<br>
&gt; &gt; From: Matthias Schwarzott &lt;<a href=3D"mailto:zzam@gentoo.org">=
zzam@gentoo.org</a>&gt;<br>
&gt; &gt; To: <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.or=
g</a><br>
&gt; &gt; Date: Sat, 12 Apr 2008 17:04:50 +0200<br>
&gt; &gt; Subject: [linux-dvb] [patch 5/5] mt312: add attach-time setting t=
o invert<br>
&gt; &gt; lnb-voltage<br>
&gt; &gt; Add a setting to config struct for inversion of lnb-voltage.<br>
&gt; &gt; Needed for support of Avermedia A700 cards.<br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Matthias Schwarzott &lt;<a href=3D"mailto:zzam@gen=
too.org">zzam@gentoo.org</a>&gt;<br>
&gt; &gt; Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c<br>
&gt; &gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; &gt; --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c<br>
&gt; &gt; +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c<br>
&gt; &gt; @@ -422,11 +422,16 @@ static int mt312_set_voltage(struct dvb_<br=
>
&gt; &gt; &nbsp; {<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; struct mt312_state *state =3D fe-&gt;=
demodulator_priv;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; const u8 volt_tab[3] =3D { 0x00, 0x40=
, 0x00 };<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; u8 val;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; if (v &gt; SEC_VOLTAGE_OFF)<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -E=
INVAL;<br>
&gt; &gt;<br>
&gt; &gt; - &nbsp; &nbsp; &nbsp; return mt312_writereg(state, DISEQC_MODE, =
volt_tab[v]);<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; val =3D volt_tab[v];<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; if (state-&gt;config-&gt;voltage_inverted)=
<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; val ^=3D 0x40;=
<br>
&gt; &gt; +<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; return mt312_writereg(state, DISEQC_MODE, =
val);<br>
&gt; &gt; &nbsp; }<br>
&gt; &gt;<br>
&gt; &gt; &nbsp; static int mt312_read_status(struct dvb_frontend *fe, fe_s=
tatus_t *s)<br>
&gt; &gt; Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h<br>
&gt; &gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; &gt; --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.h<br>
&gt; &gt; +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h<br>
&gt; &gt; @@ -31,6 +31,9 @@<br>
&gt; &gt; &nbsp; struct mt312_config {<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; /* the demodulator&#39;s i2c address =
*/<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; u8 demod_address;<br>
&gt; &gt; +<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; /* inverted voltage setting */<br>
&gt; &gt; + &nbsp; &nbsp; &nbsp; int voltage_inverted:1;<br>
&gt; &gt; &nbsp; };<br>
&gt; &gt;<br>
&gt; &gt; &nbsp; #if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312=
_MODULE) &amp;&amp;<br>
&gt; &gt; defined(MODULE))<br>
&gt; &gt; --<br>
&gt;<br>
&gt; Thanks for the patches. =BFIs your lastest unified diff on your page<b=
r>
&gt; (a700_full_20080412.diff) equivalent to these patches or must they be<=
br>
&gt; applied separately?<br>
Another 2 weeks later. These patches already have been applied at hg level.=
 So<br>
now the new remaining full patch (a700_full_20080427.diff) is to be applied=
<br>
on top.<br>
<br>
It contains a zl10036 driver and the changes to the glue code in saa7134-dv=
b.<br>
zl10036 works most of the time here, but I am not fully happy with its curr=
ent<br>
design.<br>
<br>
Open issues:<br>
* Should set_params routine be kept spiltted as it is?<br>
* Is bandwidth handling sane?<br>
Now calc the needed bw by symbolrate and add 3MHz.<br>
Datasheet suggests to start at max setting and decrease as possible after t=
he<br>
lock is established (using freq. offset info from demod).<br>
* The used gain values are found by try and error and do not work for all<b=
r>
transponders here.<br>
The most difficult transponder here was RTL - and that now works for me wit=
h<br>
exactly these gain settings (rfg=3D0, ba=3D1, bg=3D1).<br>
<br>
&gt;<br>
&gt; I&#39;ll try to some tests tonight, if you have made some progress. By=
 the way,<br>
&gt; =BFcould you tell me if it&#39;s better to use use_frontend=3D0 or 1 f=
or<br>
&gt; saa7134-dvb module? I think that this changes the driver used for fron=
tend,<br>
&gt; but I&#39;m not sure.<br>
<br>
use_frontend is intended to be used for choosing between dvb-s and dvb-t or=
<br>
similar if the frontend offers both exclusively. I abused this parameter to=
<br>
choose between the two driver for zl10313 demod. This is no longer used, so=
<br>
forget about this parameter.<br>
<br>
Regards<br>
<font color=3D"#888888">Matthias<br>
</font></blockquote></div><br>

------=_Part_2182_23429818.1209296534079--


--===============1983155659==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1983155659==--
