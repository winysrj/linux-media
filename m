Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3DLSEE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 14:04:04 -0400
Message-ID: <51684C6D.5000907@iki.fi>
Date: Fri, 12 Apr 2013 21:03:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jakob Haufe <sur5r@sur5r.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Delock 61959
References: <20130412161840.4bf01fc2@samsa.lan> <51681CD2.20905@iki.fi>
In-Reply-To: <51681CD2.20905@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to IRC discussion that device has different remote.

New board layout is needed as remote keymap is property of board config.

regards
Antti

On 04/12/2013 05:40 PM, Antti Palosaari wrote:
> On 04/12/2013 05:18 PM, Jakob Haufe wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Delock 61959 seems to be a relabeled version of Maxmedia UB425-TC with a
>> different USB ID. PCB is marked as "UB425-TC Ver: A" and this change
>> makes it work without any obvious problems.
>>
>> Signed-off-by: Jakob Haufe <sur5r@sur5r.net>
>
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>> - ---
>>   drivers/media/usb/em28xx/em28xx-cards.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c
>> b/drivers/media/usb/em28xx/em28xx-cards.c
>> index 1d3866f..82950aa 100644
>> - --- a/drivers/media/usb/em28xx/em28xx-cards.c
>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
>> @@ -2173,6 +2173,8 @@ struct usb_device_id em28xx_id_table[] = {
>>                          .driver_info = EM2860_BOARD_EASYCAP },
>>          { USB_DEVICE(0x1b80, 0xe425),
>>                          .driver_info = EM2874_BOARD_MAXMEDIA_UB425_TC },
>> +       { USB_DEVICE(0x1b80, 0xe1cc), /* Delock 61959 */
>> +                       .driver_info = EM2874_BOARD_MAXMEDIA_UB425_TC },
>>          { USB_DEVICE(0x2304, 0x0242),
>>                          .driver_info = EM2884_BOARD_PCTV_510E },
>>          { USB_DEVICE(0x2013, 0x0251),
>> - --
>> 1.7.10.4
>>
>>
>> - --
>> ceterum censeo microsoftem esse delendam.
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.12 (GNU/Linux)
>>
>> iEYEARECAAYFAlFoF8AACgkQ1YAhDic+adaIPQCfZQ+6gUH/JA6N2QVsa7nrpZyL
>> vSsAn3e+zMiFiM80Vn1oTGrgnkhDxfcx
>> =mOcG
>> -----END PGP SIGNATURE-----
>> N‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Þº{.nÇ+‰·¥Š{±™çbj)í…æèw*jg¬±¨¶‰šŽŠÝ¢j/êäz¹Þ–Šà2ŠÞ™¨è­Ú&¢)ß¡«a¶Úþø®G«éh®æj:+v‰¨Šwè†Ù¥
>>
>>
>
>


-- 
http://palosaari.fi/
