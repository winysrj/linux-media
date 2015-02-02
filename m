Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48110 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbBBOkq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 09:40:46 -0500
Message-ID: <54CF8C6B.5080308@iki.fi>
Date: Mon, 02 Feb 2015 16:40:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>
CC: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media:dvb-frontends:Change setting of dtv_frontend_properties
 modulation to the correct value in the function,hd29l2_get_frontend
References: <1422887642-15590-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1422887642-15590-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
That patch is not correct and will not even compile. Problem is that 
QAM_4NR and QAM_4 are not defined (OK, QPSK is QAM-4).

regards
Antti

On 02/02/2015 04:34 PM, Nicholas Krause wrote:
> Changes the values in the switch statement of the function,d29l2_get_frontend
> to use the proper value for the dtv_frontend_properties modulation value. Further
> more this changes the values of case 0 and case 1 to use the correct values of
> QAM_4NR and QAM_4 respectfully.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/media/dvb-frontends/hd29l2.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
> index d7b9d54..48cafc9 100644
> --- a/drivers/media/dvb-frontends/hd29l2.c
> +++ b/drivers/media/dvb-frontends/hd29l2.c
> @@ -579,11 +579,11 @@ static int hd29l2_get_frontend(struct dvb_frontend *fe)
>   	switch ((buf[0] >> 0) & 0x07) {
>   	case 0: /* QAM4NR */
>   		str_constellation = "QAM4NR";
> -		c->modulation = QAM_AUTO; /* FIXME */
> +		c->modulation = QAM_4NR;
>   		break;
>   	case 1: /* QAM4 */
>   		str_constellation = "QAM4";
> -		c->modulation = QPSK; /* FIXME */
> +		c->modulation = QAM_4;
>   		break;
>   	case 2:
>   		str_constellation = "QAM16";
>

-- 
http://palosaari.fi/
