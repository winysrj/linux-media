Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36672 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab2ITSya (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:30 -0400
Message-ID: <505B6663.7020502@schinagl.nl>
Date: Thu, 20 Sep 2012 20:54:27 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl> <505A3ADC.4000709@iki.fi>
In-Reply-To: <505A3ADC.4000709@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19-09-12 23:36, Antti Palosaari wrote:
> This is review, please fix those minor findings mentioned and resend 
> fixed patch!
Will do!
>
> On 09/19/2012 09:44 PM, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
>> in its current form gets detected and loads properly.
>>
>> Scanning using dvbscan works without problems, Locking onto a channel
>> using tzap also works fine. Only playback using tzap -r + mplayer was
>> tested and was fully functional.
>>
>> It uses the af9035 USB Bridge chip, with an af9033 demodulator. The 
>> tuner
>> used is the FCI FC2580.
>>
>> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
>> ---
>>   drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
>>   drivers/media/dvb-frontends/af9033.c      |  4 ++++
>>   drivers/media/dvb-frontends/af9033.h      |  1 +
>>   drivers/media/dvb-frontends/af9033_priv.h | 38 
>> +++++++++++++++++++++++++++++++
>>   drivers/media/tuners/fc2580.c             |  3 ++-
>>   drivers/media/usb/dvb-usb-v2/Kconfig      |  1 +
>>   drivers/media/usb/dvb-usb-v2/af9035.c     | 27 ++++++++++++++++++++++
>>   drivers/media/usb/dvb-usb-v2/af9035.h     |  1 +
>>   8 files changed, 75 insertions(+), 1 deletion(-)
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
>> index 0979ada..b40f5a0 100644
>> --- a/drivers/media/dvb-frontends/af9033.c
>> +++ b/drivers/media/dvb-frontends/af9033.c
>> @@ -314,6 +314,10 @@ static int af9033_init(struct dvb_frontend *fe)
>>           len = ARRAY_SIZE(tuner_init_tda18218);
>>           init = tuner_init_tda18218;
>>           break;
>> +    case AF9033_TUNER_FC2580:
>> +        len = ARRAY_SIZE(tuner_init_fc2580);
>> +        init = tuner_init_fc2580;
>> +        break;
>>       default:
>>           dev_dbg(&state->i2c->dev, "%s: unsupported tuner ID=%d\n",
>>                   __func__, state->cfg.tuner);
>> diff --git a/drivers/media/dvb-frontends/af9033.h 
>> b/drivers/media/dvb-frontends/af9033.h
>> index 288622b..739137e 100644 This is review, please fix those minor 
>> findings mentioned an
>> --- a/drivers/media/dvb-frontends/af9033.h
>> +++ b/drivers/media/dvb-frontends/af9033.h
>> @@ -42,6 +42,7 @@ struct af9033_config {
>>   #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
>>   #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
>>   #define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
>> +#define AF9033_TUNER_FC2580      0x32 /* FIC FC2580 */
>
> typo in name
It took me atleast 5 minutes to realize I wrote FCI as FIC. I corrected 
all instances.
>
>>       u8 tuner;
>>
>>       /*
>> diff --git a/drivers/media/dvb-frontends/af9033_priv.h 
>> b/drivers/media/dvb-frontends/af9033_priv.h
>> index 0b783b9..d2c9ae6 100644
>> --- a/drivers/media/dvb-frontends/af9033_priv.h
>> +++ b/drivers/media/dvb-frontends/af9033_priv.h
>> @@ -466,5 +466,43 @@ static const struct reg_val 
>> tuner_init_tda18218[] = {
>>       {0x80f1e6, 0x00},
>>   };
>>
>> +/* FIC FC2580 tuner init
>> +   AF9033_TUNER_FC2580      = 0x32 */
>> +static const struct reg_val tuner_init_fc2580[] = {
>> +    { 0x800046, AF9033_TUNER_FC2580 },
>
> Personally I don't like that define here. It causes some extra work 
> last time I looked USB sniffs as *just* that field is the field you 
> are first looking for. I am going to change it anyway, feel free to 
> leave if you wish, it is not error, thus I am not going to say you 
> must change it.
I was actually going to ask if it is 100% guaranteed to always be the 
tuner identifier here. If that is the case, for all tuners, I don't see 
the harm, especially with comment above. But I have removed it as per 
request, and also since I  doubt one can always guarantee that all 
tuners have the tunerid there.
>
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
>> diff --git a/drivers/media/tuners/fc2580.c 
>> b/drivers/media/tuners/fc2580.c
>> index afc0491..51bc39c 100644
>> --- a/drivers/media/tuners/fc2580.c
>> +++ b/drivers/media/tuners/fc2580.c
>> @@ -498,8 +498,9 @@ struct dvb_frontend *fc2580_attach(struct 
>> dvb_frontend *fe,
>>
>>       dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
>>
>> -    if (chip_id != 0x56)
>> +    if ((chip_id != 0x56) && (chip_id != 0x5a)) {
>>           goto err;
>> +    }
>
> hmm, braces added without a reason. That is Kernel CodingStyle 
> violation. You didn't ran checkpatch.pl ?
Checkpatch did not trigger on this. Which makes sense. Kernel 
CodingStyle is in very strong favor of K&R and from what I know from 
K&R, K&R strongly discourage not using braces as it is very likely to 
introduce bugs. Wikipedia has a small mention of this, then again 
wikipedia is wikipedia. ;)

I will take it out of you really want it out, but with checkpatch not 
even complaining, I would think this as an improvement. :D
>
>>
>>       dev_info(&priv->i2c->dev,
>>               "%s: FCI FC2580 successfully identified\n",
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
>> index 89cc901..8ca13e4 100644
>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>> @@ -513,6 +513,7 @@ static int af9035_read_config(struct 
>> dvb_usb_device *d)
>>           case AF9033_TUNER_FC0011:
>>           case AF9033_TUNER_MXL5007T:
>>           case AF9033_TUNER_TDA18218:
>> +        case AF9033_TUNER_FC2580:
>>               state->af9033_config[i].spec_inv = 1;
>>               break;
>>           default:
>> @@ -750,6 +751,11 @@ static struct tda18218_config 
>> af9035_tda18218_config = {
>>       .i2c_wr_max = 21,
>>   };
>>
>> +static struct fc2580_config af9035_fc2580_config = {
>> +    .i2c_addr = 0x56,
>> +    .clock = 16384000,
>> +};
>
> I usually define config structures as a const. Is there some reason it 
> is not static? Compiler should also print warning as it is likely 
> defined as const in fc2580. ?

But it is static! I think you ment, not const ;)
I admit admit, I blindly copied the above laying code and changed what 
needed changing. I guess the others should also be static const's and 
should be streamlined?
>
>> +
>>   static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
>>   {
>>       struct state *state = adap_to_priv(adap);
>> @@ -851,6 +857,25 @@ static int af9035_tuner_attach(struct 
>> dvb_usb_adapter *adap)
>>           fe = dvb_attach(tda18218_attach, adap->fe[0],
>>                   &d->i2c_adap, &af9035_tda18218_config);
>>           break;
>> +    case AF9033_TUNER_FC2580:
>> +        /* Tuner enable using gpiot2_o, gpiot2_en and gpiot2_on  */
>> +        ret = af9035_wr_reg(d, 0xd8eb, 1);
>> +        if (ret < 0)
>> +            goto err;
>> +
>> +        ret = af9035_wr_reg(d, 0xd8ec, 1);
>> +        if (ret < 0)
>> +            goto err;
>> +
>> +        ret = af9035_wr_reg(d, 0xd8ed, 1);
>> +        if (ret < 0)
>> +            goto err;
>> +
>> +        usleep_range(10000, 50000);
>> +        /* attach tuner */
>> +        fe = dvb_attach(fc2580_attach, adap->fe[0],
>> +                &d->i2c_adap, &af9035_fc2580_config);
>> +        break;
>
> These GPIO config registers are bitfields. You should use masked write 
> to change only the bit needed leaving undefined / unused bits to default.
I wasn't sure which of the two writes to use, and saw that most above 
tuners where not bitfields so guessed this one to be too.
>
>>       default:
>>           fe = NULL;
>>       }
>> @@ -1075,6 +1100,8 @@ static const struct usb_device_id 
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
>> index de8e761..75ef1ec 100644
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
>>
>
> And ran the checkpatch.pl. I suspect it was not ran as there was at 
> least that braces violation which is reported by checkpatch what I 
> remember.
I have, and it's happy :) Even used --strict.
>
> regards
> Antti
>
>

