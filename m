Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KMlaS-0000Sr-V1
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 17:21:39 +0200
From: Andy Walls <awalls@radix.net>
To: mpapet@yahoo.com
In-Reply-To: <859260.93316.qm@web62002.mail.re1.yahoo.com>
References: <859260.93316.qm@web62002.mail.re1.yahoo.com>
Date: Sat, 26 Jul 2008 10:47:45 -0400
Message-Id: <1217083665.2818.36.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18/hvr-1600 Issues and Updates
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

On Sat, 2008-07-26 at 00:17 -0700, Michael Papet wrote:
> Hi,
> 
> I have a new Hauppauge hvr-1600 with issues.  I'm using the download
> URL at the top of the page  http://www.linuxtv.org/hg/v4l-dvb on
> Debian Etch with a 2.6.25 kernel package from Debian's fine backports
> repo.  Make and make install went fine. modinfo reports driver version
> 1.0.
> 
> Upon reboot, I got the invalid EEPROM error and knew a dirty trick
> that worked.  I blacklist cx18, then reload it using a modprobe stanza
> in rc.local.

I'll have to remember that one.

BTW, what is your motherboard chipset (lspci)?  The CX23418 is a PCI
v2.3 compliant device.  I'm trying to collect data to see if
motherboards with PCI v2.2 chipsets or older have a problem with this
device or not.


>  Another reboot for good measure and both /dev/video0
> and /dev/dvb/xxyyzz are created, no errors in dmesg.  The dmesg data
> is below.
> 
> The NTSC tuner driver is non-functioning.  It scans and finds channels
> in mythtv.  Attempting to watch NTSC tv shows only a black screen.

I like and use MythTV as my PVR software.  However, it's a poor tool to
use for diagnosis; it introduces too many other variables and offers
little insight.

For testing NTSC, please use:

$ cat /dev/video0 > test.mpg

and any tool you want to view or inspect the test.mpg file.  You can use
ivtv-tune to change to a particular channel before or during capture.

Or use mplayer to test, something like:

$ mplayer -cache 8192 /dev/video0


Where MythTV gives you a blanks screen and (default) sparse logging,
mplayer will usually output quite a few  detailed error messages.
Again, I find ivtv-tune convenient for changing channels, but I think
v4l2-ctl will let you change frequencies as well.



>  I have debugging set at 3 at the moment, but no errors are generated.
> Please let me know what information you need to identify the issue. 

For the tuner module you may want to set the debug level higher. I just
tested with "modprobe tuner debug=5", not knowing what the effect would
be but it seemed more verbose than using "debug=1".

For the cx18 module you may also want to turn on the i2c debug flag
(debug=67) and *maybe* the high volume flag (debug=323) if you still
don't see anything unusual.  If you use high volume, you may have to
look in /var/log/messages and the dmesg ring buffer may not hold it all.


But as a troubleshooting step, first let's eliminate if it's the NTSC
tuner, or some other issue down the line.  What is the status of the
analog tuning using v4l2-ctl?  Here's an example status log showing
proper tuning of US broadcast channel 4:

$ ./v4l2-ctl -d /dev/video0 --log-status

Status Log:

   cx18-0: =================  START STATUS CARD #0  =================
   tveeprom 1-0050: Hauppauge model 74041, rev C5B2, serial# 891351
   tveeprom 1-0050: MAC address is 00-0D-FE-0D-99-D7
   tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
   tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
   tveeprom 1-0050: audio processor is CX23418 (idx 38)
   tveeprom 1-0050: decoder processor is CX23418 (idx 31)
   tveeprom 1-0050: has no radio, has IR receiver, has IR transmitter
   cx18-0: Video signal:              present
   cx18-0: Detected format:           NTSC-M
   cx18-0: Specified standard:        NTSC-M
   cx18-0: Specified video input:     Composite 7
   cx18-0: Specified audioclock freq: 48000 Hz
   cx18-0: Detected audio mode:       stereo with SAP
   cx18-0: Detected audio standard:   BTSC
   cx18-0: Audio muted:               no
   cx18-0: Audio microcontroller:     running
   cx18-0: Configured audio standard: automatic detection
   cx18-0: Configured audio system:   BTSC
   cx18-0: Specified audio input:     Tuner (In8)
   cx18-0: Preferred audio mode:      stereo
   cs5345 1-004c: Input:  1
   cs5345 1-004c: Volume: 0 dB
   tuner 2-0061: Tuner mode:      analog TV
   tuner 2-0061: Frequency:       67.25 MHz
   tuner 2-0061: Standard:        0x00001000
   cx18-0: Video Input: Tuner 1
   cx18-0: Audio Input: Tuner 1
   cx18-0: GPIO:  direction 0x00003001, value 0x00003001
   cx18-0: Tuner: TV
   cx18-0: Stream: MPEG-2 Program Stream
   cx18-0: VBI Format: No VBI
   cx18-0: Video:  720x480, 30 fps
   cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
   cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
   cx18-0: Audio:  48 kHz, Layer II, 224 kbps, Stereo, No Emphasis, No CRC
   cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
   cx18-0: Temporal Filter: Manual, 8
   cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   cx18-0: Status flags: 0x00200001
   cx18-0: Stream encoder MPEG: status 0x0118, 1% of 2016 KiB (63 buffers) in use
   cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
   cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 buffers) in use
   cx18-0: Read MPEG/VBI: 148908032/0 bytes
   cx18-0: ==================  END STATUS CARD #0  ==================


> Michael
> 
> ##### dmesg ##########
> 120.016694] Linux video capture interface: v2.00                                                  
> [  120.055132] cx18:  Start initialization, version 1.0.0                                            
> [  120.055203] cx18-0: Initializing card #0                                                          
> [  120.055207] cx18-0: Autodetected Hauppauge card                                                   
> [  120.055212] cx18-0 info: base addr: 0xe4000000                                                    
> [  120.055214] cx18-0 info: Enabling pci device                                                      
> [  120.055236] ACPI: PCI Interrupt 0000:05:09.0[A] -> GSI 18 (level, low) -> IRQ 18                  
> [  120.055252] cx18-0 info: cx23418 (rev 0) at 05:09.0, irq: 18, latency: 66, memory: 0xe4000000     

A latency timer of 66 is a little odd, not being a multiple of 8 PCI
clocks.  PCI devices are permitted to ignore the lowest three bits of
the latency timer setting: so this likely will be interpreted as 64.
(It's no big deal, I just happened to notice it.)


> [  120.055256] cx18-0 info: attempting ioremap at 0xe4000000 len 0x04000000                          
> [  120.056491] cx18-0: cx23418 revision 01010000 (B)                                                 
> [  120.134303] cx18-0 info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000               
> [  120.134303] cx18-0 info: activating i2c...                                                        
> [  120.225060] cx18-0 info: Active card count: 1.                                                    
> [  120.264977] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795                     
> [  120.264982] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                                     
> [  120.264986] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)                     
> [  120.264989] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)                                   
> [  120.264993] tveeprom 2-0050: audio processor is CX23418 (idx 38)                                  
> [  120.264996] tveeprom 2-0050: decoder processor is CX23418 (idx 31)                                
> [  120.264999] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter                    
> [  120.265002] cx18-0: Autodetected Hauppauge HVR-1600                                               
> [  120.265005] cx18-0 info: NTSC tuner detected                                                      
> [  120.265007] cx18-0: VBI is not yet supported                                                      
> [  120.359118] cx18-0 info: Loaded module tuner                                                      
> [  120.380496] cx18-0 info: Loaded module cs5345                                                     
> [  120.380496] tuner 3-0061: Setting mode_mask to 0x0e                                               
> [  120.380496] tuner 3-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)                                
> [  120.380496] tuner 3-0061: tuner 0x61: Tuner type absent                                           
> [  120.380496] cs5345 2-004c: chip found @ 0x98 (cx18 i2c driver #0-0)                               
> [  120.381758] tuner 3-0061: Calling set_type_addr for type=50, addr=0xff, mode=0x04, config=0x32    
> [  120.447481] tuner-simple 3-0061: creating new instance                                            
> [  120.447491] tuner-simple 3-0061: type set to 50 (TCL 2002N)                                       
> [  120.447496] tuner 3-0061: type set to TCL 2002N                                                   
> [  120.447499] tuner 3-0061: tv freq set to 400.00                                                   
> [  120.448356] tuner 3-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 50 used for 0x0e     
> [  120.448371] cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB total)          
> [  120.448454] cx18-0 info: Allocate TS stream: 32 x 32768 buffers (1024kB total)                    
> [  120.448501] cx18-0 info: Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
> [  120.448534] cx18-0 info: Allocate encoder PCM audio stream: 63 x 16384 buffers (1008kB total)
> [  120.448595] cx18-0: Disabled encoder IDX device
> [  120.448643] cx18-0: Registered device video0 for encoder MPEG (2 MB)
> [  120.448648] DVB: registering new adapter (cx18)
> [  120.600362] MXL5005S: Attached at address 0x63
> [  120.600379] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> [  120.600459] cx18-0: DVB Frontend registered
> [  120.600489] cx18-0: Registered device video32 for encoder YUV (2 MB)
> [  120.600515] cx18-0: Registered device video24 for encoder PCM audio (1 MB)
> [  120.600519] cx18-0: Initialized card #0: Hauppauge HVR-1600
> [  120.600544] cx18:  End initialization

The above looks OK.  I assume you switch from 400 MHz to a real TV
station before testing.  When my driver loads (I haven't updated in a
few days), it automatically changes over to US broadcast channel 4 at
67.25 MHz.


Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
