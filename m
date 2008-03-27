Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Christoph.Honermann@web.de>) id 1JezSq-000724-RI
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 22:16:49 +0100
From: Christoph Honermann <Christoph.Honermann@web.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Date: Thu, 27 Mar 2008 22:16:04 +0100
Message-Id: <1206652564.6924.22.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1346577944=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1346577944==
Content-Type: multipart/alternative; boundary="=-5MFp0RVjHaBoChhmFwfp"


--=-5MFp0RVjHaBoChhmFwfp
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, Hartmund

I have tested the following archives with my MD8800 und the DVB-S Card.

v4l-dvb-912856e2a0ce.tar.bz2 --> The DVB-S Input 1 works.
The module of the following archives are loaded with the option
"use_frontend=1,1" at the Shell or automatically:
    /etc/modprobe.d/saa7134-dvb   with the following line
   "options saa7134-dvb use_frontend=1,1"
v4l-dvb-1e295a94038e.tar.bz2; 

        FATAL: Error inserting saa7134_dvb
        (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
        
        saa7134_dvb: disagrees about version of symbol
        saa7134_ts_register
        saa7134_dvb: Unknown symbol saa7134_ts_register
        saa7134_dvb: Unknown symbol videobuf_queue_sg_init
        saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
        saa7134_dvb: Unknown symbol saa7134_set_gpio
        saa7134_dvb: disagrees about version of symbol
        saa7134_i2c_call_client
        saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
        saa7134_dvb: disagrees about version of symbol
        saa7134_ts_unregister
        saa7134_dvb: Unknown symbol saa7134_ts_unregister


v4l-dvb-f98d28c21389.tar.bz2  and v4l-dvb-a06ac2bdeb3c.tar.bz2 -->

        FATAL: Error inserting saa7134_dvb
        (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
        
        dmesg | grep saa7134 
        saa7134_dvb: Unknown symbol saa7134_tuner_callback
        saa7134_dvb: disagrees about version of symbol
        saa7134_ts_register
        saa7134_dvb: Unknown symbol saa7134_ts_register
        saa7134_dvb: Unknown symbol videobuf_queue_sg_init
        saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
        saa7134_dvb: Unknown symbol saa7134_set_gpio

The Hardware ist working with Windows XP with both Input channels.


best regards
Christoph


--=-5MFp0RVjHaBoChhmFwfp
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.16.1">
</HEAD>
<BODY>
Hi, Hartmund<BR>
<BR>
I have tested the following archives with my MD8800 und the DVB-S Card.<BR>
<BR>
v4l-dvb-912856e2a0ce.tar.bz2 --&gt; The DVB-S Input 1 works.<BR>
The module of the following archives are loaded with the option &quot;use_frontend=1,1&quot; at the Shell or automatically:<BR>
&nbsp;&nbsp;&nbsp; /etc/modprobe.d/saa7134-dvb&nbsp;&nbsp; with the following line<BR>
&nbsp;&nbsp; &quot;options saa7134-dvb use_frontend=1,1&quot;<BR>
v4l-dvb-1e295a94038e.tar.bz2; <BR>
<BLOCKQUOTE>
    FATAL: Error inserting saa7134_dvb (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko): Unknown symbol in module, or unknown parameter (see dmesg)<BR>
    <BR>
    saa7134_dvb: disagrees about version of symbol saa7134_ts_register<BR>
    saa7134_dvb: Unknown symbol saa7134_ts_register<BR>
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init<BR>
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio<BR>
    saa7134_dvb: Unknown symbol saa7134_set_gpio<BR>
    saa7134_dvb: disagrees about version of symbol saa7134_i2c_call_client<BR>
    saa7134_dvb: Unknown symbol saa7134_i2c_call_clients<BR>
    saa7134_dvb: disagrees about version of symbol saa7134_ts_unregister<BR>
    saa7134_dvb: Unknown symbol saa7134_ts_unregister<BR>
</BLOCKQUOTE>
<BR>
v4l-dvb-f98d28c21389.tar.bz2&nbsp; and v4l-dvb-a06ac2bdeb3c.tar.bz2 --&gt;<BR>
<BLOCKQUOTE>
    FATAL: Error inserting saa7134_dvb (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko): Unknown symbol in module, or unknown parameter (see dmesg)<BR>
    <BR>
    dmesg | grep saa7134 <BR>
    saa7134_dvb: Unknown symbol saa7134_tuner_callback<BR>
    saa7134_dvb: disagrees about version of symbol saa7134_ts_register<BR>
    saa7134_dvb: Unknown symbol saa7134_ts_register<BR>
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init<BR>
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio<BR>
    saa7134_dvb: Unknown symbol saa7134_set_gpio<BR>
</BLOCKQUOTE>
The Hardware ist working with Windows XP with both Input channels.<BR>
<BR>
<BR>
best regards<BR>
Christoph<BR>
<TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
<BR>
</TD>
</TR>
</TABLE>
</BODY>
</HTML>

--=-5MFp0RVjHaBoChhmFwfp--



--===============1346577944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1346577944==--
