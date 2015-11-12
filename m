Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <hmehmetkurnaz@gmail.com>) id 1ZwsfL-0003tX-53
	for linux-dvb@linuxtv.org; Thu, 12 Nov 2015 15:15:55 +0100
Received: from mail-lf0-f46.google.com ([209.85.215.46])
	by mail.tu-berlin.de (exim-4.76/mailfrontend-5) with esmtps
	[UNKNOWN:AES128-GCM-SHA256:128] for <linux-dvb@linuxtv.org>
	id 1ZwsfJ-0006KK-9S; Thu, 12 Nov 2015 15:15:55 +0100
Received: by lfdo63 with SMTP id o63so34643515lfd.2
	for <linux-dvb@linuxtv.org>; Thu, 12 Nov 2015 06:15:53 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Nov 2015 16:15:53 +0200
Message-ID: <CAGYfdegQEK5aBUHOBUwpZL37sM1cTb6NVoz6oWC0=6yqsVRm4Q@mail.gmail.com>
From: Mehmet Kurnaz <hmehmetkurnaz@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] M88RS6000 single chip DVB-S2 receiver with dw2102.c
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1197443569=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1197443569==
Content-Type: multipart/alternative; boundary=001a11410ad2a663af0524589418

--001a11410ad2a663af0524589418
Content-Type: text/plain; charset=UTF-8

Hello all,

I don't know that I am in right mailing-list and i am newbie about dvb
receiver's drivers.

I have DVBWorld DVB-S2 receiver with cy7c68013 and Montage M88RS6000 single
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

--001a11410ad2a663af0524589418
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello all,<div><br></div><div>I don&#39;t know that I am i=
n right mailing-list and i am newbie about dvb receiver&#39;s drivers.</div=
><div><br></div><div>I have DVBWorld DVB-S2 receiver with=C2=A0cy7c68013 an=
d Montage M88RS6000 single chip. I searched linux driver but unfortunately =
couldn&#39;t find any one. I found M88RS6000 driver from dvbsky.=C2=A0</div=
><div>And I used dvb-usb-dw2102.fw. Is it right choice?</div><div><br></div=
><div>But I have to add some functions to dw2102.c source. One of them is i=
2c transfer function. I need &quot;request&quot; command in dw210x_op_rw() =
function for read and write operations to write i2c transfer function for t=
his receiver. I asked to dvbworld but there is no response for a week. How =
can i write i2c transfer function?=C2=A0</div><div><br></div><div>So thanks=
</div><div>Mehmet Kurnaz</div><div><br></div><div><br></div></div>

--001a11410ad2a663af0524589418--


--===============1197443569==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1197443569==--
