Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58408 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3AAW1J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 17:27:09 -0500
Message-ID: <50E36298.3040009@iki.fi>
Date: Wed, 02 Jan 2013 00:26:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Diorser <diorser@gmx.fr>
CC: linux-media@vger.kernel.org
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal>
In-Reply-To: <op.wp845xcf4bfdfw@quantal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/01/2013 11:40 PM, Diorser wrote:
> Hi all,
>
> After struggling some days trying to wake up a AVerTV_HD_Express_A918R
> DVB-T card, I am stuck with a DMX_SET_PES_FILTER error reported by
> dvbsnoop, I cannot solve (beyond my skills).
> This card is based on Afatech AF9035 +  AF9033 + NXP TDA18218HN, and
> then very similar to AVerTV_Volar_HD_PRO_A835 (in term of components used).
>
> You will find all details and current state at:
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_HD_Express_A918R
>
> In the meantime, I propose following patches to get dvb_usb_af9035
> compatible with A918R.
> --------------------------------------------------------------------------------------
>
> --- /drivers/media/dvb-core/dvb-usb-ids.h
> +++ /drivers/media/dvb-core/dvb-usb-ids.h
>    @@ -233,6 +233,7 @@
>    #define USB_PID_AVERMEDIA_A835                         0xa835
>    #define USB_PID_AVERMEDIA_B835                         0xb835
>   +#define USB_PID_AVERMEDIA_A918R                      0x0918
>    #define USB_PID_AVERMEDIA_1867                         0x1867
>    #define USB_PID_AVERMEDIA_A867                         0xa867
> --------------------------------------------------------------------------------------
>
>   --- /drivers/media/usb/dvb-usb-v2/af9035.c
>   +++ /drivers/media/usb/dvb-usb-v2/af9035.c
>   @@ -1125,6 +1125,8 @@
>           { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B835,
>                 &af9035_props, "AVerMedia AVerTV Volar HD/PRO (A835)",
> NULL) },
>   +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A918R,
>   +             &af9035_props, "AVerMedia AverTV (A918R)", NULL) },
>           { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867,
>                 &af9035_props, "AVerMedia HD Volar (A867)", NULL) },
> --------------------------------------------------------------------------------------
>
> If someone has some ideas to solve/understand the DMX_SET_PES_FILTER
> issue, please feel free to advise what should be tested or modified.

Patch looks correct.

If you are talking of that error I saw wiki you mentioned it is not 
error. You cannot use dvbsnoop like that. You have to tune to channel 
first and only after device is tuned successfully pidscan is possible.

  # dvbsnoop -s pidscan
  dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
  Transponder PID-Scan...
  Error(22): DMX_SET_PES_FILTER: Invalid argument

If you are really sure your antenna is good (not that small antenna 
bundled) and it does not work then there is some bug. I bet some GPIO is 
wrong. Maybe you should take some sniffs using SniffUSB2.0 and look there...


> Thanks, and ... Happy New Year !
> Diorser.

regards
Antti

-- 
http://palosaari.fi/
