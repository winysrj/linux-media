Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0DDZ-0005y2-Dq
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 11:45:04 +0100
Received: by qw-out-2122.google.com with SMTP id 9so227257qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 02:44:57 -0800 (PST)
Message-ID: <c74595dc0811120244o7a44495el33188765c6a2cc80@mail.gmail.com>
Date: Wed, 12 Nov 2008 12:44:57 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Per Heldal" <heldal@eml.cc>
In-Reply-To: <1226485295.19990.28.camel@obelix>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
	<1226485295.19990.28.camel@obelix>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0962804447=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0962804447==
Content-Type: multipart/alternative;
	boundary="----=_Part_3655_2076193.1226486697056"

------=_Part_3655_2076193.1226486697056
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 12, 2008 at 12:21 PM, Per Heldal <heldal@eml.cc> wrote:

> On Wed, 2008-11-12 at 09:46 +0300, Goga777 wrote:
> > thanks for your patch.
> >
> > btw - could you scan dvb-s2 (qpsk & 8psk) channels with scan-s2 and
> > hvr4000 ? with which drivers ?
> >
>
> I seem to be able to scan some transponders, but not all, using current
> code from the repos at http://linuxtv.org/hg/v4l-dvb/ and
> http://mercurial.intuxication.org/hg/scan-s2
>
> I run scan-s2 on the following list of HD-transponders on 0.8w :
>
> S 11938000 H 25000000 3/4 35 8PSK
> S 12015000 H 30000000 3/4 35 8PSK
> S 12130000 H 30000000 3/4 35 8PSK
> S 12188000 V 25000000 3/4 35 8PSK
>
> (a selection of transponders from
> http://lyngsat.com/packages/canaldigital.html)
>
> With rolloff set to AUTO scan-s2 will not lock to any transponder.
> Instead it will appear to repeatedly re-scan sources on any transponder
> the tuner previously was tuned to.
>
> With rolloff set to 35 as above scan-s2 will lock and find channels on
> both transponders with SR=25000000, but for the 2 in the middle with
> SR=30000000 it simply repeats the channel-list of the previous
> transponder. I've been playing with alternatives for rolloff and
> modulation with no result.
>

The problem will probably be solved with new scan-s2, hopefully I'll have
time to update it today.
I'll send an update to the list when I'll update the repository.

------=_Part_3655_2076193.1226486697056
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br>
<div class="gmail_quote">On Wed, Nov 12, 2008 at 12:21 PM, Per Heldal <span dir="ltr">&lt;heldal@eml.cc&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class="Ih2E3d">On Wed, 2008-11-12 at 09:46 +0300, Goga777 wrote:<br>&gt; thanks for your patch.<br>&gt;<br>&gt; btw - could you scan dvb-s2 (qpsk &amp; 8psk) channels with scan-s2 and<br>&gt; hvr4000 ? with which drivers ?<br>
&gt;<br><br></div>I seem to be able to scan some transponders, but not all, using current<br>code from the repos at <a href="http://linuxtv.org/hg/v4l-dvb/" target="_blank">http://linuxtv.org/hg/v4l-dvb/</a> and<br>
<div class="Ih2E3d"><a href="http://mercurial.intuxication.org/hg/scan-s2" target="_blank">http://mercurial.intuxication.org/hg/scan-s2</a><br><br></div>I run scan-s2 on the following list of HD-transponders on 0.8w :<br>
<br>S 11938000 H 25000000 3/4 35 8PSK<br>S 12015000 H 30000000 3/4 35 8PSK<br>S 12130000 H 30000000 3/4 35 8PSK<br>S 12188000 V 25000000 3/4 35 8PSK<br><br>(a selection of transponders from<br><a href="http://lyngsat.com/packages/canaldigital.html" target="_blank">http://lyngsat.com/packages/canaldigital.html</a>)<br>
<br>With rolloff set to AUTO scan-s2 will not lock to any transponder.<br>Instead it will appear to repeatedly re-scan sources on any transponder<br>the tuner previously was tuned to.<br><br>With rolloff set to 35 as above scan-s2 will lock and find channels on<br>
both transponders with SR=25000000, but for the 2 in the middle with<br>SR=30000000 it simply repeats the channel-list of the previous<br>transponder. I&#39;ve been playing with alternatives for rolloff and<br>modulation with no result.<br>
</blockquote>
<div>&nbsp;</div>
<div>The problem will probably be solved with new scan-s2, hopefully I&#39;ll have time to update it today.</div>
<div>I&#39;ll send an update to the list when I&#39;ll update the repository.</div>
<div>&nbsp;</div></div></div>

------=_Part_3655_2076193.1226486697056--


--===============0962804447==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0962804447==--
