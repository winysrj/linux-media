Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:49107 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751133AbeEDBlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 21:41:09 -0400
Subject: Re: [PATCH] media: lgdt3306a: fix lgdt3306a_search()'s return type
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Thomas Meyer <thomas@m3y3r.de>, linux-media@vger.kernel.org
References: <20180424131907.5817-1-luc.vanoostenryck@gmail.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <cfa44c99-3ff7-899e-ad54-af24b0ea5b04@nextdimension.cc>
Date: Thu, 3 May 2018 20:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <20180424131907.5817-1-luc.vanoostenryck@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Brad Love <brad@nextdimension.cc>



On 2018-04-24 08:19, Luc Van Oostenryck wrote:
> The method dvb_frontend_ops::search() is defined as
> returning an 'enum dvbfe_search', but the implementation in this
> driver returns an 'int'.
>
> Fix this by returning 'enum dvbfe_search' in this driver too.
>
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/media/dvb-frontends/lgdt3306a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
> index 7eb4e1469..32de82447 100644
> --- a/drivers/media/dvb-frontends/lgdt3306a.c
> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
> @@ -1784,7 +1784,7 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
>  	return 0;
>  }
>  
> -static int lgdt3306a_search(struct dvb_frontend *fe)
> +static enum dvbfe_search lgdt3306a_search(struct dvb_frontend *fe)
>  {
>  	enum fe_status status = 0;
>  	int ret;
