Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LJcbW-0002v3-BI
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 00:42:01 +0100
From: Andy Walls <awalls@radix.net>
To: Eric Bauer <ebauer71@centurytel.net>
In-Reply-To: <496131A6.9050108@centurytel.net>
References: <4960D592.9070400@centurytel.net>
	<1231091162.3125.6.camel@palomino.walls.org>
	<49611FB9.2080409@centurytel.net>  <496131A6.9050108@centurytel.net>
Date: Sun, 04 Jan 2009 18:44:06 -0500
Message-Id: <1231112646.3117.19.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Problem Searching Channels
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

On Sun, 2009-01-04 at 16:01 -0600, Eric Bauer wrote:
> Hello Again Andy,
> 
> I was able to fix the problem reported by dmesg about the firmware.  I
> downloaded the firmware files from here:
> 
>  http://hauppauge.lightpath.net/software/install_cd/hauppauge_cd_3.4d1.zip
> 
> and installed the one I needed.  I restarted the system just to be
> safe.  Dmesg now does not report any problems with the firmware.
> However, scandvb still does not finish or find anything.  Any thoughts
> about it?

You need all three firmware files (cpu, apu, and digitizer).  Please get
them from here:

http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz

These are the latest firmware files that Conexant has provided directly
for the Linux cx18 driver and has permitted us to distribute them.  They
are later that the ones in the Hauppauge Windows driver CD.  They are
the files the cx18 driver is expecting to use (the driver does a
filesize check on at least one of them).

If the CPU firmware isn't loaded and running, you'll never get any
digital TS results.  I2C functions still work, so the tuning commands
will still happen, you'll just never get any data.

> Eric Bauer wrote: 
> > Hello Andy,
> > 
> > Thanks for the reply.  I am really stuck on this.  I am using
> > Fedora8, so I did a yum install of the latest dvb-tools application,
> > but I'm not sure which version it is.  I am executing this command:
> > 
> > $
> > scandvb /usr/share/dvb-apps/atsc/us-Cable-Standard-center-frequencies-QAM256

I use this on my old Fedora 7 machine for OTA ATSC:

$ scandvb -A 1 -v -a 0  /usr/share/dvb-apps/atsc/us-ATSC-center-frequencies-8VSB


> > On your advice, I checked as discovered that I was running verison
> > 1.0.0 of the cx18 drive.  I downloaded the latest cx18 driver and
> > installed it.  After running the modprobe as instructed, scandvb
> > could no longer find the device in the /dev directory.  After
> > rebooting, scandvb worked again and modinfo reports that I am
> > running version 1.0.4 of cx18.  Unfortunately, after several minutes
> > of scanning, the same thing is happening.  The scan will not
> > complete.

Hmmm.

Could you load the module with debugging enabled?  Maybe something like

# modprobe cx18 debug=511


That will turn on very verbose debugging.  Then when you do a scan,
in /var/log/messages, you'll see a capture task get started and a slew
of buffers handed over to the firmware.  Then when your tuner and demod
actually tune to a signal, you'll see "DMA Done" messages coming back
indicating you've recevied some data from that digital channel.


> > I don't know if this is important or not.  I tried scanning using a
> > couple other firequency files.
> > us-Cable-IRC-center-frequencies-QAM256 does the same thing, but
> > us-Cable-HRC-center-frequencies-QAM256
> >  completes without error, it just does not find any channels.  
> > 
> > I found some interesting stuff in the dmesg output.  I have a
> > Happaugue HVR-1600 model 1178, but tveeprom is reporting that it is
> > model 74041.  Seems like this might explain where my problem is
> > coming from, but I don't know how to fix it.  Here is the dmesg
> > output:

Nah. no big deal.  The 74041 is printed on the tuner can.  The 1178
model is just used on the boxes to tell people what's in the cardboard
box.

> > cx18:  Start initialization, version 1.0.4
> > cx18-0: Initializing card #0
> > cx18-0: Autodetected Hauppauge card
> > ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 21 (level, low) -> IRQ 21
> > cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
> > cx18-0: cx23418 revision 01010000 (B)
> > tveeprom 1-0050: Hauppauge model 74041, rev C5B2, serial# 2884991
> > tveeprom 1-0050: MAC address is 00-0D-FE-2C-05-7F
> > tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
> > tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
> > tveeprom 1-0050: audio processor is CX23418 (idx 38)
> > tveeprom 1-0050: decoder processor is CX23418 (idx 31)
> > tveeprom 1-0050: has no radio, has IR receiver, has IR transmitter
> > cx18-0: Autodetected Hauppauge HVR-1600
> > cx18-0: Raw VBI supported; Sliced VBI is not yet supported
> > firewire_core: created device fw0: GUID 0090270001f82fe5, S400
> > tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
> > cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> > tuner-simple 2-0061: creating new instance
> > tuner-simple 2-0061: type set to 50 (TCL 2002N)
> > cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
> > DVB: registering new adapter (cx18)
> > MXL5005S: Attached at address 0x63
> > DVB: registering adapter 0 frontend 3332 (Samsung S5H1409 QAM/8VSB
> > Frontend)...
> > cx18-0: DVB Frontend registered
> > cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
> > cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
> > cx18-0: Registered device vbi0 for encoder VBI (60 x 17328 bytes)
> > cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)
> > cx18-0: Initialized card #0: Hauppauge HVR-1600
> > cx18:  End initialization
> > 
> > And the a little further down...
> > 
> > firmware: requesting v4l-cx23418-cpu.fw
> > cx18-0: Unable to open firmware v4l-cx23418-cpu.fw
> > cx18-0: Did you put the firmware in the hotplug firmware directory?
> > cx18-0: Retry loading firmware
> > firmware: requesting v4l-cx23418-cpu.fw
> > cx18-0: Unable to open firmware v4l-cx23418-cpu.fw
> > cx18-0: Did you put the firmware in the hotplug firmware directory?
> > cx18-0: Failed to initialize firmware starting DVB feed
> > cx18-0: Failed to initialize firmware starting DVB feed
> > Press any key to continue...
> > 
> > 
> > Any thoughts about this?
> > 
> > Thanks,
> > 
> > Eric
> > 
> > 
> > Andy Walls wrote: 
> > > On Sun, 2009-01-04 at 09:28 -0600, Eric Bauer wrote:
> > >   
> > > > Hello,
> > > > 
> > > > I'm trying to set up my new Happaugue HVR-1600 card.  During the scan, 
> > > > II get several minutes of output on the screen complaining about tuning 
> > > > failures,
> > > >     
> > > 
> > > These are normal when no service is detected on those freqs.
> > > 
> > > 
> > >   
> > > > and then I get the following message:
> > > > 
> > > > start filter:1338: ERROR: ioctl DMX_SET_FILTER failed: 6 No such device 
> > > > or address
> > > >     
> > > 
> > > Hmmm.  New one one me, I'll have to investigate.
> > > 
> > > What specific tool, version and command line arguments are you using?
> > > 
> > > 
> > >   
> > > > I have to kill the scan with a control-c at this point.  Can anyone give 
> > > > me some advice with this problem?
> > > >     
> > > 
> > > Make sure you are using the latest cx18 driver from:
> > > 
> > > http://linuxtv.og/hg/v4l-dvb
> > > 
> > > versions older than v1.0.4 of the cx18 driver have problems dealing with
> > > the occasional PCI bus error.
> > > 
> > > 
> > > Instructions can be found here:
> > > 
> > > http://www.ivtvdriver.org/index.php/Cx18
> > > 
> > > 
> > > Make sure you have a good clean signal coming in:
> > > 
> > > http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
> > > 
> > > 
> > > Regards,
> > > Andy
> > > 
> > >   
> > > > Thanks,
> > > > 
> > > > Eric
> > > >     
> > > 
> > > 
> > > 
> > >   
> > 
> > 
> > ____________________________________________________________________
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
