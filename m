Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39625
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965888AbdGTXfs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 19:35:48 -0400
Date: Thu, 20 Jul 2017 20:35:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Ingo Molnar <mingo@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] dvb_frontend: ensure that inital front end status
 initialized
Message-ID: <20170720203435.1b496396@vento.lan>
In-Reply-To: <20170720221207.7505-1-colin.king@canonical.com>
References: <20170720221207.7505-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Jul 2017 23:12:07 +0100
Colin King <colin.king@canonical.com> escreveu:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The fe_status variable s is not initialized meaning it can have any
> random garbage status.  This could be problematic if fe->ops.tune is
> false as s is not updated by the call to fe->ops.tune() and a
> subsequent check on the change status will using a garbage value.
> Fix this by adding FE_NONE to the enum fe_status and initializing
> s to this.
> 
> Detected by CoverityScan, CID#112887 ("Uninitialized scalar variable")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 2 +-
>  include/uapi/linux/dvb/frontend.h     | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index e3fff8f64d37..18cc3bbc699c 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -631,7 +631,7 @@ static int dvb_frontend_thread(void *data)
>  	struct dvb_frontend *fe = data;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> -	enum fe_status s;
> +	enum fe_status s = FE_NONE;
>  	enum dvbfe_algo algo;
>  	bool re_tune = false;
>  	bool semheld = false;
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 00a20cd21ee2..afc3972b0879 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -127,6 +127,7 @@ enum fe_sec_mini_cmd {
>   *			to reset DiSEqC, tone and parameters
>   */
>  enum fe_status {
> +	FE_NONE			= 0x00,
>  	FE_HAS_SIGNAL		= 0x01,
>  	FE_HAS_CARRIER		= 0x02,
>  	FE_HAS_VITERBI		= 0x04,

If you're willing to touch the uAPI, please update its documentation:

$ git grep FE_HAS_SIGNAL Documentation/
Documentation/media/uapi/dvb/examples.rst:       if (*stat & FE_HAS_SIGNAL)
Documentation/media/uapi/dvb/fe-read-status.rst:          ``FE_HAS_SIGNAL``


Regards,
Mauro

Thanks,
Mauro
