Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from proxy1.bredband.net ([195.54.101.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jocke@jockeb.no-ip.org>) id 1JxRoy-0004xP-Qp
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 21:11:58 +0200
Received: from ironport2.bredband.com (195.54.101.122) by proxy1.bredband.net
	(7.3.127) id 4811823A00707F57 for linux-dvb@linuxtv.org;
	Sat, 17 May 2008 21:11:51 +0200
Message-ID: <20080517211153.oupzei4a4gwsoko8@192.168.1.1>
Date: Sat, 17 May 2008 21:11:53 +0200
From: Joakim Berglund <jocke@jockeb.no-ip.org>
To: linux-dvb@linuxtv.org
References: <85e6aeba0805092320ja192c12hd756b5efb3725463@mail.gmail.com>
	<48255AFC.3010508@gmail.com>
	<85e6aeba0805100639u35b26874m2ac78d446c40dd47@mail.gmail.com>
	<200805121447.18180.boexli@gmx.net>
	<85e6aeba0805120555y338844c5qd8e790d689df9d49@mail.gmail.com>
In-Reply-To: <85e6aeba0805120555y338844c5qd8e790d689df9d49@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: Re: [linux-dvb] TerraTec Cinergy C
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

Citerar Tommy Alander <tommy.alander@gmail.com>:

> On Mon, May 12, 2008 at 2:47 PM, nick <boexli@gmx.net> wrote:
>> On Saturday 10 May 2008 15:39:29 Tommy Alander wrote:
>>
>> Check this out
>>
>> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
>>
>> Let us know if this works
>
> I tried the latest version of the mantis
> driver(http://jusst.de/hg/mantis) and that one works.
> (I also updated the wiki with that information)
>


I gotta be missing something...
Either I got wrong manufacturer of the CAM or the CA part isn't done yet..
(yes it works under windows)

Help?

[ 1593.696531] found a VP-2040 PCI DVB-C device on (01:09.0),
[ 1593.696533]     Mantis Rev 1 [153b:1178], irq: 17, latency: 64
[ 1593.696536]     memory: 0xfd0ff000, mmio: 0xffffc20000602000
[ 1593.697966]     MAC Address=3D[00:08:ca:1c:72:73]
[ 1593.697991] mantis_alloc_buffers (0): DMA=3D0x8480000 =20
cpu=3D0xffff810008480000 size=3D65536
[ 1593.698009] mantis_alloc_buffers (0): RISC=3D0xc026000 =20
cpu=3D0xffff81000c026000 size=3D1000
[ 1593.698250] DVB: registering new adapter (Mantis dvb adapter)
[ 1593.907441] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[ 1593.908297] mantis_frontend_init (0): found Philips CU1216 DVB-C =20
frontend (TDA10023) @ 0x0c
[ 1593.908312] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 =20
frontend attach success
[ 1593.908327] DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
[ 1593.908362] mantis_ca_init (0): Registering EN50221 device
[ 1593.908371] dvb_ca_en50221_init
[ 1593.908503] mantis_ca_init (0): Registered EN50221 device
[ 1593.908514] mantis_hif_init (0): Adapter(0) Initializing Mantis =20
Host Interface
[ 1593.909626] dvb_ca_en50221_thread
[ 1594.789292] TUPLE type:0x53 length:8
[ 1595.188698]   0x00: 0x34 4
[ 1595.588104]   0x01: 0x8b .
[ 1595.987512]   0x02: 0x53 S
[ 1596.386917]   0x03: 0x08 .
[ 1596.786325]   0x04: 0x34 4
[ 1597.185730]   0x05: 0x8b .
[ 1597.585137]   0x06: 0x53 S
[ 1597.984543]   0x07: 0x08 .
[ 1597.984546] dvb_ca adapter 0: Invalid PC card inserted :(


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
