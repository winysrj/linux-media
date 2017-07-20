Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:40986 "EHLO
        resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935722AbdGTP4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:56:38 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH] [media] dvb_frontend: ensure that front end status is
 initialized
To: Colin King <colin.king@canonical.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <20170720152916.24266-1-colin.king@canonical.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <141477a2-1435-b74a-3ee9-1eeb6765dc12@kernel.org>
Date: Thu, 20 Jul 2017 09:48:27 -0600
MIME-Version: 1.0
In-Reply-To: <20170720152916.24266-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

On 07/20/2017 09:29 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The fe_status variable s is not initialized meaning it can have any
> random garbage status.  This could be problematic if fe->ops.tune is
> false as s is not updated by the call to fe->ops.tune() and a
> subsequent check on the change status will using a garbage value.
> Fix this by initializing s to zero.
> 
> Detected by CoverityScan, CID#112887 ("Uninitialized scalar variable")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index e3fff8f64d37..e18ea1508a59 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -631,7 +631,7 @@ static int dvb_frontend_thread(void *data)
>  	struct dvb_frontend *fe = data;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> -	enum fe_status s;
> +	enum fe_status s = 0;

0 isn't a valid value for enum fe_status. I think the right fix would be
to add FE_NONE to enum fe_status and then initialize s to that.

thanks,
-- Shuah


>  	enum dvbfe_algo algo;
>  	bool re_tune = false;
>  	bool semheld = false;
> 
