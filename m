Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web62002.mail.re1.yahoo.com ([69.147.74.225])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mpapet@yahoo.com>) id 1KMe2J-0002YV-V7
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 09:17:53 +0200
Date: Sat, 26 Jul 2008 00:17:16 -0700 (PDT)
From: Michael Papet <mpapet@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <859260.93316.qm@web62002.mail.re1.yahoo.com>
Subject: [linux-dvb] cx18/hvr-1600 Issues and Updates
Reply-To: mpapet@yahoo.com
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

I have a new Hauppauge hvr-1600 with issues.  I'm using the download URL at the top of the page  http://www.linuxtv.org/hg/v4l-dvb on Debian Etch with a 2.6.25 kernel package from Debian's fine backports repo.  Make and make install went fine. modinfo reports driver version 1.0.

Upon reboot, I got the invalid EEPROM error and knew a dirty trick that worked.  I blacklist cx18, then reload it using a modprobe stanza in rc.local. Another reboot for good measure and both /dev/video0 and /dev/dvb/xxyyzz are created, no errors in dmesg.  The dmesg data is below.

The NTSC tuner driver is non-functioning.  It scans and finds channels in mythtv.  Attempting to watch NTSC tv shows only a black screen. I have debugging set at 3 at the moment, but no errors are generated.  Please let me know what information you need to identify the issue. 

Michael

##### dmesg ##########
120.016694] Linux video capture interface: v2.00                                                  
[  120.055132] cx18:  Start initialization, version 1.0.0                                            
[  120.055203] cx18-0: Initializing card #0                                                          
[  120.055207] cx18-0: Autodetected Hauppauge card                                                   
[  120.055212] cx18-0 info: base addr: 0xe4000000                                                    
[  120.055214] cx18-0 info: Enabling pci device                                                      
[  120.055236] ACPI: PCI Interrupt 0000:05:09.0[A] -> GSI 18 (level, low) -> IRQ 18                  
[  120.055252] cx18-0 info: cx23418 (rev 0) at 05:09.0, irq: 18, latency: 66, memory: 0xe4000000     
[  120.055256] cx18-0 info: attempting ioremap at 0xe4000000 len 0x04000000                          
[  120.056491] cx18-0: cx23418 revision 01010000 (B)                                                 
[  120.134303] cx18-0 info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000               
[  120.134303] cx18-0 info: activating i2c...                                                        
[  120.225060] cx18-0 info: Active card count: 1.                                                    
[  120.264977] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795                     
[  120.264982] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                                     
[  120.264986] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)                     
[  120.264989] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)                                   
[  120.264993] tveeprom 2-0050: audio processor is CX23418 (idx 38)                                  
[  120.264996] tveeprom 2-0050: decoder processor is CX23418 (idx 31)                                
[  120.264999] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter                    
[  120.265002] cx18-0: Autodetected Hauppauge HVR-1600                                               
[  120.265005] cx18-0 info: NTSC tuner detected                                                      
[  120.265007] cx18-0: VBI is not yet supported                                                      
[  120.359118] cx18-0 info: Loaded module tuner                                                      
[  120.380496] cx18-0 info: Loaded module cs5345                                                     
[  120.380496] tuner 3-0061: Setting mode_mask to 0x0e                                               
[  120.380496] tuner 3-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)                                
[  120.380496] tuner 3-0061: tuner 0x61: Tuner type absent                                           
[  120.380496] cs5345 2-004c: chip found @ 0x98 (cx18 i2c driver #0-0)                               
[  120.381758] tuner 3-0061: Calling set_type_addr for type=50, addr=0xff, mode=0x04, config=0x32    
[  120.447481] tuner-simple 3-0061: creating new instance                                            
[  120.447491] tuner-simple 3-0061: type set to 50 (TCL 2002N)                                       
[  120.447496] tuner 3-0061: type set to TCL 2002N                                                   
[  120.447499] tuner 3-0061: tv freq set to 400.00                                                   
[  120.448356] tuner 3-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 50 used for 0x0e     
[  120.448371] cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB total)          
[  120.448454] cx18-0 info: Allocate TS stream: 32 x 32768 buffers (1024kB total)                    
[  120.448501] cx18-0 info: Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
[  120.448534] cx18-0 info: Allocate encoder PCM audio stream: 63 x 16384 buffers (1008kB total)
[  120.448595] cx18-0: Disabled encoder IDX device
[  120.448643] cx18-0: Registered device video0 for encoder MPEG (2 MB)
[  120.448648] DVB: registering new adapter (cx18)
[  120.600362] MXL5005S: Attached at address 0x63
[  120.600379] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[  120.600459] cx18-0: DVB Frontend registered
[  120.600489] cx18-0: Registered device video32 for encoder YUV (2 MB)
[  120.600515] cx18-0: Registered device video24 for encoder PCM audio (1 MB)
[  120.600519] cx18-0: Initialized card #0: Hauppauge HVR-1600
[  120.600544] cx18:  End initialization





      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
