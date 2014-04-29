Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <huydq5000@gmail.com>) id 1WeyLS-00012W-4p
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2014 05:04:36 +0200
Received: from mail-ie0-f181.google.com ([209.85.223.181])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-8) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1WeyLQ-00039O-kz; Tue, 29 Apr 2014 05:04:33 +0200
Received: by mail-ie0-f181.google.com with SMTP id y20so5649229ier.12
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2014 20:04:30 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Apr 2014 10:04:30 +0700
Message-ID: <CAGSY5EKPPRC_O6FTfCfxO+5SJki0Vp9RP4uZCzQmtyMJOuBPmQ@mail.gmail.com>
From: Dang Quang Huy <huydq5000@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with dvb drivers on KitKat
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1534435631=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1534435631==
Content-Type: multipart/alternative; boundary=20cf301cbd4ac7b7d704f825b011

--20cf301cbd4ac7b7d704f825b011
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm working with KitKat (gcc 4.7, 3.10 kernel, baytrail 64bit), after
enable DVB features via make menuconfig, I can see the device nodes
(frontend, demux, dvr) up, but It always returns ENOTTY when I use ioctl to
send FE_GET_PROPERTY to frontend node (It works with FE_GET_INFO).

If anyone has any expericence about it, please support.

Thanks,

--=20
=C4=90=E1=BA=B7ng Quang Huy

--20cf301cbd4ac7b7d704f825b011
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I&#39;m working with KitKat (gcc 4.=
7, 3.10 kernel, baytrail 64bit), after enable DVB features via make menucon=
fig, I can see the device nodes (frontend, demux, dvr) up, but It always re=
turns ENOTTY when I use ioctl to send FE_GET_PROPERTY to frontend node (It =
works with FE_GET_INFO).</div>
<div><br></div><div>If anyone has any expericence about it, please support.=
</div><div><br></div><div>Thanks,<br clear=3D"all"><div><br></div>-- <br>=
=C4=90=E1=BA=B7ng Quang Huy<br>
</div></div>

--20cf301cbd4ac7b7d704f825b011--


--===============1534435631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1534435631==--
