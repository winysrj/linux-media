Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JXdMw-00057M-9E
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 15:16:18 +0100
Received: by ik-out-1112.google.com with SMTP id b32so670009ika.1
	for <linux-dvb@linuxtv.org>; Fri, 07 Mar 2008 06:16:14 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 7 Mar 2008 15:15:52 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Z4U0HWmeJ/3HsxX"
Message-Id: <200803071515.53087.christophpfister@gmail.com>
Subject: [linux-dvb] Fwd: [Kaffeine-user] add frequenz to de-Koeln-Bonn
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--Boundary-00=_Z4U0HWmeJ/3HsxX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom a kaffeine user ...

Christoph


=2D---------  Weitergeleitete Nachricht  ----------

Betreff: [Kaffeine-user] add frequenz to de-Koeln-Bonn
Datum: Dienstag 04 M=E4rz 2008
Von: Ralf Wehner <RalfWehner@web.de>
An: kaffeine-user@lists.sf.net

Hi folks,

by a change of frequences for dvb-t in the area K=F6ln/Bonn (Germany) it=20
was necessary to add a new frequence to get the following programs:

=2D arte
=2D Das Erste
=2D EinsFestival
=2D Phoenix

So concreately, i have added the following line into the file=20
$HOME/.kde/share/apps/kaffeine/dvb-t/de-Koeln-Bonn:

T 706000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

After i've modified the frequence file, the next scan for channels in my=20
kaffeine were successful and the missing programms were found.

I've added the complete frequence file to the mail and hope it will help=20
you and others.

Cheers,
Ralf
=2D-=20
Ralf Wehner

=2D------------------------------------------------------

--Boundary-00=_Z4U0HWmeJ/3HsxX
Content-Type: text/plain;
  name="de-Koeln-Bonn"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="de-Koeln-Bonn"

# DVB-T NRW/Bonn
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 594000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 650000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 698000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 706000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 826000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

--Boundary-00=_Z4U0HWmeJ/3HsxX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Z4U0HWmeJ/3HsxX--
