Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lanshinesun@gmail.com>) id 1NU9Oh-0002u1-2O
	for linux-dvb@linuxtv.org; Mon, 11 Jan 2010 02:48:47 +0100
Received: from qw-out-2122.google.com ([74.125.92.25])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NU9Og-0000gS-Hu; Mon, 11 Jan 2010 02:48:46 +0100
Received: by qw-out-2122.google.com with SMTP id 9so2558251qwb.17
	for <linux-dvb@linuxtv.org>; Sun, 10 Jan 2010 17:48:45 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 09:48:45 +0800
Message-ID: <20bec30b1001101748i681c2d60ib26253112915306d@mail.gmail.com>
From: huimei deng <lanshinesun@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] help!
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0400287715=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0400287715==
Content-Type: multipart/alternative; boundary=001485e0e61edfabcf047cd9bc61

--001485e0e61edfabcf047cd9bc61
Content-Type: text/plain; charset=ISO-8859-1

Hello all,

I am making the stv0903(support DVB-S/S2) driver.
I have implemented the initialize routine and search algorithm with
help of ST's reference code.
In case of DVB-S, it works well but DVB-S2 has some problem on
checking the lock.
Another question is about the clock.My reference clock is 27MHz.When
 the NCOARSE register is set 0X13h,the clock will stop .I just can set
0x09h.

I would like to to get some help what is wrong.
Or any experience on this is welcome.

Regards,

--001485e0e61edfabcf047cd9bc61
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hello all,<br><br>I am making the stv0903(support DVB-S/S2) driver.<br=
>I have implemented the initialize routine and search algorithm with<br>hel=
p of ST&#39;s reference code.<br>In case of DVB-S, it works well but DVB-S2=
 has some problem on<br>
checking the lock.</div>
<div>Another question is about the clock.My reference clock is 27MHz.When=
=A0</div>
<div>=A0the NCOARSE register is set 0X13h,the clock will stop .I just can s=
et 0x09h.<br><br>I would like to to get some help what is wrong.<br>Or any =
experience on this is welcome.<br><br>Regards,<br></div>

--001485e0e61edfabcf047cd9bc61--


--===============0400287715==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0400287715==--
