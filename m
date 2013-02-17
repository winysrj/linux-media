Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3BQV5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 16:57:39 -0500
Message-ID: <5121522D.7040508@iki.fi>
Date: Sun, 17 Feb 2013 23:57:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9035: add ID [0bda:00aa] TerraTec Cinergy T Stick (rev.
 2)
References: <CAA=TYk98hQuu09bkBhrE_C0a-b1wb-i6Tc=Ds_AAEvHgZ=ZJAQ@mail.gmail.com> <5121505F.2070700@iki.fi> <CAA=TYk_JNt_Mr8xwqYb6JBepKYoh4SSM85uSLmfcN_cUsL=jsQ@mail.gmail.com>
In-Reply-To: <CAA=TYk_JNt_Mr8xwqYb6JBepKYoh4SSM85uSLmfcN_cUsL=jsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could you just sent new patch? I see it is only mistake in patch name, 
but still it is better to send new patch that I or Mauro are not needed 
to edit patch.

regards
Antti



On 02/17/2013 11:53 PM, Fabrizio Gazzato wrote:
> Errata corrige: USB ID is  [0ccd:00aa]
>
> Sorry
>
> Fabrizio
>
> 2013/2/17 Antti Palosaari <crope@iki.fi>:
>> On 02/17/2013 11:48 PM, Fabrizio Gazzato wrote:
>>>
>>> Hi Antti,
>>>
>>> this patch adds USB ID for alternative "Terratec Cinergy T Stick".
>>> Tested by a friend: works similarly to 0ccd:0093 version (af9035+tua9001)
>>>
>>> Regards
>>>
>>>
>>> Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
>>
>>
>> Acked-by: Antti Palosaari <crope@iki.fi>
>>
>>
>>> ---
>>>    drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> index 61ae7f9..c3cd6be 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> @@ -1133,6 +1133,8 @@ static const struct usb_device_id af9035_id_table[]
>>> = {
>>>                  &af9035_props, "AVerMedia Twinstar (A825)", NULL) },
>>>          { DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
>>>                  &af9035_props, "Asus U3100Mini Plus", NULL) },
>>> +        { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
>>> +               &af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL)
>>> },
>>>          { }
>>>    };
>>>    MODULE_DEVICE_TABLE(usb, af9035_id_table);
>>>
>>
>>
>> --
>> http://palosaari.fi/


-- 
http://palosaari.fi/
