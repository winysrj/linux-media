Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41090 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751658AbdKGQ21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 11:28:27 -0500
Subject: Re: [PATCH] dvb_frontend: don't use-after-free the frontend struct
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andrey Konovalov <andreyknvl@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
References: <CAAeHK+zqZCYoYJMFuAtgmHxoF6qeoxp+Ybs8PA-O0YJWEQ7VFw@mail.gmail.com>
 <b1cb7372fa822af6c06c8045963571d13ad6348b.1510062212.git.mchehab@s-opensource.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <b0bcca87-676b-fe89-144f-b5ef25fef1d2@gentoo.org>
Date: Tue, 7 Nov 2017 17:28:41 +0100
MIME-Version: 1.0
In-Reply-To: <b1cb7372fa822af6c06c8045963571d13ad6348b.1510062212.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.11.2017 um 14:44 schrieb Mauro Carvalho Chehab:
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index d485d5f6cc88..3ad83359098b 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -150,11 +150,8 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
>  
>  	dvb_frontend_invoke_release(fe, fe->ops.release);
>  
> -	if (!fepriv)
> -		return;
> -
> -	kfree(fepriv);
> -	fe->frontend_priv = NULL;
> +	if (fepriv)
> +		kfree(fepriv);

I think the condition is redundant and should be removed.
kfree(NULL) is fine.

>  }
>  
>  static void dvb_frontend_free(struct kref *ref)
> 

Regards
Matthias
