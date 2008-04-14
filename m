Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JlKhd-0006uZ-C7
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 11:10:26 +0200
Received: by rv-out-0506.google.com with SMTP id b25so714370rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 14 Apr 2008 02:09:59 -0700 (PDT)
Message-ID: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
Date: Mon, 14 Apr 2008 11:09:59 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [patch 5/5] mt312: add attach-time setting to
	invert lnb-voltage (Matthias Schwarzott)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1987909761=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1987909761==
Content-Type: multipart/alternative;
	boundary="----=_Part_36719_5459260.1208164199157"

------=_Part_36719_5459260.1208164199157
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: Matthias Schwarzott <zzam@gentoo.org>
> To: linux-dvb@linuxtv.org
> Date: Sat, 12 Apr 2008 17:04:50 +0200
> Subject: [linux-dvb] [patch 5/5] mt312: add attach-time setting to invert
> lnb-voltage
> Add a setting to config struct for inversion of lnb-voltage.
> Needed for support of Avermedia A700 cards.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
> +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> @@ -422,11 +422,16 @@ static int mt312_set_voltage(struct dvb_
>   {
>         struct mt312_state *state =3D fe->demodulator_priv;
>         const u8 volt_tab[3] =3D { 0x00, 0x40, 0x00 };
> +       u8 val;
>
>         if (v > SEC_VOLTAGE_OFF)
>                 return -EINVAL;
>
> -       return mt312_writereg(state, DISEQC_MODE, volt_tab[v]);
> +       val =3D volt_tab[v];
> +       if (state->config->voltage_inverted)
> +               val ^=3D 0x40;
> +
> +       return mt312_writereg(state, DISEQC_MODE, val);
>   }
>
>   static int mt312_read_status(struct dvb_frontend *fe, fe_status_t *s)
> Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.h
> +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> @@ -31,6 +31,9 @@
>   struct mt312_config {
>         /* the demodulator's i2c address */
>         u8 demod_address;
> +
> +       /* inverted voltage setting */
> +       int voltage_inverted:1;
>   };
>
>   #if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312_MODULE) &&
> defined(MODULE))
> --
>


Thanks for the patches. =BFIs your lastest unified diff on your page
(a700_full_20080412.diff) equivalent to these patches or must they be
applied separately?

I'll try to some tests tonight, if you have made some progress. By the way,
=BFcould you tell me if it's better to use use_frontend=3D0 or 1 for saa713=
4-dvb
module? I think that this changes the driver used for frontend, but I'm not
sure.

Regards,
  Eduard

------=_Part_36719_5459260.1208164199157
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div><span class=3D"gmail_quote"></span><blockquote class=3D"gmail_quote" s=
tyle=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8e=
x; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From: Mat=
thias Schwarzott &lt;<a href=3D"mailto:zzam@gentoo.org">zzam@gentoo.org</a>=
&gt;<br>
To: <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>D=
ate: Sat, 12 Apr 2008 17:04:50 +0200<br>Subject: [linux-dvb] [patch 5/5] mt=
312: add attach-time setting to invert lnb-voltage<br>Add a setting to conf=
ig struct for inversion of lnb-voltage.<br>
 Needed for support of Avermedia A700 cards.<br> <br> Signed-off-by: Matthi=
as Schwarzott &lt;<a href=3D"mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt=
;<br> Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c<br> =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
 --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c<br> +++ v4l-dvb=
/linux/drivers/media/dvb/frontends/mt312.c<br> @@ -422,11 +422,16 @@ static=
 int mt312_set_voltage(struct dvb_<br>&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;struct mt312_state *state =3D fe-&gt;demodulato=
r_priv;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;const u8 volt_tab[3] =3D { =
0x00, 0x40, 0x00 };<br> +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u8 val;<br> <=
br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (v &gt; SEC_VOLTAGE_O=
FF)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;return -EINVAL;<br> <br> -&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; return mt312_writereg(state, DISEQC_MODE, volt_tab[v]);<br>
 +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; val =3D volt_tab[v];<br> +&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; if (state-&gt;config-&gt;voltage_inverted)<br> +=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; val ^=3D 0x40;<br> +<br> +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; re=
turn mt312_writereg(state, DISEQC_MODE, val);<br>&nbsp;&nbsp;}<br> <br>&nbs=
p;&nbsp;static int mt312_read_status(struct dvb_frontend *fe, fe_status_t *=
s)<br>
 Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h<br> =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br> --- v4l-dvb.orig/linux/drivers/=
media/dvb/frontends/mt312.h<br> +++ v4l-dvb/linux/drivers/media/dvb/fronten=
ds/mt312.h<br>
 @@ -31,6 +31,9 @@<br>&nbsp;&nbsp;struct mt312_config {<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/* the demodulator&#39;s i2c address */<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;u8 demod_address;<br> +<br>=
 +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* inverted voltage setting */<br> +=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int voltage_inverted:1;<br>&nbsp;&nbsp=
;};<br>
 <br>&nbsp;&nbsp;#if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312=
_MODULE) &amp;&amp; defined(MODULE))<br> --<br> </blockquote></div><br><br>=
Thanks for the patches. =BFIs your lastest unified diff on your page (a700_=
full_20080412.diff) equivalent to these patches or must they be applied sep=
arately?<br>
<br>I&#39;ll try to some tests tonight, if you have made some progress. By =
the way, =BFcould you tell me if it&#39;s better to use use_frontend=3D0 or=
 1 for saa7134-dvb module? I think that this changes the driver used for fr=
ontend, but I&#39;m not sure.<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br><br><br>

------=_Part_36719_5459260.1208164199157--


--===============1987909761==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1987909761==--
