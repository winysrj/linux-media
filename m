Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39689 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbbBCKUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 05:20:23 -0500
Message-ID: <54D0A0E2.3070808@iki.fi>
Date: Tue, 03 Feb 2015 12:20:18 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>
CC: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media:dvb-frontends: Change setting of variable interval
 to the correct values in the function, hd29l2_get_frontend for the switch
 statement checking the frame header
References: <1422935531-19353-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1422935531-19353-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yet another bad patch. Do not touch whole driver unless you understand 
and can test your patches!

Antti


On 02/03/2015 05:52 AM, Nicholas Krause wrote:
> This changes the switch statement checking the frame header of the pointer,
> c as a pointer to a structure of type,dtv_frontend_properties to set the
> variable,interval correctly in the switch statement for checking the frame
> header as part of this structure pointer,c for this function correctly as
> required by the cases in this switch statement.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/media/dvb-frontends/hd29l2.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
> index d7b9d54..3d1a013 100644
> --- a/drivers/media/dvb-frontends/hd29l2.c
> +++ b/drivers/media/dvb-frontends/hd29l2.c
> @@ -635,15 +635,15 @@ static int hd29l2_get_frontend(struct dvb_frontend *fe)
>   	switch ((buf[1] >> 0) & 0x03) {
>   	case 0: /* PN945 */
>   		str_guard_interval = "PN945";
> -		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		c->guard_interval = GUARD_INTERVAL_PN945;
>   		break;
>   	case 1: /* PN595 */
>   		str_guard_interval = "PN595";
> -		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		c->guard_interval = GUARD_INTERVAL_PN595;
>   		break;
>   	case 2: /* PN420 */
>   		str_guard_interval = "PN420";
> -		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		c->guard_interval = GUARD_INTERVAL_PN420;
>   		break;
>   	default:
>   		str_guard_interval = "?";
>

-- 
http://palosaari.fi/
