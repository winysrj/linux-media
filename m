Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:40702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1FLU5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 16:57:15 -0400
Message-ID: <4DF52828.2070701@iki.fi>
Date: Sun, 12 Jun 2011 23:57:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Juergen Lock <nox@jelal.kn-bremen.de>
CC: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT
References: <20110612202512.GA63911@triton8.kn-bremen.de>
In-Reply-To: <20110612202512.GA63911@triton8.kn-bremen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I assume device uses vendor reference design USB ID (15a4:9016 or 
15a4:9015)?

About the repeating bug you mention, are you using latest driver 
version? I am not aware such bug. There have been this kind of incorrect 
behaviour old driver versions which are using HID. It was coming from 
wrong HID interval.

Also you can dump remote codes out when setting debug=2 to 
dvb_usb_af9015 module.

regards
Antti


On 06/12/2011 11:25 PM, Juergen Lock wrote:
> That's this tuner:
>
> 	http://www.lc-power.de/index.php?id=146&L=1
>
> The credit card sized remote more or less works if I set remote=4,
> so I added the hash to get it autodetected.  (`more or less' there
> meaning sometimes buttons are `stuck on repeat', i.e. ir-keytable -t
> keeps repeating the same scancode until i press another button.)
>
> Signed-off-by: Juergen Lock<nox@jelal.kn-bremen.de>
>
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -735,6 +735,7 @@ static const struct af9015_rc_setup af90
>   	{ 0xb8feb708, RC_MAP_MSI_DIGIVOX_II },
>   	{ 0xa3703d00, RC_MAP_ALINK_DTU_M },
>   	{ 0x9b7dc64e, RC_MAP_TOTAL_MEDIA_IN_HAND }, /* MYGICTV U718 */
> +	{ 0x5d49e3db, RC_MAP_DIGITTRADE }, /* LC-Power LC-USB-DVBT */
>   	{ }
>   };
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
