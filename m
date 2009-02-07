Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout1.freenet.de ([195.4.92.91])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1LVvHj-00033B-6e
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 23:04:24 +0100
Message-ID: <498E051B.2010105@freenet.de>
Date: Sat, 07 Feb 2009 23:03:07 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <4984E294.6020401@gmail.com> <498B7945.4060200@gmail.com>
	<498DEDA9.7010905@freenet.de> <498E00F2.5050202@gmail.com>
In-Reply-To: <498E00F2.5050202@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] 2033 not working with changeset 9143
Reply-To: linux-media@vger.kernel.org
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

Manu Abraham schrieb:
> Ruediger Dohmhardt wrote:
>   
>> Manu Abraham schrieb:
>>     
>>> Have added initial support for this card, as well as a large
>>> overhaul of the driver for a couple of performance impacts.
>>>
>>> Please do test with the latest updates from http://jusst.de/hg/mantis.
>>>   
>>>       
>> Hi Manu
>> the versions from January and February 2009 compile fine on the
>> SUSE-11.1 kernel 2.6.27.7-9-default x86_64.
>> The modules for my Twinhan AD-CP300 (2033) load fine, too.
>>
>> However, the devices below /dev/dvb are NOT created, and hence vdr-1.7
>> does not work.
>> The card works with the s2-liplianin driver.
>>
>> I assume it is interrupt related as listed in the lines from
>> /var/log/messages
>>
>>
>> Feb  7 21:03:38 mt40 su: (to root) rudi on /dev/pts/1
>> Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
>> Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A -> GSI 21
>> (level, low) -> IRQ 21
>> Feb  7 21:03:48 mt40 kernel: DVB: registering new adapter (Mantis DVB
>> adapter)
>> Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
>> Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A disabled
>> Feb  7 21:03:48 mt40 kernel: Mantis: probe of 0000:02:01.0 failed with
>> error -1
>> Feb  7 21:05:03 mt40 vdr: [4320] cTimeMs: using monotonic clock
>> (resolution is 1 ns)
>> Feb  7 21:05:03 mt40 vdr: [4320] VDR version 1.7.0 started
>> Feb  7 21:05:03 mt40 vdr: [4320] codeset is 'UTF-8' - known
>> Feb  7 21:05:03 mt40 vdr: [4320] ERROR: ./locale: Datei oder Verzeichnis
>> nicht gefunden
>> Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'deu,ger'
>> Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'slv,slo'
>> Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'ita'
>> Feb  7 21:05:05 mt40 vdr: [4320] no DVB device found
>>
>> I wonder whether I can check something more to get your driver back to work
>>     
>
> Can you please load the mantis module with the verbose=5 module
> parameter and try again ? At least it will show what's failing.
>
> Regards,
> Manu
>
>   
Yupp,

here is /var/log/messages with the line "options mantis verbose=5" in
/etc/modprobe.conf.local

Feb  7 22:56:41 mt40 kernel: found a VP-2033 PCI DVB-C device on (02:01.0),
Feb  7 22:56:41 mt40 kernel: vendor=1002 device=4371
Feb  7 22:56:41 mt40 kernel: Mantis 0000:02:01.0: PCI INT A -> GSI 21
(level, low) -> IRQ 21
Feb  7 22:56:41 mt40 kernel:     Mantis Rev 1 [1822:0008], irq: 21,
latency: 64
Feb  7 22:56:41 mt40 kernel:     memory: 0x0, mmio: 0xffffc20000366000
Feb  7 22:56:41 mt40 kernel: mantis_stream_control (0): Set stream to HIF
Feb  7 22:56:41 mt40 kernel: mantis_i2c_init (0): Initializing I2C ..
Feb  7 22:56:41 mt40 kernel: mantis_i2c_init (0): Disabling I2C interrupt
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb  7 22:56:41 mt40 kernel:         mantis_i2c_write: Address=[0x50]
<W>[ 08 ]
Feb  7 22:56:41 mt40 kernel:         mantis_i2c_read:  Address=[0x50]
<R>[ 00 08 ca 19 e9 b6 ]
Feb  7 22:56:41 mt40 kernel:     MAC Address=[00:08:ca:19:e9:b6]
Feb  7 22:56:41 mt40 kernel: mantis_dma_init (0): Mantis DMA init
Feb  7 22:56:41 mt40 kernel: mantis_alloc_buffers (0): DMA=0x60df0000
cpu=0xffff880060df0000 size=65536
Feb  7 22:56:41 mt40 kernel: mantis_alloc_buffers (0): RISC=0x60dba000
cpu=0xffff880060dba000 size=1000
Feb  7 22:56:41 mt40 kernel: mantis_calc_lines (0): Mantis RISC block
bytes=[4096], line bytes=[2048], line count=[32]
Feb  7 22:56:41 mt40 kernel: mantis_dvb_init (0): dvb_register_adapter
Feb  7 22:56:41 mt40 kernel: DVB: registering new adapter (Mantis DVB
adapter)
Feb  7 22:56:41 mt40 kernel: mantis_dvb_init (0): dvb_dmx_init
Feb  7 22:56:41 mt40 kernel: mantis_dvb_init (0): dvb_dmxdev_init
Feb  7 22:56:41 mt40 kernel: vp2033_frontend_init (0): Probing for
CU1216 (DVB-C)
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb  7 22:56:41 mt40 kernel:         Byte MODE:
Feb  7 22:56:41 mt40 kernel:         Byte <0> RXD=0xa1ff2280  [22]
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb  7 22:56:41 mt40 kernel:         Byte MODE:
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0):         I/O error,
LINE:155
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb  7 22:56:41 mt40 kernel:         Byte MODE:
Feb  7 22:56:41 mt40 kernel:         Byte <0> RXD=0xa1ff2280  [22]
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb  7 22:56:41 mt40 kernel:         mantis_i2c_write: Address=[0x0c]
<W>[ 00 33 ]
Feb  7 22:56:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb  7 22:56:42 mt40 kernel:         Byte MODE:
Feb  7 22:56:42 mt40 kernel: mantis_i2c_xfer (0):         I/O error,
LINE:155
Feb  7 22:56:42 mt40 kernel: mantis_dvb_init (0): !!! NO Frontends found !!!
Feb  7 22:56:42 mt40 kernel: mantis_pci_probe (0): ERROR: Mantis DVB
initialization failed <-1>
Feb  7 22:56:42 mt40 kernel: mantis_pci_probe (0): ERROR: Mantis DMA
exit! <-1>
Feb  7 22:56:42 mt40 kernel: mantis_dma_exit (0): DMA=0x60df0000
cpu=0xffff880060df0000 size=65536
Feb  7 22:56:42 mt40 kernel: mantis_dma_exit (0): RISC=0x60dba000
cpu=0xffff880060dba000 size=1000
Feb  7 22:56:42 mt40 kernel: mantis_pci_probe (0): ERROR: Mantis I2C
exit! <-1>
Feb  7 22:56:42 mt40 kernel: mantis_i2c_exit (0): Disabling I2C interrupt
Feb  7 22:56:42 mt40 kernel: mantis_i2c_exit (0): Removing I2C adapter
Feb  7 22:56:42 mt40 kernel: mantis_pci_probe (0): ERROR: Mantis PCI
exit! <-1>
Feb  7 22:56:42 mt40 kernel: mantis_pci_exit (0):  mem: 0xffffc20000366000
Feb  7 22:56:42 mt40 kernel: vendor=1002 device=4371
Feb  7 22:56:42 mt40 kernel: Mantis 0000:02:01.0: PCI INT A disabled
Feb  7 22:56:42 mt40 kernel: mantis_pci_probe (0): ERROR: Mantis free! <-1>
Feb  7 22:56:42 mt40 kernel: Mantis: probe of 0000:02:01.0 failed with
error -1




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
