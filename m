Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1KyMQV-0005PE-QN
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 09:10:45 +0100
From: Markus Hahn <markus.o.hahn@gmx.de>
To: linux-dvb@linuxtv.org
Date: Fri, 7 Nov 2008 09:10:04 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811070910.05576.markus.o.hahn@gmx.de>
Subject: [linux-dvb]  TT  C-1501 budget : no device files
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


-- Hi there, 
I now, I  had this card already running, 
but since two month,  when I load the drivers the device files woun`t  be created 

System: kubuntu 8.04 Linux mars 2.6.24-21-38
drivers: both: multiproto  http://linuxtv.org/hg  or kernel driver. 

00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 101a
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 255
        Region 0: Memory at d9000000 (32-bit, non-prefetchable) [disabled] [size=512]


I load the (tt)budget  driver :


budget                 12804  0
budget_core            11396  1 budget
saa7146                19464  2 budget,budget_core
ttpci_eeprom            2560  1 budget_core
dvb_core               79612  3 budget,budget_core,videobuf_dvb
i2c_core               23696  10 budget,budget_core,ttpci_eeprom,dvb_pll,tveeprom,i2c_viapro,i2c_algo_bit

No erros but also no dvb/frontendx device files

The second dvb-card Terratec DVB-T 1400 runns perfectly. (with device files of course )




regards markus 




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
