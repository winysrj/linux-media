Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <klaas.de.waal@gmail.com>) id 1LmEsx-0008Dn-A8
	for linux-dvb@linuxtv.org; Tue, 24 Mar 2009 23:14:16 +0100
Received: by fg-out-1718.google.com with SMTP id l27so538087fgb.2
	for <linux-dvb@linuxtv.org>; Tue, 24 Mar 2009 15:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1235712905.2748.29.camel@pc10.localdom.local>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	<1223598995.4825.12.camel@pc10.localdom.local>
	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
	<loom.20090225T203249-735@post.gmane.org>
	<1235712905.2748.29.camel@pc10.localdom.local>
Date: Tue, 24 Mar 2009 23:14:11 +0100
Message-ID: <7b41dd970903241514g677c1071raf1010653fd6b7e8@mail.gmail.com>
From: klaas de waal <klaas.de.waal@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Content-Type: multipart/mixed; boundary=000e0cd247e4db7f180465e4b393
Cc: erik_bies@hotmail.com, linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--000e0cd247e4db7f180465e4b393
Content-Type: multipart/alternative; boundary=000e0cd247e4db7f0f0465e4b391

--000e0cd247e4db7f0f0465e4b391
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Fri, Feb 27, 2009 at 6:35 AM, hermann pitton <hermann-pitton@arcor.de>wrote:

> Hi,
>
> Am Mittwoch, den 25.02.2009, 20:42 +0000 schrieb erik:
> > klaas de waal <klaas.de.waal <at> gmail.com> writes:
> > >
> > > On Fri, Oct 10, 2008 at 2:36 AM, hermann pitton <hermann-pitton <at>
> arcor.de>
> > wrote:
> > > Hi,
> > > Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
> > >  The table starts a new segment at 390MHz,
> > > > it then starts to use VCO2 instead of VCO1.
> > > > I have now (hack, hack) changed the segment start from 390 to 395MHz
> > > > so that the 388MHz is still tuned with VCO1, and this works OK!!
> > > > Like this:
> > > >
> > > > static const struct tda827xa_data tda827xa_dvbt[] = {
> > > >     { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs =
> > > > 0, .gc3 = 1},
> > > > #else
> > > >     { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> > > > 3, .gc3 = 1},
> > > > #endif
> > > >     { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs =
> > > > 3, .gc3 = 1},
> > > > etc etc
> > > >
> >
> > Hi Klaas/Hermann
> >
> > Your fix works perfectly for me as well. Prior I could not get the
> channels in
> > the 386750000 freq. With Fix appied my Ziggo locking issues disappeared.
> >
> > Is there any chance to get it into the official version?
> >
> > Erik
> >
>
> yes, there should be one for the later patch with the separate tuning
> table for tda8274a DVB-C I think.
>
> Patch for a review must be against recent mercurial v4l-dvb, needs to be
> in form of a unified diff, with mercurial installed and v4l-dvb cloned
> "hg diff > tda827x_dvb-c_improved-tuning-table.patch" something does
> create it most simple.
>
> Needs to go to linux-media@vger.kernel.org , please try README.patches
> in the v4l-dvb Documentation. Needs a Signed-off-by line.
>
> Also testers like you should provide a Tested-by line to promote it.
>
> Don't know if somebody has the tuning table for that specific tuner,
> tda8274a IIRC, or if this will only rely on the reports of the testers.
>
> Some equivalent of lna config = 0 needs to be introduced too to keep it
> quiet was said as well.
>
> Cheers,
> Hermann
>
>
>
> Hi Hermann,

Thanks for your "howto" on making a proper patch.
After a "make commit" in my local v4l-dvb tree, and filling in the template
I got the following output. I confess I do not know if this has now ended up
somewhere in linuxtv.org or that it is just local.
However, here it is:

changeset:   11143:f10e05176a88
tag:         tip
user:        Klaas de Waal <klaas.de.waal@gmail.com>
date:        Tue Mar 24 22:59:44 2009 +0100
files:       linux/drivers/media/common/tuners/tda827x.c
linux/drivers/media/dvb/ttpci/budget-ci.c
description:
Separate tuning table for DVB-C solves tuning problem at 388MHz.

From: Klaas de Waal <klaas.de.waal@gmail.com>

TechnoTrend C-1501 DVB-C card does not lock on 388MHz.
I assume that existing frequency table is valid for DVB-T. This is suggested
by the name of the table: tda827xa_dvbt.
Added a table for DVB-C with the name tda827xa_dvbc.
Added runtime selection of the DVB-C table when the tuner is type FE_QAM.
This should leave the behaviour of this driver with with DVB_T tuners
unchanged.
This modification is in file tda827x.c

The tda827x.c gives the following warning message when debug=1 :
tda827x: tda827x_config not defined, cannot set LNA gain!
Added a tda827x_config struct in budget-ci.c to get rid of this message.

Priority: normal

Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>


I have attached the result of "hg diff > tda827x_dvb-c_tuning_table.patch.
Patch is with the "hg clone" done 23 march.
Tested with Linux kernel 2.6.28.9.

Cheers,
Klaas.

--000e0cd247e4db7f0f0465e4b391
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Fri, Feb 27, 2009 at 6:35 AM, hermann=
 pitton <span dir=3D"ltr">&lt;<a href=3D"mailto:hermann-pitton@arcor.de">he=
rmann-pitton@arcor.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0=
pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
Am Mittwoch, den 25.02.2009, 20:42 +0000 schrieb erik:<br>
<div><div></div><div class=3D"h5">&gt; klaas de waal &lt;klaas.de.waal &lt;=
at&gt; <a href=3D"http://gmail.com" target=3D"_blank">gmail.com</a>&gt; wri=
tes:<br>
&gt; &gt;<br>
&gt; &gt; On Fri, Oct 10, 2008 at 2:36 AM, hermann pitton &lt;hermann-pitto=
n &lt;at&gt; <a href=3D"http://arcor.de" target=3D"_blank">arcor.de</a>&gt;=
<br>
&gt; wrote:<br>
&gt; &gt; Hi,<br>
&gt; &gt; Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:=
<br>
&gt; &gt; =A0The table starts a new segment at 390MHz,<br>
&gt; &gt; &gt; it then starts to use VCO2 instead of VCO1.<br>
&gt; &gt; &gt; I have now (hack, hack) changed the segment start from 390 t=
o 395MHz<br>
&gt; &gt; &gt; so that the 388MHz is still tuned with VCO1, and this works =
OK!!<br>
&gt; &gt; &gt; Like this:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; static const struct tda827xa_data tda827xa_dvbt[] =3D {<br>
&gt; &gt; &gt; =A0 =A0 { .lomax =3D =A056875000, .svco =3D 3, .spd =3D 4, .=
scr =3D 0, .sbs =3D<br>
&gt; &gt; &gt; 0, .gc3 =3D 1},<br>
&gt; &gt; &gt; #else<br>
&gt; &gt; &gt; =A0 =A0 { .lomax =3D 395000000, .svco =3D 2, .spd =3D 1, .sc=
r =3D 0, .sbs =3D<br>
&gt; &gt; &gt; 3, .gc3 =3D 1},<br>
&gt; &gt; &gt; #endif<br>
&gt; &gt; &gt; =A0 =A0 { .lomax =3D 455000000, .svco =3D 3, .spd =3D 1, .sc=
r =3D 0, .sbs =3D<br>
&gt; &gt; &gt; 3, .gc3 =3D 1},<br>
&gt; &gt; &gt; etc etc<br>
&gt; &gt; &gt;<br>
&gt;<br>
&gt; Hi Klaas/Hermann<br>
&gt;<br>
&gt; Your fix works perfectly for me as well. Prior I could not get the cha=
nnels in<br>
&gt; the 386750000 freq. With Fix appied my Ziggo locking issues disappeare=
d.<br>
&gt;<br>
&gt; Is there any chance to get it into the official version?<br>
&gt;<br>
&gt; Erik<br>
&gt;<br>
<br>
</div></div>yes, there should be one for the later patch with the separate =
tuning<br>
table for tda8274a DVB-C I think.<br>
<br>
Patch for a review must be against recent mercurial v4l-dvb, needs to be<br=
>
in form of a unified diff, with mercurial installed and v4l-dvb cloned<br>
&quot;hg diff &gt; tda827x_dvb-c_improved-tuning-table.patch&quot; somethin=
g does<br>
create it most simple.<br>
<br>
Needs to go to <a href=3D"mailto:linux-media@vger.kernel.org">linux-media@v=
ger.kernel.org</a> , please try README.patches<br>
in the v4l-dvb Documentation. Needs a Signed-off-by line.<br>
<br>
Also testers like you should provide a Tested-by line to promote it.<br>
<br>
Don&#39;t know if somebody has the tuning table for that specific tuner,<br=
>
tda8274a IIRC, or if this will only rely on the reports of the testers.<br>
<br>
Some equivalent of lna config =3D 0 needs to be introduced too to keep it<b=
r>
quiet was said as well.<br>
<br>
Cheers,<br>
<font color=3D"#888888">Hermann<br>
<br>
<br>
<br>
</font></blockquote><div>Hi Hermann,<br><br>Thanks for your &quot;howto&quo=
t; on making a proper patch.<br>After a &quot;make commit&quot; in my local=
 v4l-dvb tree, and filling in the template I got the following output. I co=
nfess I do not know if this has now ended up somewhere in <a href=3D"http:/=
/linuxtv.org">linuxtv.org</a> or that it is just local.<br>
However, here it is:<br><br>changeset:=A0=A0 11143:f10e05176a88<br>tag:=A0=
=A0=A0=A0=A0=A0=A0=A0 tip<br>user:=A0=A0=A0=A0=A0=A0=A0 Klaas de Waal &lt;<=
a href=3D"mailto:klaas.de.waal@gmail.com">klaas.de.waal@gmail.com</a>&gt;<b=
r>date:=A0=A0=A0=A0=A0=A0=A0 Tue Mar 24 22:59:44 2009 +0100<br>
files:=A0=A0=A0=A0=A0=A0 linux/drivers/media/common/tuners/tda827x.c linux/=
drivers/media/dvb/ttpci/budget-ci.c<br>description:<br>Separate tuning tabl=
e for DVB-C solves tuning problem at 388MHz.<br><br>From: Klaas de Waal &lt=
;<a href=3D"mailto:klaas.de.waal@gmail.com">klaas.de.waal@gmail.com</a>&gt;=
<br>
<br>TechnoTrend C-1501 DVB-C card does not lock on 388MHz.<br>I assume that=
 existing frequency table is valid for DVB-T. This is suggested<br>by the n=
ame of the table: tda827xa_dvbt.<br>Added a table for DVB-C with the name t=
da827xa_dvbc.<br>
Added runtime selection of the DVB-C table when the tuner is type FE_QAM.<b=
r>This should leave the behaviour of this driver with with DVB_T tuners unc=
hanged.<br>This modification is in file tda827x.c<br><br>The tda827x.c give=
s the following warning message when debug=3D1 :<br>
tda827x: tda827x_config not defined, cannot set LNA gain!<br>Added a tda827=
x_config struct in budget-ci.c to get rid of this message.<br><br>Priority:=
 normal<br><br>Signed-off-by: Klaas de Waal &lt;<a href=3D"mailto:klaas.de.=
waal@gmail.com">klaas.de.waal@gmail.com</a>&gt;<br>
<br><br>I have attached the result of &quot;hg diff &gt; tda827x_dvb-c_tuni=
ng_table.patch.<br>Patch is with the &quot;hg clone&quot; done 23 march.<br=
>Tested with Linux kernel 2.6.28.9.<br><br>Cheers,<br>Klaas.<br><br><br>
<br>=A0</div></div><br>

--000e0cd247e4db7f0f0465e4b391--

--000e0cd247e4db7f180465e4b393
Content-Type: text/x-patch; charset=US-ASCII; name="tda827x_dvb-c_tuning_table.patch"
Content-Disposition: attachment; filename="tda827x_dvb-c_tuning_table.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fsp4zxbw0

ZGlmZiAtciBlN2QyMjI4NWE5ZWIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3Rk
YTgyN3guYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMvdGRhODI3eC5j
CVN1biBNYXIgMjIgMjI6NDI6MjYgMjAwOSAtMDQwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L2NvbW1vbi90dW5lcnMvdGRhODI3eC5jCVR1ZSBNYXIgMjQgMjI6NDQ6MTYgMjAwOSArMDEwMApA
QCAtMzUyLDcgKzM1Miw3IEBACiAJdTggIGdjMzsKIH07CiAKLXN0YXRpYyBjb25zdCBzdHJ1Y3Qg
dGRhODI3eGFfZGF0YSB0ZGE4Mjd4YV9kdmJ0W10gPSB7CitzdGF0aWMgc3RydWN0IHRkYTgyN3hh
X2RhdGEgdGRhODI3eGFfZHZidFtdID0gewogCXsgLmxvbWF4ID0gIDU2ODc1MDAwLCAuc3ZjbyA9
IDMsIC5zcGQgPSA0LCAuc2NyID0gMCwgLnNicyA9IDAsIC5nYzMgPSAxfSwKIAl7IC5sb21heCA9
ICA2NzI1MDAwMCwgLnN2Y28gPSAwLCAuc3BkID0gMywgLnNjciA9IDAsIC5zYnMgPSAwLCAuZ2Mz
ID0gMX0sCiAJeyAubG9tYXggPSAgODEyNTAwMDAsIC5zdmNvID0gMSwgLnNwZCA9IDMsIC5zY3Ig
PSAwLCAuc2JzID0gMCwgLmdjMyA9IDF9LApAQCAtMzgyLDYgKzM4MiwzNiBAQAogCXsgLmxvbWF4
ID0gICAgICAgICAwLCAuc3ZjbyA9IDAsIC5zcGQgPSAwLCAuc2NyID0gMCwgLnNicyA9IDAsIC5n
YzMgPSAwfQogfTsKIAorc3RhdGljIHN0cnVjdCB0ZGE4Mjd4YV9kYXRhIHRkYTgyN3hhX2R2YmNb
XSA9IHsKKwl7IC5sb21heCA9ICA1MDEyNTAwMCwgLnN2Y28gPSAyLCAuc3BkID0gNCwgLnNjciA9
IDIsIC5zYnMgPSAwLCAuZ2MzID0gM30sCisJeyAubG9tYXggPSAgNTg1MDAwMDAsIC5zdmNvID0g
MywgLnNwZCA9IDQsIC5zY3IgPSAyLCAuc2JzID0gMCwgLmdjMyA9IDN9LAorCXsgLmxvbWF4ID0g
IDY5MjUwMDAwLCAuc3ZjbyA9IDAsIC5zcGQgPSAzLCAuc2NyID0gMiwgLnNicyA9IDAsIC5nYzMg
PSAzfSwKKwl7IC5sb21heCA9ICA4MzYyNTAwMCwgLnN2Y28gPSAxLCAuc3BkID0gMywgLnNjciA9
IDIsIC5zYnMgPSAwLCAuZ2MzID0gM30sCisJeyAubG9tYXggPSAgOTc1MDAwMDAsIC5zdmNvID0g
MiwgLnNwZCA9IDMsIC5zY3IgPSAyLCAuc2JzID0gMCwgLmdjMyA9IDN9LAorCXsgLmxvbWF4ID0g
MTAwMjUwMDAwLCAuc3ZjbyA9IDIsIC5zcGQgPSAzLCAuc2NyID0gMiwgLnNicyA9IDEsIC5nYzMg
PSAxfSwKKwl7IC5sb21heCA9IDExNzAwMDAwMCwgLnN2Y28gPSAzLCAuc3BkID0gMywgLnNjciA9
IDIsIC5zYnMgPSAxLCAuZ2MzID0gMX0sCisJeyAubG9tYXggPSAxMzg1MDAwMDAsIC5zdmNvID0g
MCwgLnNwZCA9IDIsIC5zY3IgPSAyLCAuc2JzID0gMSwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
MTY3MjUwMDAwLCAuc3ZjbyA9IDEsIC5zcGQgPSAyLCAuc2NyID0gMiwgLnNicyA9IDEsIC5nYzMg
PSAxfSwKKwl7IC5sb21heCA9IDE4NzAwMDAwMCwgLnN2Y28gPSAyLCAuc3BkID0gMiwgLnNjciA9
IDIsIC5zYnMgPSAxLCAuZ2MzID0gMX0sCisJeyAubG9tYXggPSAyMDA1MDAwMDAsIC5zdmNvID0g
MiwgLnNwZCA9IDIsIC5zY3IgPSAyLCAuc2JzID0gMiwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
MjM0MDAwMDAwLCAuc3ZjbyA9IDMsIC5zcGQgPSAyLCAuc2NyID0gMiwgLnNicyA9IDIsIC5nYzMg
PSAzfSwKKwl7IC5sb21heCA9IDI3NzAwMDAwMCwgLnN2Y28gPSAwLCAuc3BkID0gMSwgLnNjciA9
IDIsIC5zYnMgPSAyLCAuZ2MzID0gM30sCisJeyAubG9tYXggPSAzMjUwMDAwMDAsIC5zdmNvID0g
MSwgLnNwZCA9IDEsIC5zY3IgPSAyLCAuc2JzID0gMiwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
MzM0NTAwMDAwLCAuc3ZjbyA9IDEsIC5zcGQgPSAxLCAuc2NyID0gMiwgLnNicyA9IDMsIC5nYzMg
PSAzfSwKKwl7IC5sb21heCA9IDQwMTAwMDAwMCwgLnN2Y28gPSAyLCAuc3BkID0gMSwgLnNjciA9
IDIsIC5zYnMgPSAzLCAuZ2MzID0gM30sCisJeyAubG9tYXggPSA0NjgwMDAwMDAsIC5zdmNvID0g
MywgLnNwZCA9IDEsIC5zY3IgPSAyLCAuc2JzID0gMywgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
NTM1MDAwMDAwLCAuc3ZjbyA9IDAsIC5zcGQgPSAwLCAuc2NyID0gMSwgLnNicyA9IDMsIC5nYzMg
PSAxfSwKKwl7IC5sb21heCA9IDU1NDAwMDAwMCwgLnN2Y28gPSAwLCAuc3BkID0gMCwgLnNjciA9
IDIsIC5zYnMgPSAzLCAuZ2MzID0gMX0sCisJeyAubG9tYXggPSA2MzgwMDAwMDAsIC5zdmNvID0g
MSwgLnNwZCA9IDAsIC5zY3IgPSAxLCAuc2JzID0gNCwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
NjY5MDAwMDAwLCAuc3ZjbyA9IDEsIC5zcGQgPSAwLCAuc2NyID0gMiwgLnNicyA9IDQsIC5nYzMg
PSAxfSwKKwl7IC5sb21heCA9IDcyMDAwMDAwMCwgLnN2Y28gPSAyLCAuc3BkID0gMCwgLnNjciA9
IDEsIC5zYnMgPSA0LCAuZ2MzID0gMX0sCisJeyAubG9tYXggPSA4MDIwMDAwMDAsIC5zdmNvID0g
MiwgLnNwZCA9IDAsIC5zY3IgPSAyLCAuc2JzID0gNCwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
ODM1MDAwMDAwLCAuc3ZjbyA9IDMsIC5zcGQgPSAwLCAuc2NyID0gMSwgLnNicyA9IDQsIC5nYzMg
PSAxfSwKKwl7IC5sb21heCA9IDg4NTAwMDAwMCwgLnN2Y28gPSAzLCAuc3BkID0gMCwgLnNjciA9
IDEsIC5zYnMgPSA0LCAuZ2MzID0gMX0sCisJeyAubG9tYXggPSA5MTEwMDAwMDAsIC5zdmNvID0g
MywgLnNwZCA9IDAsIC5zY3IgPSAyLCAuc2JzID0gNCwgLmdjMyA9IDF9LAorCXsgLmxvbWF4ID0g
ICAgICAgICAwLCAuc3ZjbyA9IDAsIC5zcGQgPSAwLCAuc2NyID0gMCwgLnNicyA9IDAsIC5nYzMg
PSAwfQorfTsKKwogc3RhdGljIHN0cnVjdCB0ZGE4Mjd4YV9kYXRhIHRkYTgyN3hhX2FuYWxvZ1td
ID0gewogCXsgLmxvbWF4ID0gIDU2ODc1MDAwLCAuc3ZjbyA9IDMsIC5zcGQgPSA0LCAuc2NyID0g
MCwgLnNicyA9IDAsIC5nYzMgPSAzfSwKIAl7IC5sb21heCA9ICA2NzI1MDAwMCwgLnN2Y28gPSAw
LCAuc3BkID0gMywgLnNjciA9IDAsIC5zYnMgPSAwLCAuZ2MzID0gM30sCkBAIC00ODUsNiArNTE1
LDcgQEAKIAkJCSAgICAgICBzdHJ1Y3QgZHZiX2Zyb250ZW5kX3BhcmFtZXRlcnMgKnBhcmFtcykK
IHsKIAlzdHJ1Y3QgdGRhODI3eF9wcml2ICpwcml2ID0gZmUtPnR1bmVyX3ByaXY7CisJc3RydWN0
IHRkYTgyN3hhX2RhdGEgKmZyZXF1ZW5jeV9tYXAgPSB0ZGE4Mjd4YV9kdmJ0OwogCXU4IGJ1Zlsx
MV07CiAKIAlzdHJ1Y3QgaTJjX21zZyBtc2cgPSB7IC5hZGRyID0gcHJpdi0+aTJjX2FkZHIsIC5m
bGFncyA9IDAsCkBAIC01MTEsMjIgKzU0MiwyNyBAQAogCX0KIAl0dW5lcl9mcmVxID0gcGFyYW1z
LT5mcmVxdWVuY3kgKyBpZl9mcmVxOwogCisJaWYgKGZlLT5vcHMuaW5mby50eXBlID09IEZFX1FB
TSkgeworCQlkcHJpbnRrKCIlcyBzZWxlY3QgdGRhODI3eGFfZHZiY1xuIiwgX19mdW5jX18pOwor
CQlmcmVxdWVuY3lfbWFwID0gdGRhODI3eGFfZHZiYzsKKwl9CisKIAlpID0gMDsKLQl3aGlsZSAo
dGRhODI3eGFfZHZidFtpXS5sb21heCA8IHR1bmVyX2ZyZXEpIHsKLQkJaWYodGRhODI3eGFfZHZi
dFtpICsgMV0ubG9tYXggPT0gMCkKKwl3aGlsZSAoZnJlcXVlbmN5X21hcFtpXS5sb21heCA8IHR1
bmVyX2ZyZXEpIHsKKwkJaWYgKGZyZXF1ZW5jeV9tYXBbaSArIDFdLmxvbWF4ID09IDApCiAJCQli
cmVhazsKIAkJaSsrOwogCX0KIAotCU4gPSAoKHR1bmVyX2ZyZXEgKyAzMTI1MCkgLyA2MjUwMCkg
PDwgdGRhODI3eGFfZHZidFtpXS5zcGQ7CisJTiA9ICgodHVuZXJfZnJlcSArIDMxMjUwKSAvIDYy
NTAwKSA8PCBmcmVxdWVuY3lfbWFwW2ldLnNwZDsKIAlidWZbMF0gPSAwOyAgICAgICAgICAgIC8v
IHN1YmFkZHJlc3MKIAlidWZbMV0gPSBOID4+IDg7CiAJYnVmWzJdID0gTiAmIDB4ZmY7CiAJYnVm
WzNdID0gMDsKIAlidWZbNF0gPSAweDE2OwotCWJ1Zls1XSA9ICh0ZGE4Mjd4YV9kdmJ0W2ldLnNw
ZCA8PCA1KSArICh0ZGE4Mjd4YV9kdmJ0W2ldLnN2Y28gPDwgMykgKwotCQkJdGRhODI3eGFfZHZi
dFtpXS5zYnM7Ci0JYnVmWzZdID0gMHg0YiArICh0ZGE4Mjd4YV9kdmJ0W2ldLmdjMyA8PCA0KTsK
KwlidWZbNV0gPSAoZnJlcXVlbmN5X21hcFtpXS5zcGQgPDwgNSkgKyAoZnJlcXVlbmN5X21hcFtp
XS5zdmNvIDw8IDMpICsKKwkJCWZyZXF1ZW5jeV9tYXBbaV0uc2JzOworCWJ1Zls2XSA9IDB4NGIg
KyAoZnJlcXVlbmN5X21hcFtpXS5nYzMgPDwgNCk7CiAJYnVmWzddID0gMHgxYzsKIAlidWZbOF0g
PSAweDA2OwogCWJ1Zls5XSA9IDB4MjQ7CkBAIC01ODUsNyArNjIxLDcgQEAKIAogCS8qIGNvcnJl
Y3QgQ1AgdmFsdWUgKi8KIAlidWZbMF0gPSAweDMwOwotCWJ1ZlsxXSA9IDB4MTAgKyB0ZGE4Mjd4
YV9kdmJ0W2ldLnNjcjsKKwlidWZbMV0gPSAweDEwICsgZnJlcXVlbmN5X21hcFtpXS5zY3I7CiAJ
cmMgPSB0dW5lcl90cmFuc2ZlcihmZSwgJm1zZywgMSk7CiAJaWYgKHJjIDwgMCkKIAkJZ290byBl
cnI7CkBAIC02MDAsNyArNjM2LDcgQEAKIAltc2xlZXAoMyk7CiAJLyogZnJlZXplIEFHQzEgKi8K
IAlidWZbMF0gPSAweDUwOwotCWJ1ZlsxXSA9IDB4NGYgKyAodGRhODI3eGFfZHZidFtpXS5nYzMg
PDwgNCk7CisJYnVmWzFdID0gMHg0ZiArIChmcmVxdWVuY3lfbWFwW2ldLmdjMyA8PCA0KTsKIAly
YyA9IHR1bmVyX3RyYW5zZmVyKGZlLCAmbXNnLCAxKTsKIAlpZiAocmMgPCAwKQogCQlnb3RvIGVy
cjsKZGlmZiAtciBlN2QyMjI4NWE5ZWIgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVk
Z2V0LWNpLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVkZ2V0LWNpLmMJ
U3VuIE1hciAyMiAyMjo0MjoyNiAyMDA5IC0wNDAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL3R0cGNpL2J1ZGdldC1jaS5jCVR1ZSBNYXIgMjQgMjI6NDQ6MTYgMjAwOSArMDEwMApAQCAt
MTA4NCw2ICsxMDg0LDEwIEBACiAJLmRlbHRhZiA9IDB4YTUxMSwKIH07CiAKK3N0YXRpYyBzdHJ1
Y3QgdGRhODI3eF9jb25maWcgdGRhODI3eF9jb25maWcgPSB7CisJLmNvbmZpZyA9IDAsCit9Owor
CiAvKiBUVCBTMi0zMjAwIERWQi1TIChTVEIwODk5KSBJbml0dGFiICovCiBzdGF0aWMgY29uc3Qg
c3RydWN0IHN0YjA4OTlfczFfcmVnIHR0MzIwMF9zdGIwODk5X3MxX2luaXRfMVtdID0gewogCkBA
IC0xNDIyLDcgKzE0MjYsNyBAQAogCWNhc2UgMHgxMDFhOiAvKiBUVCBCdWRnZXQtQy0xNTAxIChw
aGlsaXBzIHRkYTEwMDIzL3BoaWxpcHMgdGRhODI3NEEpICovCiAJCWJ1ZGdldF9jaS0+YnVkZ2V0
LmR2Yl9mcm9udGVuZCA9IGR2Yl9hdHRhY2godGRhMTAwMjNfYXR0YWNoLCAmdGRhMTAwMjNfY29u
ZmlnLCAmYnVkZ2V0X2NpLT5idWRnZXQuaTJjX2FkYXAsIDB4NDgpOwogCQlpZiAoYnVkZ2V0X2Np
LT5idWRnZXQuZHZiX2Zyb250ZW5kKSB7Ci0JCQlpZiAoZHZiX2F0dGFjaCh0ZGE4Mjd4X2F0dGFj
aCwgYnVkZ2V0X2NpLT5idWRnZXQuZHZiX2Zyb250ZW5kLCAweDYxLCAmYnVkZ2V0X2NpLT5idWRn
ZXQuaTJjX2FkYXAsIE5VTEwpID09IE5VTEwpIHsKKwkJCWlmIChkdmJfYXR0YWNoKHRkYTgyN3hf
YXR0YWNoLCBidWRnZXRfY2ktPmJ1ZGdldC5kdmJfZnJvbnRlbmQsIDB4NjEsICZidWRnZXRfY2kt
PmJ1ZGdldC5pMmNfYWRhcCwgJnRkYTgyN3hfY29uZmlnKSA9PSBOVUxMKSB7CiAJCQkJcHJpbnRr
KEtFUk5fRVJSICIlczogTm8gdGRhODI3eCBmb3VuZCFcbiIsIF9fZnVuY19fKTsKIAkJCQlkdmJf
ZnJvbnRlbmRfZGV0YWNoKGJ1ZGdldF9jaS0+YnVkZ2V0LmR2Yl9mcm9udGVuZCk7CiAJCQkJYnVk
Z2V0X2NpLT5idWRnZXQuZHZiX2Zyb250ZW5kID0gTlVMTDsK
--000e0cd247e4db7f180465e4b393
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--000e0cd247e4db7f180465e4b393--
