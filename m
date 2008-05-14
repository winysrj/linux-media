Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Jw4tY-0004QV-Be
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 02:31:02 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	BCCE21800D56
	for <linux-dvb@linuxtv.org>; Wed, 14 May 2008 00:30:25 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "allan k" <sonofzev@iinet.net.au>
Date: Wed, 14 May 2008 10:30:25 +1000
Message-Id: <20080514003025.B1E00164293@ws1-4.us4.outblaze.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will it
	be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0954029989=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0954029989==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1210725025299800"

This is a multi-part message in MIME format.

--_----------=_1210725025299800
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Allan,

The "Pass Through" port is not what you are thinking it is (Unless
kingray have changed there naming conventions, let me know what model and
I can tell you exactly).  The Pass through port is usually for the DC
power (or Low frequency AC) to pass through the device and into a further
amplifier along the coax to the antenna.  You can try turning down your
mast head amplifier, this will effect other tuners connected as well OR
you can goto Jaycar or Altronics and buy some attenuators.

Regards,

Stephen.


  Cool.

  I'll try your sources out later and provide feedback. (I have the
  same
  issue as I run a Fusion Lite on the system as well).

  With regards to attenuation, there is a "pass through" port on my
  Kingray antenna amplifier. From your feedback it looks like that if I
  use the pass through port, I may get a better picture.

  cheers

  Allan
  On Wed, 2008-05-14 at 09:52 +1000, stev391@email.com wrote:
  > Allan,
  >
  > I have had similar issues to what you have described, with usually
  > good reception channels having degraded quality. One solution
  > that I have used is to place an attenuator in line to
  > reduce the signal. This card has a good sensitivity for low
  reception
  > levels however the dynamic range of the card is not good enough to
  > handle what the older more common TV cards require for reception
  > levels.
  >
  > I have had no issue with Chris Pascoe's drivers, the only problem
  is
  > that his branch is now get dated and some of my other dvb gear does
  > not work reliably under his branch. This is why I'm trying to
  > generate a patch that works against the v4l-dvb tree.
  >
  > Also can you tell me what programs you are using to watch TV with?
  > With gxine I have no problem with my patch however when I run
  mythtv
  > occassionally it crashes my tuner. I have yet to accurately
  determine
  > why this is happening, and what I need to do to ensure that a
  > userspace program doesn't crash my hardware.
  >
  > Regards,
  > Stephen.

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1210725025299800
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

Allan,<br><br>The "Pass Through" port is not what you are thinking it is (U=
nless kingray have changed there naming conventions, let me know what model=
 and I can tell you exactly).&nbsp; The Pass through port is usually for th=
e DC power (or Low frequency AC) to pass through the device and into a furt=
her amplifier along the coax to the antenna.&nbsp; You can try turning down=
 your mast head amplifier, this will effect other tuners connected as well =
OR you can goto Jaycar or Altronics and buy some attenuators.<br><br>Regard=
s,<br><br>Stephen.<br>
<div>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;"><sonofzev@iinet.net.au><br>
Cool.<br>
<br>
I'll try your sources out later and provide feedback. (I have the same<br>
issue as I run a Fusion Lite on the system as well).<br>
<br>
With regards to attenuation, there is a "pass through" port on my<br>
Kingray antenna amplifier. From your feedback it looks like that if I<br>
use the pass through port, I may get a better picture.<br>
<br>
cheers<br>
<br>
Allan<br>
On Wed, 2008-05-14 at 09:52 +1000, stev391@email.com wrote:<br>
&gt; Allan,<br>
&gt;<br>
&gt; I have had similar issues to what you have described, with usually<br>
&gt; good reception channels having degraded quality.  One solution <br>
&gt; that I have used is to place an attenuator in line to<br>
&gt; reduce the signal. This card has a good sensitivity for low reception<=
br>
&gt; levels however the dynamic range of the card is not good enough to<br>
&gt; handle what the older more common TV cards require for reception<br>
&gt; levels.<br>
&gt;<br>
&gt; I have had no issue with Chris Pascoe's drivers, the only problem is<b=
r>
&gt; that his branch is now get dated and some of my other dvb gear does<br>
&gt; not work reliably under his branch.  This is why I'm trying to<br>
&gt; generate a patch that works against the v4l-dvb tree.<br>
&gt;<br>
&gt; Also can you tell me what programs you are using to watch TV with?<br>
&gt; With gxine I have no problem with my patch however when I run mythtv<b=
r>
&gt; occassionally it crashes my tuner. I have yet to accurately determine<=
br>
&gt; why this is happening, and what I need to do to ensure that a<br>
&gt; userspace program doesn't crash my hardware.<br>
&gt;<br>
&gt; Regards,<br>
&gt; Stephen.<br></sonofzev@iinet.net.au></blockquote></div><br><BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1210725025299800--



--===============0954029989==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0954029989==--
