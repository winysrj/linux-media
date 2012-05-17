Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53466 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2EQUn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 16:43:58 -0400
Received: by bkcji2 with SMTP id ji2so1870211bkc.19
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 13:43:57 -0700 (PDT)
Message-ID: <4FB56309.1000601@gmail.com>
Date: Thu, 17 May 2012 22:43:53 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 4/5] rtl28xxu: support G-Tek Electronics Group Lifeview
 LV5TDLX DVB-T
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-5-git-send-email-thomas.mair86@googlemail.com> <4FB50F66.50301@iki.fi>
In-Reply-To: <4FB50F66.50301@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/17/2012 04:47 PM, Antti Palosaari wrote:
> On 17.05.2012 01:13, Thomas Mair wrote:
>> Signed-off-by: Thomas Mair<thomas.mair86@googlemail.com>
> 
> Nacked.
> Better PID definition is required.
> 
>> ---
>>   drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
>>   drivers/media/dvb/dvb-usb/rtl28xxu.c    |   11 ++++++++++-
>>   2 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
>> b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
>> index fd37be0..b0a86e9 100644
>> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
>> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
>> @@ -135,6 +135,7 @@
>>   #define USB_PID_GENIUS_TVGO_DVB_T03            0x4012
>>   #define USB_PID_GRANDTEC_DVBT_USB_COLD            0x0fa0
>>   #define USB_PID_GRANDTEC_DVBT_USB_WARM            0x0fa1
>> +#define USB_PID_GTEK                    0xb803
> 
> You must give better name for the device. Vendor name is not enough as
> many vendors has surely more than one device model.
> 
> Correct PID is something like USB_PID_GTEK_LIFEVIEW_LV5TDLX
>

Precisely - USB_PID_DELOCK_USB2_DVBT according to the device:
http://www.delock.de/produkte/G_61744/merkmale.html
regardless of what's in '/usr/share/hwdata/usb.ids'
;)

>>   #define USB_PID_INTEL_CE9500                0x9500
>>   #define USB_PID_ITETECH_IT9135                0x9135
>>   #define USB_PID_ITETECH_IT9135_9005            0x9005
>> diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c
>> b/drivers/media/dvb/dvb-usb/rtl28xxu.c
>> index 6817ef7..9056d28 100644
>> --- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
>> +++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
>> @@ -1135,6 +1135,7 @@ enum rtl28xxu_usb_table_entry {
>>       RTL2831U_14AA_0160,
>>       RTL2831U_14AA_0161,
>>       RTL2832U_0CCD_00A9,
>> +    RTL2832U_1F4D_B803,
>>   };
>>
>>   static struct usb_device_id rtl28xxu_table[] = {
>> @@ -1149,6 +1150,8 @@ static struct usb_device_id rtl28xxu_table[] = {
>>       /* RTL2832U */
>>       [RTL2832U_0CCD_00A9] = {
>>           USB_DEVICE(USB_VID_TERRATEC,
>> USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
>> +    [RTL2832U_1F4D_B803] = {
>> +        USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
>>       {} /* terminating entry */
>>   };
>>
>> @@ -1262,7 +1265,7 @@ static struct dvb_usb_device_properties
>> rtl28xxu_properties[] = {
>>
>>           .i2c_algo =&rtl28xxu_i2c_algo,
>>
>> -        .num_device_descs = 1,
>> +        .num_device_descs = 2,
>>           .devices = {
>>               {
>>                   .name = "Terratec Cinergy T Stick Black",
>> @@ -1270,6 +1273,12 @@ static struct dvb_usb_device_properties
>> rtl28xxu_properties[] = {
>>                       &rtl28xxu_table[RTL2832U_0CCD_00A9],
>>                   },
>>               },
>> +            {
>> +                .name = "G-Tek Electronics Group Lifeview LV5TDLX
>> DVB-T [RTL2832U]",
>> +                .warm_ids = {
>> +                    &rtl28xxu_table[RTL2832U_1F4D_B803],
>> +                },
>> +            },
>>           }
>>       },
>>
> 
> 

regards,
poma
