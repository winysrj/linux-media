Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45096 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeJKEox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 00:44:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id q5-v6so7287682wrw.12
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 14:20:50 -0700 (PDT)
Date: Wed, 10 Oct 2018 23:20:44 +0200
From: ektor5 <ek5.chimenti@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: luca.pisani@udoo.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Add SECO Boards CEC device driver
Message-ID: <20181010212041.urkanmwjbjaauq2f@Ettosoft-T55>
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <cover.1538760098.git.ek5.chimenti@gmail.com>
 <bdec2327-8c19-8ffb-9862-6df2e6e697c7@xs4all.nl>
 <20181010120928.cx6mlwigrl4zim2c@Ettosoft-T55>
 <d1027940-5c27-650e-3250-8d75cf496f84@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ydh2llnwcdk6kcx3"
Content-Disposition: inline
In-Reply-To: <d1027940-5c27-650e-3250-8d75cf496f84@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ydh2llnwcdk6kcx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 10, 2018 at 03:45:35PM +0200, Hans Verkuil wrote:
> On 10/10/18 14:09, ektor5 wrote:
> > Hi Hans,
> > 
> > On Sat, Oct 06, 2018 at 11:54:38AM +0200, Hans Verkuil wrote:
> >> Hi Ettore,
> >>
> >> On 10/05/2018 07:33 PM, ektor5 wrote:
> >>> This series of patches aims to add CEC functionalities to SECO
> >>> devices, in particular UDOO X86.
> >>>
> >>> The communication is achieved via Braswell SMBus (i2c-i801) to the
> >>> onboard STM32 microcontroller that handles the CEC signals. The driver
> >>> use direct access to the PCI addresses, due to the limitations of the
> >>> specific driver in presence of ACPI calls.
> >>>
> >>> The basic functionalities are tested with success with cec-ctl and
> >>> cec-compliance.
> >>
> >> This series looks good to me. But can you do one more test:
> >>
> >> Update your kernel to the latest media_tree master and also update your
> >> v4l-utils repo to the latest master code.
> >>
> >> With all that in place please run:
> >>
> >> cec-compliance -A
> >>
> >> (have the HDMI output connected to a CEC-capable TV when running this test).
> >>
> >> Please report back the output of cec-compliance.
> >>
> >> A bunch of CEC bug fixes and improvements were merged yesterday, and the
> >> cec-compliance adapter test is improved to check for issues that were hard
> >> to find in the past.
> >>
> >> So it will be good to have a final check of this driver.
> > 
> > Here it is, compiled media-tree and latest v4l-utils:
> > 
> > udoo@udoo-UDOO-x86:~/v4l-utils/utils/cec-compliance$ uname -a
> > Linux udoo-UDOO-x86 4.19.0-041900rc7-generic #201810071631+cec SMP Tue Oct 9 17:36:11 CEST 2018 x86_64 x86_64 x86_64 GNU/Linux
> > udoo@udoo-UDOO-x86:~/v4l-utils/utils/cec-compliance$ ./cec-compliance -A
> > cec-compliance SHA                 : 06ad469e966aafaf39c1cc76e6e0953ec7d4f9c9
> > Driver Info:
> > 	Driver Name                : secocec
> > 	Adapter Name               : CEC00001:00
> > 	Capabilities               : 0x0000000e
> > 		Logical Addresses
> > 		Transmit
> > 		Passthrough
> > 	Driver version             : 4.19.0
> > 	Available Logical Addresses: 1
> > 	Physical Address           : 3.0.0.0
> > 	Logical Address Mask       : 0x0010
> > 	CEC Version                : 2.0
> > 	Vendor ID                  : 0x000c03 (HDMI)
> > 	OSD Name                   : Playback
> > 	Logical Addresses          : 1 
> > 
> > 	  Logical Address          : 4 (Playback Device 1)
> > 	    Primary Device Type    : Playback
> > 	    Logical Address Type   : Playback
> > 	    All Device Types       : Playback
> > 	    RC TV Profile          : None
> > 	    Device Features        :
> > 		None
> > 
> > Compliance test for device /dev/cec0:
> > 
> >     The test results mean the following:
> >         OK                  Supported correctly by the device.
> >         OK (Not Supported)  Not supported and not mandatory for the device.
> >         OK (Presumed)       Presumably supported.  Manually check to confirm.
> >         OK (Unexpected)     Supported correctly but is not expected to be supported for this device.
> >         OK (Refused)        Supported by the device, but was refused.
> >         FAIL                Failed and was expected to be supported by this device.
> > 
> > Find remote devices:
> > 	Polling: OK
> > 
> > CEC API:
> > 	CEC_ADAP_G_CAPS: OK
> > 	CEC_DQEVENT: OK
> > 	CEC_ADAP_G/S_PHYS_ADDR: OK
> > 	CEC_ADAP_G/S_LOG_ADDRS: OK
> > 	CEC_TRANSMIT: OK
> > 	CEC_RECEIVE: OK
> > 	CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
> > 	CEC_G/S_MODE: OK
> > 		fail: cec-test-adapter.cpp(1042): There were 142 pending messages for 83 transmitted messages
> 
> That's not good.
> 
> If you look in the kernel log, do you see 'timed out' cec messages?

No, actually I see a lot of 'cec_transmit_msg_fh: transmit queue full'
messages.

> 
> Note: that message is a warning since commit 7ec2b3b941a666a942859684281b5f6460a0c234.
> Before that you first need to enable debugging:
> 
> echo 1 >/sys/module/cec/parameters/debug
> 
> My guess is that this might be a fw bug. Does the firmware handle Signal Free Time
> correctly? My guess is that it doesn't do that and that this test causes what is
> effectively a 'denial of service' situation: the transmitter gets blocked waiting
> for sufficient signal free time.
> 
> I have updated cec-compliance to give better information about what was received,
> so can you update cec-compliance and run again?

Yes, I've recompiled the two, in attachment there are both outputs plus
the relative kernel messages.

> 
> Also, run 'cec-ctl -m >cec.log' at the same time and mail me that log.
> 
> There are two types of CEC adapters: those that handle retransmits automatically
> (and they determine the Signal Free Time themselves) and those that don't do
> automatic retransmits, and there you normally need to program the Signal Free Time
> before starting the transmit.
> 
> This driver falls in the second category, but the SFT isn't set anywhere.
> 
> This particular adapter test actually tests this, and I have seen this
> symptom before if the SFT wasn't set correctly.

I didn't know that, there is a place to put that parameter (or there is
a default)? There is a way to evaluate a good value for that?

Thanks a lot,
	Ettore

> 
> Regards,
> 
> 	Hans
> 
> > 	CEC_EVENT_LOST_MSGS: FAIL
> > 
> > Network topology:
> > 	System Information for device 0 (TV) from device 4 (Playback Device 1):
> > 		CEC Version                : 1.4
> > 		Physical Address           : 0.0.0.0
> > 		Primary Device Type        : TV
> > 		Vendor ID                  : 0x00e091
> > 		OSD Name                   : Tx, OK, Rx, Timeout
> > 		Menu Language              : kor
> > 		Power Status               : On
> > 
> > Total: 10, Succeeded: 9, Failed: 1, Warnings: 0
> > 
> > Thanks,
> > 	Ettore
> > 
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>> v2:
> >>>  - Removed useless debug prints
> >>>  - Added DMI && PCI to dependences
> >>>  - Removed useless ifdefs
> >>>  - Renamed all irda references to ir
> >>>  - Fixed SPDX clause
> >>>  - Several style fixes
> >>>
> >>> Ettore Chimenti (2):
> >>>   media: add SECO cec driver
> >>>   seco-cec: add Consumer-IR support
> >>>
> >>>  MAINTAINERS                                |   6 +
> >>>  drivers/media/platform/Kconfig             |  22 +
> >>>  drivers/media/platform/Makefile            |   2 +
> >>>  drivers/media/platform/seco-cec/Makefile   |   1 +
> >>>  drivers/media/platform/seco-cec/seco-cec.c | 829 +++++++++++++++++++++
> >>>  drivers/media/platform/seco-cec/seco-cec.h | 141 ++++
> >>>  6 files changed, 1001 insertions(+)
> >>>  create mode 100644 drivers/media/platform/seco-cec/Makefile
> >>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
> >>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
> >>>
> >>
> 

--ydh2llnwcdk6kcx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cec-compliance.log"

cec-compliance SHA                 : 06ad469e966aafaf39c1cc76e6e0953ec7d4f9c9
Driver Info:
	Driver Name                : secocec
	Adapter Name               : CEC00001:00
	Capabilities               : 0x0000000e
		Logical Addresses
		Transmit
		Passthrough
	Driver version             : 4.19.0
	Available Logical Addresses: 1
	Physical Address           : 2.1.0.0
	Logical Address Mask       : 0x0010
	CEC Version                : 2.0
	Vendor ID                  : 0x000c03 (HDMI)
	OSD Name                   : Playback
	Logical Addresses          : 1 

	  Logical Address          : 4 (Playback Device 1)
	    Primary Device Type    : Playback
	    Logical Address Type   : Playback
	    All Device Types       : Playback
	    RC TV Profile          : None
	    Device Features        :
		None

Compliance test for device /dev/cec0:

    The test results mean the following:
        OK                  Supported correctly by the device.
        OK (Not Supported)  Not supported and not mandatory for the device.
        OK (Presumed)       Presumably supported.  Manually check to confirm.
        OK (Unexpected)     Supported correctly but is not expected to be supported for this device.
        OK (Refused)        Supported by the device, but was refused.
        FAIL                Failed and was expected to be supported by this device.

Find remote devices:
	Polling: OK

CEC API:
	CEC_ADAP_G_CAPS: OK
	CEC_DQEVENT: OK
	CEC_ADAP_G/S_PHYS_ADDR: OK
	CEC_ADAP_G/S_LOG_ADDRS: OK
		fail: cec-test-adapter.cpp(318): msg.rx_status & CEC_RX_STATUS_TIMEOUT
	CEC_TRANSMIT: FAIL
	CEC_RECEIVE: OK
	CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
	CEC_G/S_MODE: OK
		Successful transmits: 88
		Received messages: 2
		Received 54 messages immediately, and 36 over 6 seconds
		fail: cec-test-adapter.cpp(1090): There were 90 messages in the receive queue for 89 transmits
	CEC_EVENT_LOST_MSGS: FAIL

Network topology:
	System Information for device 0 (TV) from device 4 (Playback Device 1):
		CEC Version                : Tx, OK, Rx, OK, Feature Abort
		Physical Address           : 0.0.0.0
		Primary Device Type        : TV
		Vendor ID                  : Tx, OK, Rx, Timeout
		OSD Name                   : Tx, OK, Rx, Timeout
		Menu Language              : ita
		Power Status               : On
	System Information for device 5 (Audio System) from device 4 (Playback Device 1):
		CEC Version                : 1.4
		Physical Address           : 2.0.0.0
		Primary Device Type        : Audio System
		Vendor ID                  : 0x00a0de
		OSD Name                   : 'HTR-2071'
		Power Status               : On

Total: 10, Succeeded: 8, Failed: 2, Warnings: 0

--ydh2llnwcdk6kcx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cec-ctl_sft.log"

Driver Info:
	Driver Name                : secocec
	Adapter Name               : CEC00001:00
	Capabilities               : 0x0000000e
		Logical Addresses
		Transmit
		Passthrough
	Driver version             : 4.19.0
	Available Logical Addresses: 1
	Physical Address           : 2.1.0.0
	Logical Address Mask       : 0x0010
	CEC Version                : 2.0
	Vendor ID                  : 0x000c03 (HDMI)
	OSD Name                   : Playback
	Logical Addresses          : 1 

	  Logical Address          : 4 (Playback Device 1)
	    Primary Device Type    : Playback
	    Logical Address Type   : Playback
	    All Device Types       : Playback
	    RC TV Profile          : None
	    Device Features        :
		None



Initial Event: State Change: PA: 2.1.0.0, LA mask: 0x0010
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to Recording Device 1 (4 to 1): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Recording Device 2 (4 to 2): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Tuner 1 (4 to 3): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_POLL
Transmitted by Playback Device 1 to Tuner 2 (4 to 6): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Tuner 3 (4 to 7): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Playback Device 2 (4 to 8): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Recording Device 3 (4 to 9): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Tuner 4 (4 to 10): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Playback Device 3 (4 to 11): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Reserved 1 (4 to 12): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Reserved 2 (4 to 13): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries
Transmitted by Playback Device 1 to Specific (4 to 14): CEC_MSG_POLL
	Tx, Not Acknowledged (2), Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0000
Transmitted by Recording Device 1 to Recording Device 1 (1 to 1): CEC_MSG_POLL
	Tx, Not Acknowledged (4), Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0002
Transmitted by Recording Device 1 to all (1 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 2.1.0.0
	prim-devtype: record (0x01)
	Tx, Aborted, Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0000
Transmitted by Recording Device 1 to all (1 to 15): CEC_MSG_REPORT_FEATURES (0xa6):
	cec-version: version-2-0 (0x06)
	all-device-types: 72 (0x48)
	rc-profile: 16 (0x10)
	rc-profile: tv-profile-none (0x00)
	dev-features: 14 (0x0e)
	dev-features: 0 (0x00)
	Tx, Aborted, Max Retries
Transmitted by Recording Device 1 to Recording Device 1 (1 to 1): CEC_MSG_POLL
	Tx, Not Acknowledged (4), Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0002
Transmitted by Recording Device 1 to all (1 to 15): CEC_MSG_REPORT_FEATURES (0xa6):
	cec-version: version-2-0 (0x06)
	all-device-types: 72 (0x48)
	rc-profile: 16 (0x10)
	rc-profile: tv-profile-none (0x00)
	dev-features: 14 (0x0e)
	dev-features: 0 (0x00)
Transmitted by Recording Device 1 to all (1 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 2.1.0.0
	prim-devtype: record (0x01)
Received from TV to Recording Device 1 (0 to 1): CEC_MSG_GIVE_OSD_NAME (0x46)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_SET_OSD_NAME (0x47):
	name: Compliance
Received from Audio System to Recording Device 1 (5 to 1): CEC_MSG_GIVE_OSD_NAME (0x46)
Transmitted by Recording Device 1 to Audio System (1 to 5): CEC_MSG_SET_OSD_NAME (0x47):
	name: Compliance
	Tx, Aborted, Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0000
Transmitted by Playback Device 1 to Playback Device 1 (4 to 4): CEC_MSG_POLL
	Tx, Not Acknowledged (4), Max Retries

Event: State Change: PA: 2.1.0.0, LA mask: 0x0010
Transmitted by Playback Device 1 to all (4 to 15): CEC_MSG_REPORT_FEATURES (0xa6):
	cec-version: version-2-0 (0x06)
	all-device-types: playback (0x10)
	rc-profile: tv-profile-none (0x00)
	dev-features: 0 (0x00)
Transmitted by Playback Device 1 to all (4 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 2.1.0.0
	prim-devtype: playback (0x04)
Transmitted by Unregistered to TV (15 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_GIVE_OSD_NAME (0x46)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_SET_OSD_NAME (0x47):
	name: Playback
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_POLL
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_CEC_VERSION (0x9f)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 159 (0x9f)
	reason: unrecognized-op (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from TV to all (0 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 0.0.0.0
	prim-devtype: tv (0x00)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_DEVICE_VENDOR_ID (0x8c)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_OSD_NAME (0x46)
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GET_MENU_LANGUAGE (0x91)
Received from TV to all (0 to 15): CEC_MSG_SET_MENU_LANGUAGE (0x32):
	language: ita
Transmitted by Playback Device 1 to TV (4 to 0): CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
Received from TV to Playback Device 1 (0 to 4): CEC_MSG_REPORT_POWER_STATUS (0x90):
	pwr-state: on (0x00)
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GET_CEC_VERSION (0x9f)
Received from Audio System to Playback Device 1 (5 to 4): CEC_MSG_CEC_VERSION (0x9e):
	cec-version: version-1-4 (0x05)
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Received from Audio System to all (5 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
	phys-addr: 2.0.0.0
	prim-devtype: audiosystem (0x05)
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GIVE_DEVICE_VENDOR_ID (0x8c)
Received from Audio System to all (5 to 15): CEC_MSG_DEVICE_VENDOR_ID (0x87):
	vendor-id: 41182 (0x0000a0de)
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GIVE_OSD_NAME (0x46)
Received from Audio System to Playback Device 1 (5 to 4): CEC_MSG_SET_OSD_NAME (0x47):
	name: HTR-2071
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GET_MENU_LANGUAGE (0x91)
Received from Audio System to Playback Device 1 (5 to 4): CEC_MSG_FEATURE_ABORT (0x00):
	abort-msg: 145 (0x91)
	reason: unrecognized-op (0x00)
Transmitted by Playback Device 1 to Audio System (4 to 5): CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
Received from Audio System to Playback Device 1 (5 to 4): CEC_MSG_REPORT_POWER_STATUS (0x90):
	pwr-state: on (0x00)

--ydh2llnwcdk6kcx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg_cec.log"

Linux version 4.19.0-041900rc7-generic (root@udoo-UDOO-x86) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #201810071631+cec SMP Tue Oct 9 17:36:11 CEST 2018
seco_cec: loading out-of-tree module taints kernel.
seco_cec: module verification failed: signature and/or required key missing - tainting kernel
secocec CEC00001:00: irq-gpio is bound to IRQ 119
secocec CEC00001:00: IRQ detected at 119
secocec CEC00001:00: IR enabled
rc rc0: lirc_dev: driver secocec registered at minor = 0, scancode receiver, no transmitter
secocec CEC00001:00: Device registered
secocec CEC00001:00: Device enabled
secocec CEC00001:00: Device disabled
secocec CEC00001:00: Device enabled
secocec CEC00001:00: Device disabled
secocec CEC00001:00: Device enabled
secocec CEC00001:00: Device disabled
secocec CEC00001:00: Device enabled
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 1 pa 2.1.0.0
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 1 pa 2.1.0.0
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 4 pa 2.1.0.0
cec-CEC00001:00: cec_transmit_msg_fh: invalid poll message
cec-CEC00001:00: cec_transmit_msg_fh: can't reply to poll msg
cec-CEC00001:00: cec_transmit_msg_fh: invalid length 0
cec-CEC00001:00: cec_transmit_msg_fh: invalid length 17
cec-CEC00001:00: cec_transmit_msg_fh: can't reply to poll msg
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 1 pa 2.1.0.0
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 1 pa 2.1.0.0
cec-CEC00001:00: physical address: 2.1.0.0, claim 1 logical addresses
cec-CEC00001:00: config: la 4 pa 2.1.0.0
cec-CEC00001:00: cec_transmit_msg_fh: invalid poll message
cec-CEC00001:00: cec_transmit_msg_fh: can't reply to poll msg
cec-CEC00001:00: cec_transmit_msg_fh: invalid length 0
cec-CEC00001:00: cec_transmit_msg_fh: invalid length 17
cec-CEC00001:00: cec_transmit_msg_fh: can't reply to poll msg
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: cec_s_mode: monitor modes require NO_INITIATOR
cec-CEC00001:00: cec_s_mode: MONITOR_ALL not supported
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: cec_transmit_msg_fh: transmit queue full
cec-CEC00001:00: reported physical address 0.0.0.0 for logical address 0
cec-CEC00001:00: reported physical address 2.0.0.0 for logical address 5

--ydh2llnwcdk6kcx3--
