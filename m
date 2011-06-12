Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:47270 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1FLL1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 07:27:16 -0400
Message-ID: <4DF4A292.3070409@iki.fi>
Date: Sun, 12 Jun 2011 14:27:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lopez Lopez <reality_es@yahoo.es>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: dual sveon stv22 Afatech af9015 support (kworld clone)
References: <S1753342Ab1FKJ3p/20110611092945Z+46855@vger.kernel.org> <672951.10004.qm@web24108.mail.ird.yahoo.com>
In-Reply-To: <672951.10004.qm@web24108.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Could you send lsusb -vvd <usb:id> output from that device?

Also remote controller keytable is needed. You can enable remote debug 
by modprobe dvb_usb_af9015 debug=2. After that it should output remote 
codes to the message.log.

regards,
Antti


On 06/11/2011 12:38 PM, Lopez Lopez wrote:
> Hello:
>
> I have patched af9015.c and dvb-usb-ids to support sveon stv22 ( KWorld USB Dual DVB-T TV Stick (DVB-T 399U)  clone ) dual with
> -----
> #define USB_PID_SVEON_STV22                0xe401
> ------
>   in dvb-usb-ids.h file
>
> and
> -----
> /* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
>      {USB_DEVICE(USB_VID_KWORLD_2,
>   USB_PID_KWORLD_395U_4)},
>      {USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
>      {0},
> };
>
> ------
> {
>                  .name = "Sveon STV22 Dual USB DVB-T Tuner HDTV ",
>                  .cold_ids = {&af9015_usb_table[32], NULL},
>                  .warm_ids = {NULL},
>              },
>
> -----
>
> in af9015.c
>
> i expect to help you to extends linux dvb usb support.
>
> thanks for your time
>
> Emilio David Diaus Lopez
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
