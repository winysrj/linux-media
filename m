Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50479 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab0G2BXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 21:23:32 -0400
Subject: Re: saa7164 i2c problem
From: Andy Walls <awalls@md.metrocast.net>
To: Dong Lin <d.lin@post.harvard.edu>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100725162511.M94906@post.harvard.edu>
References: <20100725162511.M94906@post.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 21:24:10 -0400
Message-ID: <1280366650.2392.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dong,

On Sun, 2010-07-25 at 09:38 -0700, Dong Lin wrote:
> Andy,

PLease be advised that I will usually ignore private emails asking for
tech support, when there is no obvious need for privacy.  Linux
development works best with many eyes to help shoulder the workload and
spot the problems.  Thus I respond Cc:-ing the LMML list.


> I am having trouble using an hvr-2250 card (0070:8851). It seems that there
> was some kind of i2c error triggered by the 7164 driver.

Well, I'm not quite the right person to ask about Philips chips.  I
don't have access to datasheets and programming manuals for them.


>  The strangest thing
> is that it worked for the very first time when the card was physically
> inserted into the machine. But Starting from the second boot, it no longer
> works. I wonder if you have looked into this problem.

It looks like a power management problem or chip reset problem.  See
below.


> Steven Toth mentioned on one mailing list that it might be related to AMD
> systems only. But I cannot find any specifics.

> Thanks,
> 
> Dong Lin
> 
> 
> ---------------------
> 
> [   20.406838] saa7164 driver loaded
> [   20.407370] ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
> [   20.407375] saa7164 0000:03:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level,
> low) -> IRQ 16
> [   20.407541] CORE saa7164[0]: subsystem: 0070:8851, board: Hauppauge
> WinTV-HVR2250 [card=7,autodetected]
> [   20.407547] saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 16,
> latency: 0, mmio: 0xfd000000
> [   20.407552] saa7164 0000:03:00.0: setting latency timer to 64
> [   20.407556] IRQ 16/saa7164[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   20.564011] saa7164_downloadfirmware() no first image
> [   20.564264] saa7164_downloadfirmware() Waiting for firmware upload
> (v4l-saa7164-1.0.3.fw)
> [   20.564269] saa7164 0000:03:00.0: firmware: requesting v4l-saa7164-1.0.3.fw
> [   20.684414] saa7164_downloadfirmware() firmware read 3978608 bytes.
> [   20.684418] saa7164_downloadfirmware() firmware loaded.
> [   20.684419] Firmware file header part 1:
> [   20.684422]  .FirmwareSize = 0x0
> [   20.684423]  .BSLSize = 0x0
> [   20.684424]  .Reserved = 0x3cb57
> [   20.684426]  .Version = 0x3
> [   20.684427] saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608
> [   20.684433] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
> [   20.684434] saa7164_downloadfirmware() BSLSize = 0x0
> [   20.684436] saa7164_downloadfirmware() Reserved = 0x0
> [   20.684438] saa7164_downloadfirmware() Version = 0x51cc1
> [   20.699720] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   20.699726] HDA Intel 0000:00:05.0: PCI INT B -> Link[AAZA] -> GSI 22
> (level, low) -> IRQ 22
> [   20.699729] hda_intel: Disable MSI for Nvidia chipset
> [   20.699761] HDA Intel 0000:00:05.0: setting latency timer to 64
> [   21.296090] input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:05.0/input/input7
> [   24.922396] CPU0 attaching NULL sched-domain.
> [   24.922403] CPU1 attaching NULL sched-domain.
> [   24.944083] CPU0 attaching sched-domain:
> [   24.944088]  domain 0: span 0-1 level MC
> [   24.944091]   groups: 0 1
> [   24.944097] CPU1 attaching sched-domain:
> [   24.944099]  domain 0: span 0-1 level MC
> [   24.944101]   groups: 1 0
> [   27.276020] saa7164_downloadimage() Image downloaded, booting...
> [   27.380013] saa7164_downloadimage() Image booted successfully.
> [   27.380031] starting firmware download(2)
> [   29.504018] saa7164_downloadimage() Image downloaded, booting...
> [   30.720519] eth1: no IPv6 routers present
> [   31.168047] saa7164_downloadimage() Image booted successfully.
> [   31.168072] firmware download complete.
> [   31.204870] tveeprom 5-0000: Hauppauge model 88061, rev C4F2, serial# 6567048
> [   31.204874] tveeprom 5-0000: MAC address is 00-0D-FE-64-34-88
> [   31.204877] tveeprom 5-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)
> [   31.204880] tveeprom 5-0000: TV standards NTSC(M) ATSC/DVB Digital (eeprom
> 0x88)
> [   31.204883] tveeprom 5-0000: audio processor is SAA7164 (idx 43)
> [   31.204885] tveeprom 5-0000: decoder processor is SAA7164 (idx 40)
> [   31.204887] tveeprom 5-0000: has radio, has IR receiver, has no IR transmitter
> [   31.204889] saa7164[0]: Hauppauge eeprom: model=88061
> [   31.708552] tda18271 6-0060: creating new instance
> [   31.712620] TDA18271HD/C2 detected @ 6-0060
> [   31.964810] DVB: registering new adapter (saa7164)
> [   31.964818] DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB
> Frontend)...
> [   32.248340] tda18271 7-0060: creating new instance
> [   32.252388] TDA18271HD/C2 detected @ 7-0060
> [   32.500491] tda18271: performing RF tracking filter calibration
> [   35.254384] tda18271: RF tracking filter calibration complete
> [   35.254732] DVB: registering new adapter (saa7164)
> [   35.254738] DVB: registering adapter 1 frontend 0 (Samsung S5H1411 QAM/8VSB
> Frontend)...

What did you try in the 30 minutes and 45 seconds between driver load
and the error?

> [ 1879.428026] Event timed out
> [ 1879.428033] saa7164_api_i2c_write() error, ret(1) = 0x32
> [ 1879.428037] s5h1411_writereg: writereg error 0x19 0xf4 0x0000, ret == -5)
                                                  ^^^^^^^^^^^^^^^^

This is the s5h1411 driver trying to take the digital demodulator out of
power down by calling s5h1411_set_powerstate(fe, 0).  The I2C subsystem
returned -EIO (-5) which means the demodulator chip didn't respond.

It could be an AMD PCIe chipset problem, but I doubt it.   PCIe bus
errors aren't as common as PCI bus errors in my limited experience with
PCIe.

What seems to be the case is the demod chip went dumb (or some other
slave on the I2C bus did), and a simple I2C command isn't going to bring
it back.   If there's a GPIO that can be toggled to reset the demod,
that's what one would want to use in this case.  You can change the
s5h1411_sleep() function into a no-op and see if that works around your
problem.


Regards,
Andy

