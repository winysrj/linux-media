Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Kuv3D-00039b-Uc
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 21:20:30 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1310526qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 13:20:23 -0700 (PDT)
Message-ID: <c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
Date: Tue, 28 Oct 2008 22:20:22 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "oleg roitburd" <oroitburd@gmail.com>
In-Reply-To: <b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0763309152=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0763309152==
Content-Type: multipart/alternative;
	boundary="----=_Part_129960_9921015.1225225223305"

------=_Part_129960_9921015.1225225223305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Oct 28, 2008 at 10:05 PM, oleg roitburd <oroitburd@gmail.com> wrote:

>
> Small snipet from VDR/channels.c
> -------------------------------snip------------------------------
> const tChannelParameterMap ModulationValues[] = {
>  {  16, QAM_16,   "QAM16" },
>  {  32, QAM_32,   "QAM32" },
>  {  64, QAM_64,   "QAM64" },
>  { 128, QAM_128,  "QAM128" },
>  { 256, QAM_256,  "QAM256" },
>  {   2, QPSK,     "QPSK" },
>  {   5, PSK_8,    "8PSK" },
>  {   6, APSK_16,  "16APSK" },
>  {  10, VSB_8,    "VSB8" },
>  {  11, VSB_16,   "VSB16" },
>  { 998, QAM_AUTO, "QAMAUTO" },
>  { -1 }
>  };
> -------------------------------------------snap----------------------------

Thanks. I'll use it in the dump.


>
> >
> > FEC you can specify in the frequency file as "AUTO", "1/3", "2/3" and so
> on.
> > I'll update README to make it clear. All frequency files samples show
> that
> > option.
>
> i have seen, that FEC will be set if FEC is in initial file.
> If transponder was found via NIT it will be not set

Yeah, it was my change since I saw NIT specifying incorrect FEC for a
channel that was in my frequency list already!
I'll probably change it so NIT will be considered as the correct info unless
frequency list include non-AUTO value.
This way it will be possible to overwrite values or rely on network
announcements if you want full automatic behavior.

------=_Part_129960_9921015.1225225223305
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Tue, Oct 28, 2008 at 10:05 PM, oleg roitburd <span dir="ltr">&lt;<a href="mailto:oroitburd@gmail.com">oroitburd@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
Small snipet from VDR/channels.c<br>
-------------------------------snip------------------------------<br>
const tChannelParameterMap ModulationValues[] = {<br>
 &nbsp;{ &nbsp;16, QAM_16, &nbsp; &quot;QAM16&quot; },<br>
 &nbsp;{ &nbsp;32, QAM_32, &nbsp; &quot;QAM32&quot; },<br>
 &nbsp;{ &nbsp;64, QAM_64, &nbsp; &quot;QAM64&quot; },<br>
 &nbsp;{ 128, QAM_128, &nbsp;&quot;QAM128&quot; },<br>
 &nbsp;{ 256, QAM_256, &nbsp;&quot;QAM256&quot; },<br>
 &nbsp;{ &nbsp; 2, QPSK, &nbsp; &nbsp; &quot;QPSK&quot; },<br>
 &nbsp;{ &nbsp; 5, PSK_8, &nbsp; &nbsp;&quot;8PSK&quot; },<br>
 &nbsp;{ &nbsp; 6, APSK_16, &nbsp;&quot;16APSK&quot; },<br>
 &nbsp;{ &nbsp;10, VSB_8, &nbsp; &nbsp;&quot;VSB8&quot; },<br>
 &nbsp;{ &nbsp;11, VSB_16, &nbsp; &quot;VSB16&quot; },<br>
 &nbsp;{ 998, QAM_AUTO, &quot;QAMAUTO&quot; },<br>
 &nbsp;{ -1 }<br>
 &nbsp;};<br>
-------------------------------------------snap----------------------------</blockquote><div>Thanks. I&#39;ll use it in the dump.<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<div class="Ih2E3d">&gt;<br>
&gt; FEC you can specify in the frequency file as &quot;AUTO&quot;, &quot;1/3&quot;, &quot;2/3&quot; and so on.<br>
&gt; I&#39;ll update README to make it clear. All frequency files samples show that<br>
&gt; option.<br>
<br>
</div>i have seen, that FEC will be set if FEC is in initial file.<br>
If transponder was found via NIT it will be not set</blockquote><div>Yeah, it was my change since I saw NIT specifying incorrect FEC for a channel that was in my frequency list already!<br>I&#39;ll probably change it so NIT will be considered as the correct info unless frequency list include non-AUTO value.<br>
This way it will be possible to overwrite values or rely on network announcements if you want full automatic behavior.<br>&nbsp;<br></div></div><br></div>

------=_Part_129960_9921015.1225225223305--


--===============0763309152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0763309152==--
