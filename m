Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848Ab3BEWMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 17:12:43 -0500
Date: Tue, 5 Feb 2013 20:10:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michael Hunold <michael@mihu.de>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [media] dvb-usb: reading before start of array
Message-ID: <20130205201001.60fe547e@redhat.com>
In-Reply-To: <20130109073632.GD2454@elgon.mountain>
References: <20130109073632.GD2454@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Jan 2013 10:36:32 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> This is a static checker fix.  In the ttusb_process_muxpack() we do:
> 
> 	cc = (muxpack[len - 4] << 8) | muxpack[len - 3];
> 
> That means if we pass a number less than 4 then we will either trigger a
> checksum error message or read before the start of the array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I can't test this.
> 
> This patch doesn't introduce any bugs, but I'm not positive this is the
> right thing to do.  Perhaps it's better to print an error message?

I don't have any ttusb device either, but i suspect that printing an
error message inside ttusb_process_muxpack() would be better.

>From what I understood, this code gets the URB data and groups it
into one TS packet (188 bytes, typically). Then, it calls 
ttusb_process_muxpack() in order to handle it.

So, the normal condition would be to always receive 188 bytes here
(usual TS packet size), except if there's something wrong with the
URB transfer.

It seems, however, that there are other issues at the logic at
ttusb_process_muxpack().

For example, from this code snippet:

        for (i = 0; i < len; i += 2)
                csum ^= le16_to_cpup((__le16 *) (muxpack + i));

an odd value for len also seems to cause troubles at this logic.

so, IMHO, the better would be to print a warning if the value is
odd or smaller than 4, and discard it.

> 
> diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> index 5b682cc..99a2fd1 100644
> --- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> +++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> @@ -709,7 +709,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
>  			 * if length is valid and we reached the end:
>  			 * goto next muxpack
>  			 */
> -				if ((ttusb->muxpack_ptr >= 2) &&
> +				if ((ttusb->muxpack_ptr >= 4) &&
>  				    (ttusb->muxpack_ptr ==
>  				     ttusb->muxpack_len)) {
>  					ttusb_process_muxpack(ttusb,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
