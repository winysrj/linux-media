Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0FLP-0007xv-D9
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 14:01:15 +0100
Received: by qw-out-2122.google.com with SMTP id 9so256286qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 05:01:11 -0800 (PST)
Message-ID: <c74595dc0811120501h36c129a2wf85202263274c453@mail.gmail.com>
Date: Wed, 12 Nov 2008 15:01:11 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Christophe Thommeret" <hftom@free.fr>
In-Reply-To: <200811121353.47705.hftom@free.fr>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
	<c74595dc0811120408l4ef3cf92g9b1efc850e3b0b48@mail.gmail.com>
	<200811121353.47705.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0578093034=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0578093034==
Content-Type: multipart/alternative;
	boundary="----=_Part_5021_1165142.1226494871071"

------=_Part_5021_1165142.1226494871071
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 12, 2008 at 2:53 PM, Christophe Thommeret <hftom@free.fr> wrote:

> > BTW, you give here example of NIT parsing, do you know the format of the
> > message and what field specifies that the delivery system is DVB-S2? scan
> > utility code doesn't parse it, so I just add both DVB-S and DVB-S2 scans
> > for newly added transponder from NITmessage.
>
> It's specified in Satellite Descriptor:
> modulation_system==1, =>S2
> modulation_system==0, =>S
>
Thanks, but it doesn't help in my case.
NIT can specify new transponders, when adding them to the scan list I have
to know whenever they are DVB-S or DVB-S2.
Satellte descriptor is received after locking to the transponder.


>
> --
> Christophe Thommeret
>

------=_Part_5021_1165142.1226494871071
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br>
<div class="gmail_quote">On Wed, Nov 12, 2008 at 2:53 PM, Christophe Thommeret <span dir="ltr">&lt;<a href="mailto:hftom@free.fr">hftom@free.fr</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class="Ih2E3d">&gt; BTW, you give here example of NIT parsing, do you know the format of the<br>&gt; message and what field specifies that the delivery system is DVB-S2? scan<br>&gt; utility code doesn&#39;t parse it, so I just add both DVB-S and DVB-S2 scans<br>
&gt; for newly added transponder from NITmessage.<br><br></div>It&#39;s specified in Satellite Descriptor:<br>modulation_system==1, =&gt;S2<br>modulation_system==0, =&gt;S<br></blockquote>
<div>Thanks, but it doesn&#39;t help in my case.</div>
<div>NIT can specify new transponders, when adding them to the scan list I have to know whenever they are DVB-S or DVB-S2.</div>
<div>Satellte descriptor is received after locking to the transponder.</div>
<div>&nbsp;</div>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=""></span><br>--<br><font color="#888888">Christophe Thommeret<br></font></blockquote></div><br></div>

------=_Part_5021_1165142.1226494871071--


--===============0578093034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0578093034==--
