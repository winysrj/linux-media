Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <coolvijet@gmail.com>) id 1KO3qb-0006sK-QX
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 07:03:40 +0200
Received: by ik-out-1112.google.com with SMTP id c21so275190ika.1
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 22:03:34 -0700 (PDT)
Message-ID: <f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
Date: Wed, 30 Jul 2008 10:33:33 +0530
From: "vijet m" <coolvijet@gmail.com>
To: "Frederic CAND" <frederic.cand@anevia.com>
In-Reply-To: <488F40A0.8080201@anevia.com>
MIME-Version: 1.0
References: <f3ebb34d0807290258i68f62f57w451a9741ad362b0d@mail.gmail.com>
	<488EEA80.4060908@anevia.com>
	<f3ebb34d0807290420l6c943e15jc1e27878963a7206@mail.gmail.com>
	<488F3E32.1010102@anevia.com> <488F3F0B.3000209@linuxtv.org>
	<488F40A0.8080201@anevia.com>
Cc: linux-dvb@linuxtv.org, Marcel Siegert <mws@linuxtv.org>
Subject: Re: [linux-dvb] How to record whole TS?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2063403717=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2063403717==
Content-Type: multipart/alternative;
	boundary="----=_Part_25113_31497479.1217394213989"

------=_Part_25113_31497479.1217394213989
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Sorry to interrupt your discussion but I have a question regarding recordin=
g
of MPEG2 streams.
As Kurt said, if you set pesfilter with output as DMX_OUT_TS_TAP and pass
the pid, it will record the streams corresponding
to that pid. So, if I pass audio and video pid, then it will record only th=
e
audio and video streams.
I wanted to know how to record the DVB SI/PSI tables corresponding to the
streams I'm recording.
Do I have to pass the pids of the tables I want to record or is there some
other way?
Right now, I'm using the pid value 0x2000 for setting pes filter which is
proving to be computationally intensive and consuming lot of CPU.
Please help.

Thanks in advance,
       Vijet M

On Tue, Jul 29, 2008 at 9:39 PM, Frederic CAND <frederic.cand@anevia.com>wr=
ote:

> Marcel Siegert a =E9crit :
> > hiho,
> >
> > Frederic CAND schrieb:
> >> kurt xue a =E9crit :
> >>> Hi CAND,
> >>>
> >>> Thanks for your reply, you are right. When I set pid 0x2000, the
> >>> demux gives whole stream. You are so good, maybe this should be
> >>> mentioned in the api doc :). Thanks!
> >>>
> >>
> >> I guess that should be the case (for the doc).
> >> However, take care : handling a full MPTS takes much more CPU than
> >> just some PIDs ...
> >> RegardS.
> >
> >
> > that depends on the device you're using for recording, doesn't it? :)
> >
> > regards marcel
> >
>
> My idea was, handling 3 Mbps containing one Video PID + one Audio PID +
> some SI/PSI Tables seems to me cost-effective compared to handling
> 40Mbps of a DVB Stream (that's what was my example ... DVB-S Streams...)
>
> --
> CAND Frederic
> Product Manager
> ANEVIA
>
> _______________________________________________
>  linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_25113_31497479.1217394213989
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><p>Hi,</p>
<p>Sorry to interrupt your discussion but I have a question regarding recor=
ding of MPEG2 streams.<br>As Kurt said, if you set pesfilter with output as=
 DMX_OUT_TS_TAP and pass the pid, it will record the streams corresponding =
<br>
to that pid. So, if I pass audio and video pid, then it will record only th=
e audio and video streams.<br>I wanted to know how to record the DVB SI/PSI=
 tables corresponding to the streams I&#39;m recording.<br>Do I have to pas=
s the pids of the tables I want to record or is there some other way?<br>
Right now, I&#39;m using the pid value 0x2000 for setting pes filter which =
is proving to be computationally intensive and consuming lot of CPU.<br>Ple=
ase help.</p>
<p>Thanks in advance,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vijet M<=
br><br></p>
<div class=3D"gmail_quote">On Tue, Jul 29, 2008 at 9:39 PM, Frederic CAND <=
span dir=3D"ltr">&lt;<a href=3D"mailto:frederic.cand@anevia.com">frederic.c=
and@anevia.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Marcel Siegert a =E9crit :<br>
<div class=3D"Ih2E3d">&gt; hiho,<br>&gt;<br>&gt; Frederic CAND schrieb:<br>=
&gt;&gt; kurt xue a =E9crit :<br>&gt;&gt;&gt; Hi CAND,<br>&gt;&gt;&gt;<br>&=
gt;&gt;&gt; Thanks for your reply, you are right. When I set pid 0x2000, th=
e<br>
&gt;&gt;&gt; demux gives whole stream. You are so good, maybe this should b=
e<br>&gt;&gt;&gt; mentioned in the api doc :). Thanks!<br>&gt;&gt;&gt;<br>&=
gt;&gt;<br>&gt;&gt; I guess that should be the case (for the doc).<br>&gt;&=
gt; However, take care : handling a full MPTS takes much more CPU than<br>
&gt;&gt; just some PIDs ...<br>&gt;&gt; RegardS.<br>&gt;<br>&gt;<br>&gt; th=
at depends on the device you&#39;re using for recording, doesn&#39;t it? :)=
<br>&gt;<br>&gt; regards marcel<br>&gt;<br><br></div>My idea was, handling =
3 Mbps containing one Video PID + one Audio PID +<br>
some SI/PSI Tables seems to me cost-effective compared to handling<br>40Mbp=
s of a DVB Stream (that&#39;s what was my example ... DVB-S Streams...)<br>
<div class=3D"Ih2E3d"><br>--<br>CAND Frederic<br>Product Manager<br>ANEVIA<=
br><br>_______________________________________________<br></div>
<div>
<div></div>
<div class=3D"Wj3C7c">linux-dvb mailing list<br><a href=3D"mailto:linux-dvb=
@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.or=
g/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.=
org/cgi-bin/mailman/listinfo/linux-dvb</a></div>
</div></blockquote></div><br></div>

------=_Part_25113_31497479.1217394213989--


--===============2063403717==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2063403717==--
