Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50420 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdBDMgL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Feb 2017 07:36:11 -0500
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
To: Gregor Jasny <gjasny@googlemail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
 <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
From: Marcel Heinz <quisquilia@gmx.de>
Message-ID: <8792984d-54c9-01a8-0f84-7a1f0312a12f@gmx.de>
Date: Sat, 4 Feb 2017 13:35:47 +0100
MIME-Version: 1.0
In-Reply-To: <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

trying to provide a bit more information:

Am 04.02.2017 um 10:08 schrieb Gregor Jasny:
> Hello,
> 
> On 2/4/17 3:35 AM, Marcel Heinz wrote:
>> After the upgrade from libdvbv5-0 1.10.1-1 to 1.12.2-2, any applications
>> using libdvbv5-0 fail to work with my DVB-S card.
>>
>> [...]
>> Output with new dvb-tools / libdvbv5-0 1.12.2-2:
>>
>> |$ dvbv5-scan -l UNIVERSAL /usr/share/dvb/dvb-s/Astra-19.2e
>> |Using LNBf UNIVERSAL
>> |        Europe
>> |        10800 to 11800 MHz and 11600 to 12700 MHz
>> |	 Dual LO, IF = lowband 9750 MHz, highband 10600	MHz
>> |ERROR    command BANDWIDTH_HZ (5) not found during retrieve
>> |Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
>> |Scanning frequency #1 12551500
>> |ERROR    FE_SET_PROPERTY: Invalid argument
>> |ERROR    dvb_fe_set_parms failed: Invalid argument


Using -vvv doesn't give any more clues:

| Using LNBf UNIVERSAL
|         Universal, Europe
|         10800 to 11800 MHz, LO: 9750 MHz
|         11600 to 12700 MHz, LO: 10600 MHz
| Found dvb demux device: dvb0.demux0
|   path: /dev/dvb/adapter0/demux0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.demux0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| Found dvb dvr device: dvb0.dvr0
|   path: /dev/dvb/adapter0/dvr0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.dvr0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| Found dvb frontend device: dvb0.frontend0
|   path: /dev/dvb/adapter0/frontend0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.frontend0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| Found dvb net device: dvb0.net0
|   path: /dev/dvb/adapter0/net0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.net0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| Selected dvb demux device: dvb0.demux0
|   path: /dev/dvb/adapter0/demux0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.demux0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| using demux 'dvb0.demux0'
| Selected dvb frontend device: dvb0.frontend0
|   path: /dev/dvb/adapter0/frontend0
|   sysfs path:
/sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/dvb/dvb0.frontend0
|   bus addr: pci:0000:09:00.0
|   bus ID: 2103:13d0
| Device Conexant CX24123/CX24109 (/dev/dvb/adapter0/frontend0)
capabilities:
|      CAN_FEC_1_2
|      CAN_FEC_2_3
|      CAN_FEC_3_4
|      CAN_FEC_4_5
|      CAN_FEC_5_6
|      CAN_FEC_6_7
|      CAN_FEC_7_8
|      CAN_FEC_AUTO
|      CAN_INVERSION_AUTO
|      CAN_QPSK
|      CAN_RECOVER
| DVB API Version 5.10, Current v5 delivery system: DVBS
| Supported delivery system:
|     [DVBS]
| Failed to guess country from the current locale setting.
|
| ERROR    command BANDWIDTH_HZ (5) not found during retrieve
| Cannot calc frequency shift. Either bandwidth/symbol-rate is
unavailable (yet).
| Scanning frequency #1 12551500
| frequency: 12551.50 MHz, high_band: 1
| L-Band frequency: 12551.50 MHz (offset = 0.00 MHz)
| ERROR    FE_SET_PROPERTY: Invalid argument
| FREQUENCY = 12551500
| INVERSION = AUTO
| SYMBOL_RATE = 22000000
| INNER_FEC = 5/6
| POLARIZATION = VERTICAL
| DELIVERY_SYSTEM = DVBS
| ERROR    dvb_fe_set_parms failed: Invalid argument
| SEC: set voltage to OFF

The arguments seem plausible to me, but the ioctl still fails with EINVAL.

What might be more interesting is the kernel message produced by the
failed attempt:

| [42607.855196] b2c2_flexcop_pci 0000:09:00.0: DVB: adapter 0 frontend
0 frequency 12551500 out of range (950000..2150000)

This frequency range doesn't look like DVB-S at all...

Regards,
	Marcel



