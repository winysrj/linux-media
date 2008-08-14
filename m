Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kurtxue@gmail.com>) id 1KTZVH-0000I8-AT
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 11:52:24 +0200
Received: by ti-out-0910.google.com with SMTP id w7so213189tib.13
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 02:52:16 -0700 (PDT)
Message-ID: <f3ebb34d0808140252m172ae76crb63e464f2cc98f95@mail.gmail.com>
Date: Thu, 14 Aug 2008 11:52:14 +0200
From: "kurt xue" <kurtxue@gmail.com>
To: "Jelle De Loecker" <skerit@kipdola.com>
In-Reply-To: <48A038B8.7020900@kipdola.com>
MIME-Version: 1.0
References: <f3ebb34d0808040958x2182bd3crde88559e685725fe@mail.gmail.com>
	<200808041904.48093.hftom@free.fr> <48A004E3.2090006@kipdola.com>
	<200808111448.55087.hftom@free.fr> <48A038B8.7020900@kipdola.com>
Cc: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Is it possible to descramble signal from 2
	frontends?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1358301230=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1358301230==
Content-Type: multipart/alternative;
	boundary="----=_Part_30368_32266960.1218707536728"

------=_Part_30368_32266960.1218707536728
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks Jelle, and Christophe, thanks for your reply. I was thinking in a
technical (developer's) way, but didn't mean to start an illegal issue...
Anyway I know the answer now, thanks

On Mon, Aug 11, 2008 at 3:03 PM, Jelle De Loecker <skerit@kipdola.com>wrote=
:

> Christophe Thommeret schreef:
> > Le Monday 11 August 2008 11:22:43 Jelle De Loecker, vous avez =E9crit :
> >
> >> Christophe Thommeret schreef:
> >>
> >>> Le Monday 04 August 2008 18:58:17 kurt xue, vous avez =E9crit :
> >>>
> >>>> Hi,
> >>>>
> >>>> I have two TechnoTrend DVB-C PCI card and 1 CAM, is it possible to u=
se
> >>>> this CAM to descramble signal from frontends of both DVB card?
> >>>>
> >>>> Thanks in advance for any reply!
> >>>> Kurt
> >>>>
> >>> No.
> >>>
> >> That isn't a very helpful answer to his problem, is it?
> >> He might have wanted any reply, but trying to be friendly wouldn't hav=
e
> >> killed you.
> >>
> >> I'll give this a go:
> >>
> >> There is a way, called "cardsharing", to decode multiple streams with =
1
> >> cam.
> >>
> > CAM !=3D CardReader
> >
> >
> >> Do note, however, that some people think this is illegal, but that's
> >> because cardsharing has a bad name. There are people who perform this
> >> "cardsharing" with other people over the internet, which IS illegal.
> >>
> > Getting control words outside the "secured" area is illegal.
> >
> >> Because of this most people don't want us to talk about *any *kind of
> >> cardsharing, just to be on the safe side.
> >> I can follow their reasoning but it still resembles some kind of
> >> illogical censor which we should not tollerate!
> >> But I digress ...
> >>
> >> Because this local cardsharing is not illegal (at least not where I'm
> >> from), some set top boxes you buy in the store also have multiple
> >> (working) tuners, so they perform some kind of internal cardsharing as
> >> well.
> >>
> > It's not a matter of cardsharing. It's of course technicaly possible to
> have
> > one cam beeing feed with streams from different tuners, but not on most
> PC
> > DVB cards like the TT ones where CI is wired to the card.
> >
> >
> >> Please correct me if I'm wrong or being ignorant ...
> >>
> > Done.
> >
> What is the definition of this "secured" area?
>
> According to you it's perfectly ok to decrypt multiple streams with one
> cam... but only if it is with the correct, approved, hardware?
>
> In essence, this is a shortcomming of the TT hardware, can we really
> tell people not to fix it using software because it'll break some
> ridiculous IP law, or whatever?
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_30368_32266960.1218707536728
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Thanks Jelle, and Christophe, thanks for your reply. I was=
 thinking in a technical (developer&#39;s) way, but didn&#39;t mean to star=
t an illegal issue... Anyway I know the answer now, thanks <br><br><div cla=
ss=3D"gmail_quote">
On Mon, Aug 11, 2008 at 3:03 PM, Jelle De Loecker <span dir=3D"ltr">&lt;<a =
href=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(2=
04, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class=3D"Wj3C7c">Christophe Thommeret schreef:<br>
&gt; Le Monday 11 August 2008 11:22:43 Jelle De Loecker, vous avez =E9crit =
:<br>
&gt;<br>
&gt;&gt; Christophe Thommeret schreef:<br>
&gt;&gt;<br>
&gt;&gt;&gt; Le Monday 04 August 2008 18:58:17 kurt xue, vous avez =E9crit =
:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Hi,<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; I have two TechnoTrend DVB-C PCI card and 1 CAM, is it pos=
sible to use<br>
&gt;&gt;&gt;&gt; this CAM to descramble signal from frontends of both DVB c=
ard?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Thanks in advance for any reply!<br>
&gt;&gt;&gt;&gt; Kurt<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt; No.<br>
&gt;&gt;&gt;<br>
&gt;&gt; That isn&#39;t a very helpful answer to his problem, is it?<br>
&gt;&gt; He might have wanted any reply, but trying to be friendly wouldn&#=
39;t have<br>
&gt;&gt; killed you.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;ll give this a go:<br>
&gt;&gt;<br>
&gt;&gt; There is a way, called &quot;cardsharing&quot;, to decode multiple=
 streams with 1<br>
&gt;&gt; cam.<br>
&gt;&gt;<br>
&gt; CAM !=3D CardReader<br>
&gt;<br>
&gt;<br>
&gt;&gt; Do note, however, that some people think this is illegal, but that=
&#39;s<br>
&gt;&gt; because cardsharing has a bad name. There are people who perform t=
his<br>
&gt;&gt; &quot;cardsharing&quot; with other people over the internet, which=
 IS illegal.<br>
&gt;&gt;<br>
&gt; Getting control words outside the &quot;secured&quot; area is illegal.=
<br>
&gt;<br>
&gt;&gt; Because of this most people don&#39;t want us to talk about *any *=
kind of<br>
&gt;&gt; cardsharing, just to be on the safe side.<br>
&gt;&gt; I can follow their reasoning but it still resembles some kind of<b=
r>
&gt;&gt; illogical censor which we should not tollerate!<br>
&gt;&gt; But I digress ...<br>
&gt;&gt;<br>
&gt;&gt; Because this local cardsharing is not illegal (at least not where =
I&#39;m<br>
&gt;&gt; from), some set top boxes you buy in the store also have multiple<=
br>
&gt;&gt; (working) tuners, so they perform some kind of internal cardsharin=
g as<br>
&gt;&gt; well.<br>
&gt;&gt;<br>
&gt; It&#39;s not a matter of cardsharing. It&#39;s of course technicaly po=
ssible to have<br>
&gt; one cam beeing feed with streams from different tuners, but not on mos=
t PC<br>
&gt; DVB cards like the TT ones where CI is wired to the card.<br>
&gt;<br>
&gt;<br>
&gt;&gt; Please correct me if I&#39;m wrong or being ignorant ...<br>
&gt;&gt;<br>
&gt; Done.<br>
&gt;<br>
</div></div>What is the definition of this &quot;secured&quot; area?<br>
<br>
According to you it&#39;s perfectly ok to decrypt multiple streams with one=
<br>
cam... but only if it is with the correct, approved, hardware?<br>
<br>
In essence, this is a shortcomming of the TT hardware, can we really<br>
tell people not to fix it using software because it&#39;ll break some<br>
ridiculous IP law, or whatever?<br>
<div><div></div><div class=3D"Wj3C7c"><br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br></div>

------=_Part_30368_32266960.1218707536728--


--===============1358301230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1358301230==--
