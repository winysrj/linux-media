Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KAOPu-0001Qm-Es
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 14:11:36 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	2C32D1800137
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 12:10:58 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Sun, 22 Jun 2008 22:10:58 +1000
Message-Id: <20080622121058.122F7BE4078@ws1-9.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1980329911=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1980329911==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1214136658286580"

This is a multi-part message in MIME format.

--_----------=_1214136658286580
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Steven,

The card works perfectly using Chris Pascoe's branch, I can use both
tuners at the same time. It only stuffs up when I try and merge the
relevant sections into tip, as per the patch I attached in the previous
email.  So this eliminates bios/hardware faults. I can also try in
windows for you, but I'm sure this is not the fault.

I would like to run a more modern version of the hg code as I have other
cards sitting around that could go in the same system and also I fear
that if somebody doesn't do the work to get it into tip, support will
disappear for newer kernels.

Thanks for help, any further advice?
(Also you lost me a bit with sram and risc, is this for the
microprocessor on the tv card or is it on my motherboard/cpu? And do you
have any documentation about them so I can learn more about it?)

Stephen.

  ----- Original Message -----
  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
  Date: Sat, 21 Jun 2008 08:54:39 -0400



  > As soon as I try to access both cards at the same time it breaks
  > and only a full computer restart will fix it, i have tried
  > unloading all the modules that I can find that this card uses and
  > loading them again. I get the syslog attached below (cx23885 with
  > debug =3D1). It doesn't matter what progam i use to access them
  > (tried gxine, totem, mythtv) it all works the same, only one at a
  > time or it breaks.

  If the vidb and vidc (ts1 / ts2) bridge streams each single channel
  correctly, but not both together then this is either a sram
  configuration issue (the risc engine's workspace is being corrupted
  by another risc channel), or your system has a pcie compatibility
  issue.

  I've seen both of these issues in the past.

  I don't have a hardware product with demodulators on vidb and c, so
  that's not something I can repro.

  Can you dual boot the same system under windows and remove any pcie
  compatibility doubts?

  - Steve

--=20
See Exclusive Videos: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1214136658286580
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Steven,<br><br>The card works perfectly using Chris Pascoe's branch, I can =
use both tuners at the same time. It only stuffs up when I try and merge th=
e relevant sections into tip, as per the patch I attached in the previous e=
mail.&nbsp; So this eliminates bios/hardware faults. I can also try in wind=
ows for you, but I'm sure this is not the fault.<br><br>I would like to run=
 a more modern version of the hg code as I have other cards sitting around =
that could go in the same system and also I fear that if somebody doesn't d=
o the work to get it into tip, support will disappear for newer kernels.<br=
><br>Thanks for help, any further advice? <br>(Also you lost me a bit with =
sram and risc, is this for the microprocessor on the tv card or is it on my=
 motherboard/cpu? And do you have any documentation about them so I can lea=
rn more about it?)<br><br>Stephen.<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts<br>
Date: Sat, 21 Jun 2008 08:54:39 -0400<br>
<br>

<br>
<br>
&gt; As soon as I try to access both cards at the same time it breaks <br>
&gt; and only a full computer restart will fix it, i have tried <br>
&gt; unloading all the modules that I can find that this card uses and <br>
&gt; loading them again. I get the syslog attached below (cx23885 with <br>
&gt; debug =3D1).  It doesn't matter what progam i use to access them <br>
&gt; (tried gxine, totem, mythtv) it all works the same, only one at a <br>
&gt; time or it breaks.<br>
<br>
If the vidb and vidc (ts1 / ts2) bridge streams each single channel <br>
correctly, but not both together then this is either a sram <br>
configuration issue (the risc engine's workspace is being corrupted <br>
by another risc channel), or your system has a pcie compatibility <br>
issue.<br>
<br>
I've seen both of these issues in the past.<br>
<br>
I don't have a hardware product with demodulators on vidb and c, so <br>
that's not something I can repro.<br>
<br>
Can you dual boot the same system under windows and remove any pcie <br>
compatibility doubts?<br>
<br>
- Steve<br>
</stoth@linuxtv.org></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Videos: <a href=3D"http://link.brightcove.com/services/=
player/bcpid1403465002?bclid=3D1527697154&bctid=3D1531204364", target=3D"_b=
lank"> <b> 10th Annual Young Hollywood Awards</b></a><br>
</div>

--_----------=_1214136658286580--



--===============1980329911==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1980329911==--
