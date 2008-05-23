Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from proxy3.bredband.net ([195.54.101.73])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jocke@jockeb.no-ip.org>) id 1JzcwA-0007oH-1I
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 21:28:22 +0200
Received: from ironport2.bredband.com (195.54.101.122) by proxy3.bredband.net
	(7.3.127) id 481183EA008B51BA for linux-dvb@linuxtv.org;
	Fri, 23 May 2008 21:28:17 +0200
Message-ID: <20080523212816.e3l3sl8pccg08ogc@192.168.1.1>
Date: Fri, 23 May 2008 21:28:16 +0200
From: Joakim Berglund <jocke@jockeb.no-ip.org>
To: linux-dvb@linuxtv.org
References: <482EB3E5.7090607@freenet.de> <482F49BB.4060300@gmail.com>
	<48327AEF.1060809@freenet.de> <48371567.8080304@gmail.com>
In-Reply-To: <48371567.8080304@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
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

Citerar Manu Abraham <abraham.manu@gmail.com>:

> Ruediger Dohmhardt wrote:
>> Manu Abraham schrieb:
>>> Ruediger Dohmhardt wrote:
>>>
...
>> changeset 7325b14e79e460fc (Monday evening):
>> Unencrypted channels: ok:
>> When I zap to an encrypted one, the drive hangs as shown below.
>> Then I need to reboot the machine, because
>>      modprobe -r mantis
>>
>> could not really unload the module.
>
>
> Can you please test again ?
>

Exactly the same problem on an 2040.
Checked before and after todays patch.

-----------------------------

[ 1320.629931] found a VP-2040 PCI DVB-C device on (01:09.0),
[ 1320.629932]     Mantis Rev 1 [153b:1178], irq: 17, latency: 64
[ 1320.629935]     memory: 0xfd0ff000, mmio: 0xffffc200006ba000
[ 1320.630623]         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
[ 1320.630857]         mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca  
1c 72 73 ]
[ 1320.631702]     MAC Address=[00:08:ca:1c:72:73]
[ 1320.631731] mantis_alloc_buffers (0): DMA=0x1a20000  
cpu=0xffff810001a20000 size=65536
[ 1320.631737] mantis_alloc_buffers (0): RISC=0x2c8a0000  
cpu=0xffff81002c8a0000 size=1000
[ 1320.632651] DVB: registering new adapter (Mantis dvb adapter)
[ 1320.840918] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[ 1320.840925]         mantis_i2c_write: Address=[0x50] <W>[ ff ]
[ 1320.841068]         mantis_i2c_read:  Address=[0x50] <R>[ 3b ]
[ 1320.841212]         mantis_i2c_write: Address=[0x0c] <W>[ 00 33 ]
[ 1320.841495]         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
[ 1320.841637]         mantis_i2c_read:  Address=[0x0c] <R>[ 7d ]
[ 1320.841779] mantis_frontend_init (0): found Philips CU1216 DVB-C  
frontend (TDA10023) @ 0x0c
[ 1320.841782] mantis_frontend_init (0): Mantis DVB-C Philips CU1216  
frontend attach success
[ 1320.841786] DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
[ 1320.841830] mantis_ca_init (0): Registering EN50221 device
[ 1320.842645] mantis_ca_init (0): Registered EN50221 device
[ 1320.842654] mantis_hif_init (0): Adapter(0) Initializing Mantis  
Host Interface
[ 1323.448980] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 1344.901122]         mantis_i2c_write: Address=[0x0c] <W>[ 2a  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1347.303023] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x2a, val == 0x02, ret == -121)
[ 1347.344417]         mantis_i2c_write: Address=[0x0c] <W>[ 2a  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1349.745797] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x2a, val == 0x03, ret == -121)
[ 1349.787189]         mantis_i2c_write: Address=[0x0c] <W>[ 28  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1352.188567] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x28, val == 0x07, ret == -121)
[ 1352.188572]         mantis_i2c_write: Address=[0x0c] <W>[ 29  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1354.589796] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x29, val == 0xc0, ret == -121)
[ 1354.589800]         mantis_i2c_write: Address=[0x0c] <W>[ 00  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1356.991028] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x00, val == 0x23, ret == -121)
[ 1356.991032]         mantis_i2c_write: Address=[0x0c] <W>[ 2a  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1359.392261] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x2a, val == 0x08, ret == -121)
[ 1359.433657]         mantis_i2c_write: Address=[0x0c] <W>[ 1f  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1361.835031] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0x1f, val == 0x00, ret == -121)
[ 1361.876428]         mantis_i2c_write: Address=[0x0c] <W>[ e6  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1364.277802] DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
[ 1364.277806]         mantis_i2c_write: Address=[0x0c] <W>[ e6  
<3>mantis_ack_wait (0): Slave RACK Fail !
[ 1366.679040] DVB: TDA10023(0): tda10023_writereg, writereg error  
(reg == 0xe6, val == 0x04, ret == -121)
[ 1366.679044]         mantis_i2c_write: Address=[0x0c] <W>[ 10


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
