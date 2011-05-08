Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:51403 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1EHWLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:11:44 -0400
Message-ID: <4DC7151E.1060606@linuxtv.org>
Date: Mon, 09 May 2011 00:11:42 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mxl5005: Fix warning caused by new entries in
 an enum
References: <4DC6BF28.8070006@redhat.com> <1304882240-23044-4-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304882240-23044-4-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/08/2011 09:17 PM, Steve Kerrison wrote:
> Additional bandwidth modes have been added in frontend.h
> mxl5005s.c had no default case so the compiler was warning about
> a non-exhausive switch statement.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  drivers/media/common/tuners/mxl5005s.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
> index 0d6e094..d80e6f3 100644
> --- a/drivers/media/common/tuners/mxl5005s.c
> +++ b/drivers/media/common/tuners/mxl5005s.c
> @@ -4020,6 +4020,10 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
>  			case BANDWIDTH_7_MHZ:
>  				req_bw  = MXL5005S_BANDWIDTH_7MHZ;
>  				break;
> +			default:
> +				dprintk(1,"%s: Unsupported bandwidth mode %u, reverting to default\n",
> +					__func__,params->u.ofdm.bandwidth);
> +				/* Fall back to auto */
>  			case BANDWIDTH_AUTO:
>  			case BANDWIDTH_8_MHZ:
>  				req_bw  = MXL5005S_BANDWIDTH_8MHZ;

Same as in 2/5.

>From 9492d6c7665bf8b55ec3a42577794cea3e87ee15 Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Fri, 8 Apr 2011 16:37:57 +0000
Subject: [PATCH 1/2] DVB: mxl5005s: handle new bandwidths by returning -EINVAL

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/common/tuners/mxl5005s.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 605e28b..5618b35 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -4024,6 +4024,8 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
 			case BANDWIDTH_8_MHZ:
 				req_bw  = MXL5005S_BANDWIDTH_8MHZ;
 				break;
+			default:
+				return -EINVAL;
 			}
 		}
 
-- 
1.7.2.5

