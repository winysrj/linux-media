Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:53950 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2IJO3j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 10:29:39 -0400
Message-ID: <504DF950.8060006@schinagl.nl>
Date: Mon, 10 Sep 2012 16:29:36 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi> <504D17AA.8020807@schinagl.nl> <504D1859.5050201@iki.fi> <504DB9D4.6020502@schinagl.nl> <504DD311.7060408@iki.fi>
In-Reply-To: <504DD311.7060408@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------010106080405010704020804"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010106080405010704020804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10-09-12 13:46, Antti Palosaari wrote:
> On 09/10/2012 12:58 PM, Oliver Schinagl wrote:
>> Changed the address as recommended, which after reading 7bit and 8bit
>> addressing makes perfect sense (drop the r/w bit and get the actual
>> address).
>>
>>   static struct fc2580_config af9035_fc2580_config = {
>> -       .i2c_addr = 0xac,
>> +       .i2c_addr = 0x56,
>>          .clock = 16384000,
>>   };
>>
>>
>> So now the address should actually be correct ;)
>>
>> Unfortunately, nothing. What other debug options do I need to enable
>> besides CONFIG_DVB_USB_DEBUG to get more interesting output?
>
> For me it sees something happens as there is no I2C error seen anymore.
>
> AF9035 driver uses Kernel dynamic debugs. CONFIG_DVB_USB_DEBUG is 
> legacy and proprietary DVB subsystem debug which should not be used 
> anymore.
> You could order dynamic debugs like that:
> modprobe dvb_usb_af9035; echo -n 'module dvb_usb_af9035 +p' > 
> /sys/kernel/debug/dynamic_debug/control
>
> For tuner, demod and dvb_usbv2 similarly if needed.
I've did and added output from control and dmesg output.

I don't exactly know how to read the dynamic debug output, the only 
thing that jumped out at me, was:
drivers/media/dvb-frontends/af9033.c:327 [af9033]af9033_init =p "%s: 
unsupported tuner ID=%d\012"

So I will search and see where in the driver the supported tunerID's are 
stored and fix that.

Any other pointers/things you see I should look at?
>
>> Anyway, dmesg reports the following.
>> [60.071538] usb 1-3: new high-speed USB device number 3 using ehci_hcd
>> [60.192627] usb 1-3: New USB device found, idVendor=0b05, idProduct=1779
>> [60.192638] usb 1-3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [60.192646] usb 1-3: Product: AF9035A USB Device
>> [60.192652] usb 1-3: Manufacturer: Afa Technologies Inc.
>> [60.192657] usb 1-3: SerialNumber: AF010asdfasdf12314
>> [60.198686] input: Afa Technologies Inc. AF9035A USB Device as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.1/input/input14
>> [60.198832] hid-generic 0003:0B05:1779.0003: input: USB HID v1.01
>> Keyboard [Afa Technologies Inc. AF9035A USB Device] on
>> usb-0000:00:12.2-3/input1
>> [60.263893] usbcore: registered new interface driver dvb_usb_af9035
>> [60.264605] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in cold 
>> state
>> [60.273924] usb 1-3: dvb_usbv2: downloading firmware from file
>> 'dvb-usb-af9035-02.fw'
>> [60.584267] dvb_usb_af9035: firmware version=11.5.9.0
>> [60.584287] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in warm 
>> state
>> [60.586802] usb 1-3: dvb_usbv2: will pass the complete MPEG2 transport
>> stream to the software demuxer
>> [60.586871] DVB: registering new adapter (Asus U3100Mini Plus)
>> [60.595637] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
>> [60.595654] usb 1-3: DVB: registering adapter 0 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [60.599889] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while
>> loading driver (-19)
>>
>> I then tried using the firmware that came with said driver, as the
>> version seems slightly different/newer.
>>
>> #define FW_RELEASE_VERSION "v8_8_63_0"
>>
>> #define DVB_LL_VERSION1 11
>> #define DVB_LL_VERSION2 22
>> #define DVB_LL_VERSION3 12
>> #define DVB_LL_VERSION4 0
>>
>> #define DVB_OFDM_VERSION1 5
>> #define DVB_OFDM_VERSION2 66
>> #define DVB_OFDM_VERSION3 12
>> #define DVB_OFDM_VERSION4 0
>>
>> (which also gets displayed when loading the firmware, originally on the
>> old kernel).
>>
>> This however results in a hard lock/dump when plugging in the device.
>> Are there certain size restrictions etc? What I did to obtain said
>> firmware was write a simple program that reads the array, static
>> unsigned char Firmware_codes[] and outputs the read bytes to a file.
>>  From what I saw from the -02 firmware, the first few bytes are
>> identical (header?) so should be right procedure.
>
> Firmare surely works but you make some mistake. I have extracted those 
> from  the windows driver.
>
> http://palosaari.fi/linux/v4l-dvb/firmware/af9035/
>
A link to, or your files should be listed at the linuxdvb firmware 
download page ;)

I noticed your latest firmware is way newer then the one I had. So 
deffinatly using that one.
>> Btw, when using the -02 firmware and trying to unload the af9033 module,
>> either with or without the stick plugged in, it just hangs there for a
>> long time. Reboot fails too (it hangs at trying to disable swap). Only a
>> sys-req-reisub successfully reboots.
>>
>> oliver
>
>
> Antti

Oliver
>>
>>
>> On 09/10/12 00:29, Antti Palosaari wrote:
>>> On 09/10/2012 01:26 AM, Oliver Schinagl wrote:
>>>> On 09/09/12 23:51, Antti Palosaari wrote:
>>>>> On 09/09/2012 11:49 PM, Oliver Schinagl wrote:
>>>>>> Hi All/Antti,
>>>>>>
>>>>>> I used Antti's previous patch to try to get some support in for the
>>>>>> Asus
>>>>>> MyCinema U3100Mini Plus as it uses a supported driver (af9035) 
>>>>>> and now
>>>>>> supported tuner (FCI FC2580).
>>>>>>
>>>>>> It compiles fine and almost works :(
>>>>>>
>>>>>> Here's what I get, which I have no idea what causes it.
>>>>>>
>>>>>> dmesg output:
>>>>>> [ 380.677434] usb 1-3: New USB device found, idVendor=0b05,
>>>>>> idProduct=1779
>>>>>> [ 380.677445] usb 1-3: New USB device strings: Mfr=1, Product=2,
>>>>>> SerialNumber=3
>>>>>> [ 380.677452] usb 1-3: Product: AF9035A USB Device
>>>>>> [ 380.677458] usb 1-3: Manufacturer: Afa Technologies Inc.
>>>>>> [ 380.677463] usb 1-3: SerialNumber: AF01020abcdef12301
>>>>>> [ 380.683361] input: Afa Technologies Inc. AF9035A USB Device as
>>>>>> /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.1/input/input15
>>>>>> [ 380.683505] hid-generic 0003:0B05:1779.0004: input: USB HID v1.01
>>>>>> Keyboard [Afa Technologies Inc. AF9035A USB Device] on
>>>>>> usb-0000:00:12.2-3/input1
>>>>>> [ 380.703807] usbcore: registered new interface driver 
>>>>>> dvb_usb_af9035
>>>>>> [ 380.704553] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in
>>>>>> cold
>>>>>> state
>>>>>> [ 380.705075] usb 1-3: dvb_usbv2: downloading firmware from file
>>>>>> 'dvb-usb-af9035-02.fw'
>>>>>> [ 381.014996] dvb_usb_af9035: firmware version=11.5.9.0
>>>>>> [ 381.015018] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in
>>>>>> warm
>>>>>> state
>>>>>> [ 381.017172] usb 1-3: dvb_usbv2: will pass the complete MPEG2
>>>>>> transport stream to the software demuxer
>>>>>> [ 381.017242] DVB: registering new adapter (Asus U3100Mini Plus)
>>>>>> [ 381.037184] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
>>>>>> [ 381.037200] usb 1-3: DVB: registering adapter 0 frontend 0 
>>>>>> (Afatech
>>>>>> AF9033 (DVB-T))...
>>>>>> [ 381.044197] i2c i2c-1: fc2580: i2c rd failed=-5 reg=01 len=1
>>>>>> [ 381.044357] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while
>>>>>> loading driver (-19)
>>>>>
>>>>> I2C communication to tuner chip does not work at all. It tries to 
>>>>> read
>>>>> chip id register but fails. If you enable debugs you will see which
>>>>> error status af9035 reports.
>>>> CONFIG_DVB_USB_DEBUG was enabled, but nothing extra :(
>>>>
>>>>>
>>>>> There is likely 3 possibilities:
>>>>> 1) wrong I2C address
>>>> Well as linked before, I used it from the 'official' driver, where it
>>>> says:
>>>> #define FC2580_ADDRESS 0xAC
>>>>
>>>> grepping the entire source of theirs, I then found this in FC2580.c
>>>> TunerDescription tuner_FC2580 = {
>>>> FC2580_open, /** Function to open tuner. */
>>>> FC2580_close, /** Function to close tuner. */
>>>> FC2580_set, /** Function set frequency. */
>>>> FC2580_scripts, /** Scripts. */
>>>> FC2580_scriptSets, /** Length of scripts. */
>>>> FC2580_ADDRESS, /** The I2C address of tuner. */
>>>> 1, /** Valid length of tuner register. */
>>>> 0, /** IF frequency of tuner. */
>>>> True, /** Spectrum inversion. */
>>>> 0x32, /** tuner id */
>>>> };
>>>>
>>>> The only other thing that I recognize is the scripts, which is some 
>>>> init
>>>> code (which I asked about below, which should also be right, unless I
>>>> made a typo) and the tuner id, which is the first thing in the script
>>>> and in my patch defined as AF9033_TUNER_FC2580. No idea of its
>>>> significance :)
>>>>
>>>>> 2) wrong GPIOs
>>>>> * tuner is not powered on or it is on standby
>>>> How/where would I check that?
>>>>
>>>>> 3) wrong firmware
>>>>> * it very unlikely that even wrong firmware fails basic I2C...
>>>> I know there's a few versions right? the 01 02 etc? But that is mostly
>>>> in relation with the af9035 mostly right?
>>>>
>>>>>
>>>>>> using the following modules.
>>>>>> fc2580 4189 -1
>>>>>> af9033 10266 0
>>>>>> dvb_usb_af9035 8924 0
>>>>>> dvb_usbv2 11388 1 dvb_usb_af9035
>>>>>> dvb_core 71756 1 dvb_usbv2
>>>>>> rc_core 10583 2 dvb_usbv2,dvb_usb_af9035
>>>>>>
>>>>>> I'm supprised though that dvb-pll isn't there. Wasn't that a
>>>>>> requirement? [1]
>>>>>
>>>>> No. dvb-pll is used for old simple 4-byte PLLs. FCI FC2580 is modern
>>>>> silicon tuner. There is PLL used inside FC2580 for frequency
>>>>> synthesizer
>>>>> but no dvb-pll needed as all calculations are done inside that 
>>>>> driver.
>>>>> Silicon tuners are so much more complicated to program than old 
>>>>> 4-byte
>>>>> PLLs, thus own driver is needed for each silicon tuner chip.
>>>> Ah, well then the wiki needs a small update ;)
>>>>>
>>>>>> For the tuner 'script' firmware/init bit, I used the 'official' 
>>>>>> driver
>>>>>> [2].
>>>>>>
>>>>>> Also the i2c-addr and clock comes from these files.
>>>>>
>>>>> Aaah, now I see. At least I2C address is wrong. You use 0xac but 
>>>>> should
>>>>> be 0x56. There is wrong "8-bit" address used. 0xac >> 1 == 0x56.
>>>> That I don't understand (as I wrote above) 0xac 'should' be the 
>>>> correct,
>>>> but appearantly it needs to be shifted. Why?
>>>
>>> Because it is wrong in vendor driver you look. I2C addresses are 7 bit
>>> long and LSB bit used for direction (read or write). Try to search some
>>> I2C tutorials. This kind of wrong I2C addresses are called usually 
>>> 8-bit
>>> I2C address.
>>>
>>>>
>>>>>
>>>>>
>>>>> 16384000 (16.384MHz) is FC2580 internal clock what I understand. It
>>>>> should be OK. I suspect that everyone uses it for DVB-T to save
>>>>> components / make design simple.
>>>> I would assume so, since also that is in the original sources; 
>>>> fc2580.c
>>>> lists it as:
>>>> #define FREQ_XTAL 16384 //16.384MHz
>>>>
>>>>>
>>>>>> One minor questions I have regarding the recently submitted RTL and
>>>>>> AF9033 drivers, is one uses AF9033_TUNER_* whereas the other uses
>>>>>> TUNER_RTL2832_*. Any reason for this? It just confused me is all.
>>>>>
>>>>> It is just naming issue driver, driver author decision. Usually names
>>>>> start with driver name letters (in that case RTL28XXU_). It is not 
>>>>> big
>>>>> issue for variable names unless it is too "general" to conflict some
>>>>> library. For function names driver names prefix (rtl28xxu_) should be
>>>>> used as it eases debugging (example ooops is dumped showing function
>>>>> names).
>>>>
>>>> Ok I will test the shifted i2c address and try that.
>>>>>
>>>>>
>>>>> Antti
>>>>>
>>>>>>
>>>>>> Oliver
>>>>>>
>>>>>> [1] http://linuxtv.org/wiki/index.php/DVB_via_USB#Introduction
>>>>>> [2] 
>>>>>> http://git.schinagl.nl/AF903x_SRC.git/tree/api/FCI_FC2580_Script.h
>>>> <snipped patch>
>>>
>>>
>>
>
>


--------------010106080405010704020804
Content-Type: text/x-log;
 name="debug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debug.log"

drivers/media/tuners/fc2580.c:448 [fc2580]fc2580_release =p "%s:\012"
drivers/media/tuners/fc2580.c:403 [fc2580]fc2580_init =p "%s: failed=%d\012"
drivers/media/tuners/fc2580.c:383 [fc2580]fc2580_init =p "%s:\012"
drivers/media/tuners/fc2580.c:429 [fc2580]fc2580_sleep =p "%s: failed=%d\012"
drivers/media/tuners/fc2580.c:412 [fc2580]fc2580_sleep =p "%s:\012"
drivers/media/tuners/fc2580.c:374 [fc2580]fc2580_set_params =p "%s: failed=%d\012"
drivers/media/tuners/fc2580.c:360 [fc2580]fc2580_set_params =p "%s: loop=%i\012"
drivers/media/tuners/fc2580.c:133 [fc2580]fc2580_set_params =p "%s: delivery_system=%d frequency=%d bandwidth_hz=%d\012"
drivers/media/tuners/fc2580.c:437 [fc2580]fc2580_get_if_frequency =p "%s:\012"
drivers/media/tuners/fc2580.c:516 [fc2580]fc2580_attach =p "%s: failed=%d\012"
drivers/media/tuners/fc2580.c:499 [fc2580]fc2580_attach =p "%s: chip_id=%02x\012"
drivers/media/dvb-frontends/af9033.c:355 [af9033]af9033_init =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:327 [af9033]af9033_init =p "%s: unsupported tuner ID=%d\012"
drivers/media/dvb-frontends/af9033.c:303 [af9033]af9033_init =p "%s: load tuner specific settings\012"
drivers/media/dvb-frontends/af9033.c:292 [af9033]af9033_init =p "%s: load ofsm settings\012"
drivers/media/dvb-frontends/af9033.c:258 [af9033]af9033_init =p "%s: adc=%d adc_cw=%06x\012"
drivers/media/dvb-frontends/af9033.c:240 [af9033]af9033_init =p "%s: clock=%d clock_cw=%08x\012"
drivers/media/dvb-frontends/af9033.c:408 [af9033]af9033_sleep =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:382 [af9033]af9033_sleep =p "%s: loop=%d\012"
drivers/media/dvb-frontends/af9033.c:185 [af9033]af9033_div =p "%s: a=%d b=%d x=%d r=%d r=%x\012"
drivers/media/dvb-frontends/af9033.c:168 [af9033]af9033_div =p "%s: a=%d b=%d x=%d\012"
drivers/media/dvb-frontends/af9033.c:546 [af9033]af9033_set_frontend =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:446 [af9033]af9033_set_frontend =p "%s: invalid bandwidth_hz\012"
drivers/media/dvb-frontends/af9033.c:432 [af9033]af9033_set_frontend =p "%s: frequency=%d bandwidth_hz=%d\012"
drivers/media/dvb-frontends/af9033.c:673 [af9033]af9033_get_frontend =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:558 [af9033]af9033_get_frontend =p "%s\012"
drivers/media/dvb-frontends/af9033.c:719 [af9033]af9033_read_status =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:795 [af9033]af9033_read_signal_strength =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:773 [af9033]af9033_read_snr =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:839 [af9033]af9033_update_ch_stat =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:885 [af9033]af9033_i2c_gate_ctrl =p "%s: failed=%d\012"
drivers/media/dvb-frontends/af9033.c:876 [af9033]af9033_i2c_gate_ctrl =p "%s: enable=%d\012"
drivers/media/dvb-frontends/af9033.c:899 [af9033]af9033_attach =p "%s:\012"
drivers/media/rc/rc-main.c:517 [rc_core]rc_g_keycode_from_table =_ "%s: %s: scancode 0x%04x keycode 0x%02x\012"
drivers/media/rc/rc-main.c:647 [rc_core]ir_do_keydown =_ "%s: %s: key down event, key 0x%04x, scancode 0x%04x\012"
drivers/media/rc/rc-main.c:536 [rc_core]ir_do_keyup =_ "%s: keyup key 0x%04x\012"
drivers/media/rc/rc-main.c:786 [rc_core]show_protocols =_ "%s: allowed - 0x%llx, enabled - 0x%llx\012"
drivers/media/rc/rc-main.c:923 [rc_core]store_protocols =_ "%s: Current protocol(s): 0x%llx\012"
drivers/media/rc/rc-main.c:908 [rc_core]store_protocols =_ "%s: Error setting protocols to 0x%llx\012"
drivers/media/rc/rc-main.c:899 [rc_core]store_protocols =_ "%s: Protocol not specified\012"
drivers/media/rc/rc-main.c:883 [rc_core]store_protocols =_ "%s: Unknown protocol: '%s'\012"
drivers/media/rc/rc-main.c:848 [rc_core]store_protocols =_ "%s: Protocol switching not supported\012"
drivers/media/rc/rc-main.c:230 [rc_core]ir_update_mapping =_ "%s: #%d: %s scan 0x%04x with key 0x%04x\012"
drivers/media/rc/rc-main.c:222 [rc_core]ir_update_mapping =_ "%s: #%d: Deleting scan 0x%04x\012"
drivers/media/rc/rc-main.c:188 [rc_core]ir_resize_table =_ "%s: Failed to kmalloc %u bytes\012"
drivers/media/rc/rc-main.c:180 [rc_core]ir_resize_table =_ "%s: Shrinking table to %u bytes\012"
drivers/media/rc/rc-main.c:174 [rc_core]ir_resize_table =_ "%s: Growing table to %u bytes\012"
drivers/media/rc/rc-main.c:134 [rc_core]ir_create_table =_ "%s: Allocated space for %u keycode entries (%u bytes)\012"
drivers/media/rc/rc-main.c:381 [rc_core]ir_setkeytable =_ "%s: Allocated space for %u keycode entries (%u bytes)\012"
drivers/media/rc/rc-main.c:1131 [rc_core]rc_register_device =_ "%s: Registered rc%ld (driver: %s, remote: %s, mode %s)\012"
drivers/media/rc/rc-main.c:1110 [rc_core]rc_register_device =_ "%s: Loading raw decoders\012"
drivers/media/rc/rc-main.c:1163 [rc_core]rc_unregister_device =_ "%s: Freed keycode table\012"
drivers/media/rc/ir-raw.c:91 [rc_core]ir_raw_event_store =_ "%s: sample: (%05dus %s)\012"
drivers/media/rc/ir-raw.c:203 [rc_core]ir_raw_event_set_idle =_ "%s: %s idle mode\012"
drivers/media/dvb-core/dvb_frontend.c:2475 [dvb_core]dvb_frontend_suspend =_ "%s: adap=%d fe=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2493 [dvb_core]dvb_frontend_resume =_ "%s: adap=%d fe=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2635 [dvb_core]dvb_validate_params_dvbt =_ "%s: code_rate_LP=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2621 [dvb_core]dvb_validate_params_dvbt =_ "%s: code_rate_LP=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2603 [dvb_core]dvb_validate_params_dvbt =_ "%s: code_rate_HP=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2589 [dvb_core]dvb_validate_params_dvbt =_ "%s: hierarchy=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2576 [dvb_core]dvb_validate_params_dvbt =_ "%s: guard_interval=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2563 [dvb_core]dvb_validate_params_dvbt =_ "%s: modulation=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2551 [dvb_core]dvb_validate_params_dvbt =_ "%s: transmission_mode=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2540 [dvb_core]dvb_validate_params_dvbt =_ "%s: bandwidth_hz=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2529 [dvb_core]dvb_validate_params_dvbt =_ "%s: frequency=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2519 [dvb_core]dvb_validate_params_dvbt =_ "%s: delivery_system=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2512 [dvb_core]dvb_validate_params_dvbt =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2754 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: fec_inner=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2739 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: guard_interval=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2723 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: modulation=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2710 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: transmission_mode=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2695 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: dvbt2_plp_id=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2684 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: bandwidth_hz=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2670 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: frequency=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2655 [dvb_core]dvb_validate_params_dvbt2 =_ "%s: delivery_system=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2648 [dvb_core]dvb_validate_params_dvbt2 =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2808 [dvb_core]dvb_validate_params_dvbc_annex_a =_ "%s: modulation=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2794 [dvb_core]dvb_validate_params_dvbc_annex_a =_ "%s: symbol_rate=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2786 [dvb_core]dvb_validate_params_dvbc_annex_a =_ "%s: frequency=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2773 [dvb_core]dvb_validate_params_dvbc_annex_a =_ "%s: delivery_system=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2766 [dvb_core]dvb_validate_params_dvbc_annex_a =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2905 [dvb_core]dvb_validate_params_dtmb =_ "%s: interleaving=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2894 [dvb_core]dvb_validate_params_dtmb =_ "%s: fec_inner=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2881 [dvb_core]dvb_validate_params_dtmb =_ "%s: guard_interval=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2869 [dvb_core]dvb_validate_params_dtmb =_ "%s: transmission_mode=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2858 [dvb_core]dvb_validate_params_dtmb =_ "%s: modulation=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2844 [dvb_core]dvb_validate_params_dtmb =_ "%s: bandwidth_hz=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2835 [dvb_core]dvb_validate_params_dtmb =_ "%s: frequency=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2827 [dvb_core]dvb_validate_params_dtmb =_ "%s: delivery_system=%d\012"
drivers/media/dvb-core/dvb_frontend.c:2820 [dvb_core]dvb_validate_params_dtmb =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:924 [dvb_core]dvb_frontend_clear_cache =_ "%s: Clearing cache for delivery system %d\012"
drivers/media/dvb-core/dvb_frontend.c:238 [dvb_core]dvb_frontend_get_event =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:1144 [dvb_core]dtv_property_cache_sync =_ "%s: Preparing ATSC req\012"
drivers/media/dvb-core/dvb_frontend.c:1111 [dvb_core]dtv_property_cache_sync =_ "%s: Preparing OFDM req\012"
drivers/media/dvb-core/dvb_frontend.c:1105 [dvb_core]dtv_property_cache_sync =_ "%s: Preparing QAM req\012"
drivers/media/dvb-core/dvb_frontend.c:1100 [dvb_core]dtv_property_cache_sync =_ "%s: Preparing QPSK req\012"
drivers/media/dvb-core/dvb_frontend.c:2115 [dvb_core]dvb_frontend_ioctl_legacy =_ "%s: current delivery system on cache: %d, V3 type: %d\012"
drivers/media/dvb-core/dvb_frontend.c:1083 [dvb_core]dtv_property_dump =_ "%s: tvp.u.data = 0x%08x\012"
drivers/media/dvb-core/dvb_frontend.c:1080 [dvb_core]dtv_property_dump =_ "%s: tvp.u.buffer.data[0x%02x] = 0x%02x\012"
drivers/media/dvb-core/dvb_frontend.c:1075 [dvb_core]dtv_property_dump =_ "%s: tvp.u.buffer.len = 0x%02x\012"
drivers/media/dvb-core/dvb_frontend.c:1071 [dvb_core]dtv_property_dump =_ "%s: tvp.cmd    = 0x%08x (%s)\012"
drivers/media/dvb-core/dvb_frontend.c:1642 [dvb_core]set_delivery_system =_ "%s: change delivery system on cache to %d\012"
drivers/media/dvb-core/dvb_frontend.c:1622 [dvb_core]set_delivery_system =_ "%s: Using defaults for SYS_ISDBT\012"
drivers/media/dvb-core/dvb_frontend.c:1612 [dvb_core]set_delivery_system =_ "%s: Using delivery system %d emulated as if it were a %d\012"
drivers/media/dvb-core/dvb_frontend.c:1594 [dvb_core]set_delivery_system =_ "%s: Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\012"
drivers/media/dvb-core/dvb_frontend.c:1575 [dvb_core]set_delivery_system =_ "%s: can't use a DVBv3 FE_SET_FRONTEND call on this frontend\012"
drivers/media/dvb-core/dvb_frontend.c:1559 [dvb_core]set_delivery_system =_ "%s: Changing delivery system to %d\012"
drivers/media/dvb-core/dvb_frontend.c:1544 [dvb_core]set_delivery_system =_ "%s: Couldn't find a delivery system that matches %d\012"
drivers/media/dvb-core/dvb_frontend.c:1521 [dvb_core]set_delivery_system =_ "%s: This frontend doesn't support DVBv3 calls\012"
drivers/media/dvb-core/dvb_frontend.c:1502 [dvb_core]set_delivery_system =_ "%s: Using delivery system to %d\012"
drivers/media/dvb-core/dvb_frontend.c:1676 [dvb_core]dtv_property_process_set =_ "%s: Finalised property cache\012"
drivers/media/dvb-core/dvb_frontend.c:1901 [dvb_core]dvb_frontend_ioctl_properties =_ "%s: properties.props = %p\012"
drivers/media/dvb-core/dvb_frontend.c:1900 [dvb_core]dvb_frontend_ioctl_properties =_ "%s: properties.num = %d\012"
drivers/media/dvb-core/dvb_frontend.c:1894 [dvb_core]dvb_frontend_ioctl_properties =_ "%s: Property cache is full, tuning\012"
drivers/media/dvb-core/dvb_frontend.c:1868 [dvb_core]dvb_frontend_ioctl_properties =_ "%s: properties.props = %p\012"
drivers/media/dvb-core/dvb_frontend.c:1867 [dvb_core]dvb_frontend_ioctl_properties =_ "%s: properties.num = %d\012"
drivers/media/dvb-core/dvb_frontend.c:1862 [dvb_core]dvb_frontend_ioctl_properties =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:1826 [dvb_core]dvb_frontend_ioctl =_ "%s: (%d)\012"
drivers/media/dvb-core/dvb_frontend.c:2325 [dvb_core]dvb_frontend_poll =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:408 [dvb_core]dvb_frontend_swzigzag_autotune =_ "%s: drift:%i inversion:%i auto_step:%i auto_sub_step:%i started_auto_step:%i\012"
drivers/media/dvb-core/dvb_frontend.c:312 [dvb_core]dvb_frontend_swzigzag_update_delay =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:208 [dvb_core]dvb_frontend_add_event =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:1224 [dvb_core]dtv_property_legacy_params_sync =_ "%s: Preparing VSB req\012"
drivers/media/dvb-core/dvb_frontend.c:1192 [dvb_core]dtv_property_legacy_params_sync =_ "%s: Preparing OFDM req\012"
drivers/media/dvb-core/dvb_frontend.c:1186 [dvb_core]dtv_property_legacy_params_sync =_ "%s: Preparing QAM req\012"
drivers/media/dvb-core/dvb_frontend.c:1181 [dvb_core]dtv_property_legacy_params_sync =_ "%s: Preparing QPSK req\012"
drivers/media/dvb-core/dvb_frontend.c:285 [dvb_core]dvb_frontend_init =_ "%s: initialising adapter %i frontend %i (%s)...\012"
drivers/media/dvb-core/dvb_frontend.c:715 [dvb_core]dvb_frontend_thread =_ "%s: UNDEFINED ALGO !\012"
drivers/media/dvb-core/dvb_frontend.c:679 [dvb_core]dvb_frontend_thread =_ "%s: Retune requested, FESTAT_RETUNE\012"
drivers/media/dvb-core/dvb_frontend.c:677 [dvb_core]dvb_frontend_thread =_ "%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\012"
drivers/media/dvb-core/dvb_frontend.c:673 [dvb_core]dvb_frontend_thread =_ "%s: Frontend ALGO = DVBFE_ALGO_SW\012"
drivers/media/dvb-core/dvb_frontend.c:667 [dvb_core]dvb_frontend_thread =_ "%s: state changed, adding current state\012"
drivers/media/dvb-core/dvb_frontend.c:656 [dvb_core]dvb_frontend_thread =_ "%s: Retune requested, FESTATE_RETUNE\012"
drivers/media/dvb-core/dvb_frontend.c:653 [dvb_core]dvb_frontend_thread =_ "%s: Frontend ALGO = DVBFE_ALGO_HW\012"
drivers/media/dvb-core/dvb_frontend.c:607 [dvb_core]dvb_frontend_thread =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:821 [dvb_core]dvb_frontend_start =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2343 [dvb_core]dvb_frontend_open =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2438 [dvb_core]dvb_frontend_release =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2925 [dvb_core]dvb_register_frontend =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:752 [dvb_core]dvb_frontend_stop =_ "%s:\012"
drivers/media/dvb-core/dvb_frontend.c:2967 [dvb_core]dvb_unregister_frontend =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:230 [dvb_usbv2]dvb_usbv2_adapter_stream_init =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:242 [dvb_usbv2]dvb_usbv2_adapter_stream_exit =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:357 [dvb_usbv2]dvb_usb_ctrl_feed =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:298 [dvb_usbv2]dvb_usb_ctrl_feed =_ "%s: start feeding\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:267 [dvb_usbv2]dvb_usb_ctrl_feed =_ "%s: stop feeding\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:258 [dvb_usbv2]dvb_usb_ctrl_feed =_ "%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d '%s'\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:381 [dvb_usbv2]dvb_usbv2_adapter_dvb_init =_ "%s: dvb_register_adapter() failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:375 [dvb_usbv2]dvb_usbv2_adapter_dvb_init =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:446 [dvb_usbv2]dvb_usbv2_adapter_dvb_exit =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:480 [dvb_usbv2]dvb_usbv2_device_power_ctrl =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:470 [dvb_usbv2]dvb_usbv2_device_power_ctrl =_ "%s: power=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:516 [dvb_usbv2]dvb_usb_fe_init =_ "%s: ret=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:490 [dvb_usbv2]dvb_usb_fe_init =_ "%s: adap=%d fe=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:552 [dvb_usbv2]dvb_usb_fe_sleep =_ "%s: ret=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:526 [dvb_usbv2]dvb_usb_fe_sleep =_ "%s: adap=%d fe=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:619 [dvb_usbv2]dvb_usbv2_adapter_frontend_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:601 [dvb_usbv2]dvb_usbv2_adapter_frontend_init =_ "%s: tuner_attach() failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:574 [dvb_usbv2]dvb_usbv2_adapter_frontend_init =_ "%s: frontend_attach() do not exists\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:569 [dvb_usbv2]dvb_usbv2_adapter_frontend_init =_ "%s: frontend_attach() failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:560 [dvb_usbv2]dvb_usbv2_adapter_frontend_init =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:627 [dvb_usbv2]dvb_usbv2_adapter_frontend_exit =_ "%s: adap=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:189 [dvb_usbv2]dvb_usbv2_remote_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:133 [dvb_usbv2]dvb_usbv2_remote_init =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:712 [dvb_usbv2]dvb_usbv2_adapter_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:91 [dvb_usbv2]dvb_usbv2_i2c_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:71 [dvb_usbv2]dvb_usbv2_i2c_init =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:782 [dvb_usbv2]dvb_usbv2_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:749 [dvb_usbv2]dvb_usbv2_init =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:64 [dvb_usbv2]dvb_usbv2_download_firmware =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:38 [dvb_usbv2]dvb_usbv2_download_firmware =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:869 [dvb_usbv2]dvb_usbv2_init_work =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:799 [dvb_usbv2]dvb_usbv2_init_work =_ "%s: work_pid=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:925 [dvb_usbv2]dvb_usbv2_probe =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:883 [dvb_usbv2]dvb_usbv2_probe =_ "%s: bInterfaceNumber=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:97 [dvb_usbv2]dvb_usbv2_i2c_exit =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:719 [dvb_usbv2]dvb_usbv2_adapter_exit =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:195 [dvb_usbv2]dvb_usbv2_remote_exit =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:735 [dvb_usbv2]dvb_usbv2_exit =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:936 [dvb_usbv2]dvb_usbv2_disconnect =_ "%s: pid=%d work_pid=%d\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:957 [dvb_usbv2]dvb_usbv2_suspend =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:1017 [dvb_usbv2]dvb_usbv2_resume =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:987 [dvb_usbv2]dvb_usbv2_resume_common =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:1027 [dvb_usbv2]dvb_usbv2_reset_resume =_ "%s:\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:65 [dvb_usbv2]dvb_usbv2_generic_rw =_ "%s: <<< %*ph\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:39 [dvb_usbv2]dvb_usbv2_generic_rw =_ "%s: >>> %*ph\012"
drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:31 [dvb_usbv2]dvb_usbv2_generic_rw =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:81 [dvb_usbv2]usb_urb_killv2 =_ "%s: kill urb=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:101 [dvb_usbv2]usb_urb_submitv2 =_ "%s: submit urb=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:124 [dvb_usbv2]usb_urb_free_urbs =_ "%s: free urb=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:214 [dvb_usbv2]usb_free_stream_buffers =_ "%s: free buf=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:249 [dvb_usbv2]usb_alloc_stream_buffers =_ "%s: alloc buf=%d %p (dma %llu)\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:241 [dvb_usbv2]usb_alloc_stream_buffers =_ "%s: alloc buf=%d failed\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:233 [dvb_usbv2]usb_alloc_stream_buffers =_ "%s: all in all I will use %lu bytes for streaming\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:301 [dvb_usbv2]usb_urb_reconfig =_ "%s: re-alloc urbs\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:175 [dvb_usbv2]usb_urb_alloc_isoc_urbs =_ "%s: failed\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:171 [dvb_usbv2]usb_urb_alloc_isoc_urbs =_ "%s: alloc urb=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:55 [dvb_usbv2]usb_urb_complete =_ "%s: iso frame descriptor has an error=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:43 [dvb_usbv2]usb_urb_complete =_ "%s: urb completition failed=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:30 [dvb_usbv2]usb_urb_complete =_ "%s: %s urb completed status=%d length=%d/%d pack_num=%d errors=%d\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:143 [dvb_usbv2]usb_urb_alloc_bulk_urbs =_ "%s: failed\012"
drivers/media/usb/dvb-usb-v2/usb_urb.c:140 [dvb_usbv2]usb_urb_alloc_bulk_urbs =_ "%s: alloc urb=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:334 [dvb_usb_af9035]af9035_identify_state =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:325 [dvb_usb_af9035]af9035_identify_state =_ "%s: reply=%*ph\012"
drivers/media/usb/dvb-usb-v2/af9035.c:438 [dvb_usb_af9035]af9035_download_firmware =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:411 [dvb_usb_af9035]af9035_download_firmware =_ "%s: data uploaded=%zu\012"
drivers/media/usb/dvb-usb-v2/af9035.c:380 [dvb_usb_af9035]af9035_download_firmware =_ "%s: bad firmware\012"
drivers/media/usb/dvb-usb-v2/af9035.c:376 [dvb_usb_af9035]af9035_download_firmware =_ "%s: core=%d addr=%04x data_len=%d checksum=%04x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:588 [dvb_usb_af9035]af9035_read_config =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:570 [dvb_usb_af9035]af9035_read_config =_ "%s: [%d]IF=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:542 [dvb_usb_af9035]af9035_read_config =_ "%s: [%d]tuner=%02x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:533 [dvb_usb_af9035]af9035_read_config =_ "%s: 2nd demod I2C addr:%02x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:526 [dvb_usb_af9035]af9035_read_config =_ "%s: dual mode=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:679 [dvb_usb_af9035]af9035_fc0011_tuner_callback =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:762 [dvb_usb_af9035]af9035_frontend_attach =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:928 [dvb_usb_af9035]af9035_tuner_attach =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:974 [dvb_usb_af9035]af9035_init =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:961 [dvb_usb_af9035]af9035_init =_ "%s: USB speed=%d frame_size=%04x packet_size=%02x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:1049 [dvb_usb_af9035]af9035_get_rc_config =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:1026 [dvb_usb_af9035]af9035_get_rc_config =_ "%s: ir_type=%02x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:1018 [dvb_usb_af9035]af9035_get_rc_config =_ "%s: ir_mode=%02x\012"
drivers/media/usb/dvb-usb-v2/af9035.c:115 [dvb_usb_af9035]af9035_ctrl_msg =_ "%s: failed=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:102 [dvb_usb_af9035]af9035_ctrl_msg =_ "%s: command=%02x failed fw error=%d\012"
drivers/media/usb/dvb-usb-v2/af9035.c:58 [dvb_usb_af9035]af9035_ctrl_msg =_ "%s: too much data wlen=%d rlen=%d\012"


[  187.551577] usb 1-3: new high-speed USB device number 3 using ehci_hcd
[  187.672952] usb 1-3: New USB device found, idVendor=0b05, idProduct=1779
[  187.672965] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  187.672974] usb 1-3: Product: AF9035A USB Device
[  187.672981] usb 1-3: Manufacturer: Afa Technologies Inc.
[  187.672986] usb 1-3: SerialNumber: AF0102020700001
[  187.679952] input: Afa Technologies Inc. AF9035A USB Device as /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.1/input/input14
[  187.680230] hid-generic 0003:0B05:1779.0003: input: USB HID v1.01 Keyboard [Afa Technologies Inc. AF9035A USB Device] on usb-0000:00:12.2-3/input1
[  187.731117] usbcore: registered new interface driver dvb_usb_af9035
[  187.731822] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in cold state
[  187.742775] usb 1-3: dvb_usbv2: downloading firmware from file 'dvb-usb-af9035-02.fw'
[  188.044792] dvb_usb_af9035: firmware version=12.13.15.0
[  188.044914] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in warm state
[  188.047433] usb 1-3: dvb_usbv2: will pass the complete MPEG2 transport stream to the software demuxer
[  188.047541] DVB: registering new adapter (Asus U3100Mini Plus)
[  188.050526] af9033_attach:
[  188.051502] af9033: firmware version: LINK=12.13.15.0 OFDM=6.20.15.0
[  188.051520] usb 1-3: DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
[  188.054019] i2c i2c-1: fc2580_attach: chip_id=5a
[  188.054030] i2c i2c-1: fc2580_attach: failed=0
[  188.054471] i2c i2c-1: fc2580_release:
[  188.054485] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while loading driver (-19)


--------------010106080405010704020804--
