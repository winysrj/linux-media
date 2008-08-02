Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72LUViR008802
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 17:30:31 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72LUKMk032244
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 17:30:20 -0400
From: Andy Walls <awalls@radix.net>
To: ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Content-Type: text/plain
Date: Sat, 02 Aug 2008 17:25:26 -0400
Message-Id: <1217712326.2699.84.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: cx18: Possible causal realtionship for HVR-1600 I2C errors
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Quite a few HVR-1600 users have reported cx18 driver I2C related
problems usually with the following errors present:

   tveeprom 1-0050: Huh, no eeprom present (err=-121)?
   tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.

   s5h1409_readreg: readreg error (ret == -121)
   cx18: frontend initialization failed
   cx18-0: DVB failed to register

and an unusable HVR-1600/CX23418 under linux.


On the surface the problem appeared to be related to the devices on the
I2C buses of the HVR-1600.  Given the data from a number of user reports
piling up, I think I can say that it's likely a PCI v2.2 or earlier bus
problem with the CX23418 under linux.  The I2C bus errors appear to be
just a symptom of a larger underlying problem.

The CX23418 is a PCI v2.3 device according to Conexant's publicly
available product literature.  The users who experience the dreaded -121
(-EREMOTEIO) errors under linux, all (I need to double check with
Michael) seem to have the HVR-1600 card installed in a machine with a
PCI v2.2 or earlier chipset.  **So I suspect, under linux at least, the
HVR-1600 or CX23418 won't work with a PCI v2.2 or earlier chipset.**


Here are my collected reports.

Non-working (under linux) setups:

Reporter:    Scott
PCI chipset: Intel 82850 & 82801BA rev 4
PCI version: v2.2
AGP:         Yes
Video:       PCI nVidia NV34 GeForce FX 5500
Symptoms:    tveeprom ret=-121 error, card not working

Reporter:    Ryan Watts
PCI chipset: VIA VT8363/8365 & VT82C686
PCI version: v2.2 (VT8363)
AGP:         Yes
Video:       AGP nVidia NV18 GeForce4 MX 4000
Symptoms:    tveeprom ret=-121 error, card not working

Reporter:    Michael
PCI Chipset: ?
PCI Version: ?
AGP:         ?
Video:       ?
Symptoms:    I2C bus intermittently seems to work as intialization
completes including tveeprom and dvb demodulator init.  Analog tuner
init doesn't seem to happen.  HVR-1600 cannot be made to do useful work.


Reporter:    Matt Loomis
PCI Chipset: VIA VT8363/8365 & VT82C686
PCI Version: v2.2 (VT8363)
AGP:         Yes
Video:       AGP ATI Technologies Inc Radeon RV200 QW [Radeon 7500]
             PCI Silicon Integrated Systems [SiS] 86C326 5598/6326
Symptoms:    cx18 driver fails to init with the tveeprom ret=121 error.
Both sets of CX23418 I2C control registers are returning bogus values
when read (they don't match what was just written).  ***Card works under
Windows XP with Hauppauge drivers.****


Reporter:    Michael Papet
PCI Chipset: Intel 82845G & 82801DB
PCI Version: v2.2 (82801DB)
AGP:         ?
Video:       82845 Integrated Graphics
Symptoms:    cx18 driver fails to init at boot time with I2C ret=-121
errors.  If blacklisted for boot and modprobed later, driver appears to
initialize.  Card seems unable to be tuned.


Reporter:    Gerhard Wittreich
PCI Chipset: Intel 82845 & 82801BA
PCI Version: V2.2 (82801)
AGP:         Yes
Video:       AGP ATI Technologies Inc Rage 128 Pro Ultra TF
Symptoms:    cx18 driver fails to init due to apparent I2C bus errors,
but one set of CX23418 I2C control registers is acting normally while
the other set is returning bogus values when read (identical to the
values in Matt Loomis' reports).


Working setups:

Reporter:    Gerhard Wittreich
PCI Chipset: nVidia MPC61
PCI Version: Unknown but it's a PCIe chipset, so assuming > v2.2
AGP:         no
Video:       PCIe nVidia Corporation G70 [GeForce 7600 GT]
Symptoms:    No problems; card works.


Reporter:    Gerhard Wittreich
PCI Chipset: Intel 82915G* & 82801F*
PCI Version: v2.3 (82801F*)
AGP:         no
Video:       ?
Symptoms:    No problems; card works.


Reporter:    Andy Walls
PCI Chipset: ATI RS740 & SB700
PCI Version: v2.3 (SB700)
AGP:         no
Video:       PCI ATI Technologies Inc Radeon 2100
Symptoms:    No problems; card works.


I'd be interested in additional reports of:

1. Errors I made in the above collected data.

2. A CX23418 based card working properly or not under Linux (or Windows)
in a machine with a PCI v2.2 or earlier chipset.

3. The differences between PCI v2.2 and v2.3 that would cause PC v2.2
host writes to a PCI v2.3 device to fail or for reads to return bogus
values (i.e. reading back 0x7 after a value of 0x21c0b was just
written.)?

4. If anyone knows what magical tweak Windows or the Hauppauge HVR-1600
Windows driver is making to get the HVR-1600 working with (at least) the
VIA VT8363 & VT82C686.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
