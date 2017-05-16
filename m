Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42556 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750777AbdEPLSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 07:18:06 -0400
Subject: Re: [patch, libv4l]: Introduce define for lookup table size
To: Pavel Machek <pavel@ucw.cz>
References: <20170424093059.GA20427@amd> <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd> <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd> <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd> <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd> <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
Date: Tue, 16 May 2017 13:17:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170509110440.GC28248@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/17 13:04, Pavel Machek wrote:
> 
> Make lookup table size configurable at compile-time.

I don't think I'll take this patch. The problem is that if we really add
support for 10 or 12 bit lookup tables in the future, then just changing
LSIZE isn't enough.

This patch doesn't really add anything as it stands.

Regards,

	Hans

>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/lib/libv4lconvert/processing/libv4lprocessing-priv.h b/lib/libv4lconvert/processing/libv4lprocessing-priv.h
> index e4a29dd..55e1687 100644
> --- a/lib/libv4lconvert/processing/libv4lprocessing-priv.h
> +++ b/lib/libv4lconvert/processing/libv4lprocessing-priv.h
> @@ -25,6 +25,8 @@
>  #include "../libv4lsyscall-priv.h"
>  
>  #define V4L2PROCESSING_UPDATE_RATE 10
> +/* Size of lookup tables */
> +#define LSIZE 256
>  
>  struct v4lprocessing_data {
>  	struct v4lcontrol_data *control;
> @@ -32,15 +34,15 @@ struct v4lprocessing_data {
>  	int do_process;
>  	int controls_changed;
>  	/* True if any of the lookup tables does not contain
> -	   linear 0-255 */
> +	   linear 0-LSIZE-1 */
>  	int lookup_table_active;
>  	/* Counts the number of processed frames until a
>  	   V4L2PROCESSING_UPDATE_RATE overflow happens */
>  	int lookup_table_update_counter;
>  	/* RGB/BGR lookup tables */
> -	unsigned char comp1[256];
> -	unsigned char green[256];
> -	unsigned char comp2[256];
> +	unsigned char comp1[LSIZE];
> +	unsigned char green[LSIZE];
> +	unsigned char comp2[LSIZE];
>  	/* Filter private data for filters which need it */
>  	/* whitebalance.c data */
>  	int green_avg;
> @@ -48,7 +50,7 @@ struct v4lprocessing_data {
>  	int comp2_avg;
>  	/* gamma.c data */
>  	int last_gamma;
> -	unsigned char gamma_table[256];
> +	unsigned char gamma_table[LSIZE];
>  	/* autogain.c data */
>  	int last_gain_correction;
>  };
> diff --git a/lib/libv4lconvert/processing/libv4lprocessing.c b/lib/libv4lconvert/processing/libv4lprocessing.c
> index b061f50..6d0ad20 100644
> --- a/lib/libv4lconvert/processing/libv4lprocessing.c
> +++ b/lib/libv4lconvert/processing/libv4lprocessing.c
> @@ -74,7 +74,7 @@ static void v4lprocessing_update_lookup_tables(struct v4lprocessing_data *data,
>  {
>  	int i;
>  
> -	for (i = 0; i < 256; i++) {
> +	for (i = 0; i < LSIZE; i++) {
>  		data->comp1[i] = i;
>  		data->green[i] = i;
>  		data->comp2[i] = i;
> diff --git a/lib/libv4lconvert/processing/whitebalance.c b/lib/libv4lconvert/processing/whitebalance.c
> index c74069a..2dd33c1 100644
> --- a/lib/libv4lconvert/processing/whitebalance.c
> +++ b/lib/libv4lconvert/processing/whitebalance.c
> @@ -27,7 +27,7 @@
>  #include "libv4lprocessing-priv.h"
>  #include "../libv4lconvert-priv.h" /* for PIX_FMT defines */
>  
> -#define CLIP256(color) (((color) > 0xff) ? 0xff : (((color) < 0) ? 0 : (color)))
> +#define CLIPLSIZE(color) (((color) > LSIZE) ? LSIZE : (((color) < 0) ? 0 : (color)))
>  #define CLIP(color, min, max) (((color) > (max)) ? (max) : (((color) < (min)) ? (min) : (color)))
>  
>  static int whitebalance_active(struct v4lprocessing_data *data)
> @@ -111,10 +111,10 @@ static int whitebalance_calculate_lookup_tables_generic(
>  
>  	avg_avg = (data->green_avg + data->comp1_avg + data->comp2_avg) / 3;
>  
> -	for (i = 0; i < 256; i++) {
> -		data->comp1[i] = CLIP256(data->comp1[i] * avg_avg / data->comp1_avg);
> -		data->green[i] = CLIP256(data->green[i] * avg_avg / data->green_avg);
> -		data->comp2[i] = CLIP256(data->comp2[i] * avg_avg / data->comp2_avg);
> +	for (i = 0; i < LSIZE; i++) {
> +		data->comp1[i] = CLIPLSIZE(data->comp1[i] * avg_avg / data->comp1_avg);
> +		data->green[i] = CLIPLSIZE(data->green[i] * avg_avg / data->green_avg);
> +		data->comp2[i] = CLIPLSIZE(data->comp2[i] * avg_avg / data->comp2_avg);
>  	}
>  
>  	return 1;
> 
