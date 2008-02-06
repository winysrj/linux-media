Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JMfsl-0004Dw-Qs
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 09:43:52 +0100
Received: by rv-out-0910.google.com with SMTP id b22so2436514rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 06 Feb 2008 00:43:47 -0800 (PST)
Message-ID: <617be8890802060043u5505bd44y5ef37389e3704c8e@mail.gmail.com>
Date: Wed, 6 Feb 2008 09:43:47 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200802051219.54633.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890801290207t77149e2fh73c753501c39e835@mail.gmail.com>
	<200802042213.38495.zzam@gentoo.org>
	<617be8890802050108q5abf2c44la66a813143da205@mail.gmail.com>
	<200802051219.54633.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for analog part for Avermedia A700 fails to
	apply
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1086854320=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1086854320==
Content-Type: multipart/alternative;
	boundary="----=_Part_4961_24981435.1202287427289"

------=_Part_4961_24981435.1202287427289
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ok, thanks for your tips. I guess I'll need to wait until Tino fixes his
patch. I tried yesterday using only yours but I didn't get a lock on any
channel.

By the way: with your DVB-S patch I got a new frontend / adaptor / etc...
set created. And here my problems started: this porks my current setup, as
the 2 adapters created by the Nova-T 500 appear now with a different
numbering schema.

Even worse, the actual numbering schema is different on a cold boot or on a
reboot:

cold boot:
  - dvb:0 -> Avermedia DVB-S
  - dvb:1, dvb:2 -> Nova-T 500

reboot:
  - dvb:0 -> Nova-T 500 first tuner
  - dvb:1 -> Avermedia DVB-S
  - dvb:2 -> Nova-T 500 second tuner

I guess that on cold boot the Nova-T 500 devices initialize later because o=
f
the firmware loading.

=BFWould you know (or whoever) how could I solve this and obligate someway =
the
system to use a fixed numbering schema for the DVB devices? Maybe you could
give me a hint, as it seems see you are a Gentoo developer (I'm using Gento=
o
64 bits).

Best regards,
  Eduard





2008/2/5, Matthias Schwarzott <zzam@gentoo.org>:
>
> On Tuesday 05 February 2008, you wrote:
> > Hi,
>
> Hi!
>
> >     Bad news: I've been unsuccesfully trying to apply the new patches
> (as
> > mentioned in the wiki), with the following results:
> >
> > 1.- analog part applies just fine:
> >
> > mediacenter v4l-dvb # patch -p1 < ../1_avertv_A700_analog_part.diff
> > patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> > patching file linux/drivers/media/video/saa7134/saa7134.h
> > patching file linux/Documentation/video4linux/CARDLIST.saa7134
> >
> It is just listed extra as this patch is the only one I think is correct
> and I
> hope it gets applied to v4l-dvb in near future. (Maybe after some others
> have
> verified it.)
>
> >
> > 2.- Your patch (ZZam's) gives some warnings:
> >
>
> >
> > Apparently the A700 section is duplicated. I assume that the second
> section
> > is the good one, as the first gives only option for analog input. This
> is
> > probably related to the patch no aplying cleanly. I've removed the 1st
> > section and now it seems to compile fine.
> >
> So you found out the hard way, that patch 1 (analog-only) is already part
> of
> my patch and you should only apply one of these.
>
> >
> > 3.- Tino's patch gets worse. It even doesn't apply:
> >
>
> I guess this patch is also influenced by some new added cards.
>
> Regards
>   Matthias
>
> --
> Matthias Schwarzott (zzam)
>

------=_Part_4961_24981435.1202287427289
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ok, thanks for your tips. I guess I&#39;ll need to wait until Tino fixes hi=
s patch. I tried yesterday using only yours but I didn&#39;t get a lock on =
any channel. <br><br>By the way: with your DVB-S patch I got a new frontend=
 / adaptor / etc... set created. And here my problems started: this porks m=
y current setup, as the 2 adapters created by the Nova-T 500 appear now wit=
h a different numbering schema. <br>
<br>Even worse, the actual numbering schema is different on a cold boot or =
on a reboot:<br><br>cold boot:<br>&nbsp; - dvb:0 -&gt; Avermedia DVB-S<br>&=
nbsp; - dvb:1, dvb:2 -&gt; Nova-T 500<br><br>reboot:<br>&nbsp; - dvb:0 -&gt=
; Nova-T 500 first tuner<br>
&nbsp; - dvb:1 -&gt; Avermedia DVB-S<br>
&nbsp; - dvb:2 -&gt; Nova-T 500 second tuner<br>
<br>I guess that on cold boot the Nova-T 500 devices initialize later becau=
se of the firmware loading.<br><br>=BFWould you know (or whoever) how could=
 I solve this and obligate someway the system to use a fixed numbering sche=
ma for the DVB devices? Maybe you could give me a hint, as it seems see you=
 are a Gentoo developer (I&#39;m using Gentoo 64 bits).<br>
<br>Best regards, <br>&nbsp; Eduard<br><br><br><br><br><br><div><span class=
=3D"gmail_quote">2008/2/5, Matthias Schwarzott &lt;<a href=3D"mailto:zzam@g=
entoo.org">zzam@gentoo.org</a>&gt;:</span><blockquote class=3D"gmail_quote"=
 style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.=
8ex; padding-left: 1ex;">
On Tuesday 05 February 2008, you wrote:<br>&gt; Hi,<br><br>Hi!<br><br>&gt;&=
nbsp;&nbsp;&nbsp;&nbsp; Bad news: I&#39;ve been unsuccesfully trying to app=
ly the new patches (as<br>&gt; mentioned in the wiki), with the following r=
esults:<br>&gt;<br>
&gt; 1.- analog part applies just fine:<br>&gt;<br>&gt; mediacenter v4l-dvb=
 # patch -p1 &lt; ../1_avertv_A700_analog_part.diff<br>&gt; patching file l=
inux/drivers/media/video/saa7134/saa7134-cards.c<br>&gt; patching file linu=
x/drivers/media/video/saa7134/saa7134.h<br>
&gt; patching file linux/Documentation/video4linux/CARDLIST.saa7134<br>&gt;=
<br>It is just listed extra as this patch is the only one I think is correc=
t and I<br>hope it gets applied to v4l-dvb in near future. (Maybe after som=
e others have<br>
verified it.)<br><br>&gt;<br>&gt; 2.- Your patch (ZZam&#39;s) gives some wa=
rnings:<br>&gt;<br><br>&gt;<br>&gt; Apparently the A700 section is duplicat=
ed. I assume that the second section<br>&gt; is the good one, as the first =
gives only option for analog input. This is<br>
&gt; probably related to the patch no aplying cleanly. I&#39;ve removed the=
 1st<br>&gt; section and now it seems to compile fine.<br>&gt;<br>So you fo=
und out the hard way, that patch 1 (analog-only) is already part of<br>
my patch and you should only apply one of these.<br><br>&gt;<br>&gt; 3.- Ti=
no&#39;s patch gets worse. It even doesn&#39;t apply:<br>&gt;<br><br>I gues=
s this patch is also influenced by some new added cards.<br><br>Regards<br>
&nbsp;&nbsp;Matthias<br><br>--<br>Matthias Schwarzott (zzam)<br></blockquot=
e></div><br>

------=_Part_4961_24981435.1202287427289--


--===============1086854320==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1086854320==--
