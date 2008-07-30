Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kurtxue@gmail.com>) id 1KO5me-0003lb-60
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 09:07:42 +0200
Received: by ti-out-0910.google.com with SMTP id w7so99643tib.13
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 00:07:34 -0700 (PDT)
Message-ID: <f3ebb34d0807300007h45cc7c02y9115d4eb9803f094@mail.gmail.com>
Date: Wed, 30 Jul 2008 09:07:34 +0200
From: "kurt xue" <kurtxue@gmail.com>
To: "vijet m" <coolvijet@gmail.com>
In-Reply-To: <f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
MIME-Version: 1.0
References: <f3ebb34d0807290258i68f62f57w451a9741ad362b0d@mail.gmail.com>
	<488EEA80.4060908@anevia.com>
	<f3ebb34d0807290420l6c943e15jc1e27878963a7206@mail.gmail.com>
	<488F3E32.1010102@anevia.com> <488F3F0B.3000209@linuxtv.org>
	<488F40A0.8080201@anevia.com>
	<f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
Cc: Marcel Siegert <mws@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to record whole TS?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0373902808=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0373902808==
Content-Type: multipart/alternative;
	boundary="----=_Part_24664_6836932.1217401654517"

------=_Part_24664_6836932.1217401654517
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Vijet,

Some PSI tables locate in special PIDs, pls refer to 13818-1; and you also
can analyze PMT first to get information about whatever PIDs carrying the
table you want to record. Hope that can answer your question :)

Best regards,
Kurt

2008/7/30 vijet m <coolvijet@gmail.com>

> Hi,
>
> Sorry to interrupt your discussion but I have a question regarding
> recording of MPEG2 streams.
> As Kurt said, if you set pesfilter with output as DMX_OUT_TS_TAP and pass
> the pid, it will record the streams corresponding
> to that pid. So, if I pass audio and video pid, then it will record only
> the audio and video streams.
> I wanted to know how to record the DVB SI/PSI tables corresponding to the
> streams I'm recording.
> Do I have to pass the pids of the tables I want to record or is there som=
e
> other way?
> Right now, I'm using the pid value 0x2000 for setting pes filter which is
> proving to be computationally intensive and consuming lot of CPU.
> Please help.
>
> Thanks in advance,
>        Vijet M
>
> On Tue, Jul 29, 2008 at 9:39 PM, Frederic CAND <frederic.cand@anevia.com>=
wrote:
>
>> Marcel Siegert a =E9crit :
>> > hiho,
>> >
>> > Frederic CAND schrieb:
>> >> kurt xue a =E9crit :
>> >>> Hi CAND,
>> >>>
>> >>> Thanks for your reply, you are right. When I set pid 0x2000, the
>> >>> demux gives whole stream. You are so good, maybe this should be
>> >>> mentioned in the api doc :). Thanks!
>> >>>
>> >>
>> >> I guess that should be the case (for the doc).
>> >> However, take care : handling a full MPTS takes much more CPU than
>> >> just some PIDs ...
>> >> RegardS.
>> >
>> >
>> > that depends on the device you're using for recording, doesn't it? :)
>> >
>> > regards marcel
>> >
>>
>> My idea was, handling 3 Mbps containing one Video PID + one Audio PID +
>> some SI/PSI Tables seems to me cost-effective compared to handling
>> 40Mbps of a DVB Stream (that's what was my example ... DVB-S Streams...)
>>
>> --
>> CAND Frederic
>> Product Manager
>> ANEVIA
>>
>> _______________________________________________
>>  linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_24664_6836932.1217401654517
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Hi Vijet,<br><br>Some PSI tables locate in special PIDs, p=
ls refer to 13818-1; and you also can analyze PMT first to get information =
about whatever PIDs carrying the table you want to record. Hope that can an=
swer your question :)<br>
<br>Best regards,<br>Kurt<br><br><div class=3D"gmail_quote">2008/7/30 vijet=
 m <span dir=3D"ltr">&lt;<a href=3D"mailto:coolvijet@gmail.com">coolvijet@g=
mail.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D"borde=
r-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-le=
ft: 1ex;">
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
<div class=3D"gmail_quote"><div><div></div><div class=3D"Wj3C7c">On Tue, Ju=
l 29, 2008 at 9:39 PM, Frederic CAND <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:frederic.cand@anevia.com" target=3D"_blank">frederic.cand@anevia.com</a>&=
gt;</span> wrote:<br>

</div></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px sol=
id rgb(204, 204, 204); margin: 0px 0px 0px 0.8ex; padding-left: 1ex;"><div>=
<div></div><div class=3D"Wj3C7c">Marcel Siegert a =E9crit :<br>
<div>&gt; hiho,<br>&gt;<br>&gt; Frederic CAND schrieb:<br>&gt;&gt; kurt xue=
 a =E9crit :<br>&gt;&gt;&gt; Hi CAND,<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; Thank=
s for your reply, you are right. When I set pid 0x2000, the<br>
&gt;&gt;&gt; demux gives whole stream. You are so good, maybe this should b=
e<br>&gt;&gt;&gt; mentioned in the api doc :). Thanks!<br>&gt;&gt;&gt;<br>&=
gt;&gt;<br>&gt;&gt; I guess that should be the case (for the doc).<br>
&gt;&gt; However, take care : handling a full MPTS takes much more CPU than=
<br>
&gt;&gt; just some PIDs ...<br>&gt;&gt; RegardS.<br>&gt;<br>&gt;<br>&gt; th=
at depends on the device you&#39;re using for recording, doesn&#39;t it? :)=
<br>&gt;<br>&gt; regards marcel<br>&gt;<br><br></div>My idea was, handling =
3 Mbps containing one Video PID + one Audio PID +<br>

some SI/PSI Tables seems to me cost-effective compared to handling<br>40Mbp=
s of a DVB Stream (that&#39;s what was my example ... DVB-S Streams...)<br>
</div></div><div><div><div></div><div class=3D"Wj3C7c"><br>--<br>CAND Frede=
ric<br>Product Manager<br>ANEVIA<br><br></div></div>_______________________=
________________________<br></div>
<div>
<div></div>
<div>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb@linuxtv.org" tar=
get=3D"_blank">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.o=
rg/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv=
.org/cgi-bin/mailman/listinfo/linux-dvb</a></div>

</div></blockquote></div><br></div>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

------=_Part_24664_6836932.1217401654517--


--===============0373902808==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0373902808==--
