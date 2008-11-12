Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0MlD-0005YM-CO
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 21:56:25 +0100
Received: by qw-out-2122.google.com with SMTP id 9so414095qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 12:56:18 -0800 (PST)
Message-ID: <c74595dc0811121256h505d71e1q3468e061dfefc3df@mail.gmail.com>
Date: Wed, 12 Nov 2008 22:56:18 +0200
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
Content-Type: multipart/mixed; boundary="===============0587610837=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0587610837==
Content-Type: multipart/alternative;
	boundary="----=_Part_13327_10211020.1226523378917"

------=_Part_13327_10211020.1226523378917
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
Hans,
I'm looking on your QPSK diff and I disagree with the changes.
I think the concept of having all missing parameters as AUTO values should
have modulation, rolloff and FEC set to AUTO enumeration.
If your card can't handle the AUTO setting, so you have to specify it in the
frequency file.
Applying your changes will break scaning S2 channels for a freq file with
the following line:
S 11258000 H 27500000
or even
S2 11258000 H 27500000

Since it will order the driver to use QPSK modulation, while there should be
8PSK or AUTO.
I don't really know how rolloff=35 will affect since its the default in some
drivers, but again, AUTO setting was intended for that purpose,
to let the card/driver decide what parameters should be used.


> Regards,
> Hans
>
> --
> Release early, release often.
>
> Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten
> Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
>

------=_Part_13327_10211020.1226523378917
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Wed, Nov 12, 2008 at 4:31 AM, Hans Werner <span dir="ltr">&lt;<a href="mailto:HWerner4@gmx.de">HWerner4@gmx.de</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I have attached two patches for scan-s2 at <a href="http://mercurial.intuxication.org/hg/scan-s2" target="_blank">http://mercurial.intuxication.org/hg/scan-s2</a>.<br>
<br>
Patch1: Some fixes for problems I found. QAM_AUTO is not supported by all drivers,<br>
in particular the HVR-4000, so one needs to use QPSK as the default and ensure that<br>
settings are parsed properly from the network information -- the new S2 FECs and<br>
modulations were not handled.<br>
<br>
Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish to the correct<br>
position for the scan:<br>
&nbsp;scan-s2 -r 19.2E -n dvb-s/Astra-19.2E<br>
&nbsp;or<br>
&nbsp;scan-s2 -R 2 -n dvb-s/Astra-19.2E<br>
<br>
A file (rotor.conf) listing the rotor positions is used (NB: rotors vary -- do check your<br>
rotor manual).<br>
</blockquote><div>Hans,<br>I&#39;m looking on your QPSK diff and I disagree with the changes.<br>I think the concept of having all missing parameters as AUTO values should have modulation, rolloff and FEC set to AUTO enumeration.<br>
If your card can&#39;t handle the AUTO setting, so you have to specify it in the frequency file.<br>Applying your changes will break scaning S2 channels for a freq file with the following line:<br>S 11258000 H 27500000<br>
or even<br>S2 11258000 H 27500000<br><br>Since it will order the driver to use QPSK modulation, while there should be 8PSK or AUTO.<br>I don&#39;t really know how rolloff=35 will affect since its the default in some drivers, but again, AUTO setting was intended for that purpose,<br>
to let the card/driver decide what parameters should be used.<br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
Regards,<br>
Hans<br>
<font color="#888888"><br>
--<br>
Release early, release often.<br>
<br>
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten<br>
Browser-Versionen downloaden: <a href="http://www.gmx.net/de/go/browser" target="_blank">http://www.gmx.net/de/go/browser</a><br>
</font></blockquote></div><br></div>

------=_Part_13327_10211020.1226523378917--


--===============0587610837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0587610837==--
