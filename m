Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56468 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932751AbeGFTPD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 15:15:03 -0400
Subject: Re: [PATCH v2 2/3] media: dvb: represent min/max/step/tolerance freqs
 in Hz
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Jemma Denson <jdenson@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Sean Young <sean@mess.org>,
        Kees Cook <keescook@chromium.org>,
        Dan Gopstein <dgopstein@nyu.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brad Love <brad@nextdimension.cc>,
        Thomas Meyer <thomas@m3y3r.de>, Arnd Bergmann <arnd@arndb.de>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Athanasios Oikonomou <athoik@gmail.com>,
        Akihiro Tsukada <tskd08@gmail.com>, Michael Buesch <m@bues.ch>,
        =?UTF-8?Q?J=c3=a9r=c3=a9my_Lefaure?= <jeremy.lefaure@lse.epita.fr>,
        linux1394-devel@lists.sourceforge.net
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
 <0ea966e5313043b1b9e6d658ad356841fb961e84.1530830503.git.mchehab+samsung@kernel.org>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <8552051d-e9ab-5a16-489f-fb4c16814620@gentoo.org>
Date: Fri, 6 Jul 2018 21:14:52 +0200
MIME-Version: 1.0
In-Reply-To: <0ea966e5313043b1b9e6d658ad356841fb961e84.1530830503.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.07.2018 um 00:59 schrieb Mauro Carvalho Chehab:

Hi Mauro,

I have one comment below.

> Right now, satellite frontend drivers specify frequencies in kHz,
> while terrestrial/cable ones specify in Hz. That's confusing
> for developers.
> 
> However, the main problem is that universal frontends capable
> of handling both satellite and non-satelite delivery systems
> are appearing. We end by needing to hack the drivers in
> order to support such hybrid frontends.
> 
> So, convert everything to specify frontend frequencies in Hz.
> 
> Tested-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---

> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 75e95b56f8b3..3b9dca7d7d02 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
[...]
> @@ -2391,9 +2417,19 @@ static int dvb_frontend_handle_ioctl(struct file *file,
>  
>  	case FE_GET_INFO: {
>  		struct dvb_frontend_info *info = parg;
> +		memset(info, 0, sizeof(*info));
>  
> -		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
> -		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
> +		strcpy(info->name, fe->ops.info.name);
> +		info->frequency_stepsize = fe->ops.info.frequency_stepsize_hz;
> +		info->frequency_tolerance = fe->ops.info.frequency_tolerance_hz;

The variables frequency_stepsize and frequency_tolerance are assigned
again some lines below.

> +		info->symbol_rate_min = fe->ops.info.symbol_rate_min;
> +		info->symbol_rate_max = fe->ops.info.symbol_rate_max;
> +		info->symbol_rate_tolerance = fe->ops.info.symbol_rate_tolerance;
> +		info->caps = fe->ops.info.caps;
> +		info->frequency_stepsize = dvb_frontend_get_stepsize(fe);
> +		dvb_frontend_get_frequency_limits(fe, &info->frequency_min,
> +						  &info->frequency_max,
> +						  &info->frequency_tolerance);
>  
>  		/*
>  		 * Associate the 4 delivery systems supported by DVBv3

Matthias
