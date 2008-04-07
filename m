Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate03.web.de ([217.72.192.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Christoph.Honermann@web.de>) id 1JiwhW-0003Wi-1k
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 21:08:18 +0200
Message-ID: <47FA70C3.5040808@web.de>
Date: Mon, 07 Apr 2008 21:06:43 +0200
From: Christoph Honermann <Christoph.Honermann@web.de>
MIME-Version: 1.0
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
In-Reply-To: <47EC1668.5000608@t-online.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0109253544=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0109253544==
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Hi, Hartmund<br>
<br>
<br>
Hartmut Hackmann schrieb:
<blockquote cite="mid:47EC1668.5000608@t-online.de" type="cite">
  <pre wrap="">Hi, Christoph

Christoph Honermann schrieb:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi, Hartmund

I have tested the following archives with my MD8800 und the DVB-S Card.

v4l-dvb-912856e2a0ce.tar.bz2 --&gt; The DVB-S Input 1 works.
The module of the following archives are loaded with the option
"use_frontend=1,1" at the Shell or automatically:
    /etc/modprobe.d/saa7134-dvb   with the following line
   "options saa7134-dvb use_frontend=1,1"
v4l-dvb-1e295a94038e.tar.bz2;

    FATAL: Error inserting saa7134_dvb
    (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
    Unknown symbol in module, or unknown parameter (see dmesg)

    saa7134_dvb: disagrees about version of symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
    saa7134_dvb: Unknown symbol saa7134_set_gpio
    saa7134_dvb: disagrees about version of symbol saa7134_i2c_call_client
    saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
    saa7134_dvb: disagrees about version of symbol saa7134_ts_unregister
    saa7134_dvb: Unknown symbol saa7134_ts_unregister


v4l-dvb-f98d28c21389.tar.bz2  and v4l-dvb-a06ac2bdeb3c.tar.bz2 --&gt;

    FATAL: Error inserting saa7134_dvb
    (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
    Unknown symbol in module, or unknown parameter (see dmesg)

    dmesg | grep saa7134
    saa7134_dvb: Unknown symbol saa7134_tuner_callback
    saa7134_dvb: disagrees about version of symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
    saa7134_dvb: Unknown symbol saa7134_set_gpio

The Hardware ist working with Windows XP with both Input channels.

    </pre>
  </blockquote>
  <pre wrap=""><!---->This occurs when you mix modules of different driver versions. You need to
replace all modules of the v4l-dvb subsystem.
So after you compiled and installed with
  make; make install
you need to unload all modules of the subsystem either with
  make rmmod
or reboot.
Afterwards, you can unload and reload a single module as you tried to do.

Hartmut

  </pre>
</blockquote>
the second DVB-S Channel is working.<br>
But there is one thing that makes Problems.<br>
I have the effect that the devices /dev/dvb/adapter0/dvr0 and
/dev/dvb/adapter1/dvr0 are missed from kaffeine. Therefore it wont
work (no TV-picture, no sound, no channel scanning).<br>
If i look with Nautilus (file manager) therefore the whole Section
/dev/dvb is switching off.<br>
Can that be an effect of the module?<br>
The Problem is sometimes not there but i don't find the reason
(changing the Modules, reboots, ..). If I solve the Problem, should I
test the kombination between DVB-S and DVB-T?<br>
<br>
Best regards<br>
Christoph<br>
<br>
</body>
</html>


--===============0109253544==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0109253544==--
