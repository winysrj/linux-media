Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <hmehmetkurnaz@gmail.com>) id 1ZyJiV-0005uD-AK
	for linux-dvb@linuxtv.org; Mon, 16 Nov 2015 14:21:08 +0100
Received: from mail-lf0-f66.google.com ([209.85.215.66])
	by mail.tu-berlin.de (exim-4.76/mailfrontend-8) with esmtps
	[UNKNOWN:AES128-GCM-SHA256:128] for <linux-dvb@linuxtv.org>
	id 1ZyJiU-0006av-jX; Mon, 16 Nov 2015 14:21:07 +0100
Received: by lfu94 with SMTP id 94so2940247lfu.1
	for <linux-dvb@linuxtv.org>; Mon, 16 Nov 2015 05:21:05 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Nov 2015 15:21:05 +0200
Message-ID: <CAGYfdei+wZBP+5wwXqeFgMNp0JDH_YZXOtmeVUjO09USKF8EXQ@mail.gmail.com>
From: Mehmet Kurnaz <hmehmetkurnaz@gmail.com>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: [linux-dvb] M88RS6000 single chip DVB-S2 receiver with dw2102.c
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0973725103=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0973725103==
Content-Type: multipart/alternative; boundary=001a114002c809cdb40524a84844

--001a114002c809cdb40524a84844
Content-Type: text/plain; charset=UTF-8

Hello all,

I don't know that I am in right mailing-list and i am newbie about dvb
receiver's drivers.

I have a DVBWorld DVB-S2 receiver with cy7c68013 and Montage M88RS6000
single

chip. I searched linux driver but unfortunately couldn't find any one. I
found M88RS6000 driver from dvbsky.
And I used dvb-usb-dw2102.fw. Is it right choice?

But I have to add some functions to dw2102.c source. One of them is i2c
transfer function. I need "request" command in dw210x_op_rw() function for
read and write operations to write i2c transfer function for this receiver.
I asked to dvbworld but there is no response for a week. How can i write
i2c transfer function?

So thanks
Mehmet Kurnaz

--001a114002c809cdb40524a84844
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span class=3D"im" style=3D"font-size:12.8px">Hello all,<b=
r><br>I don&#39;t know that I am in right mailing-list and i am newbie abou=
t dvb<br>receiver&#39;s drivers.<br><br></span><span style=3D"font-size:12.=
8px">I have a DVBWorld DVB-S2 receiver with cy7c68013 and Montage M88RS6000=
 single</span><div class=3D"" style=3D"font-size:12.8px"><div id=3D":zj" cl=
ass=3D"" tabindex=3D"0"><img class=3D"" src=3D"https://ssl.gstatic.com/ui/v=
1/icons/mail/images/cleardot.gif"></div></div><div class=3D"" style=3D"font=
-size:12.8px"><span class=3D"im"><br>chip. I searched linux driver but unfo=
rtunately couldn&#39;t find any one. I<br>found M88RS6000 driver from dvbsk=
y.<br>And I used dvb-usb-dw2102.fw. Is it right choice?<br><br>But I have t=
o add some functions to dw2102.c source. One of them is i2c<br>transfer fun=
ction. I need &quot;request&quot; command in dw210x_op_rw() function for<br=
>read and write operations to write i2c transfer function for this receiver=
.<br>I asked to dvbworld but there is no response for a week. How can i wri=
te<br>i2c transfer function?<br><br>So thanks<br>Mehmet Kurnaz</span></div>=
</div>

--001a114002c809cdb40524a84844--


--===============0973725103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0973725103==--
