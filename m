Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0DC4-0005S1-42
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 11:43:30 +0100
Received: by qw-out-2122.google.com with SMTP id 9so227009qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 02:43:23 -0800 (PST)
Message-ID: <c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
Date: Wed, 12 Nov 2008 12:43:23 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081112023112.94740@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1268514631=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1268514631==
Content-Type: multipart/alternative;
	boundary="----=_Part_3641_3050483.1226486603450"

------=_Part_3641_3050483.1226486603450
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 12, 2008 at 4:31 AM, Hans Werner <HWerner4@gmx.de> wrote:

> I have attached two patches for scan-s2 at
> http://mercurial.intuxication.org/hg/scan-s2.
>
> Patch1: Some fixes for problems I found. QAM_AUTO is not supported by all
> drivers,
> in particular the HVR-4000, so one needs to use QPSK as the default and
> ensure that
> settings are parsed properly from the network information -- the new S2
> FECs and
> modulations were not handled.
>
> Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish to
> the correct
> position for the scan:
>  scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
>  or
>  scan-s2 -R 2 -n dvb-s/Astra-19.2E
>
> A file (rotor.conf) listing the rotor positions is used (NB: rotors vary --
> do check your
> rotor manual).
>

I didn't check the diff files yet, will do it when I get home.
But I don't think QPSK should be used by default. I have a version already
where you can specify which scan mode you want to be performed DVB-S or
DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly specify
QPSK in frequency file the utility will not scan DVB-S2, same logic also for
8PSK that will scan only DVB-S2 and will not try to scan DVB-S.
I'll push that version soon to the repository.

The default should stay the AUTO mode since there are cards that can handle
that and their owners might have simplified frequency file version.

------=_Part_3641_3050483.1226486603450
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br>
<div class="gmail_quote">On Wed, Nov 12, 2008 at 4:31 AM, Hans Werner <span dir="ltr">&lt;<a href="mailto:HWerner4@gmx.de">HWerner4@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">I have attached two patches for scan-s2 at <a href="http://mercurial.intuxication.org/hg/scan-s2" target="_blank">http://mercurial.intuxication.org/hg/scan-s2</a>.<br>
<br>Patch1: Some fixes for problems I found. QAM_AUTO is not supported by all drivers,<br>in particular the HVR-4000, so one needs to use QPSK as the default and ensure that<br>settings are parsed properly from the network information -- the new S2 FECs and<br>
modulations were not handled.<br><br>Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish to the correct<br>position for the scan:<br>&nbsp;scan-s2 -r 19.2E -n dvb-s/Astra-19.2E<br>&nbsp;or<br>&nbsp;scan-s2 -R 2 -n dvb-s/Astra-19.2E<br>
<br>A file (rotor.conf) listing the rotor positions is used (NB: rotors vary -- do check your<br>rotor manual).<br></blockquote>
<div>&nbsp;</div>
<div>I didn&#39;t check the diff files yet, will do it when I get home.<br>But I don&#39;t think QPSK should be used by default. I have a version already where you can specify which scan mode you want to be performed DVB-S or DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly specify QPSK in frequency file the utility will not scan DVB-S2, same logic also for 8PSK that will scan only DVB-S2 and will not try to scan DVB-S.<br>
I&#39;ll push that version soon to the repository.<br>&nbsp;<br>The default should stay the AUTO mode since there are cards that can handle that and their owners might have simplified frequency file version.</div></div></div>

------=_Part_3641_3050483.1226486603450--


--===============1268514631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1268514631==--
