Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55882 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbbBFOIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Feb 2015 09:08:34 -0500
Message-ID: <54D4CAC3.6080900@web.de>
Date: Fri, 06 Feb 2015 15:08:03 +0100
From: steigerungs faktor <steigerungsfaktor@web.de>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Sundtek Media Pro III Europe switching off
References: <54CDFC13.6040908@web.de> <CA+O4pCJBg6ggcKqddeRK6AVkz3HPUgMoKjfx1a-5K6fTNrO5Rg@mail.gmail.com>
In-Reply-To: <CA+O4pCJBg6ggcKqddeRK6AVkz3HPUgMoKjfx1a-5K6fTNrO5Rg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2015 um 14:26 schrieb Markus Rechberger:
> You'd need to show us some logfiles.
>
> echo loglevel=min > /etc/sundtek.conf
> (and reboot)
> or
> /opt/bin/mediaclient --loglevel=min (this will turn on the logfile immediately).
>
> Is the tuner attached to a USB 3.0 port?
>
> What does tvheadend say?
>
> The tuner and drivers are 100% stable and proven with tvheadend, so in
> case tvheadend is blocked something else must be wrong.
>
> Best Regards,
> Markus
>
> On Sun, Feb 1, 2015 at 11:12 AM, steigerungs faktor
> <steigerungsfaktor@web.de> wrote:
Hi.
Sry for the delay, testet quite a bit during nights. And switched from
TVHeadend to VDR. Better used to.

Obviously I have a USB problem, allthough not using 3.0
Will contact Fedora and Sundtek.

Thanks for the trouble

Gunter


If interested, here is the story:

Yesterday, after boot, Sundtek Media Pro was on. Driver loaded. TV
possible, Rec possible. (By the way, not KODI but XBMC Gotham is running
on this Fedora 20.)
Hardware is Gigabyte GA-870A-USB3 Mainboard, Dualcore 3,4 GHz AMD. 4GB
RAM, NVIDIA 9500. NVIDIA driver in use. SSD (reboot is nice).
 
Setting Timer (1) worked with live TV running; at programmed time, vdr
switched channel and recorded.
Interesting: I had live TV on Eurosport, Timer on Tele 5, and could
record Tele5 with Eurosport continuing to show football....
Probably same transponder, and the tuner can split the signals ???
Anyways, Eurosport kept going after Timer end. Tuner had no chance for
pausing (?).
Next Timer (2): Some time later, DasErste.
Eurosport live ended, DasErste was recorded.
Next timer(3) : DasErsteHD, immediately following Timer 2.
Was recorded correctly; obviously again Tuner had no chance for pausing (?).
Yet after rec, live TV was off.
Next Timer (4): hours later. Rec startet, but no data recorded.

This morning no chance of getting xbmc to show tv. "No data from backend."

Reboot, device plugged in.

mediasrv.log:
2015-02-06 09:06:10 [1050] restarting logging
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] read status failure 1041
2015-02-06 09:06:10 [1050] The device just got disconnected from the system
2015-02-06 09:06:10 [1050] Shutting down this device instance
2015-02-06 09:06:10 [1050] USB Transfer problem, shutting down driver
instance (-1 - 19)
2015-02-06 09:06:10 [1050] Stopping Remote Control support
2015-02-06 09:06:10 [1050] Enabling Standby
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] Tuner response error (660)
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [1050] send vendor cmd failed with status --1
2015-02-06 09:06:10 [1050] send vendor cmd failed with status --1
2015-02-06 09:06:10 [1050] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:06:10 [4953] RC: detached remote control
2015-02-06 09:06:10 [1050] clearing id: 0
2015-02-06 09:06:17 [1050] Shutting down driver now
2015-02-06 09:06:17 [1050] Waiting for service thread to complete
2015-02-06 09:07:05 [1086] RC: IR Event /dev/input/event12
2015-02-06 09:07:05 [1095] RC: IR Event /dev/input/event12
2015-02-06 09:11:40 [1048] The device just got disconnected from the system
2015-02-06 09:11:40 [1048] Shutting down this device instance
2015-02-06 09:11:40 [1048] USB Transfer problem, shutting down driver
instance (-1 - 19)
2015-02-06 09:11:40 [1048] Stopping Remote Control support
2015-02-06 09:11:40 [1911] RC: detached remote control
2015-02-06 09:11:40 [1048] clearing id: 0

--------------------------------------------------

Aha. USB problem. Unplugged device, plugged back in without reboot.

mediasrv.log:
all kinds of errors like:
2015-02-06 09:11:41 [1048] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:11:41 [1048] send vendor cmd failed with status --1
2015-02-06 09:11:41 [1048] sending command failed with status fffffffc
(Unknown error -4)
2015-02-06 09:11:41 [1048] sending command failed with status fffffffe
(Unknown error -2)
2015-02-06 09:11:41 [1048] sending command failed with status fffffffd
(Unknown error -3)
2015-02-06 09:11:41 [1048] Tuner communcication error (573)
2015-02-06 09:11:41 [1048] Tuner response error (660)
2015-02-06 09:11:41 [1048] Tuner acknowledge message timed out (527)
2015-02-06 09:11:41 [1048] Tuner response error (660)
2015-02-06 09:11:41 [1048] xouton fail
2015-02-06 09:11:41 [1048] Error loading firmware for demodulator (400)
2015-02-06 09:11:41 [1048] Unable to start demod firmware (426)
2015-02-06 09:11:41 [1048] Unable to read demod chip rev
2015-02-06 09:11:41 [1048] Error reading response from demodulator
2015-02-06 09:11:41 [1048] Unable to set demod property 257
2015-02-06 09:11:41 [1048] Unable to start clock (demod, 344)
2015-02-06 09:11:41 [1048] Powerup problem (384)
2015-02-06 09:11:41 [1048] Unable to read demod part info (443)

plus
-----------------------------------------------------
2015-02-06 09:11:40 [1048] registering ID: 0
2015-02-06 09:11:40 [1048] Using dynamic configuration
2015-02-06 09:11:40 [1048] DTV1 Transfer is set to: Bulk
2015-02-06 09:11:41 [1048] Using Sundtek remote control layout
2015-02-06 09:11:41 [1048] IR Setup
2015-02-06 09:11:41 [1929] RC: IR Event /dev/input/event12
2015-02-06 09:11:41 [1048] Allocation using pg for type 65678
2015-02-06 09:11:41 [1938] RC: IR Event /dev/input/event12
2015-02-06 09:11:41 [1048] attaching DVB-T, DVB-C, DVB-T2
2015-02-06 09:11:41 [1048] demodulator successfully attached (DVB-C)!
2015-02-06 09:11:41 [1048] This device uses the third generation Tuner
2015-02-06 09:11:41 [1048] Power up demodulator
2015-02-06 09:11:41 [1048] Allocation using pg for type 16
2015-02-06 09:11:41 [1048] SETTING PAL/SECAM
2015-02-06 09:11:41 [1048] attaching video decoder
2015-02-06 09:11:41 [1048] Setting frequency: 245250000
2015-02-06 09:11:41 [1048] Setting analogTV Parameters
2015-02-06 09:11:41 [1048] Setting PAL-B
2015-02-06 09:11:41 [1048] unable to set analogtv frequency 424
2015-02-06 09:11:41 [1048] send vendor cmd failed with status --1
2015-02-06 09:11:41 [1048] attaching radio module
2015-02-06 09:11:42 [1048] requesting to tune to frequency: 87900000 4
2015-02-06 09:11:42 [1048] Setting Radio Volume: 219
2015-02-06 09:11:42 [1048] configure urbs for bulk
2015-02-06 09:11:42 [1048] Registering OSS emulation
2015-02-06 09:11:42 [1048] registering: adapter0/0
2015-02-06 09:11:42 [1048] registered virtual: /dev/dvb/adapter0/frontend0
2015-02-06 09:11:42 [1048] registered virtual: /dev/dvb/adapter0/demux0
2015-02-06 09:11:42 [1048] registered virtual: /dev/dvb/adapter0/dvr0
2015-02-06 09:11:42 [1048] registered virtual: /dev/dsp0
2015-02-06 09:11:42 [1048] registered virtual: /dev/video0
2015-02-06 09:11:42 [1048] registered virtual: /dev/vbi0
2015-02-06 09:11:42 [1048] registered virtual: /dev/radio0
2015-02-06 09:11:42 [1048] registered virtual: /dev/rds0
2015-02-06 09:11:42 [1048] Initializing Remote Control Support
2015-02-06 09:11:42 [1048] This system does not support memory mapped
USB transfers
2015-02-06 09:11:42 [1048] Once your system reaches the latest kernel
version the
2015-02-06 09:11:42 [1048] performance will increase automatically
2015-02-06 09:11:42 [1048] The device just got disconnected from the system
2015-02-06 09:11:42 [1048] Shutting down this device instance
2015-02-06 09:11:42 [1048] USB Transfer problem, shutting down driver
instance (-1 - 19)
2015-02-06 09:11:42 [1048] registered virtual: /dev/mediainput0
2015-02-06 09:11:42 [1048] Trying to load ffmpeg codecs
2015-02-06 09:11:42 [1048] could not load libavutil.so
2015-02-06 09:11:42 [1048] could not load libswscale.so
2015-02-06 09:11:42 [1048] could not load libavcodec.so
2015-02-06 09:11:42 [1048] could not load libavformat.so
2015-02-06 09:11:42 [1048] AnalogTV encoding won't be possible in
driver's side
2015-02-06 09:11:42 [1048] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:11:42 [1048] Initialized MediaTV Pro III USB (EU)
2015-02-06 09:11:42 [1048] Driver loaded within 1797 milliseconds
2015-02-06 09:11:42 [1048] Stopping Remote Control support
2015-02-06 09:11:42 [1048] Enabling Standby
2015-02-06 09:11:42 [1048] send vendor cmd failed with status --1
2015-02-06 09:11:42 [1048] send vendor cmd failed with status --1
2015-02-06 09:11:42 [1048] sending command failed with status ffffffff
(Unknown error -1)
2015-02-06 09:11:42 [1952] RC: detached remote control
2015-02-06 09:11:42 [1048] clearing id: 0
2015-02-06 09:11:48 [1048] registering ID: 0
2015-02-06 09:11:48 [1048] Using dynamic configuration
2015-02-06 09:11:48 [1048] DTV1 Transfer is set to: Bulk
2015-02-06 09:11:49 [1048] Using Sundtek remote control layout
2015-02-06 09:11:49 [1048]
2015-02-06 09:11:49 [1048] IR Setup
2015-02-06 09:11:49 [1980] RC: IR Event /dev/input/event12
2015-02-06 09:11:49 [1989] RC: IR Event /dev/input/event12
2015-02-06 09:11:49 [1048] Allocation using pg for type 65678
2015-02-06 09:11:49 [1048] attaching DVB-T, DVB-C, DVB-T2
2015-02-06 09:11:49 [1048] demodulator successfully attached (DVB-C)!
2015-02-06 09:11:49 [1048] This device uses the third generation Tuner
2015-02-06 09:11:49 [1048] Power up demodulator
2015-02-06 09:11:51 [1048] Allocation using pg for type 16
2015-02-06 09:11:51 [1048] SETTING PAL/SECAM
2015-02-06 09:11:51 [1048] SETTING PAL/SECAM
2015-02-06 09:11:51 [1048] attaching video decoder
2015-02-06 09:11:52 [1048] SETTING PAL/SECAM
2015-02-06 09:11:52 [1048] Setting frequency: 245250000
2015-02-06 09:11:52 [1048] Setting analogTV Parameters
2015-02-06 09:11:52 [1048] Setting PAL-B
2015-02-06 09:11:52 [1048] attaching radio module
2015-02-06 09:11:53 [1048] requesting to tune to frequency: 87900000 4
2015-02-06 09:11:53 [1048] Setting Radio Volume: 219
2015-02-06 09:11:53 [1048] configure urbs for bulk
2015-02-06 09:11:53 [1048] Registering OSS emulation
2015-02-06 09:11:53 [1048] registering: adapter0/0
2015-02-06 09:11:53 [1048] registered virtual: /dev/dvb/adapter0/frontend0
2015-02-06 09:11:53 [1048] registered virtual: /dev/dvb/adapter0/demux0
2015-02-06 09:11:53 [1048] registered virtual: /dev/dvb/adapter0/dvr0
2015-02-06 09:11:53 [1048] registered virtual: /dev/dsp0
2015-02-06 09:11:53 [1048] registered virtual: /dev/video0
2015-02-06 09:11:53 [1048] registered virtual: /dev/vbi0
2015-02-06 09:11:53 [1048] registered virtual: /dev/radio0
2015-02-06 09:11:53 [1048] registered virtual: /dev/rds0
2015-02-06 09:11:53 [1048] Initializing Remote Control Support
2015-02-06 09:11:53 [1048] This system does not support memory mapped
USB transfers
2015-02-06 09:11:53 [1048] Once your system reaches the latest kernel
version the
2015-02-06 09:11:53 [1048] performance will increase automatically
2015-02-06 09:11:53 [1048] registered virtual: /dev/mediainput0
2015-02-06 09:11:53 [1048] Trying to load ffmpeg codecs
2015-02-06 09:11:53 [1048] could not load libavutil.so
2015-02-06 09:11:53 [1048] could not load libswscale.so
2015-02-06 09:11:53 [1048] could not load libavcodec.so
2015-02-06 09:11:53 [1048] could not load libavformat.so
2015-02-06 09:11:53 [1048] AnalogTV encoding won't be possible in
driver's side
2015-02-06 09:11:53 [1048] Initialized MediaTV Pro III USB (EU)
2015-02-06 09:11:53 [1048] Driver loaded within 5191 milliseconds
2015-02-06 09:12:08 [1048] Enabling Standby

-----

>> Hi.
>> New to the list, so maybe topic "Sundtek Media Pro III" has been treatet
>> allready.
>> If so, please just send "archives".
>>
>> If not:
>> Setup is the the above Stick, newest driver, Linux (Fedora 20), Kodi
>> with TVHeadend.
>> All fine when initially starting. Shows TV and records shows.
>> Then Timer is set, and stick 'stops working'. I.e.: the timed show is
>> not recorded.
>> Instead Kodi tells me that connection to tvheadend is lost.
>> To gain stick back, reboot is necessary.
>>
>> Any ideas?
>>
>> Gunter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

