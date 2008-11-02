Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1Kwc7d-0005QP-Dv
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 13:32:04 +0100
Received: from pixle (pixle.cedo.cz [193.165.198.235])
	by postak.cedo.cz (Postfix) with SMTP id AA3AC225749
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 13:31:26 +0100 (CET)
Message-ID: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: <linux-dvb@linuxtv.org>
Date: Sun, 2 Nov 2008 13:32:58 +0100
MIME-Version: 1.0
Subject: [linux-dvb] Any DVB-C tuner with working CAM?
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

Hello,
I have bought and tested two DVB-C cards which are supported according to
http://www.linuxtv.org/wiki/index.php/DVB-C_PCI_Cards
Both are perfectly working with FTA but none with the CAM.

1. TechnoTrend Premium DVB-C 2300

DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
adapter has MAC addr = ....
dvb-ttpci: gpioirq unknown type=0 len=0
dvb-ttpci: info @ card 3: firm f0240009, rtsl b0250018, vid 71010068, app
80002622
dvb-ttpci: firmware @ card 3 supports CI link layer interface
dvb-ttpci: DVB-C analog module @ card 3 detected, initializing MSP3415
dvb_ttpci: saa7113 not accessible.
saa7146_vv: saa7146 (0): registered device video2 [v4l2]
saa7146_vv: saa7146 (0): registered device vbi2 [v4l2]
DVB: registering frontend 3 (ST STV0297 DVB-C)...

Applications detect the inserted CAM even if the CAM is not inserted ;-) but
even when it is, no scrambled channel is decrypted.

2. Technisat CableStar HD2

found a VP-2040 PCI DVB-C device on (01:02.0),
    Mantis Rev 1 [1ae4:0002], irq: 18, latency: 64
    memory: 0xefeff000, mmio: 0xffffc20000aee000
    MAC Address=[....]
mantis_alloc_buffers (0): DMA=0x7d820000 cpu=0xffff81007d820000 size=65536
mantis_alloc_buffers (0): RISC=0x7e50e000 cpu=0xffff81007e50e000 size=1000
DVB: registering new adapter (Mantis dvb adapter)

It says that an unsupported CAM is inserted. :-( Then I found in this
mailing list that the mantis CI-CAM support is not finalized yet. I
appreciate the work that Manu does with the mantis driver and I trust that
it will be supported in the comming months but I would expect that the Wiki
page mentioned above will have also the information about not yet supported
CI! :-(

So I have the CAM, two DVB-C cards but can't watch the channels I pay every
month... I spent many days with Google to find out a working solution with
these two or another card but unsuccessfully. Can somebody please advice me
a DVB-C card with CI which _is on market_ and does work with Technisat Conax
CAM?

Thanks in advance,
Tomas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
