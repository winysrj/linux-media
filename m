Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-4.orange.nl ([193.252.22.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1Kvxmc-0008Ef-2M
	for linux-dvb@linuxtv.org; Fri, 31 Oct 2008 18:27:40 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6307.online.nl (SMTP Server) with ESMTP id 63D207000088
	for <linux-dvb@linuxtv.org>; Fri, 31 Oct 2008 18:27:04 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6307.online.nl (SMTP Server) with ESMTP id BF7AC7000084
	for <linux-dvb@linuxtv.org>; Fri, 31 Oct 2008 18:26:59 +0100 (CET)
Message-ID: <490B3FDF.9020407@verbraak.org>
Date: Fri, 31 Oct 2008 18:26:55 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <412bdbff0810220607x588735f2v780104a5cafc3b8a@mail.gmail.com>	<48FF5C43.9090309@linuxtv.org>	<200810230300.43637.liplianin@tut.by>
	<490A18D5.3070500@verbraak.org>
In-Reply-To: <490A18D5.3070500@verbraak.org>
Subject: Re: [linux-dvb] stb0899 drivers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1020737535=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1020737535==
Content-Type: multipart/alternative;
 boundary="------------030804020209030105050300"

This is a multi-part message in MIME format.
--------------030804020209030105050300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michel Verbraak schreef:
> Igor M. Liplianin schreef:
>   
>> Hi Steven and Mauro
>>
>> As I understand, now we all waiting (again!) for Manu Abraham to commit?
>> Truly his code are huge and needs long time to clean up, but I made 
>> http://mercurial.intuxication.org/hg/s2-liplianin 
>> in order to help to convert it.
>> Right now I state the code is stable and works absolutely of no difference with multiproto 
>> version.
>> I mean it locks all channels, which multiproto version locks, but without any modifications to 
>> current DVB API.
>> What can I do now?
>>
>> Igor
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   
>>     
> Igor,
>
> I have tested your tree and can confirm the following. This is tested 
> with a Technisat HD2 (0x0003 version).
>
> Card is detected:
> Oct 29 20:05:55 recorder kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> 
> GSI 21 (level, low) -> IRQ 21
> Oct 29 20:05:55 recorder kernel: irq: 21, latency: 64
> Oct 29 20:05:55 recorder kernel:  memory: 0xf1bff000, mmio: 0xf89fe000
> Oct 29 20:05:55 recorder kernel: found a VP-1041 PCI DSS/DVB-S/DVB-S2 
> device on (02:09.0),
> Oct 29 20:05:55 recorder kernel:     Mantis Rev 1 [1ae4:0003], irq: 21, 
> latency: 64
> Oct 29 20:05:55 recorder kernel:     memory: 0xf1bff000, mmio: 0xf89fe000
> Oct 29 20:05:55 recorder kernel:     MAC Address=[00:08:c9:e0:3c:de]
> Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
> DMA=0x34b10000 cpu=0xf4b10000 size=65536
> Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
> RISC=0x36e95000 cpu=0xf6e95000 size=1000
> Oct 29 20:05:55 recorder kernel: DVB: registering new adapter (Mantis 
> dvb adapter)
> Oct 29 20:05:55 recorder kernel: stb0899_attach: Attaching STB0899
> Oct 29 20:05:55 recorder kernel: mantis_frontend_init (0): found STB0899 
> DVB-S/DVB-S2 frontend @0x68
> Oct 29 20:05:55 recorder kernel: stb6100_attach: Attaching STB6100
> Oct 29 20:05:55 recorder kernel: DVB: registering adapter 6 frontend 0 
> (STB0899 Multistandard)...
> Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registering EN50221 
> device
> Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registered EN50221 
> device
> Oct 29 20:05:55 recorder kernel: mantis_hif_init (0): Adapter(0) 
> Initializing Mantis Host Interface
>
> Scanning with scan-s2 works but not all channels are found. Tested on 
> Astra 28.2 (839 channels found) and Astra 19.2 (896 channels found). On 
> the 28.2 I'm missing BBC 1 to 4 for example and on Astra 19.2 the Dutch 
> channels. This is probably not a problem of scan-s2 but the driver.
>
> Zapping with szap-s2 works for the channels found by scan-s2. I get data 
> on vdr0 and it can be viewed by xine or mplayer. I can even get a lock 
> on "BBC London 1" with manual set settings, not found by scan-s2, but I 
> do not get any data on vdr0 device. This is logged in /var/log/messages
>
> Oct 30 21:21:25 recorder kernel: mantis start feed & dma
> Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:25 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:26 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:28 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:29 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
> Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:29 recorder kernel: stb6100_set_frequency: Frequency=1023000
> Oct 30 21:21:29 recorder kernel: stb6100_get_frequency: Frequency=1022994
> Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
> Oct 30 21:21:36 recorder kernel: mantis stop feed and dma
>
> I have a rotor connected and it can be controlled by the normal diseqc 
> commands. I have my own application which worked with the old api and it 
> does still work. So I'm able to rotate it.
>
> I can confirm that it partially works but the only problem for me is 
> that it does not find all the channels on the satellites.
>
> Regards,
>
> Michel.
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
I have to correct myself. The Diseqc rotor control, USALS, is not 
stable. After I rebooted the system it will not rotate my rotor anymore. 
Still testing.

Michel.

--------------030804020209030105050300
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Michel Verbraak schreef:
<blockquote cite="mid:490A18D5.3070500@verbraak.org" type="cite">
  <pre wrap="">Igor M. Liplianin schreef:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi Steven and Mauro

As I understand, now we all waiting (again!) for Manu Abraham to commit?
Truly his code are huge and needs long time to clean up, but I made 
<a class="moz-txt-link-freetext" href="http://mercurial.intuxication.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a> 
in order to help to convert it.
Right now I state the code is stable and works absolutely of no difference with multiproto 
version.
I mean it locks all channels, which multiproto version locks, but without any modifications to 
current DVB API.
What can I do now?

Igor

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  
    </pre>
  </blockquote>
  <pre wrap=""><!---->Igor,

I have tested your tree and can confirm the following. This is tested 
with a Technisat HD2 (0x0003 version).

Card is detected:
Oct 29 20:05:55 recorder kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -&gt; 
GSI 21 (level, low) -&gt; IRQ 21
Oct 29 20:05:55 recorder kernel: irq: 21, latency: 64
Oct 29 20:05:55 recorder kernel:  memory: 0xf1bff000, mmio: 0xf89fe000
Oct 29 20:05:55 recorder kernel: found a VP-1041 PCI DSS/DVB-S/DVB-S2 
device on (02:09.0),
Oct 29 20:05:55 recorder kernel:     Mantis Rev 1 [1ae4:0003], irq: 21, 
latency: 64
Oct 29 20:05:55 recorder kernel:     memory: 0xf1bff000, mmio: 0xf89fe000
Oct 29 20:05:55 recorder kernel:     MAC Address=[00:08:c9:e0:3c:de]
Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
DMA=0x34b10000 cpu=0xf4b10000 size=65536
Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
RISC=0x36e95000 cpu=0xf6e95000 size=1000
Oct 29 20:05:55 recorder kernel: DVB: registering new adapter (Mantis 
dvb adapter)
Oct 29 20:05:55 recorder kernel: stb0899_attach: Attaching STB0899
Oct 29 20:05:55 recorder kernel: mantis_frontend_init (0): found STB0899 
DVB-S/DVB-S2 frontend @0x68
Oct 29 20:05:55 recorder kernel: stb6100_attach: Attaching STB6100
Oct 29 20:05:55 recorder kernel: DVB: registering adapter 6 frontend 0 
(STB0899 Multistandard)...
Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registering EN50221 
device
Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registered EN50221 
device
Oct 29 20:05:55 recorder kernel: mantis_hif_init (0): Adapter(0) 
Initializing Mantis Host Interface

Scanning with scan-s2 works but not all channels are found. Tested on 
Astra 28.2 (839 channels found) and Astra 19.2 (896 channels found). On 
the 28.2 I'm missing BBC 1 to 4 for example and on Astra 19.2 the Dutch 
channels. This is probably not a problem of scan-s2 but the driver.

Zapping with szap-s2 works for the channels found by scan-s2. I get data 
on vdr0 and it can be viewed by xine or mplayer. I can even get a lock 
on "BBC London 1" with manual set settings, not found by scan-s2, but I 
do not get any data on vdr0 device. This is logged in /var/log/messages

Oct 30 21:21:25 recorder kernel: mantis start feed &amp; dma
Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:25 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:29 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:36 recorder kernel: mantis stop feed and dma

I have a rotor connected and it can be controlled by the normal diseqc 
commands. I have my own application which worked with the old api and it 
does still work. So I'm able to rotate it.

I can confirm that it partially works but the only problem for me is 
that it does not find all the channels on the satellites.

Regards,

Michel.


_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
I have to correct myself. The Diseqc rotor control, USALS, is not
stable. After I rebooted the system it will not rotate my rotor
anymore. Still testing.<br>
<br>
Michel.<br>
</body>
</html>

--------------030804020209030105050300--



--===============1020737535==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1020737535==--
