Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59299 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab2IIVvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:51:20 -0400
Message-ID: <504D0F44.6030706@iki.fi>
Date: Mon, 10 Sep 2012 00:51:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl>
In-Reply-To: <504D00BC.4040109@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2012 11:49 PM, Oliver Schinagl wrote:
> Hi All/Antti,
>
> I used Antti's previous patch to try to get some support in for the Asus
> MyCinema U3100Mini Plus as it uses a supported driver (af9035) and now
> supported tuner (FCI FC2580).
>
> It compiles fine and almost works :(
>
> Here's what I get, which I have no idea what causes it.
>
> dmesg output:
> [  380.677434] usb 1-3: New USB device found, idVendor=0b05, idProduct=1779
> [  380.677445] usb 1-3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [  380.677452] usb 1-3: Product: AF9035A USB Device
> [  380.677458] usb 1-3: Manufacturer: Afa Technologies Inc.
> [  380.677463] usb 1-3: SerialNumber: AF01020abcdef12301
> [  380.683361] input: Afa Technologies Inc. AF9035A USB Device as
> /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.1/input/input15
> [  380.683505] hid-generic 0003:0B05:1779.0004: input: USB HID v1.01
> Keyboard [Afa Technologies Inc. AF9035A USB Device] on
> usb-0000:00:12.2-3/input1
> [  380.703807] usbcore: registered new interface driver dvb_usb_af9035
> [  380.704553] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in cold
> state
> [  380.705075] usb 1-3: dvb_usbv2: downloading firmware from file
> 'dvb-usb-af9035-02.fw'
> [  381.014996] dvb_usb_af9035: firmware version=11.5.9.0
> [  381.015018] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in warm
> state
> [  381.017172] usb 1-3: dvb_usbv2: will pass the complete MPEG2
> transport stream to the software demuxer
> [  381.017242] DVB: registering new adapter (Asus U3100Mini Plus)
> [  381.037184] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
> [  381.037200] usb 1-3: DVB: registering adapter 0 frontend 0 (Afatech
> AF9033 (DVB-T))...
> [  381.044197] i2c i2c-1: fc2580: i2c rd failed=-5 reg=01 len=1
> [  381.044357] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while
> loading driver (-19)

I2C communication to tuner chip does not work at all. It tries to read 
chip id register but fails. If you enable debugs you will see which 
error status af9035 reports.

There is likely 3 possibilities:
1) wrong I2C address
2) wrong GPIOs
  * tuner is not powered on or it is on standby
3) wrong firmware
  * it very unlikely that even wrong firmware fails basic I2C...

> using the following modules.
> fc2580                  4189  -1
> af9033                 10266  0
> dvb_usb_af9035          8924  0
> dvb_usbv2              11388  1 dvb_usb_af9035
> dvb_core               71756  1 dvb_usbv2
> rc_core                10583  2 dvb_usbv2,dvb_usb_af9035
>
> I'm supprised though that dvb-pll isn't there. Wasn't that a
> requirement? [1]

No. dvb-pll is used for old simple 4-byte PLLs. FCI FC2580 is modern 
silicon tuner. There is PLL used inside FC2580 for frequency synthesizer 
but no dvb-pll needed as all calculations are done inside that driver. 
Silicon tuners are so much more complicated to program than old 4-byte 
PLLs, thus own driver is needed for each silicon tuner chip.

> For the tuner 'script' firmware/init bit, I used the 'official' driver [2].
>
> Also the i2c-addr and clock comes from these files.

Aaah, now I see. At least I2C address is wrong. You use 0xac but should 
be 0x56. There is wrong "8-bit" address used. 0xac >> 1 == 0x56.


16384000 (16.384MHz) is FC2580 internal clock what I understand. It 
should be OK. I suspect that everyone uses it for DVB-T to save 
components / make design simple.

> One minor questions I have regarding the recently submitted RTL and
> AF9033 drivers, is one uses AF9033_TUNER_* whereas the other uses
> TUNER_RTL2832_*. Any reason for this? It just confused me is all.

It is just naming issue driver, driver author decision. Usually names 
start with driver name letters (in that case RTL28XXU_). It is not big 
issue for variable names unless it is too "general" to conflict some 
library. For function names driver names prefix (rtl28xxu_) should be 
used as it eases debugging (example ooops is dumped showing function names).


Antti

>
> Oliver
>
> [1] http://linuxtv.org/wiki/index.php/DVB_via_USB#Introduction
> [2] http://git.schinagl.nl/AF903x_SRC.git/tree/api/FCI_FC2580_Script.h
>
>
> On 09/09/12 22:47, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl<oliver@schinagl.nl>
>>
>> Initial support for the Asus MyCinema U3100Mini Plus. This currently
>> does not work however. It uses teh af9033/5 demodulater with an
>> FCI FC2580 tuner.
>>
>> Signed-off-by: Oliver Schinagl<oliver@schinagl.nl>
>> ---
>>   drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
>>   drivers/media/dvb-frontends/af9033.c      |  4 ++++
>>   drivers/media/dvb-frontends/af9033.h      |  1 +
>>   drivers/media/dvb-frontends/af9033_priv.h | 36
>> +++++++++++++++++++++++++++++++
>>   drivers/media/usb/dvb-usb-v2/Kconfig      |  1 +
>>   drivers/media/usb/dvb-usb-v2/af9035.c     | 12 +++++++++++
>>   drivers/media/usb/dvb-usb-v2/af9035.h     |  1 +
>>   7 files changed, 56 insertions(+)
>>
>> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h
>> b/drivers/media/dvb-core/dvb-usb-ids.h
>> index d572307..58e0220 100644
>> --- a/drivers/media/dvb-core/dvb-usb-ids.h
>> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
>> @@ -329,6 +329,7 @@
>>   #define USB_PID_ASUS_U3000                0x171f
>>   #define USB_PID_ASUS_U3000H                0x1736
>>   #define USB_PID_ASUS_U3100                0x173f
>> +#define USB_PID_ASUS_U3100MINI_PLUS            0x1779
>>   #define USB_PID_YUAN_EC372S                0x1edc
>>   #define USB_PID_YUAN_STK7700PH                0x1f08
>>   #define USB_PID_YUAN_PD378S                0x2edc
>> diff --git a/drivers/media/dvb-frontends/af9033.c
>> b/drivers/media/dvb-frontends/af9033.c
>> index cd8c883..1568c6a 100644
>> --- a/drivers/media/dvb-frontends/af9033.c
>> +++ b/drivers/media/dvb-frontends/af9033.c
>> @@ -318,6 +318,10 @@ static int af9033_init(struct dvb_frontend *fe)
>>           len = ARRAY_SIZE(tuner_init_tda18218);
>>           init = tuner_init_tda18218;
>>           break;
>> +    case AF9033_TUNER_FC2580:
>> +        len = ARRAY_SIZE(tuner_init_fc2580);
>> +        init = tuner_init_fc2580;
>> +        break;
>>       default:
>>           pr_debug("%s: unsupported tuner ID=%d\n", __func__,
>>                   state->cfg.tuner);
>> diff --git a/drivers/media/dvb-frontends/af9033.h
>> b/drivers/media/dvb-frontends/af9033.h
>> index 9e302c3..3dd6edd 100644
>> --- a/drivers/media/dvb-frontends/af9033.h
>> +++ b/drivers/media/dvb-frontends/af9033.h
>> @@ -42,6 +42,7 @@ struct af9033_config {
>>   #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
>>   #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
>>   #define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
>> +#define AF9033_TUNER_FC2580      0x32 /* FCI FC2580 */
>>       u8 tuner;
>>
>>       /*
>> diff --git a/drivers/media/dvb-frontends/af9033_priv.h
>> b/drivers/media/dvb-frontends/af9033_priv.h
>> index 0b783b9..4126255 100644
>> --- a/drivers/media/dvb-frontends/af9033_priv.h
>> +++ b/drivers/media/dvb-frontends/af9033_priv.h
>> @@ -466,5 +466,41 @@ static const struct reg_val tuner_init_tda18218[]
>> = {
>>       {0x80f1e6, 0x00},
>>   };
>>
>> +static const struct reg_val tuner_init_fc2580[] = {
>> +    { 0x800046, AF9033_TUNER_FC2580 },
>> +    { 0x800057, 0x01 },
>> +    { 0x800058, 0x00 },
>> +    { 0x80005f, 0x00 },
>> +    { 0x800060, 0x00 },
>> +    { 0x800071, 0x05 },
>> +    { 0x800072, 0x02 },
>> +    { 0x800074, 0x01 },
>> +    { 0x800079, 0x01 },
>> +    { 0x800093, 0x00 },
>> +    { 0x800094, 0x00 },
>> +    { 0x800095, 0x00 },
>> +    { 0x800096, 0x05 },
>> +    { 0x8000b3, 0x01 },
>> +    { 0x8000c3, 0x01 },
>> +    { 0x8000c4, 0x00 },
>> +    { 0x80f007, 0x00 },
>> +    { 0x80f00c, 0x19 },
>> +    { 0x80f00d, 0x1A },
>> +    { 0x80f00e, 0x00 },
>> +    { 0x80f00f, 0x02 },
>> +    { 0x80f010, 0x00 },
>> +    { 0x80f011, 0x02 },
>> +    { 0x80f012, 0x00 },
>> +    { 0x80f013, 0x02 },
>> +    { 0x80f014, 0x00 },
>> +    { 0x80f015, 0x02 },
>> +    { 0x80f01f, 0x96 },
>> +    { 0x80f020, 0x00 },
>> +    { 0x80f029, 0x96 },
>> +    { 0x80f02a, 0x00 },
>> +    { 0x80f077, 0x01 },
>> +    { 0x80f1e6, 0x01 },
>> +};
>> +
>>   #endif /* AF9033_PRIV_H */
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig
>> b/drivers/media/usb/dvb-usb-v2/Kconfig
>> index e09930c..834bfec 100644
>> --- a/drivers/media/usb/dvb-usb-v2/Kconfig
>> +++ b/drivers/media/usb/dvb-usb-v2/Kconfig
>> @@ -40,6 +40,7 @@ config DVB_USB_AF9035
>>       select MEDIA_TUNER_FC0011 if MEDIA_SUBDRV_AUTOSELECT
>>       select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
>>       select MEDIA_TUNER_TDA18218 if MEDIA_SUBDRV_AUTOSELECT
>> +    select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
>>       help
>>         Say Y here to support the Afatech AF9035 based DVB USB receiver.
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>> index 9e5bbf9..952fbdb 100644
>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>> @@ -546,6 +546,7 @@ static int af9035_read_config(struct
>> dvb_usb_device *d)
>>           case AF9033_TUNER_FC0011:
>>           case AF9033_TUNER_MXL5007T:
>>           case AF9033_TUNER_TDA18218:
>> +        case AF9033_TUNER_FC2580:
>>               state->af9033_config[i].spec_inv = 1;
>>               break;
>>           default:
>> @@ -798,6 +799,11 @@ static struct tda18218_config
>> af9035_tda18218_config = {
>>       .i2c_wr_max = 21,
>>   };
>>
>> +static struct fc2580_config af9035_fc2580_config = {
>> +    .i2c_addr = 0xac,
>> +    .clock = 16384000,
>> +};
>> +
>>   static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
>>   {
>>       struct state *state = adap_to_priv(adap);
>> @@ -903,6 +909,10 @@ static int af9035_tuner_attach(struct
>> dvb_usb_adapter *adap)
>>           fe = dvb_attach(tda18218_attach, adap->fe[0],
>>                   &d->i2c_adap,&af9035_tda18218_config);
>>           break;
>> +    case AF9033_TUNER_FC2580:
>> +        fe = dvb_attach(fc2580_attach, adap->fe[0],
>> +                &d->i2c_adap,&af9035_fc2580_config);
>> +        break;
>>       default:
>>           fe = NULL;
>>       }
>> @@ -1126,6 +1136,8 @@ static const struct usb_device_id
>> af9035_id_table[] = {
>>           &af9035_props, "AVerMedia HD Volar (A867)", NULL) },
>>       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TWINSTAR,
>>           &af9035_props, "AVerMedia Twinstar (A825)", NULL) },
>> +    { DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
>> +        &af9035_props, "Asus U3100Mini Plus", NULL) },
>>       { }
>>   };
>>   MODULE_DEVICE_TABLE(usb, af9035_id_table);
>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h
>> b/drivers/media/usb/dvb-usb-v2/af9035.h
>> index bb7bc7a..4864d9a 100644
>> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
>> @@ -28,6 +28,7 @@
>>   #include "fc0011.h"
>>   #include "mxl5007t.h"
>>   #include "tda18218.h"
>> +#include "fc2580.h"
>>
>>   struct reg_val {
>>       u32 reg;
>


-- 
http://palosaari.fi/
