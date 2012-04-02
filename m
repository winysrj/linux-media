Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42566 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2DBWkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 18:40:11 -0400
Message-ID: <4F7A2AC9.8040407@iki.fi>
Date: Tue, 03 Apr 2012 01:40:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH 3/5] tda18218: fix IF frequency for 7MHz bandwidth channels
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com> <1333401917-27203-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-4-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 00:25, Gianluca Gennari wrote:
> This is necessary to tune VHF channels with the AVerMedia A835 stick.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/common/tuners/tda18218.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
> index dfb3a83..b079696 100644
> --- a/drivers/media/common/tuners/tda18218.c
> +++ b/drivers/media/common/tuners/tda18218.c
> @@ -144,7 +144,7 @@ static int tda18218_set_params(struct dvb_frontend *fe)
>   		priv->if_frequency = 3000000;
>   	} else if (bw<= 7000000) {
>   		LP_Fc = 1;
> -		priv->if_frequency = 3500000;
> +		priv->if_frequency = 4000000;
>   	} else {
>   		LP_Fc = 2;
>   		priv->if_frequency = 4000000;

Kwaak, I will not apply that until I have done background checking. That 
driver is used only by AF9015 currently. And I did that driver as 
reverse-engineering and thus there is some things guessed. I have only 8 
MHz wide signal, thus I never tested 7 and 6 MHz. Have no DVB-T 
modulator either... Maybe some AF9015 user can confirm? Is there any 
AF9015 & TDA18218 bug reports seen in discussion forums...

regards
Antti
-- 
http://palosaari.fi/
