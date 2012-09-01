Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36461 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2IANyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 09:54:24 -0400
Received: by bkwj10 with SMTP id j10so1633397bkw.19
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2012 06:54:23 -0700 (PDT)
Message-ID: <5042138B.4080109@gmail.com>
Date: Sat, 01 Sep 2012 15:54:19 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>,
	David Basden <davidb-git@rcpt.to>,
	Zdenek Styblik <stybla@turnovfree.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/5] rtl28xxu: fix rtl2832u module reload fails bug
References: <1345593382-11367-1-git-send-email-crope@iki.fi> <1345593382-11367-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2012 01:56 AM, Antti Palosaari wrote:
> This is workaround / partial fix.
> 
> rtl2832u_power_ctrl() and rtl2832u_frontend_attach() needs to
> be go through carefully and fix properly. There is clearly
> some logical errors when handling power-management ang GPIOs...
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Cc: Thomas Mair <thomas.mair86@googlemail.com>
> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 1ccb99b..c246c50 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -946,17 +946,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
>  		if (ret)
>  			goto err;
>  
> -		/* demod HW reset */
> -		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
> -		if (ret)
> -			goto err;
> -		/* bit 5 to 0 */
> -		val &= 0xdf;
> -
> -		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
> -		if (ret)
> -			goto err;
> -
>  		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
>  		if (ret)
>  			goto err;
> 

Test: PASSED!
Working zapping on every hard/cold boot, soft/warm [re]boot and every
module(dvb_usb_rtl28xxu) [re]load.
Outside the box thinking!
Antti, thank you very much!

media_build
commit 420335f564c32517a791ecea3909af233925634d
1f4d:b803 G-Tek Electronics Group Lifeview LV5TDLX DVB-T [RTL2832U]

Cheers,
poma


