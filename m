Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <winbalak@rediffmail.com>) id 1OxuyZ-0004st-E7
	for linux-dvb@linuxtv.org; Tue, 21 Sep 2010 07:01:07 +0200
Received: from f5mail-237-214.rediffmail.com ([202.137.237.214]
	helo=rediffmail.com)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with smtp
	for <linux-dvb@linuxtv.org>
	id 1OxuyY-0006js-7j; Tue, 21 Sep 2010 07:01:07 +0200
Date: 21 Sep 2010 04:53:13 -0000
Message-ID: <20100921045313.26772.qmail@f5mail-237-214.rediffmail.com>
MIME-Version: 1.0
To: <linux-dvb@linuxtv.org>
From: "Bala  Subramaniam" <winbalak@rediffmail.com>
Subject: [linux-dvb] =?utf-8?q?Samsung_S2_Tuner=28DNBU10711IST=29_Driver?=
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0355068917=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0355068917==
Content-Type: multipart/alternative;
	boundary="=_7f9e34ab5d6d59e218ac57f9cf812b89"

--=_7f9e34ab5d6d59e218ac57f9cf812b89
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"

Hello all,



I am making the driver for Samsung S2 Tuner(DNBU10711IST),which has stv0903b link chip with front end stv6110 Rf chip.



I have implemented the initialize routine and search algorithm with

help of ST's reference code.



In case of DVB-S, it works well but DVB-S2 has some problem on

checking the lock.



I would like to to get some help what is wrong.

Or any experience on this is welcome.



Regards,

Bala
--=_7f9e34ab5d6d59e218ac57f9cf812b89
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="UTF-8"

Hello all,<br />
<br />
I am making the driver for Samsung S2 Tuner(DNBU10711IST),which has stv0903=
b link chip with front end stv6110 Rf chip.<br />
<br />
I have implemented the initialize routine and search algorithm with<br />
help of ST's reference code.<br />
<br />
In case of DVB-S, it works well but DVB-S2 has some problem on<br />
checking the lock.<br />
<br />
I would like to to get some help what is wrong.<br />
Or any experience on this is welcome.<br />
<br />
Regards,<br />
Bala<br><Table border=3D0 Width=3D644 Height=3D57 cellspacing=3D0 cellpaddi=
ng=3D0 style=3D"font-family:Verdana;font-size:11px;line-height:15px;"><TR><=
td><A HREF=3D"http://sigads.rediff.com/RealMedia/ads/click_nx.ads/www.redif=
fmail.com/signatureline.htm@Middle?" target=3D"_blank"><IMG SRC=3D"http://s=
igads.rediff.com/RealMedia/ads/adstream_nx.ads/www.rediffmail.com/signature=
line.htm@Middle"></A></td></TR></Table>
--=_7f9e34ab5d6d59e218ac57f9cf812b89--


--===============0355068917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0355068917==--
