Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <hmehmetkurnaz@gmail.com>) id 1ZxB2d-0001eW-OF
	for linux-dvb@linuxtv.org; Fri, 13 Nov 2015 10:53:12 +0100
Received: from mail-lf0-f67.google.com ([209.85.215.67])
	by mail.tu-berlin.de (exim-4.76/mailfrontend-6) with esmtps
	[UNKNOWN:AES128-GCM-SHA256:128] for <linux-dvb@linuxtv.org>
	id 1ZxB2c-0000aR-4y; Fri, 13 Nov 2015 10:53:11 +0100
Received: by lffu14 with SMTP id u14so4973587lff.2
	for <linux-dvb@linuxtv.org>; Fri, 13 Nov 2015 01:53:10 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Nov 2015 11:53:09 +0200
Message-ID: <CAGYfdeiap4vNbo+yENZo5h-NwQcn952f=A4NfE9ySAofeiDmOQ@mail.gmail.com>
From: Mehmet Kurnaz <hmehmetkurnaz@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Delivery Status Notification (Failure)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0366044942=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0366044942==
Content-Type: multipart/alternative; boundary=001a11410ad2ed0cf40524690664

--001a11410ad2ed0cf40524690664
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

--001a11410ad2ed0cf40524690664
Content-Type: text/html; charset=UTF-8

<div dir="ltr"><div class="gmail_quote"><div dir="ltr"><div class="gmail_quote"><div><div>Hello all,<br>
<br>
I don&#39;t know that I am in right mailing-list and i am newbie about dvb<br>
receiver&#39;s drivers.<br>
<br>
I have DVBWorld DVB-S2 receiver with cy7c68013 and Montage M88RS6000 single<br>
chip. I searched linux driver but unfortunately couldn&#39;t find any one. I<br>
found M88RS6000 driver from dvbsky.<br>
And I used dvb-usb-dw2102.fw. Is it right choice?<br>
<br>
But I have to add some functions to dw2102.c source. One of them is i2c<br>
transfer function. I need &quot;request&quot; command in dw210x_op_rw() function for<br>
read and write operations to write i2c transfer function for this receiver.<br>
I asked to dvbworld but there is no response for a week. How can i write<br>
i2c transfer function?<br>
<br>
So thanks<span class="HOEnZb"><font color="#888888"><br>
Mehmet Kurnaz<br>
</font></span></div></div></div><br></div>
</div><br></div>

--001a11410ad2ed0cf40524690664--


--===============0366044942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0366044942==--
