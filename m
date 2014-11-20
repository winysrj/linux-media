Return-path: <linux-media-owner@vger.kernel.org>
Received: from anke-und-chris.de ([89.110.150.28]:58174 "EHLO v1544.ncsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbaKTMxY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 07:53:24 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Nov 2014 12:53:17 +0000
From: Christopher Scheuring <chris@anke-und-chris.de>
To: Antti Palosaari <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Fwd: Re: Re: Problems with Linux drivers (Debian Jessie kernel
 3.16.0-4)
In-Reply-To: <546D91C3.4070500@iki.fi>
References: <201411191028007188819@dvbsky.net>
 <546CEF67.9060803@anke-und-chris.de> <546D91C3.4070500@iki.fi>
Message-ID: <ce39c06f0e8f4f4adddf805ab6bd49f1@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I yust checked the SNR Level the DVBSky-Card providing with the
drivers from dvbsky.net (media_build-bst-14-141106):

# ./femon -a 0
using '/dev/dvb/adapter0/frontend0'
FE: Montage DS3103/TS2022 (SAT)
status 1f | signal 7323 | snr b064 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK

# ./femon -a 1
using '/dev/dvb/adapter1/frontend0'
FE: Montage DS3103/TS2022 (SAT)
status 1f | signal 7a71 | snr 2a17 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK


Looks "better" than with driver from linuxtv.org via git. And I
don't have any sync problems or video / audio drops.


I currently determined following:
* Using the drivers from dvbsky.net the card is "Montage DS3103/TS2022"
  => Loading FW dvb-fe-ds3103.fw
* With the drivers from linuxtv.org the card is "Montage M88DS3103"
  => Loading FW dvb-demod-m88ds3103.fw


I'm a bit confused... perhaps if I use the linuxtv.org drivers, the
card is recognized wrong and that's the problem?


Regards,
Chris


On Thu, 20 Nov 2014 09:01:23 +0200, Antti Palosaari <crope@iki.fi> wrote:
> Moikka
> According to logs, everything seems to be fine. You could not compare 
> statistics numbers between two drivers. SNR 0096 is 150DEC, which means 
> 15dB, IIRC it was max chip could return for DVB-S.
> 
> No idea about sync etc. problems, are you sure about those? I am pretty 
> sure it works rather well as I haven't got bug reports from PCTV 461e 
> users which has that same demod + tuner.
> 
> regards
> Antti
> 
> 
> 
> On 11/19/2014 09:28 PM, Christopher Scheuring wrote:
>> Hello Antti,
>>
>> the guys from tech@dvbsky.net told me to contact you because of my
>> problems with the drivers for my DVBSKY S952.
>>
>> I attached the whole conversation. Currently the main problem is if i
>> use the current drivers via
>> git(http://git.linuxtv.org/cgit.cgi/media_build.git/about/) my single
>> TT-Budget card works fine. But the signal from the DVDBSky S952 is very
>> worse: Sync problems, bad SNR, drops on video and audio... If I use the
>> driver dvbsky.net provides (media_build-bst-14-141106), the signal on
>> booth tuners is fine - but then my TT-Budget doesn't works anymore (see
>> end of this mail aka starting the conversation with tech@dvbsky.net).
>>
>> Do you have any ideas, how I could fix this problem? Before I updated
my
>> system (from Debian Wheezy with Kernel 3.2.0-4-amd64 everything was
fine
>> with both cards.
>>
>>
>> If you need more detailed information, please let me know, so I could
>> provide them as soon as possible,
>>
>> Thanks a lot and best wishes
>> Chris
>>
>>
>> -------- Weitergeleitete Nachricht --------
>> Betreff: 	Re: Re: Problems with Linux drivers (Debian Jessie kernel
>> 3.16.0-4)
>> Datum: 	Wed, 19 Nov 2014 10:28:06 +0800
>> Von: 	tech <tech@dvbsky.net>
>> An: 	Christopher Scheuring <chris@anke-und-chris.de>
>>
>>
>>
>> Hello,
>> Could you report this problem to Antti Palosaari crope@iki.fi
>> <mailto:crope@iki.fi> and cc to linux-media@vger.kernel.org ?
>> Antti is the author/maintainer of M88DS3103 driver.Montage M88DS3103
(SAT)*
>> Please list the compare result of the driver from DVBSky site and
>> Linuxtv.org.
>> Max from DVBSky also register linux-media mail list.
>> He will get your report and co-work with Antti to fix this issue of
>> M88DS3103 driver from Linuxtv.org.
>> BR,
>> tech
>>
------------------------------------------------------------------------
>> *From:* Christopher Scheuring<chris@anke-und-chris.de
>> <mailto:chris@anke-und-chris.de>>
>> *Date:* 2014-11-19  04:42:10
>> *To:* tech<tech@dvbsky.net <mailto:tech@dvbsky.net>>
>> *Cc:* <>
>> *Subject:* Re: Problems with Linux drivers (Debian Jessie kernel
>> 3.16.0-4)
>> Hello,
>>
>> with the drivers from linuxtv.org and the firmware provided by your
>> site, both cards work.
>>
>> But the DVBSky card (Montage M88DS3103) do now have a really bad
>> SNR!TT-Budget C-1501 works as expected. See the output of femon - the
>> signal of the DVBSky card was excellent with the drivers from you
>> site... Any idea, what could cause the problem? TV signal provided by
>> the DVBSky sometimes drops :-(
>>
>> xxx@xxx:~/VDR/linuxtv-dvb-apps-1.1.1/util/szap$ ./femon -a1
>> *using '/dev/dvb/adapter1/frontend0'**
>> **FE: Montage M88DS3103 (SAT)*
>> status 1f | signal 585e | *snr 0096* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>> status 1f | signal 585e | *snr 0096* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>>
>> xxx@xxx:~/VDR/linuxtv-dvb-apps-1.1.1/util/szap$ ./femon -a2
>> *using '/dev/dvb/adapter2/frontend0'**
>> **FE: Montage M88DS3103 (SAT)*
>> status 1f | signal 6c07 | *snr 0096* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>> status 1f | signal 6c07 | *snr 0096* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>>
>> xxx@xxx:~/VDR/linuxtv-dvb-apps-1.1.1/util/szap$ ./femon -a0
>> *using '/dev/dvb/adapter0/frontend0'**
>> **FE: STV090x Multistandard (SAT)*
>> status 1f | signal a3d6 | *snr bccb* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>> status 1f | signal a3d6 | *snr bd2e* | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>>
>> Here the dmesg output of the loaded drivers and firmware of the DVBSky
>> Card:
>>
>> dmesg | egrep "cx23885|i2c|m88ds3103"
>>      c02ef64aab828d80040b5dce934729312e698c33 [media] cx23885: add
>> DVBSky T982(Dual DVB-T2/T/C) support
>>      9aa785b1500a7bd40b736f31b341e204bd5fb174 [media] add lgdt330x
>> device name i2c_devs array
>>      c02ef64aab828d80040b5dce934729312e698c33 [media] cx23885: add
>> DVBSky T982(Dual DVB-T2/T/C) support
>>      9aa785b1500a7bd40b736f31b341e204bd5fb174 [media] add lgdt330x
>> device name i2c_devs array
>>      c02ef64aab828d80040b5dce934729312e698c33 [media] cx23885: add
>> DVBSky T982(Dual DVB-T2/T/C) support
>>      9aa785b1500a7bd40b736f31b341e204bd5fb174 [media] add lgdt330x
>> device name i2c_devs array
>> [   16.396426] cx23885 driver version 0.0.4 loaded
>> [   16.396558] CORE cx23885[0]: subsystem: 4254:0952, board: DVBSky
S952
>> [card=50,autodetected]
>> [   16.838409] cx25840 4-0044: cx23885 A/V decoder found @ 0x88
>> (cx23885[0])
>> [   16.909538] cx25840 4-0044: firmware: direct-loading firmware
>> v4l-cx23885-avcore-01.fw
>> [   17.518086] cx25840 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
>> (16382 bytes)
>> [   17.533358] cx23885_dvb_register() allocating 1 frontend(s)
>> [   17.533362] cx23885[0]: cx23885 based dvb card
>> [   17.670143] i2c i2c-3: m88ds3103_attach: chip_id=70
>> [   17.672970] i2c i2c-3: Added multiplexed i2c bus 5
>> [   17.780353] DVB: registering new adapter (cx23885[0])
>> [   17.780357] cx23885 0000:04:00.0: DVB: registering adapter 1
frontend
>> 0 (Montage M88DS3103)...
>> [   17.807503] cx23885_dvb_register() allocating 1 frontend(s)
>> [   17.807505] cx23885[0]: cx23885 based dvb card
>> [   17.807987] i2c i2c-2: m88ds3103_attach: chip_id=70
>> [   17.810783] i2c i2c-2: Added multiplexed i2c bus 6
>> [   17.866021] DVB: registering new adapter (cx23885[0])
>> [   17.866025] cx23885 0000:04:00.0: DVB: registering adapter 2
frontend
>> 0 (Montage M88DS3103)...
>> [   17.893182] cx23885_dev_checkrevision() Hardware revision = 0xa5
>> [   17.893187] cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 19,
>> latency: 0, mmio: 0xfda00000
>> [   51.512292] i2c i2c-3: m88ds3103: found a 'Montage M88DS3103' in
cold
>> state
>> [   51.818948] cx23885 0000:04:00.0: firmware: direct-loading firmware
>> dvb-demod-m88ds3103.fw
>> [   51.818958] i2c i2c-3: m88ds3103: downloading firmware from file
>> 'dvb-demod-m88ds3103.fw'
>> [   52.720270] i2c i2c-3: m88ds3103: found a 'Montage M88DS3103' in
warm
>> state
>> [   52.720276] i2c i2c-3: m88ds3103: firmware version 3.B
>> [   52.734588] i2c i2c-2: m88ds3103: found a 'Montage M88DS3103' in
cold
>> state
>> [   52.734618] cx23885 0000:04:00.0: firmware: direct-loading firmware
>> dvb-demod-m88ds3103.fw
>> [   52.734621] i2c i2c-2: m88ds3103: downloading firmware from file
>> 'dvb-demod-m88ds3103.fw'
>> [   53.636110] i2c i2c-2: m88ds3103: found a 'Montage M88DS3103' in
warm
>> state
>> [   53.636115] i2c i2c-2: m88ds3103: firmware version 3.B
>>
>>
>> Thanks a lot for your help.
>>
>> Regards,
>> Chris
>>
>>
>>
>> Am 18.11.2014 um 03:27 schrieb tech:
>>> Hello,
>>> Could you get the media code from linuxtv.org?
>>> and build this driver and install.
>>> http://git.linuxtv.org/cgit.cgi/media_build.git/about/
>>> BR,
>>> tech
>>>
------------------------------------------------------------------------
>>> *From:* Christopher Scheuring<chris@anke-und-chris.de
>>> <mailto:chris@anke-und-chris.de>>
>>> *Date:* 2014-11-18  06:07:27
>>> *To:* tech<tech@dvbsky.net <mailto:tech@dvbsky.net>>
>>> *Cc:* <>
>>> *Subject:* Problems with Linux drivers (Debian Jessie kernel 3.16.0-4)
>>> Hi,
>>>
>>> I reinstalled after updating my system with the Linux drivers for the
>>> dvbsky cards provided by your site (media_build-bst-14-141106).
>>>
>>> Compiling with the build_x64.sh script was successfully and I could
>>> install the needed drivers via make install. After that the Conexant
>>> Systems CX23885 (DVBSKY S952) card works perfectly.
>>>
>>> Unfortunately after installing the drivers my Philips Semiconductors
>>> SAA7146 (TT-Budget C-1501) card doesn't runs anymore - the card worked
>>> perfectly before installing the provided drivers from your page!
>>>
>>> If got following error message in the kernel-log:
>>> [ 14.916814] budget_core: disagrees about version of symbol
>>> dvb_dmxdev_init
>>> [   14.916819] budget_core: Unknown symbol dvb_dmxdev_init (err -22)
>>> [   14.916827] budget_core: disagrees about version of symbol
>>> saa7146_wait_for_debi_done
>>> [   14.916829] budget_core: Unknown symbol saa7146_wait_for_debi_done
>>> (err -22)
>>> [   14.916832] budget_core: disagrees about version of symbol
>>> saa7146_i2c_adapter_prepare
>>> [   14.916833] budget_core: Unknown symbol saa7146_i2c_adapter_prepare
>>> (err -22)
>>> [   14.916840] budget_core: disagrees about version of symbol
>>> dvb_register_adapter
>>> [   14.916841] budget_core: Unknown symbol dvb_register_adapter (err
>>> -22)
>>> [   14.916846] budget_core: disagrees about version of symbol
>>> dvb_dmx_swfilter_packets
>>> [   14.916848] budget_core: Unknown symbol dvb_dmx_swfilter_packets
>>> (err -22)
>>> [   14.916862] budget_core: disagrees about version of symbol
>>> dvb_dmx_release
>>> [   14.916864] budget_core: Unknown symbol dvb_dmx_release (err -22)
>>> [   14.916869] budget_core: disagrees about version of symbol
>>> dvb_net_init
>>> [   14.916871] budget_core: Unknown symbol dvb_net_init (err -22)
>>> [   14.916875] budget_core: disagrees about version of symbol
>>> dvb_dmxdev_release
>>> [   14.916877] budget_core: Unknown symbol dvb_dmxdev_release (err
-22)
>>> [   14.916890] budget_core: disagrees about version of symbol
>>> dvb_net_release
>>> [   14.916892] budget_core: Unknown symbol dvb_net_release (err -22)
>>> [   14.916896] budget_core: disagrees about version of symbol
>>> saa7146_setgpio
>>> [   14.916897] budget_core: Unknown symbol saa7146_setgpio (err -22)
>>> [   14.916902] budget_core: disagrees about version of symbol
>>> dvb_unregister_adapter
>>> [   14.916904] budget_core: Unknown symbol dvb_unregister_adapter (err
>>> -22)
>>> [   14.916907] budget_core: disagrees about version of symbol
>>> dvb_dmx_init
>>> [   14.916908] budget_core: Unknown symbol dvb_dmx_init (err -22)
>>>
>>>
>>>
>>> I think something went wrong with the provided driver packes or some
>>> drivers where overwritten, and some necessary not... I couldn't found
>>> any solution in the internet.
>>>
>>> Here my relevant system-infos:
>>> Linux XXX 3.16.0-4-amd64 #1 SMP Debian 3.16.7-2 (2014-11-06) x86_64
>>> GNU/Linux
>>>
>>> The needed kernel header files 3.16.0-4-amd64 are installed.
>>>
>>> lsmod | grep dvb
>>> rc_dvbsky              12399  0
>>> dvbsky_m88ds3103       25614  2
>>> videobuf_dvb           12762  1 cx23885
>>> videobuf_core          21832  3 videobuf_dma_sg,cx23885,videobuf_dvb
>>> dvb_core              102010  3 cx23885,altera_ci,videobuf_dvb
>>> i2c_core               46012  11
>>>
drm,i2c_i801,cx23885,cx25840,dvbsky_m88ds3103,nvidia,v4l2_common,tveeprom,ttpci_eeprom,tda18271,videodev
>>> rc_core                22404  13
>>>
ir_sharp_decoder,lirc_dev,cx23885,ir_lirc_codec,ir_rc5_decoder,ir_nec_decoder,ir_sony_decoder,rc_dvbsky,ir_mce_kbd_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_sanyo_decoder
>>>
>>>
>>>
>>> Could you provide me any help for a solution getting the SAA7146
>>> (TT-Budget C-1501) card working again with the kernel 3.16.0-4? With
>>> the kernel 3.2.0-4-amd64 (with Debian wheezy) and the drivers
>>> media_build-bst-13-140526 I didn't had the problems... everything
>>> worked fine. Downgrading is no solution :-)
>>>
>>> Attached the complete dmesg protocol.
>>>
>>>
>>> Thanks a lot!
>>>
>>> Regards,
>>> Chris
>>>
>>
>>
>>

-- 
Christopher Scheuring *** chris@anke-und-chris.de
