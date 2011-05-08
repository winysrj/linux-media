Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:42554 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab1EHWi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:38:26 -0400
Message-ID: <4DC71B5E.7000902@linuxtv.org>
Date: Mon, 09 May 2011 00:38:22 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] DVB: Add basic API support for DVB-T2 and bump
 minor version
References: <4DC6BF28.8070006@redhat.com> <1304882240-23044-2-git-send-email-steve@stevekerrison.com> <4DC717AD.8030609@linuxtv.org>
In-Reply-To: <4DC717AD.8030609@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/09/2011 12:22 AM, Andreas Oberritter wrote:
> 
> Please also include the following (only compile-tested) lines within this commit:
> 
> From 4329b836a6590421b178710160fcca3b39f64e18 Mon Sep 17 00:00:00 2001
> From: Andreas Oberritter <obi@linuxtv.org>
> Date: Sun, 8 May 2011 22:14:07 +0000
> Subject: [PATCH] DVB: dvb_frontend: add PLP ID to property cache
> 
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++++++
>  drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index dc3457c..5af1d67 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1323,6 +1323,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  	case DTV_ISDBS_TS_ID:
>  		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
>  		break;
> +	case DTV_DVBT2_PLP_ID:
> +		tvp->u.data = c->dvbt2_plp_id;
> +		break;

Sorry, this depends on a changeset I haven't submitted yet and thus won't compile
inside your tree. See below for a fixed patch.

>  	default:
>  		r = -1;
>  	}
> @@ -1478,6 +1481,9 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  	case DTV_ISDBS_TS_ID:
>  		fe->dtv_property_cache.isdbs_ts_id = tvp->u.data;
>  		break;
> +	case DTV_DVBT2_PLP_ID:
> +		c->dvbt2_plp_id = tvp->u.data;
> +		break;
>  	default:
>  		r = -1;
>  	}
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 3b86050..fb2b13f 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -358,6 +358,9 @@ struct dtv_frontend_properties {
>  
>  	/* ISDB-T specifics */
>  	u32			isdbs_ts_id;
> +
> +	/* DVB-T2 specifics */
> +	u32			dvbt2_plp_id;
>  };
>  
>  struct dvb_frontend {

>From 6e7abb85241e7aef5783f9c216e829de5fe90cb7 Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Sun, 8 May 2011 22:14:07 +0000
Subject: [PATCH] DVB: dvb_frontend: add PLP ID to property cache

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++++++
 drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index dc3457c..d04ef09 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1323,6 +1323,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_ISDBS_TS_ID:
 		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
 		break;
+	case DTV_DVBT2_PLP_ID:
+		tvp->u.data = fe->dtv_property_cache.dvbt2_plp_id;
+		break;
 	default:
 		r = -1;
 	}
@@ -1478,6 +1481,9 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	case DTV_ISDBS_TS_ID:
 		fe->dtv_property_cache.isdbs_ts_id = tvp->u.data;
 		break;
+	case DTV_DVBT2_PLP_ID:
+		fe->dtv_property_cache.dvbt2_plp_id = tvp->u.data;
+		break;
 	default:
 		r = -1;
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 3b86050..fb2b13f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -358,6 +358,9 @@ struct dtv_frontend_properties {
 
 	/* ISDB-T specifics */
 	u32			isdbs_ts_id;
+
+	/* DVB-T2 specifics */
+	u32			dvbt2_plp_id;
 };
 
 struct dvb_frontend {
