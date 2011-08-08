Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1HHTu4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2011 15:50:56 -0400
Message-ID: <4E403E1B.3020806@iki.fi>
Date: Mon, 08 Aug 2011 22:50:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair Buxton <a.j.buxton@gmail.com>
CC: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?B?U2FzY2hhIFfDvHN0ZW1h?= =?UTF-8?B?bm4=?=
	<sascha@killerhippy.de>, Thomas Holzeisen <thomas@holzeisen.de>,
	stybla@turnovfree.net
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net> <4DFFC82B.10402@iki.fi> <1308649292.3635.2.camel@maxim-laptop> <4E006BDB.8060000@hoogenraad.net> <4E17CA94.8030307@iki.fi> <4E3B2EB3.6030501@iki.fi> <CAO-Op+FBtPm9fdB4bskq3Hv_GorLuUUb6VFx7W+2JBxoCGwnYg@mail.gmail.com> <CAO-Op+FY9KVPQFgF1ykNz_BqJu653yM2-1oj5BZotUOhLtKGVw@mail.gmail.com>
In-Reply-To: <CAO-Op+FY9KVPQFgF1ykNz_BqJu653yM2-1oj5BZotUOhLtKGVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2011 08:13 AM, Alistair Buxton wrote:
> On 6 August 2011 04:56, Alistair Buxton <a.j.buxton@gmail.com> wrote:
>> With the latest driver my card never gets a signal lock, not even
>> once. As before there are no error messages. It does always probe
>> correctly now though.
> 
> I tracked this down to:
> 
> http://git.linuxtv.org/anttip/media_tree.git/commit/e5d3e4f27f0cf71c29d12ce39752195d8994dea3
> 
> and to this specific change:
> 
> @@ -459,21 +563,14 @@ static int rtl28xxu_power_ctrl(struct
> dvb_usb_device *d, int onoff)
>                 sys0 = sys0 & 0x0f;
>                 sys0 |= 0xe0;
>         } else {
> -
> -#if 0 /* keep */
>                 /*
>                  * FIXME: Use .fe_ioctl_override() to prevent demod
> -                * IOCTLs in case of device is powered off.
> -                *
> -                * For now we cannot power off device because most FE IOCTLs
> -                * can be performed only when device is powered.
> -                * Using IOCTLs when device is powered off will result errors
> -                * because register access to demod fails.
> +                * IOCTLs in case of device is powered off. Or change
> +                * RTL2830 demod not perform requestesd IOCTL & IO when sleep.
>                  */
>                 gpio &= (~0x01); /* GPIO0 = 0 */
>                 gpio |= 0x10; /* GPIO4 = 1 */
>                 sys0 = sys0 & (~0xc0);
> -#endif
>         }
> 
>         deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
> 
> 
> Commenting those three lines makes the driver work again. Don't know
> yet if it will keep working for longer than a couple of days.

I suspect it is tuner GPIO. It is not clear which GPIO pins are used for
tuner reset. I should find this out soon. Most likely MXL5005S tuner
reset have connected to different GPIO than MT2060 design I have.

Could you test commenting out only gpio change to see if it helps?

regards
Antti
-- 
http://palosaari.fi/
