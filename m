Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:52964 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757368Ab0BCVPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 16:15:45 -0500
Message-ID: <4B69E761.9020306@arcor.de>
Date: Wed, 03 Feb 2010 22:15:13 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 12/15] - tm6000 bugfix tuner reset time and tuner param
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>	 <4B69D8CC.2030008@arcor.de> <4B69DD3F.2000103@arcor.de> <829197381002031252l3800aeb3hbe60307324e96278@mail.gmail.com>
In-Reply-To: <829197381002031252l3800aeb3hbe60307324e96278@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.02.2010 21:52, schrieb Devin Heitmueller:
> On Wed, Feb 3, 2010 at 3:31 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> --- a/drivers/staging/tm6000/tm6000-cards.c
>> +++ b/drivers/staging/tm6000/tm6000-cards.c
>> @@ -221,12 +239,13 @@ struct usb_device_id tm6000_id_table [] = {
>>     { USB_DEVICE(0x2040, 0x6600), .driver_info =
>> TM6010_BOARD_HAUPPAUGE_900H },
>>     { USB_DEVICE(0x6000, 0xdec0), .driver_info =
>> TM6010_BOARD_BEHOLD_WANDER },
>>     { USB_DEVICE(0x6000, 0xdec1), .driver_info =
>> TM6010_BOARD_BEHOLD_VOYAGER },
>>     { USB_DEVICE(0x0ccd, 0x0086), .driver_info =
>> TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
>>     { },
>>  };
>>
>>  /* Tuner callback to provide the proper gpio changes needed for xc2028 */
>>
>> -static int tm6000_tuner_callback(void *ptr, int component, int command,
>> int arg)
>> +int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
>>  {
>>     
> Why was the static removed from this declaration?  What could possibly
> be calling this from outside the module?  And if there were something
> that needed it, the declaration would have to be moved to a header
> file so it could be included elsewhere (which should be in this same
> patch).
>
> Just to be clear, the fact that I am going through these patches
> should not be taken personally - I'm just trying to give you some
> advice on what you need to do to ensure the patches can be accepted
> upstream and be reviewed with minimal cost to the other developers.
>
> Devin
>
>   
1. It broke by building.
2. callback for dvb frontend (tm6000-dvb.c) so can the tuner a reset
send if it goes in DVB mode (it must reload the firmware)

-- 
Stefan Ringel <stefan.ringel@arcor.de>

