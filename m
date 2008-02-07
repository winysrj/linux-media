Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from pop.iicinternet.com ([208.81.112.117])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <henry-list@leinhos.com>) id 1JNCNS-00082A-3J
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 20:25:42 +0100
Message-ID: <20080207173847.865.qmail@pop.iicinternet.com>
From: "Henry Leinhos" <henry-list@leinhos.com>
To: linux-dvb@linuxtv.org
Date: Thu, 07 Feb 2008 09:38:47 -0800
Mime-Version: 1.0
Subject: [linux-dvb] wintv-hvr-1250 setup?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, 

I recently acquired a Hauppauge wintv-hvr-1250 PCIe ATSC tuner card and have 
compiled/installed the latest v4l-dvb drivers ok. 

(BTW, I'm using an ABIT AN-M2HD motherboard with an AMD 4000+ cpu) 

I'm not sure which modules are required, but when I load the cx23885 module 
(via /sbin/modprobe cx23885), I get an error on the tveeprom header.  dmesg 
reports: 

CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 
[card=3,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 4-0050: Encountered bad packet header [ff]. Corrupt or not a 
Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0, mmio: 
0xfce00000
PCI: Setting latency timer of device 0000:03:00.0 to 64 


I'm concerned about the tveeprom message  -- are there any other modules I 
need to load for this board?  Is there any firmware I'm missing? 

Thanks,
Henry

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
