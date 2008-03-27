Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout10.sul.t-online.de ([194.25.134.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JezyV-0002Ah-Ot
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 22:49:32 +0100
Message-ID: <47EC1668.5000608@t-online.de>
Date: Thu, 27 Mar 2008 22:49:28 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Christoph Honermann <Christoph.Honermann@web.de>
References: <1206652564.6924.22.camel@ubuntu>
In-Reply-To: <1206652564.6924.22.camel@ubuntu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, Christoph

Christoph Honermann schrieb:
> Hi, Hartmund
> 
> I have tested the following archives with my MD8800 und the DVB-S Card.
> 
> v4l-dvb-912856e2a0ce.tar.bz2 --> The DVB-S Input 1 works.
> The module of the following archives are loaded with the option
> "use_frontend=1,1" at the Shell or automatically:
>     /etc/modprobe.d/saa7134-dvb   with the following line
>    "options saa7134-dvb use_frontend=1,1"
> v4l-dvb-1e295a94038e.tar.bz2;
> 
>     FATAL: Error inserting saa7134_dvb
>     (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
>     Unknown symbol in module, or unknown parameter (see dmesg)
> 
>     saa7134_dvb: disagrees about version of symbol saa7134_ts_register
>     saa7134_dvb: Unknown symbol saa7134_ts_register
>     saa7134_dvb: Unknown symbol videobuf_queue_sg_init
>     saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
>     saa7134_dvb: Unknown symbol saa7134_set_gpio
>     saa7134_dvb: disagrees about version of symbol saa7134_i2c_call_client
>     saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
>     saa7134_dvb: disagrees about version of symbol saa7134_ts_unregister
>     saa7134_dvb: Unknown symbol saa7134_ts_unregister
> 
> 
> v4l-dvb-f98d28c21389.tar.bz2  and v4l-dvb-a06ac2bdeb3c.tar.bz2 -->
> 
>     FATAL: Error inserting saa7134_dvb
>     (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
>     Unknown symbol in module, or unknown parameter (see dmesg)
> 
>     dmesg | grep saa7134
>     saa7134_dvb: Unknown symbol saa7134_tuner_callback
>     saa7134_dvb: disagrees about version of symbol saa7134_ts_register
>     saa7134_dvb: Unknown symbol saa7134_ts_register
>     saa7134_dvb: Unknown symbol videobuf_queue_sg_init
>     saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
>     saa7134_dvb: Unknown symbol saa7134_set_gpio
> 
> The Hardware ist working with Windows XP with both Input channels.
> 
This occurs when you mix modules of different driver versions. You need to
replace all modules of the v4l-dvb subsystem.
So after you compiled and installed with
  make; make install
you need to unload all modules of the subsystem either with
  make rmmod
or reboot.
Afterwards, you can unload and reload a single module as you tried to do.

Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
