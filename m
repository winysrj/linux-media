Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41585 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaFZJlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 05:41:55 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so672260wiv.8
        for <linux-media@vger.kernel.org>; Thu, 26 Jun 2014 02:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM187nBPf66kBwx6VCFLeQvJ5spiqsRF8wb7MUm8-ffGQQg0Mw@mail.gmail.com>
References: <1403615732-9193-1-git-send-email-crope@iki.fi>
	<CAM187nByJMOmOrYJPKfZ0WyrARSD1+eAyoEOKahDiGyk9no5qw@mail.gmail.com>
	<53AAB68B.4010806@iki.fi>
	<CAM187nBPf66kBwx6VCFLeQvJ5spiqsRF8wb7MUm8-ffGQQg0Mw@mail.gmail.com>
Date: Thu, 26 Jun 2014 19:41:49 +1000
Message-ID: <CAM187nBLCjrZREq3A+mNdAkVPEics_pCVVx0ZNrKjzGeR0kdqA@mail.gmail.com>
Subject: Re: [PATCH] af9035: override tuner id when bad value set into eeprom
From: David Shirley <tephra@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Unname <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As promised results on the 9033 driver (with the patch to fix the
tuner id/eeprom thingy):

3.42:
Jun 26 19:30:56 crystal kernel: [  102.250152] i2c i2c-11: af9033:
firmware version: LINK=0.0.0.0 OFDM=3.29.3.3
root@crystal:~# tzap -c ~mythtv/channels -a 2 ONE
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0078 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0096 | ber 00000000 | unc 00000000 |
^C
root@crystal:~# tzap -c ~mythtv/channels -a 3 ONE
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0046 | ber 73ffffe3 | unc 0000270f |
status 07 | signal ffff | snr 0000 | ber 73ffffe3 | unc 00004e1e |
status 00 | signal ffff | snr 0046 | ber 73ffffe3 | unc 0000752d |
status 07 | signal ffff | snr 0000 | ber 73ffffe3 | unc 00009c3c |
status 00 | signal ffff | snr 0046 | ber ffffffff | unc 0000c34c |

3.40:
Jun 26 19:35:06 crystal kernel: [   71.134391] i2c i2c-11: af9033:
firmware version: LINK=0.0.0.0 OFDM=3.17.1.0
root@crystal:~# tzap -c ~mythtv/channels -a 2 ONE
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0078 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 01 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0078 | ber 00000000 | unc 00002685 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00004d0a |
status 00 | signal ffff | snr 008c | ber 00000000 | unc 0000738f |
status 01 | signal ffff | snr 0000 | ber 00000000 | unc 00009a14 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 0000c099 |
status 07 | signal ffff | snr 0078 | ber 00000000 | unc 0000e71e |
status 00 | signal ffff | snr 0078 | ber ffffffff | unc 00010e2e |
status 1f | signal ffff | snr 0000 | ber ffffffff | unc 0001353e | FE_HAS_LOCK
status 00 | signal ffff | snr 0122 | ber ffffffff | unc 00015c4e |
status 07 | signal ffff | snr 0078 | ber ffffffff | unc 0001835e |
status 00 | signal ffff | snr 000a | ber ffffffff | unc 0001aa6e |
status 07 | signal ffff | snr 0000 | ber ffffffff | unc 0001d17e |
^C

root@crystal:~# tzap -c ~mythtv/channels -a 3 ONE
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 01 | signal ffff | snr 00aa | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0096 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
status 01 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 001e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 07 | signal ffff | snr 00aa | ber 00000000 | unc 0000211c |
status 07 | signal ffff | snr 00aa | ber ffffffff | unc 0000482c |
status 07 | signal ffff | snr 0000 | ber 76aaaa8d | unc 00006f39 |
status 07 | signal ffff | snr 0046 | ber 76aaaa8d | unc 00009646 |
status 07 | signal ffff | snr 0046 | ber ffffffff | unc 0000bd56 |
status 07 | signal ffff | snr 0000 | ber ffffffff | unc 0000e466 |
status 07 | signal ffff | snr 0046 | ber ffffffff | unc 00010b76 |
status 1f | signal ffff | snr 0118 | ber ffffffff | unc 00013286 | FE_HAS_LOCK
status 1f | signal ffff | snr 00dc | ber ffffffff | unc 00015996 | FE_HAS_LOCK
status 07 | signal ffff | snr 00aa | ber ffffffff | unc 000180a6 |
status 07 | signal ffff | snr 00aa | ber ffffffff | unc 0001a7b6 |
^C


stock kernel driver (ftp/extract from ite.com.tw):
Jun 26 19:38:31 crystal kernel: [  276.422317] i2c i2c-11: af9033:
firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
root@crystal:/lib/firmware# tzap -c ~mythtv/channels -a 2 ONE
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 082496b0 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 06a6ca1a | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 05336f08 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 05c002a6 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 03d55fd6 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 04a8b336 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 05c05148 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 06a6470c | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 00d2 | ber 04e7df5c | unc 00000000 | FE_HAS_LOCK
^C
root@crystal:/lib/firmware# tzap -c ~mythtv/channels -a 3 ONE
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/mythtv/channels'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
^C

As you can see the stock kernel/download-extract file gives best lock.

The 3.42 doesn't lock at all, and the 3.40 has a hard time maintaining the lock.

I will retest after new antenna goes on :)

Regards
David


On 25 June 2014 22:59, David Shirley <tephra@gmail.com> wrote:
> With the IT913X driver:
>
> I found that IT9135v2_3.42.3.3_3.29.3.3 wouldn't tune at all and
> IT9135v2_3.40.1.0_3.17.1.0 appeared to be less happy to tune (rightly
> so if the reception from the "kernel driver" (ie the one the script
> ftp's and extracts) is anything to go by)
>
> I will retest now that i'm on the AF9035 driver, give me a few days :)
>
> On 25 June 2014 21:46, Antti Palosaari <crope@iki.fi> wrote:
>> On 06/25/2014 01:32 PM, David Shirley wrote:
>>>
>>> Patched vanilla 3.15.1, this is the dmesg:
>>>
>>> Jun 25 20:16:16 crystal kernel: [  136.546403] usb 3-4.1.2: new
>>> high-speed USB device number 9 using xhci_hcd
>>> Jun 25 20:16:16 crystal kernel: [  136.634428] usb 3-4.1.2: New USB
>>> device found, idVendor=0413, idProduct=6a05
>>> Jun 25 20:16:16 crystal kernel: [  136.634435] usb 3-4.1.2: New USB
>>> device strings: Mfr=1, Product=2, SerialNumber=0
>>> Jun 25 20:16:16 crystal kernel: [  136.634438] usb 3-4.1.2: Product:
>>> WinFast DTV Dongle Dual
>>> Jun 25 20:16:16 crystal kernel: [  136.634441] usb 3-4.1.2:
>>> Manufacturer: Leadtek
>>> Jun 25 20:16:16 crystal kernel: [  136.643754] usb 3-4.1.2:
>>> dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
>>> Jun 25 20:16:16 crystal kernel: [  136.644100] usb 3-4.1.2:
>>> dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle Dual' in cold state
>>> Jun 25 20:16:16 crystal kernel: [  136.644429] usb 3-4.1.2:
>>> dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
>>> Jun 25 20:16:18 crystal kernel: [  138.553335] usb 3-4.1.2:
>>> dvb_usb_af9035: firmware version=3.39.1.0
>>> Jun 25 20:16:18 crystal kernel: [  138.553350] usb 3-4.1.2:
>>> dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle Dual' in warm state
>>> Jun 25 20:16:18 crystal kernel: [  138.555176] usb 3-4.1.2:
>>> dvb_usb_af9035: [0] overriding tuner from 38 to 60
>>> Jun 25 20:16:18 crystal kernel: [  138.556515] usb 3-4.1.2:
>>> dvb_usb_af9035: [1] overriding tuner from 38 to 60
>>> Jun 25 20:16:18 crystal kernel: [  138.557900] usb 3-4.1.2:
>>> dvb_usb_v2: will pass the complete MPEG2 transport stream to the
>>> software demuxer
>>> Jun 25 20:16:18 crystal kernel: [  138.557957] DVB: registering new
>>> adapter (Leadtek WinFast DTV Dongle Dual)
>>> Jun 25 20:16:18 crystal kernel: [  138.564417] i2c i2c-11: af9033:
>>> firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
>>> Jun 25 20:16:18 crystal kernel: [  138.564446] usb 3-4.1.2: DVB:
>>> registering adapter 2 frontend 0 (Afatech AF9033 (DVB-T))...
>>> Jun 25 20:16:18 crystal kernel: [  138.568091] i2c i2c-11:
>>> tuner_it913x: ITE Tech IT913X successfully attached
>>> Jun 25 20:16:18 crystal kernel: [  138.568110] usb 3-4.1.2:
>>> dvb_usb_v2: will pass the complete MPEG2 transport stream to the
>>> software demuxer
>>> Jun 25 20:16:18 crystal kernel: [  138.568139] DVB: registering new
>>> adapter (Leadtek WinFast DTV Dongle Dual)
>>> Jun 25 20:16:18 crystal kernel: [  138.580208] i2c i2c-11: af9033:
>>> firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
>>> Jun 25 20:16:18 crystal kernel: [  138.580219] usb 3-4.1.2: DVB:
>>> registering adapter 3 frontend 0 (Afatech AF9033 (DVB-T))...
>>> Jun 25 20:16:18 crystal kernel: [  138.580364] i2c i2c-11:
>>> tuner_it913x: ITE Tech IT913X successfully attached
>>> Jun 25 20:16:18 crystal kernel: [  138.591871] Registered IR keymap
>>> rc-empty
>>> Jun 25 20:16:18 crystal kernel: [  138.591995] input: Leadtek WinFast
>>> DTV Dongle Dual as
>>> /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1.2/rc/rc2/input11
>>> Jun 25 20:16:18 crystal kernel: [  138.592069] rc2: Leadtek WinFast
>>> DTV Dongle Dual as
>>> /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1.2/rc/rc2
>>> Jun 25 20:16:18 crystal kernel: [  138.592075] usb 3-4.1.2:
>>> dvb_usb_v2: schedule remote query interval to 500 msecs
>>> Jun 25 20:16:18 crystal kernel: [  138.592078] usb 3-4.1.2:
>>> dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual' successfully initialized
>>> and connected
>>> Jun 25 20:16:18 crystal kernel: [  138.592113] usbcore: registered new
>>> interface driver dvb_usb_af9035
>>>
>>> I can confirm that this tuner now works on the 9035 driver.
>>>
>>> However, im not sure if its the tuner thats just crap or my signal
>>> strength, as an AF9013 can tune and get ok reception, but this IT913X
>>> can tune but barely maintain a good picture. ITE say this particular
>>> tuner requires 2db more so I guess its feasible my 9013's are right on
>>> the border and the 9137 just cant "do it" :)
>>>
>>> I have a new antenna going in on the weekend so I will report back then!
>>
>>
>> Could you test newer firmwares? I have dumped out those initialization
>> register tables from Windows driver version 12.07.06.1. Newer firmwares are
>> dumped out from Windows driver version 12.10.04.1. Due to that newer
>> firmwares will work better with this driver - you were using the oldest
>> firmware. I have got few reports newer or even newest firmware 3.42.3.3 -
>> 3.29.3.3 works most best.
>>
>> http://palosaari.fi/linux/v4l-dvb/firmware/IT9135/12.10.04.1/
>>
>> If that does not help I have to get IT9135 v2 dual device in order to fix
>> it.
>>
>> regards
>> Antti
>>
>>
>>
>>
>>>
>>> Merci!
>>> D.
>>>
>>> On 24 June 2014 23:15, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>> Tuner ID set into EEPROM is wrong in some cases, which causes driver
>>>> to select wrong tuner profile. That leads device non-working. Fix
>>>> issue by overriding known bad tuner IDs with suitable default value.
>>>>
>>>> Cc: stable@vger.kernel.org # v3.15+
>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>> ---
>>>>   drivers/media/usb/dvb-usb-v2/af9035.c | 40
>>>> +++++++++++++++++++++++++++++------
>>>>   1 file changed, 33 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> index 021e4d3..7b9b75f 100644
>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> @@ -704,15 +704,41 @@ static int af9035_read_config(struct dvb_usb_device
>>>> *d)
>>>>                  if (ret < 0)
>>>>                          goto err;
>>>>
>>>> -               if (tmp == 0x00)
>>>> -                       dev_dbg(&d->udev->dev,
>>>> -                                       "%s: [%d]tuner not set, using
>>>> default\n",
>>>> -                                       __func__, i);
>>>> -               else
>>>> +               dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
>>>> +                               __func__, i, tmp);
>>>> +
>>>> +               /* tuner sanity check */
>>>> +               if (state->chip_type == 0x9135) {
>>>> +                       if (state->chip_version == 0x02) {
>>>> +                               /* IT9135 BX (v2) */
>>>> +                               switch (tmp) {
>>>> +                               case AF9033_TUNER_IT9135_60:
>>>> +                               case AF9033_TUNER_IT9135_61:
>>>> +                               case AF9033_TUNER_IT9135_62:
>>>> +                                       state->af9033_config[i].tuner =
>>>> tmp;
>>>> +                                       break;
>>>> +                               }
>>>> +                       } else {
>>>> +                               /* IT9135 AX (v1) */
>>>> +                               switch (tmp) {
>>>> +                               case AF9033_TUNER_IT9135_38:
>>>> +                               case AF9033_TUNER_IT9135_51:
>>>> +                               case AF9033_TUNER_IT9135_52:
>>>> +                                       state->af9033_config[i].tuner =
>>>> tmp;
>>>> +                                       break;
>>>> +                               }
>>>> +                       }
>>>> +               } else {
>>>> +                       /* AF9035 */
>>>>                          state->af9033_config[i].tuner = tmp;
>>>> +               }
>>>>
>>>> -               dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
>>>> -                               __func__, i,
>>>> state->af9033_config[i].tuner);
>>>> +               if (state->af9033_config[i].tuner != tmp) {
>>>> +                       dev_info(&d->udev->dev,
>>>> +                                       "%s: [%d] overriding tuner from
>>>> %02x to %02x\n",
>>>> +                                       KBUILD_MODNAME, i, tmp,
>>>> +                                       state->af9033_config[i].tuner);
>>>> +               }
>>>>
>>>>                  switch (state->af9033_config[i].tuner) {
>>>>                  case AF9033_TUNER_TUA9001:
>>>> --
>>>> 1.9.3
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> http://palosaari.fi/
