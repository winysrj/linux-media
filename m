Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael@stepanoff.org>) id 1K5odU-0004ZW-Av
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 23:10:41 +0200
Received: by py-out-1112.google.com with SMTP id a29so889952pyi.0
	for <linux-dvb@linuxtv.org>; Mon, 09 Jun 2008 14:10:35 -0700 (PDT)
Message-ID: <65922d730806091410o7243b139pdc0b7137d4921c85@mail.gmail.com>
Date: Tue, 10 Jun 2008 00:10:33 +0300
From: "Michael Stepanov" <michael@stepanoff.org>
To: "Thorsten Barth" <thorsten.barth@web-arts.com>
In-Reply-To: <484D1253.9090201@web-arts.com>
MIME-Version: 1.0
References: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
	<200806082120.04766@orion.escape-edv.de>
	<484D1253.9090201@web-arts.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT-Budget/WinTV-NOVA-CI is recognized as sound card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0443862121=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0443862121==
Content-Type: multipart/alternative;
	boundary="----=_Part_23034_24925912.1213045833898"

------=_Part_23034_24925912.1213045833898
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Tom,

The name of module is snd_aw2. Just add it to the /etc/modprobe.d/blacklist

On Mon, Jun 9, 2008 at 2:21 PM, Thorsten Barth <thorsten.barth@web-arts.com=
>
wrote:

> Hello,
>
> could this also be the case with a Hauppauge Nova S-Plus PCI unter
> Kubuntu 7.10 ?
>
> If so, what do I have to do to disable the audiowerk driver? What is the
> name of the module, and am I right if I take a look at the files in
> /etc/modules.d/* ?
>
> Thanks and CU
> Thorsten
>
> Oliver Endriss schrieb:
> > Michael Stepanov wrote:
> >
> >> Hi,
> >>
> >> I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It'=
s
> >> recognized as Audiowerk2 sound card instead of DVB:
> >>
> >> linuxmce@dcerouter:~$ cat /proc/asound/cards
> >>  0 [Audiowerk2     ]: aw2 - Audiowerk2
> >>                       Audiowerk2 with SAA7146 irq 16
> >>  1 [NVidia         ]: HDA-Intel - HDA NVidia
> >>                       HDA NVidia at 0xfe020000 irq 20
> >>
> >> This is what I can see in the dmesg output:
> >> [   81.311527] saa7146: register extension 'budget_ci dvb'.
> >>
> >> I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.
> >>
> >> Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
> >> x86_64 GNU/Linux
> >>
> >> Any suggestion how to solve that will be very appreciated.
> >>
> >
> > Complain to the developers of the Audiowerk2 driver for this:
> >
> > | static struct pci_device_id snd_aw2_ids[] =3D {
> > |     {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID,
> PCI_ANY_ID,
> > |      0, 0, 0},
> > |     {0}
> > | };
> >
> > This will grab _all_ saa7146-based cards. :-(
> >
> > For now you should blacklist that driver.
> >
> > CU
> > Oliver
> >
> >
>
> --
> *Thorsten Barth*
> Vorstand
>
> *Web Arts AG*
> Seifgrundstra=DFe 2
> 61348 Bad Homburg v. d. H=F6he
> http://www.web-arts.com
>
> Tel.: +49.6172.68097-17
> Fax: +49.6172.68097-77
> thorsten.barth@web-arts.com <mailto:thorsten.barth@web-arts.com>
>
>
> *Sitz der Gesellschaft:* Bad Homburg v. d. H=F6he | *Amtsgericht:* Bad
> Homburg v. d. H=F6he HRB 6719
> *Steuernummer:* 003 248 00118 Finanzamt Bad Homburg v. d. H=F6he
> *Vorstand:* Thorsten Barth, Andr=E9 Morys | *Aufsichtsrat:* Gerhard
> Beinhauer (Vors.)
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



--=20
Cheers,
Michael

------=_Part_23034_24925912.1213045833898
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Tom,<br><br>The name of module is snd_aw2. Just add it to the /etc/modpr=
obe.d/blacklist<br><br><div class=3D"gmail_quote">On Mon, Jun 9, 2008 at 2:=
21 PM, Thorsten Barth &lt;<a href=3D"mailto:thorsten.barth@web-arts.com">th=
orsten.barth@web-arts.com</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello,<br>
<br>
could this also be the case with a Hauppauge Nova S-Plus PCI unter<br>
Kubuntu 7.10 ?<br>
<br>
If so, what do I have to do to disable the audiowerk driver? What is the<br=
>
name of the module, and am I right if I take a look at the files in<br>
/etc/modules.d/* ?<br>
<br>
Thanks and CU<br>
Thorsten<br>
<br>
Oliver Endriss schrieb:<br>
<div class=3D"Ih2E3d">&gt; Michael Stepanov wrote:<br>
&gt;<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card.=
 It&#39;s<br>
&gt;&gt; recognized as Audiowerk2 sound card instead of DVB:<br>
&gt;&gt;<br>
&gt;&gt; linuxmce@dcerouter:~$ cat /proc/asound/cards<br>
&gt;&gt; &nbsp;0 [Audiowerk2 &nbsp; &nbsp; ]: aw2 - Audiowerk2<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; Audiowerk2 with SAA7146 irq 16<br>
&gt;&gt; &nbsp;1 [NVidia &nbsp; &nbsp; &nbsp; &nbsp; ]: HDA-Intel - HDA NVi=
dia<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; HDA NVidia at 0xfe020000 irq 20<br>
&gt;&gt;<br>
&gt;&gt; This is what I can see in the dmesg output:<br>
&gt;&gt; [ &nbsp; 81.311527] saa7146: register extension &#39;budget_ci dvb=
&#39;.<br>
&gt;&gt;<br>
&gt;&gt; I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.<=
br>
&gt;&gt;<br>
&gt;&gt; Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2=
007<br>
&gt;&gt; x86_64 GNU/Linux<br>
&gt;&gt;<br>
&gt;&gt; Any suggestion how to solve that will be very appreciated.<br>
&gt;&gt;<br>
&gt;<br>
&gt; Complain to the developers of the Audiowerk2 driver for this:<br>
&gt;<br>
&gt; | static struct pci_device_id snd_aw2_ids[] =3D {<br>
&gt; | &nbsp; &nbsp; {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY=
_ID, PCI_ANY_ID,<br>
&gt; | &nbsp; &nbsp; &nbsp;0, 0, 0},<br>
&gt; | &nbsp; &nbsp; {0}<br>
&gt; | };<br>
&gt;<br>
&gt; This will grab _all_ saa7146-based cards. :-(<br>
&gt;<br>
&gt; For now you should blacklist that driver.<br>
&gt;<br>
&gt; CU<br>
&gt; Oliver<br>
&gt;<br>
&gt;<br>
<br>
--<br>
</div>*Thorsten Barth*<br>
Vorstand<br>
<br>
*Web Arts AG*<br>
Seifgrundstra=DFe 2<br>
61348 Bad Homburg v. d. H=F6he<br>
<a href=3D"http://www.web-arts.com" target=3D"_blank">http://www.web-arts.c=
om</a><br>
<br>
Tel.: +49.6172.68097-17<br>
Fax: +49.6172.68097-77<br>
<a href=3D"mailto:thorsten.barth@web-arts.com">thorsten.barth@web-arts.com<=
/a> &lt;mailto:<a href=3D"mailto:thorsten.barth@web-arts.com">thorsten.bart=
h@web-arts.com</a>&gt;<br>
<br>
<br>
*Sitz der Gesellschaft:* Bad Homburg v. d. H=F6he | *Amtsgericht:* Bad<br>
Homburg v. d. H=F6he HRB 6719<br>
*Steuernummer:* 003 248 00118 Finanzamt Bad Homburg v. d. H=F6he<br>
*Vorstand:* Thorsten Barth, Andr=E9 Morys | *Aufsichtsrat:* Gerhard<br>
Beinhauer (Vors.)<br>
<div><div></div><div class=3D"Wj3C7c"><br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>Cheers,<br>=
Michael

------=_Part_23034_24925912.1213045833898--


--===============0443862121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0443862121==--
