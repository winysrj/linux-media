Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout3.freenet.de ([195.4.92.93])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1Kp2V4-0002wT-OB
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 17:04:58 +0200
Received: from [195.4.92.15] (helo=5.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port
	25) (Exim 4.69 #65) id 1Kp2V0-0004J2-Vz
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 17:04:50 +0200
Received: from 91-64-99-86-dynip.superkabel.de ([91.64.99.86]:62655
	helo=[192.168.2.112])
	by 5.mx.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port
	25) (Exim 4.69 #65) id 1Kp2V0-0006V7-MW
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 17:04:50 +0200
Message-ID: <48F21218.5010608@freenet.de>
Date: Sun, 12 Oct 2008 17:04:56 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20081011163649.GU15309@aketzu.net> <48F1CCE2.90104@gmx.de>
In-Reply-To: <48F1CCE2.90104@gmx.de>
Subject: Re: [linux-dvb] Mantis and CAM problems
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

Clemens Sutor schrieb:
> Anssi Kolehmainen schrieb:
>   
>> I have Terratec Cinergy C (dvb-c, 1822:4e35) card and when I try to use CAM I
>> just get TS continuity errors with vdr and cannot watch any channel. I'm using
>> latest driver from jusst.de/hg/mantis and it feels rather unstable at times
>> (previous versions crashed machine almost instantly with CAM...)
>>
>> I can access CAM menu in vdr but after a while it says CAM not responding. If I
>> do rmmod & modprobe mantis after that I get "dvb_ca adapter 0: Invalid PC card
>> inserted :(". Removing & reattaching CAM doesn't do any better, after modprobe
>> mantis everything freezes and caps+scroll lock blink on the keyboard.
>>
>> Linux 2.6.24i-1-686, Debian package
>> Oct 11 19:08:18 ampere kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 20
>> Oct 11 19:08:18 ampere kernel: irq: 20, latency: 32
>> Oct 11 19:08:18 ampere kernel:  memory: 0xdf000000, mmio: 0xf8a76000
>> Oct 11 19:08:18 ampere kernel: found a VP-2040 PCI DVB-C device on (02:09.0),
>> Oct 11 19:08:18 ampere kernel:     Mantis Rev 1 [153b:1178], irq: 20, latency: 32
>> Oct 11 19:08:18 ampere kernel:     memory: 0xdf000000, mmio: 0xf8a76000
>> Oct 11 19:08:18 ampere kernel:     MAC Address=[00:08:ca:1c:87:ea]
>> Oct 11 19:08:18 ampere kernel: mantis_alloc_buffers (0): DMA=0x36c70000 cpu=0xf6c70000 size=65536
>> Oct 11 19:08:18 ampere kernel: mantis_alloc_buffers (0): RISC=0x1582f000 cpu=0xd582f000 size=1000
>> Oct 11 19:08:18 ampere kernel: DVB: registering new adapter (Mantis dvb adapter)
>> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
>> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
>> Oct 11 19:08:18 ampere kernel: DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
>> Oct 11 19:08:18 ampere kernel: mantis_ca_init (0): Registering EN50221 device
>> Oct 11 19:08:18 ampere kernel: mantis_ca_init (0): Registered EN50221 device
>> Oct 11 19:08:18 ampere kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
>> Oct 11 19:08:22 ampere kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
>> Oct 11 19:08:27 ampere kernel: mantis start feed & dma
>> Oct 11 19:08:35 ampere kernel: mantis stop feed and dma
>>
>> start vdr
>> Oct 11 19:10:26 ampere vdr: [23112] CI adapter on device 0 thread started (pid=23108, tid=23112)
>> Oct 11 19:10:26 ampere vdr: [23112] CAM 1: module present
>> Oct 11 19:10:27 ampere vdr: [23108] device 1 provides: DVBC
>> Oct 11 19:10:30 ampere kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
>> Oct 11 19:10:30 ampere vdr: [23112] CAM 1: module ready
>> Oct 11 19:10:32 ampere vdr: [23112] CAM 1: Conax 4.00e, 01, 0B00, 04B1
>> Oct 11 19:10:36 ampere vdr: [23112] CAM 1: doesn't reply to QUERY - only a single channel can be decrypted
>> Oct 11 19:10:36 ampere vdr: [23108] switching to channel 1
>> Oct 11 19:10:36 ampere kernel: mantis start feed & dma
>> Oct 11 19:10:36 ampere vdr: [23121] transfer thread started (pid=23108, tid=23121)
>> Oct 11 19:10:36 ampere vdr: [23122] receiver on device 1 thread started (pid=23108, tid=23122)
>> Oct 11 19:10:36 ampere vdr: [23123] TS buffer on device 1 thread started (pid=23108, tid=23123)
>> Oct 11 19:10:36 ampere kernel: dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (5)
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (15)
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (1)
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (6)
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (9)
>> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (12)
>>
>> Something like ~150 TS continuity errors per sec. Video is pretty much garbage.
>> However if I remove CAM then everything works perfectly (except I can't watch
>> encrypted channels).
>>
>>   
>>     
> Hello Anssi,
>
> please see:
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028555.html
> and
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028851.html.
> and all following threads.
>
> The facts are still the same.
>
> Bye Clemens
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
It is not supported for the 2033, yet.

http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028857.html




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
