Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from waladir.klfree.cz ([81.201.51.58] helo=culibrk.hrbkovi.eu)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ludek@hrbkovi.eu>) id 1LMgft-00011A-F5
	for linux-dvb@linuxtv.org; Tue, 13 Jan 2009 11:39:10 +0100
Message-ID: <496C6F77.8070405@hrbkovi.eu>
Date: Tue, 13 Jan 2009 11:39:51 +0100
From: Ludek <ludek@hrbkovi.eu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TechniSat CableStar HD2 & CAM
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

Hi,

I've problem with TechniCrypt CAM inserted on my TechniSat CableStar HD2 
  (DVB-C card) with current mantis driver. I'm able to watch FTA 
channels only :-(  As I read this list I'm afraid that CAM modules with 
this card is not supported yet. Does anyone get this card with CAM working?

[ 4197.469043] Mantis 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[ 4197.469078] irq: 20, latency: 32
[ 4197.469079]  memory: 0xec100000, mmio: 0xffffc20004950000
[ 4197.469082] found a VP-2040 PCI DVB-C device on (05:00.0),
[ 4197.469084]     Mantis Rev 1 [1ae4:0002], irq: 20, latency: 32
[ 4197.469087]     memory: 0xec100000, mmio: 0xffffc20004950000
[ 4197.471385]         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
[ 4197.471982]         mantis_i2c_read:  Address=[0x50] <R>[ 00 08 c9 d0 
1f 2c ]
[ 4197.474091]     MAC Address=[00:08:c9:d0:1f:2c]
[ 4197.474119] mantis_alloc_buffers (0): DMA=0x541a0000 
cpu=0xffff8800541a0000 size=65536
[ 4197.474190] mantis_alloc_buffers (0): RISC=0x34c0a000 
cpu=0xffff880034c0a000 size=1000
[ 4197.474256] DVB: registering new adapter (Mantis dvb adapter)
[ 4197.992116] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[ 4197.992176]         mantis_i2c_write: Address=[0x50] <W>[ ff ]
[ 4197.992528]         mantis_i2c_read:  Address=[0x50] <R>[ e4 ]
[ 4197.992956]         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
[ 4197.993308]         mantis_i2c_read:  Address=[0x0c] <R>[ 7d ]
[ 4197.993727]         mantis_i2c_write: Address=[0x50] <W>[ ff ]
[ 4197.994078]         mantis_i2c_read:  Address=[0x50] <R>[ e4 ]
[ 4197.994465]         mantis_i2c_write: Address=[0x0c] <W>[ 00 33 ]
[ 4197.995226]         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
[ 4197.995577]         mantis_i2c_read:  Address=[0x0c] <R>[ 7d ]
[ 4197.995928] TDA10023: i2c-addr = 0x0c, id = 0x7d
[ 4197.995931] mantis_frontend_init (0): found Philips CU1216 DVB-C 
frontend (TDA10023) @ 0x0c
[ 4197.995993] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 
frontend attach success
[ 4197.996117] DVB: registering adapter 0 frontend 0 (Philips TDA10023 
DVB-C)...
[ 4197.996234] mantis_ca_init (0): Registering EN50221 device
[ 4197.996289] dvb_ca_en50221_init
[ 4197.996374] mantis_ca_init (0): Registered EN50221 device
[ 4197.996430] CAMCHANGE IRQ slot:0 change_type:1
[ 4197.996431] dvb_ca_en50221_thread_wakeup
[ 4197.996437] mantis_hif_init (0): Adapter(0) Initializing Mantis Host 
Interface
[ 4197.996674] dvb_ca_en50221_thread
[ 4199.000019] CAMREADY IRQ slot:0
[ 4199.000034] dvb_ca_en50221_thread_wakeup
[ 4199.000350] TUPLE type:0x0 length:0
[ 4199.000355] dvb_ca adapter 0: Invalid PC card inserted :(

Regards,

Ludek

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
