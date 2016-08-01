Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36637 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbcHAXAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 19:00:46 -0400
Received: by mail-qk0-f182.google.com with SMTP id v123so27075899qkh.3
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 15:59:58 -0700 (PDT)
MIME-Version: 1.0
From: CIJOML CIJOMLovic <cijoml@gmail.com>
Date: Mon, 1 Aug 2016 23:55:52 +0200
Message-ID: <CAB0z4NpxFtZQ5Z9oeiSR1AWb03SNnYTWQE9nnuOVzso-uh7oQQ@mail.gmail.com>
Subject: [PATCH TRY 3] Support for EVOLVEO XtraTV stick
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti,

since I see that nobody fixed my patch, here is fixed version which
works for me and is made against latest git version

diff -urN media_build.old/linux/drivers/media/dvb-core/dvb-usb-ids.h
media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
--- media_build.old/linux/drivers/media/dvb-core/dvb-usb-ids.h
2016-05-07 07:45:09.000000000 +0200
+++ media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
2016-08-01 23:18:18.660938910 +0200
@@ -411,4 +411,5 @@
 #define USB_PID_SVEON_STV27                             0xd3af
 #define USB_PID_TURBOX_DTT_2000                         0xd3a4
 #define USB_PID_WINTV_SOLOHD                            0x0264
+#define USB_PID_EVOLVEO_XTRATV_STICK                   0xa115
 #endif
diff -urN media_build.old/linux/drivers/media/usb/dvb-usb-v2/af9035.c
media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
--- media_build.old/linux/drivers/media/usb/dvb-usb-v2/af9035.c
2016-07-16 07:45:08.000000000 +0200
+++ media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
2016-08-01 23:19:43.853325151 +0200
@@ -2090,6 +2090,8 @@
                &af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
        { DVB_USB_DEVICE(USB_VID_AVERMEDIA, 0x0337,
                &af9035_props, "AVerMedia HD Volar (A867)", NULL) },
+       { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_EVOLVEO_XTRATV_STICK,
+               &af9035_props, "EVOLVEO XtraTV stick", NULL) },

        /* IT9135 devices */
        { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,
diff -urN media_build.old/v4l/af9035.c media_build/v4l/af9035.c
--- media_build.old/v4l/af9035.c        2016-07-16 07:45:08.000000000 +0200
+++ media_build/v4l/af9035.c    2016-08-01 23:19:43.853325151 +0200
@@ -2090,6 +2090,8 @@
                &af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
        { DVB_USB_DEVICE(USB_VID_AVERMEDIA, 0x0337,
                &af9035_props, "AVerMedia HD Volar (A867)", NULL) },
+       { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_EVOLVEO_XTRATV_STICK,
+               &af9035_props, "EVOLVEO XtraTV stick", NULL) },

        /* IT9135 devices */
        { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,


Please apply

Best regards

Michal

2016-08-01 22:35 GMT+02:00 CIJOML CIJOMLovic <cijoml@gmail.com>:
> Hello Antti,
>
> where/how can I remove the key mapping? I am not familiar with this source.
>
> Thank you for help
>
> Regards
>
> Michal
>
> 2015-08-31 20:35 GMT+02:00 Antti Palosaari <crope@iki.fi>:
>> On 08/31/2015 09:04 PM, CIJOML CIJOMLovic wrote:
>>>
>>> Hello guys,
>>>
>>> please find out down this email patch to support EVOLVEO XtraTV stick.
>>> This tuner is for android phones with microusb connecter, however with
>>> reduction it works perfectly with linux kernel:
>>> The device identify itself at USB bus as Bus 002 Device 004: ID
>>> 1f4d:a115 G-Tek Electronics Group
>>> so I have created new vendor group but device named as its commercial
>>> name.
>>>
>>> Thank you for merging this patch to upstream
>>
>>
>> VID for GTEK is already defined there.
>>
>> Could you remove also remote controller default keymap as I think there is
>> no remote controller at all.
>>
>> regards
>> Antti
>>
>>>
>>> Best regards
>>>
>>> Michal
>>>
>>>
>>> diff -urN media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
>>> media_build.new/linux/drivers/media/dvb-core/dvb-usb-ids.h
>>> --- media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
>>> 2015-05-11 13:20:08.000000000 +0200
>>> +++ media_build.new/linux/drivers/media/dvb-core/dvb-usb-ids.h
>>> 2015-06-16 22:26:01.917990493 +0200
>>> @@ -70,6 +70,8 @@
>>>   #define USB_VID_EVOLUTEPC            0x1e59
>>>   #define USB_VID_AZUREWAVE            0x13d3
>>>   #define USB_VID_TECHNISAT            0x14f7
>>> +#define USB_VID_GTEK                0x1f4d
>>> +
>>>
>>>   /* Product IDs */
>>>   #define USB_PID_ADSTECH_USB2_COLD            0xa333
>>> @@ -388,4 +390,5 @@
>>>   #define USB_PID_PCTV_2002E_SE                           0x025d
>>>   #define USB_PID_SVEON_STV27                             0xd3af
>>>   #define USB_PID_TURBOX_DTT_2000                         0xd3a4
>>> +#define USB_PID_EVOLVEO_XTRATV_STICK            0xa115
>>>   #endif
>>> diff -urN media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>> media_build.new/linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>> --- media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>> 2015-05-30 17:32:46.000000000 +0200
>>> +++ media_build.new/linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>> 2015-06-16 22:26:14.561990868 +0200
>>> @@ -2075,6 +2075,8 @@
>>>           &af9035_props, "PCTV AndroiDTV (78e)", RC_MAP_IT913X_V1) },
>>>       { DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
>>>           &af9035_props, "PCTV microStick (79e)", RC_MAP_IT913X_V2) },
>>> +    { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_EVOLVEO_XTRATV_STICK,
>>> +        &af9035_props, "EVOLVEO XtraTV stick", RC_MAP_IT913X_V2) },
>>>
>>>       /* IT930x devices */
>>>       { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
>>> r
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> http://palosaari.fi/
