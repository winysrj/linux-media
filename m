Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ian.bonham@gmail.com>) id 1JqYHo-0005Xd-T8
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 20:41:14 +0200
Received: by py-out-1112.google.com with SMTP id a29so5778738pyi.0
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 11:41:05 -0700 (PDT)
Message-ID: <2f8cbffc0804281141n3539e111i3b41cac7122cc462@mail.gmail.com>
Date: Mon, 28 Apr 2008 20:41:05 +0200
From: "Ian Bonham" <ian.bonham@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48156679.3030000@schoebel-online.net>
MIME-Version: 1.0
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
	<E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
	<48156679.3030000@schoebel-online.net>
Subject: Re: [linux-dvb] HVR4000 & Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1792180706=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1792180706==
Content-Type: multipart/alternative;
	boundary="----=_Part_6632_10805603.1209408065397"

------=_Part_6632_10805603.1209408065397
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Many thanks for all your help everyone, following Hagen's tip I went into
/lib/modules/2.6.24-16-generic/ubuntu/media and just "rm -rf"'d the whole
cx88 directory. Then re-checked out the older v4l-dvb tree, repatched it
with dev.kewl.org's stable mfe patch and everything seems to be Ok now.

Thanks for your help guys,

Ian



2008/4/28 Hagen Sch=F6bel <hagen@schoebel-online.net>:

>
> Before you try the 'new' modules you have to remove the 'original'
> Ubuntu-Version of cx88*. These modules can found in
> /lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don't now why not in
> normal tree) and come with paket linux-ubuntu-modules-2.6.24-16-generic.
>
> Hagen
>
>  Hi All.
> > >
> > > Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy
> > > Heron) on
> > > my machine with the HVR4000 in, and now, no TV! It's gone on with
> > > kernel
> > > 2.6.24-16 on a P4 HyperThread, and everything worked just fine under
> > > Gutsy.
> > > I've pulled down the v4l-dvb tree (current and revision 127f67dea087
> > > as
> > > suggested in Wiki) and tried patching with dev.kewl.org's MFE and SFE
> > > current patches (7285) and the latest.
> > >
> > > Everything 'seems' to compile Ok, and installs fine. When I reboot
> > > however I
> > > get a huge chunk of borked stuff and no card. (Dmesg output at end of
> > > message)
> > >
> > > Could anyone please give me any pointers on how (or if) they have
> > > their
> > > HVR4000 running under Ubuntu 8.04LTS ?
> > >
> > > Would really appriciate it.
> > > Thanks in advance,
> > >
> > > Ian
> > >
> > > DMESG Output:
> > > cx88xx: disagrees about version of symbol videobuf_waiton
> > > [   37.790909] cx88xx: Unknown symbol videobuf_waiton
> > >
> > >
> > >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
>
>

------=_Part_6632_10805603.1209408065397
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Many thanks for all your help everyone, following Hagen&#39;s tip I went in=
to /lib/modules/2.6.24-16-generic/ubuntu/media and just &quot;rm -rf&quot;&=
#39;d the whole cx88 directory. Then re-checked out the older v4l-dvb tree,=
 repatched it with dev.kewl.org&#39;s stable mfe patch and everything seems=
 to be Ok now.<br>
<br>Thanks for your help guys,<br><br>Ian<br><br><br><br><div class=3D"gmai=
l_quote">2008/4/28 Hagen Sch=F6bel &lt;<a href=3D"mailto:hagen@schoebel-onl=
ine.net">hagen@schoebel-online.net</a>&gt;:<br><blockquote class=3D"gmail_q=
uote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0=
pt 0.8ex; padding-left: 1ex;">
<br>
Before you try the &#39;new&#39; modules you have to remove the &#39;origin=
al&#39; Ubuntu-Version of cx88*. These modules can found in /lib/modules/2.=
6.24-16-generic/ubuntu/media/cx88 (don&#39;t now why not in normal tree) an=
d come with paket linux-ubuntu-modules-2.6.24-16-generic.<br>

<br>
Hagen<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); padding-left: 1ex;"><div class=3D"Ih2E3d"><blockquote class=3D"g=
mail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); padding-lef=
t: 1ex;">

Hi All.<br>
<br>
Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy Heron) o=
n<br>
my machine with the HVR4000 in, and now, no TV! It&#39;s gone on with kerne=
l<br>
2.6.24-16 on a P4 HyperThread, and everything worked just fine under Gutsy.=
<br>
I&#39;ve pulled down the v4l-dvb tree (current and revision 127f67dea087 as=
<br>
suggested in Wiki) and tried patching with dev.kewl.org&#39;s MFE and SFE<b=
r>
current patches (7285) and the latest.<br>
<br>
Everything &#39;seems&#39; to compile Ok, and installs fine. When I reboot =
however I<br>
get a huge chunk of borked stuff and no card. (Dmesg output at end of<br>
message)<br>
<br>
Could anyone please give me any pointers on how (or if) they have their<br>
HVR4000 running under Ubuntu 8.04LTS ?<br>
<br>
Would really appriciate it.<br>
Thanks in advance,<br>
<br>
Ian<br>
<br>
DMESG Output:<br>
cx88xx: disagrees about version of symbol videobuf_waiton<br>
[ &nbsp; 37.790909] cx88xx: Unknown symbol videobuf_waiton<br>
<br>
 &nbsp; &nbsp;<br>
</blockquote>
<br></div>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
 &nbsp;<br>
</blockquote>
<br>
</blockquote></div><br>

------=_Part_6632_10805603.1209408065397--


--===============1792180706==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1792180706==--
