Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1IFPkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:40:22 -0400
Message-ID: <4E663EE2.3050403@redhat.com>
Date: Tue, 06 Sep 2011 12:40:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Em 06-09-2011 12:29, Mauro Carvalho Chehab escreveu:
> There are several issues with the original alsa_stream code that got
> fixed on xawtv3, made by me and by Hans de Goede. Basically, the
> code were re-written, in order to follow the alsa best practises.
> 
> Backport the changes from xawtv, in order to make it to work on a
> wider range of V4L and sound adapters.

FYI, just flooded your mailbox with 10 patches for tvtime. ;)

I'm wanting to test some things with tvtime on one of my testboxes, but some
of my cards weren't working with the alsa streaming, due to a few bugs that
were solved on xawtv fork.

So, I decided to backport it to tvtime and recompile the Fedora package for it.
That's where the other 9 patches come ;)

Basically, after applying this series of 10 patches, we can just remove all
patches from Fedora, making life easier for distro maintainers (as the same
thing is probably true on other distros - at least one of the Fedora patches
came from Debian, from the fedora git logs).

One important thing for distros is to have a tarball with the latest version
hosted on a public site, so I've increased the version to 1.0.3 and I'm
thinking on storing a copy of it at linuxtv, just like we do with xawtv3.

If you prefer, all patches are also on my tvtime git tree, at:
	http://git.linuxtv.org/mchehab/tvtime.git

Thanks,
Mauro

> 
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
> ---
>   src/alsa_stream.c |  629 ++++++++++++++++++++++++++++++-----------------------
>   src/alsa_stream.h |    6 +-
>   src/tvtime.c      |    6 +-
>   3 files changed, 363 insertions(+), 278 deletions(-)
> 
> diff --git a/src/alsa_stream.c b/src/alsa_stream.c
> index 2243b02..b6a41a5 100644
> --- a/src/alsa_stream.c
> +++ b/src/alsa_stream.c
> @@ -6,6 +6,9 @@
>    *  Derived from the alsa-driver test tool latency.c:
>    *    Copyright (c) by Jaroslav Kysela<perex@perex.cz>
>    *
> + *  Copyright (c) 2011 - Mauro Carvalho Chehab<mchehab@redhat.com>
> + *	Ported to xawtv, with bug fixes and improvements
> + *
>    *  This program is free software; you can redistribute it and/or modify
>    *  it under the terms of the GNU General Public License as published by
>    *  the Free Software Foundation; either version 2 of the License, or
> @@ -32,8 +35,16 @@
>   #include<alsa/asoundlib.h>
>   #include<sys/time.h>
>   #include<math.h>
> +#include "alsa_stream.h"
> +
> +/* Private vars to control alsa thread status */
> +static int alsa_is_running = 0;
> +static int stop_alsa = 0;
> 
> +/* Error handlers */
>   snd_output_t *output = NULL;
> +FILE *error_fp;
> +int verbose = 0;
> 
>   struct final_params {
>       int bufsize;
> @@ -42,403 +53,435 @@ struct final_params {
>       int channels;
>   };
> 
> -int setparams_stream(snd_pcm_t *handle,
> -		     snd_pcm_hw_params_t *params,
> -		     snd_pcm_format_t format,
> -		     int channels,
> -		     int rate,
> -		     const char *id)
> +static int setparams_stream(snd_pcm_t *handle,
> +			    snd_pcm_hw_params_t *params,
> +			    snd_pcm_format_t format,
> +			    int channels,
> +			    const char *id)
>   {
>       int err;
> -    unsigned int rrate;
> 
>       err = snd_pcm_hw_params_any(handle, params);
>       if (err<  0) {
> -	printf("Broken configuration for %s PCM: no configurations available: %s\n", snd_strerror(err), id);
> -	return err;
> -    }
> -    err = snd_pcm_hw_params_set_rate_resample(handle, params, 1);
> -    if (err<  0) {
> -	printf("Resample setup failed for %s: %s\n", id, snd_strerror(err));
> +	fprintf(error_fp,
> +		"alsa: Broken configuration for %s PCM: no configurations available: %s\n",
> +		snd_strerror(err), id);
>   	return err;
>       }
> +
>       err = snd_pcm_hw_params_set_access(handle, params,
>   				       SND_PCM_ACCESS_RW_INTERLEAVED);
>       if (err<  0) {
> -	printf("Access type not available for %s: %s\n", id,
> -	       snd_strerror(err));
> +	fprintf(error_fp, "alsa: Access type not available for %s: %s\n", id,
> +		snd_strerror(err));
>   	return err;
>       }
> 
>       err = snd_pcm_hw_params_set_format(handle, params, format);
>       if (err<  0) {
> -	printf("Sample format not available for %s: %s\n", id,
> +	fprintf(error_fp, "alsa: Sample format not available for %s: %s\n", id,
>   	       snd_strerror(err));
>   	return err;
>       }
>       err = snd_pcm_hw_params_set_channels(handle, params, channels);
>       if (err<  0) {
> -	printf("Channels count (%i) not available for %s: %s\n", channels, id,
> -	       snd_strerror(err));
> -	return err;
> -    }
> -    rrate = rate;
> -    err = snd_pcm_hw_params_set_rate_near(handle, params,&rrate, 0);
> -    if (err<  0) {
> -	printf("Rate %iHz not available for %s: %s\n", rate, id,
> -	       snd_strerror(err));
> +	fprintf(error_fp, "alsa: Channels count (%i) not available for %s: %s\n",
> +		channels, id, snd_strerror(err));
>   	return err;
>       }
> -    if ((int)rrate != rate) {
> -	printf("Rate doesn't match (requested %iHz, get %iHz)\n", rate, err);
> -	return -EINVAL;
> -    }
> +
>       return 0;
>   }
> 
> -int setparams_bufsize(snd_pcm_t *handle,
> +static void getparams_periods(snd_pcm_t *handle,
>   		      snd_pcm_hw_params_t *params,
> -		      snd_pcm_hw_params_t *tparams,
> -		      snd_pcm_uframes_t bufsize,
> -		      int period_size,
> +		      unsigned int *usecs,
> +		      unsigned int *count,
> +		      const char *id)
> +{
> +    unsigned min = 0, max = 0;
> +
> +    snd_pcm_hw_params_get_periods_min(params,&min, 0);
> +    snd_pcm_hw_params_get_periods_max(params,&max, 0);
> +    if (min&&  max) {
> +	if (verbose)
> +	    fprintf(error_fp, "alsa: %s periods range between %u and %u. Want: %u\n",
> +		    id, min, max, *count);
> +	if (*count<  min)
> +	    *count = min;
> +	if (*count>  max)
> +	    *count = max;
> +    }
> +
> +    min = max = 0;
> +    snd_pcm_hw_params_get_period_time_min(params,&min, 0);
> +    snd_pcm_hw_params_get_period_time_max(params,&max, 0);
> +    if (min&&  max) {
> +	if (verbose)
> +	    fprintf(error_fp, "alsa: %s period time range between %u and %u. Want: %u\n",
> +		    id, min, max, *usecs);
> +	if (*usecs<  min)
> +	    *usecs = min;
> +	if (*usecs>  max)
> +	    *usecs = max;
> +    }
> +}
> +
> +static int setparams_periods(snd_pcm_t *handle,
> +		      snd_pcm_hw_params_t *params,
> +		      unsigned int *usecs,
> +		      unsigned int *count,
>   		      const char *id)
>   {
>       int err;
> -    snd_pcm_uframes_t periodsize;
> 
> -    snd_pcm_hw_params_copy(params, tparams);
> -    periodsize = bufsize * 2;
> -    err = snd_pcm_hw_params_set_buffer_size_near(handle, params,&periodsize);
> +    err = snd_pcm_hw_params_set_period_time_near(handle, params, usecs, 0);
>       if (err<  0) {
> -	printf("Unable to set buffer size %li for %s: %s\n",
> -	       bufsize * 2, id, snd_strerror(err));
> -	return err;
> +	    fprintf(error_fp, "alsa: Unable to set period time %u for %s: %s\n",
> +		    *usecs, id, snd_strerror(err));
> +	    return err;
>       }
> -    if (period_size>  0)
> -	periodsize = period_size;
> -    else
> -	periodsize /= 2;
> -    err = snd_pcm_hw_params_set_period_size_near(handle, params,&periodsize,
> -						 0);
> +
> +    err = snd_pcm_hw_params_set_periods_near(handle, params, count, 0);
>       if (err<  0) {
> -	printf("Unable to set period size %li for %s: %s\n", periodsize, id,
> -	       snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to set %u periods for %s: %s\n",
> +		*count, id, snd_strerror(err));
>   	return err;
>       }
> +
> +    if (verbose)
> +	fprintf(error_fp, "alsa: %s period set to %u periods of %u time\n",
> +		id, *count, *usecs);
> +
>       return 0;
>   }
> 
> -int setparams_set(snd_pcm_t *handle,
> -		  snd_pcm_hw_params_t *params,
> -		  snd_pcm_sw_params_t *swparams,
> -		  const char *id)
> +static int setparams_set(snd_pcm_t *handle,
> +			 snd_pcm_hw_params_t *params,
> +			 snd_pcm_sw_params_t *swparams,
> +			 snd_pcm_uframes_t start_treshold,
> +			 const char *id)
>   {
>       int err;
> 
>       err = snd_pcm_hw_params(handle, params);
>       if (err<  0) {
> -	printf("Unable to set hw params for %s: %s\n", id, snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to set hw params for %s: %s\n",
> +		id, snd_strerror(err));
>   	return err;
>       }
>       err = snd_pcm_sw_params_current(handle, swparams);
>       if (err<  0) {
> -	printf("Unable to determine current swparams for %s: %s\n", id,
> -	       snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to determine current swparams for %s: %s\n",
> +		id, snd_strerror(err));
>   	return err;
>       }
> -    err = snd_pcm_sw_params_set_start_threshold(handle, swparams, 0x7fffffff);
> +    err = snd_pcm_sw_params_set_start_threshold(handle, swparams,
> +						start_treshold);
>       if (err<  0) {
> -	printf("Unable to set start threshold mode for %s: %s\n", id,
> -	       snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to set start threshold mode for %s: %s\n",
> +		id, snd_strerror(err));
>   	return err;
>       }
> 
>       err = snd_pcm_sw_params_set_avail_min(handle, swparams, 4);
>       if (err<  0) {
> -	printf("Unable to set avail min for %s: %s\n", id, snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to set avail min for %s: %s\n",
> +		id, snd_strerror(err));
>   	return err;
>       }
>       err = snd_pcm_sw_params(handle, swparams);
>       if (err<  0) {
> -	printf("Unable to set sw params for %s: %s\n", id, snd_strerror(err));
> +	fprintf(error_fp, "alsa: Unable to set sw params for %s: %s\n",
> +		id, snd_strerror(err));
>   	return err;
>       }
>       return 0;
>   }
> 
> -int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle, snd_pcm_format_t format,
> -	      struct final_params *negotiated)
> +static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
> +		     snd_pcm_format_t format,
> +		     int latency, int allow_resample,
> +		     struct final_params *negotiated)
>   {
> -    int rate = 48000;
> -    int latency_min = 600;		/* in frames / 2 */
> -    int channels = 2;
> -    int latency = latency_min - 4;
> -    int bufsize = latency;
> -    int err, last_bufsize = bufsize;
> -    snd_pcm_hw_params_t *pt_params, *ct_params;
> -    snd_pcm_hw_params_t *p_params, *c_params;
> +    int i;
> +    unsigned ratep, ratec = 0;
> +    unsigned ratemin = 32000, ratemax = 96000, val;
> +    int err, channels = 2;
> +    snd_pcm_hw_params_t *p_hwparams, *c_hwparams;
>       snd_pcm_sw_params_t *p_swparams, *c_swparams;
> -    snd_pcm_uframes_t p_size, c_size, p_psize, c_psize;
> -    unsigned int p_time, c_time;
> -
> -    snd_pcm_hw_params_alloca(&p_params);
> -    snd_pcm_hw_params_alloca(&c_params);
> -    snd_pcm_hw_params_alloca(&pt_params);
> -    snd_pcm_hw_params_alloca(&ct_params);
> +    snd_pcm_uframes_t c_size, p_psize, c_psize;
> +    /* Our latency is 2 periods (in usecs) */
> +    unsigned int c_periods = 2, p_periods;
> +    unsigned int c_periodtime, p_periodtime;
> +
> +    snd_pcm_hw_params_alloca(&p_hwparams);
> +    snd_pcm_hw_params_alloca(&c_hwparams);
>       snd_pcm_sw_params_alloca(&p_swparams);
>       snd_pcm_sw_params_alloca(&c_swparams);
> -    if ((err = setparams_stream(phandle, pt_params, format, channels, rate,
> -				"playback"))<  0) {
> -	printf("Unable to set parameters for playback stream: %s\n", snd_strerror(err));
> -	return 1;
> -    }
> -    if ((err = setparams_stream(chandle, ct_params, format, channels, rate,
> -				"capture"))<  0) {
> -	printf("Unable to set parameters for playback stream: %s\n", snd_strerror(err));
> +
> +    if (setparams_stream(phandle, p_hwparams, format, channels, "playback"))
>   	return 1;
> -    }
> 
> -  __again:
> -    if (last_bufsize == bufsize)
> -	bufsize += 4;
> -    last_bufsize = bufsize;
> +    if (setparams_stream(chandle, c_hwparams, format, channels, "capture"))
> +	return 1;
> 
> -    if ((err = setparams_bufsize(phandle, p_params, pt_params, bufsize, 0,
> -				 "playback"))<  0) {
> -	printf("Unable to set sw parameters for playback stream: %s\n",
> -	       snd_strerror(err));
> -	return -1;
> -    }
> -    if ((err = setparams_bufsize(chandle, c_params, ct_params, bufsize, 0,
> -				 "capture"))<  0) {
> -	printf("Unable to set sw parameters for playback stream: %s\n",
> -	       snd_strerror(err));
> -	return -1;
> +    if (allow_resample) {
> +	err = snd_pcm_hw_params_set_rate_resample(chandle, c_hwparams, 1);
> +	if (err<  0) {
> +	    fprintf(error_fp, "alsa: Resample setup failed: %s\n", snd_strerror(err));
> +	    return 1;
> +	} else if (verbose)
> +	   fprintf(error_fp, "alsa: Resample enabled.\n");
> +    }
> +
> +    err = snd_pcm_hw_params_get_rate_min(c_hwparams,&ratemin, 0);
> +    if (err>= 0&&  verbose)
> +	fprintf(error_fp, "alsa: Capture min rate is %d\n", ratemin);
> +    err = snd_pcm_hw_params_get_rate_max(c_hwparams,&ratemax, 0);
> +    if (err>= 0&&  verbose)
> +	fprintf(error_fp, "alsa: Capture max rate is %u\n", ratemax);
> +
> +    err = snd_pcm_hw_params_get_rate_min(p_hwparams,&val, 0);
> +    if (err>= 0) {
> +	if (verbose)
> +	    fprintf(error_fp, "alsa: Playback min rate is %u\n", val);
> +	if (val>  ratemin)
> +		ratemin = val;
> +    }
> +    err = snd_pcm_hw_params_get_rate_max(p_hwparams,&val, 0);
> +    if (err>= 0) {
> +	if (verbose)
> +	    fprintf(error_fp, "alsa: Playback max rate is %u\n", val);
> +	if (val<  ratemax)
> +		ratemax = val;
> +    }
> +
> +    if (verbose)
> +	fprintf(error_fp, "alsa: Will search a common rate between %u and %u\n",
> +		ratemin, ratemax);
> +
> +    for (i = ratemin; i<= ratemax; i+= 100) {
> +	err = snd_pcm_hw_params_set_rate_near(chandle, c_hwparams,&i, 0);
> +	if (err)
> +	    continue;
> +	ratec = i;
> +	ratep = i;
> +	err = snd_pcm_hw_params_set_rate_near(phandle, p_hwparams,&ratep, 0);
> +	if (err)
> +	    continue;
> +	if (ratep == ratec)
> +	    break;
> +	if (verbose)
> +	    fprintf(error_fp,
> +		    "alsa: Failed to set to %u: capture wanted %u, playback wanted %u%s\n",
> +		    i, ratec, ratep,
> +		    allow_resample ? " with resample enabled": "");
>       }
> 
> -    snd_pcm_hw_params_get_period_size(p_params,&p_psize, NULL);
> -    if (p_psize>  (unsigned int)bufsize)
> -	bufsize = p_psize;
> -
> -    snd_pcm_hw_params_get_period_size(c_params,&c_psize, NULL);
> -    if (c_psize>  (unsigned int)bufsize)
> -	bufsize = c_psize;
> +    if (err<  0) {
> +	fprintf(error_fp, "alsa: Failed to set a supported rate: %s\n",
> +		snd_strerror(err));
> +	return 1;
> +    }
> +    if (ratep != ratec) {
> +	if (verbose || allow_resample)
> +	    fprintf(error_fp,
> +		    "alsa: Couldn't find a rate that it is supported by both playback and capture\n");
> +	return 2;
> +    }
> +    if (verbose)
> +	fprintf(error_fp, "alsa: Using Rate %d\n", ratec);
> +
> +    /* Negociate period parameters */
> +
> +    c_periodtime = latency * 1000 / c_periods;
> +    getparams_periods(chandle, c_hwparams,&c_periodtime,&c_periods, "capture");
> +    p_periods = c_periods * 2;
> +    p_periodtime = c_periodtime;
> +    getparams_periods(phandle, p_hwparams,&p_periodtime,&p_periods, "playback");
> +    c_periods = p_periods / 2;
> +
> +    /*
> +     * Some playback devices support a very limited periodtime range. If the user needs to
> +     * use a higher latency to avoid overrun/underrun, use an alternate algorithm of incresing
> +     * the number of periods, to archive the needed latency
> +     */
> +    if (p_periodtime<  c_periodtime) {
> +	c_periodtime = p_periodtime;
> +	c_periods = round (latency * 1000.0 / c_periodtime + 0.5);
> +	getparams_periods(chandle, c_hwparams,&c_periodtime,&c_periods, "capture");
> +	p_periods = c_periods * 2;
> +	p_periodtime = c_periodtime;
> +	getparams_periods(phandle, p_hwparams,&p_periodtime,&p_periods, "playback");
> +	c_periods = p_periods / 2;
> +    }
> +
> +    if (setparams_periods(chandle, c_hwparams,&c_periodtime,&c_periods, "capture"))
> +	return 1;
> 
> -    snd_pcm_hw_params_get_period_time(p_params,&p_time, NULL);
> -    snd_pcm_hw_params_get_period_time(c_params,&c_time, NULL);
> +    /* Note we use twice as much periods for the playback buffer, since we
> +       will get a period size near the requested time and we don't want it to
> +       end up smaller then the capture buffer as then we could end up blocking
> +       on writing to it. Note we will configure the playback dev to start
> +       playing as soon as it has 2 capture periods worth of data, so this
> +       won't influence latency */
> +    if (setparams_periods(phandle, p_hwparams,&p_periodtime,&p_periods, "playback"))
> +	return 1;
> 
> -    if (p_time != c_time)
> -	goto __again;
> +    snd_pcm_hw_params_get_period_size(p_hwparams,&p_psize, NULL);
> +    snd_pcm_hw_params_get_period_size(c_hwparams,&c_psize, NULL);
> +    snd_pcm_hw_params_get_buffer_size(c_hwparams,&c_size);
> 
> -    snd_pcm_hw_params_get_buffer_size(p_params,&p_size);
> -    if (p_psize * 2<  p_size)
> -	goto __again;
> -    snd_pcm_hw_params_get_buffer_size(c_params,&c_size);
> -    if (c_psize * 2<  c_size)
> -	goto __again;
> +    latency = c_periods * c_psize;
> +    if (setparams_set(phandle, p_hwparams, p_swparams, latency, "playback"))
> +	return 1;
> 
> -    if ((err = setparams_set(phandle, p_params, p_swparams, "playback"))<  0) {
> -	printf("Unable to set sw parameters for playback stream: %s\n",
> -	       snd_strerror(err));
> -	return -1;
> -    }
> -    if ((err = setparams_set(chandle, c_params, c_swparams, "capture"))<  0) {
> -	printf("Unable to set sw parameters for playback stream: %s\n",
> -	       snd_strerror(err));
> -	return -1;
> -    }
> +    if (setparams_set(chandle, c_hwparams, c_swparams, c_psize, "capture"))
> +	return 1;
> 
>       if ((err = snd_pcm_prepare(phandle))<  0) {
> -	printf("Prepare error: %s\n", snd_strerror(err));
> -	return -1;
> +	fprintf(error_fp, "alsa: Prepare error: %s\n", snd_strerror(err));
> +	return 1;
>       }
> 
> -#ifdef SHOW_ALSA_DEBUG
> -    printf("final config\n");
> -    snd_pcm_dump_setup(phandle, output);
> -    snd_pcm_dump_setup(chandle, output);
> -    printf("Parameters are %iHz, %s, %i channels\n", rate,
> -	   snd_pcm_format_name(format), channels);
> -    fflush(stdout);
> -#endif
> +    if (verbose) {
> +	fprintf(error_fp, "alsa: Negociated configuration:\n");
> +	snd_pcm_dump_setup(phandle, output);
> +	snd_pcm_dump_setup(chandle, output);
> +	fprintf(error_fp, "alsa: Parameters are %iHz, %s, %i channels\n",
> +		ratep, snd_pcm_format_name(format), channels);
> +	fprintf(error_fp, "alsa: Set bitrate to %u%s, buffer size is %u\n", ratec,
> +		allow_resample ? " with resample enabled at playback": "",
> +		(unsigned int)c_size);
> +    }
> 
> -    negotiated->bufsize = bufsize;
> -    negotiated->rate = rate;
> +    negotiated->bufsize = c_size;
> +    negotiated->rate = ratep;
>       negotiated->channels = channels;
> -    negotiated->latency = bufsize;
> +    negotiated->latency = latency;
>       return 0;
>   }
> 
> -void setscheduler(void)
> -{
> -    struct sched_param sched_param;
> -
> -    if (sched_getparam(0,&sched_param)<  0) {
> -	printf("Scheduler getparam failed...\n");
> -	return;
> -    }
> -    sched_param.sched_priority = sched_get_priority_max(SCHED_RR);
> -    if (!sched_setscheduler(0, SCHED_RR,&sched_param)) {
> -	printf("Scheduler set to Round Robin with priority %i...\n", sched_param.sched_priority);
> -	fflush(stdout);
> -	return;
> -    }
> -    printf("!!!Scheduler set to Round Robin with priority %i FAILED!!!\n", sched_param.sched_priority);
> -}
> -
> -snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len,
> -			  size_t *frames, size_t *max)
> +/* Read up to len frames */
> +static snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len)
>   {
>       snd_pcm_sframes_t r;
> 
>       r = snd_pcm_readi(handle, buf, len);
> -    if (r<  0) {
> -	return r;
> +    if (r<  0&&  r != -EAGAIN) {
> +	r = snd_pcm_recover(handle, r, 0);
> +	if (r<  0)
> +	    fprintf(error_fp, "alsa: overrun recover error: %s\n", snd_strerror(r));
>       }
> -
> -    if (r>  0) {
> -	*frames += r;
> -	if ((long)*max<  r)
> -	    *max = r;
> -    }
> -
>       return r;
>   }
> 
> -snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len,
> -			   size_t *frames)
> +/* Write len frames (note not up to len, but all of len!) */
> +static snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len)
>   {
>       snd_pcm_sframes_t r;
> 
> -    while (len>  0) {
> +    while (1) {
>   	r = snd_pcm_writei(handle, buf, len);
> +	if (r == len)
> +	    return 0;
>   	if (r<  0) {
> -	    return r;
> +	    r = snd_pcm_recover(handle, r, 0);
> +	    if (r<  0) {
> +		fprintf(error_fp, "alsa: underrun recover error: %s\n",
> +			snd_strerror(r));
> +		return r;
> +	    }
>   	}
> -
>   	buf += r * 4;
>   	len -= r;
> -	*frames += r;
> -    }
> -    return 0;
> -}
> -
> -int startup_capture(snd_pcm_t *phandle, snd_pcm_t *chandle,
> -		    snd_pcm_format_t format, char *buffer, int latency,
> -		    int channels)
> -{
> -    size_t frames_out;
> -    int err;
> -
> -    frames_out = 0;
> -    if (snd_pcm_format_set_silence(format, buffer, latency*channels)<  0) {
> -	fprintf(stderr, "silence error\n");
> -	return 1;
> -    }
> -    if (writebuf(phandle, buffer, latency,&frames_out)<  0) {
> -	fprintf(stderr, "write error\n");
> -	return 1;
> +	snd_pcm_wait(handle, 100);
>       }
> -    if (writebuf(phandle, buffer, latency,&frames_out)<  0) {
> -	fprintf(stderr, "write error\n");
> -	return 1;
> -    }
> -
> -    if ((err = snd_pcm_start(chandle))<  0) {
> -	printf("Go error: %s\n", snd_strerror(err));
> -	return 1;
> -    }
> -    return 0;
>   }
> 
> -int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
> +static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
>   {
>       snd_pcm_t *phandle, *chandle;
>       char *buffer;
>       int err;
>       ssize_t r;
> -    size_t frames_in, frames_out, in_max;
>       struct final_params negotiated;
> -    int ret = 0;
>       snd_pcm_format_t format = SND_PCM_FORMAT_S16_LE;
> +    char pdevice_new[32];
> 
> -    err = snd_output_stdio_attach(&output, stdout, 0);
> +    err = snd_output_stdio_attach(&output, error_fp, 0);
>       if (err<  0) {
> -	printf("Output failed: %s\n", snd_strerror(err));
> +	fprintf(error_fp, "alsa: Output failed: %s\n", snd_strerror(err));
>   	return 0;
>       }
> 
> -//    setscheduler();
> -
> -    printf("Playback device is %s\n", pdevice);
> -    printf("Capture device is %s\n", cdevice);
> -
>       /* Open the devices */
>       if ((err = snd_pcm_open(&phandle, pdevice, SND_PCM_STREAM_PLAYBACK,
> -			    SND_PCM_NONBLOCK))<  0) {
> -	printf("Cannot open ALSA Playback device %s: %s\n", pdevice,
> -	       snd_strerror(err));
> +			    0))<  0) {
> +	fprintf(error_fp, "alsa: Cannot open playback device %s: %s\n",
> +		pdevice, snd_strerror(err));
>   	return 0;
>       }
>       if ((err = snd_pcm_open(&chandle, cdevice, SND_PCM_STREAM_CAPTURE,
>   			    SND_PCM_NONBLOCK))<  0) {
> -	printf("Cannot open ALSA Capture device %s: %s\n",
> -	       cdevice, snd_strerror(err));
> +	fprintf(error_fp, "alsa: Cannot open capture device %s: %s\n",
> +		cdevice, snd_strerror(err));
>   	return 0;
>       }
> 
> -    frames_in = frames_out = 0;
> -    if (setparams(phandle, chandle, format,&negotiated)<  0) {
> -	printf("setparams failed\n");
> +    err = setparams(phandle, chandle, format, latency, 0,&negotiated);
> +
> +    /* Try to use plughw instead, as it allows emulating speed */
> +    if (err == 2&&  strncmp(pdevice, "hw", 2) == 0) {
> +
> +	snd_pcm_close(phandle);
> +
> +	sprintf(pdevice_new, "plug%s", pdevice);
> +	pdevice = pdevice_new;
> +	if (verbose)
> +	    fprintf(error_fp, "alsa: Trying %s for playback\n", pdevice);
> +	if ((err = snd_pcm_open(&phandle, pdevice, SND_PCM_STREAM_PLAYBACK,
> +				0))<  0) {
> +	    fprintf(error_fp, "alsa: Cannot open playback device %s: %s\n",
> +		    pdevice, snd_strerror(err));
> +	}
> +
> +	err = setparams(phandle, chandle, format, latency, 1,&negotiated);
> +    }
> +
> +    if (err != 0) {
> +	fprintf(error_fp, "alsa: setparams failed\n");
>   	return 1;
>       }
> 
>       buffer = malloc((negotiated.bufsize * snd_pcm_format_width(format) / 8)
>   		    * negotiated.channels);
>       if (buffer == NULL) {
> -	printf("Failed allocating buffer for audio\n");
> +	fprintf(error_fp, "alsa: Failed allocating buffer for audio\n");
>   	return 0;
> -
> -    }
> -    if ((err = snd_pcm_link(chandle, phandle))<  0) {
> -	printf("Streams link error: %d %s\n", err, snd_strerror(err));
> -	return 1;
>       }
> 
> -    startup_capture(phandle, chandle, format, buffer, negotiated.latency,
> -		    negotiated.channels);
> -
> -    while (1) { 			
> -	in_max = 0;
> -
> +    /*
> +     * Buffering delay is due for capture and for playback, so we
> +     * need to multiply it by two.
> +     */
> +    fprintf(error_fp,
> +	    "alsa: stream started from %s to %s (%i Hz, buffer delay = %.2f ms)\n",
> +	    cdevice, pdevice, negotiated.rate,
> +	    negotiated.latency * 1000.0 / negotiated.rate);
> +
> +    alsa_is_running = 1;
> +
> +    while (!stop_alsa) {
> +	/* We start with a read and not a wait to auto(re)start the capture */
> +	r = readbuf(chandle, buffer, negotiated.bufsize);
> +	if (r == 0)   /* Succesfully recovered from an overrun? */
> +	    continue; /* Force restart of capture stream */
> +	if (r>  0)
> +	    writebuf(phandle, buffer, r);
>   	/* use poll to wait for next event */
> -	ret = snd_pcm_wait(chandle, 1000);
> -	if (ret<  0) {
> -	    if ((err = snd_pcm_recover(chandle, ret, 0))<  0) {
> -		fprintf(stderr, "xrun: recover error: %s",
> -			snd_strerror(err));
> -		break;
> -	    }
> -
> -	    /* Restart capture */
> -	    startup_capture(phandle, chandle, format, buffer,
> -			    negotiated.latency, negotiated.channels);
> -	    continue;
> -	} else if (ret == 0) {
> -	    /* Timed out */
> -	    continue;
> -	}
> -
> -	if ((r = readbuf(chandle, buffer, negotiated.latency,&frames_in,
> -			&in_max))>  0) {
> -	    if (writebuf(phandle, buffer, r,&frames_out)<  0) {
> -		startup_capture(phandle, chandle, format, buffer,
> -				negotiated.latency, negotiated.channels);
> -	    }
> -	} else if (r<  0) {
> -	    startup_capture(phandle, chandle, format, buffer,
> -			    negotiated.latency, negotiated.channels);
> -	}
> +	snd_pcm_wait(chandle, 1000);
>       }
> 
>       snd_pcm_drop(chandle);
> @@ -451,28 +494,55 @@ int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
> 
>       snd_pcm_close(phandle);
>       snd_pcm_close(chandle);
> +
> +    alsa_is_running = 0;
>       return 0;
>   }
> 
>   struct input_params {
> -    const char *pdevice;
> -    const char *cdevice;
> +    char *pdevice;
> +    char *cdevice;
> +    int latency;
>   };
> 
> -void *tvtime_alsa_thread_entry(void *whatever)
> +static void *alsa_thread_entry(void *whatever)
>   {
>       struct input_params *inputs = (struct input_params *) whatever;
> -    tvtime_alsa_stream(inputs->pdevice, inputs->cdevice);
> +
> +    if (verbose)
> +	fprintf(error_fp, "alsa: starting copying alsa stream from %s to %s\n",
> +		inputs->cdevice, inputs->pdevice);
> +    alsa_stream(inputs->pdevice, inputs->cdevice, inputs->latency);
> +    fprintf(error_fp, "alsa: stream stopped\n");
> +
> +    free(inputs->pdevice);
> +    free(inputs->cdevice);
> +    free(inputs);
> +
> +    return NULL;
>   }
> 
> -int tvtime_alsa_thread_startup(const char *pdevice, const char *cdevice)
> +/*************************************************************************
> + Public functions
> + *************************************************************************/
> +
> +int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
> +			FILE *__error_fp, int __verbose)
>   {
>       int ret;
>       pthread_t thread;
>       struct input_params *inputs = malloc(sizeof(struct input_params));
> 
> +    if (__error_fp)
> +	error_fp = __error_fp;
> +    else
> +	error_fp = stderr;
> +
> +    verbose = __verbose;
> +
> +
>       if (inputs == NULL) {
> -	printf("failed allocating memory for ALSA inputs\n");
> +	fprintf(error_fp, "alsa: failed allocating memory for inputs\n");
>   	return 0;
>       }
> 
> @@ -484,18 +554,27 @@ int tvtime_alsa_thread_startup(const char *pdevice, const char *cdevice)
> 
>       inputs->pdevice = strdup(pdevice);
>       inputs->cdevice = strdup(cdevice);
> +    inputs->latency = latency;
> +
> +    if (alsa_is_running) {
> +       stop_alsa = 1;
> +       while ((volatile int)alsa_is_running)
> +	       usleep(10);
> +    }
> +
> +    stop_alsa = 0;
> 
>       ret = pthread_create(&thread, NULL,
> -			&tvtime_alsa_thread_entry, (void *) inputs);
> +			&alsa_thread_entry, (void *) inputs);
>       return ret;
>   }
> 
> -#ifdef TVTIME_ALSA_DEBUGGING
> -/* This allows the alsa_stream.c to be a standalone binary for debugging */
> - int main(int argc, char *argv[])
> +void alsa_thread_stop(void)
> +{
> +	stop_alsa = 1;
> +}
> +
> +int alsa_thread_is_running(void)
>   {
> -    char *pdevice = "hw:0,0";
> -    char *cdevice = "hw:1,0";
> -    tvtime_alsa_stream(pdevice, cdevice);
> +	return alsa_is_running;
>   }
> -#endif
> diff --git a/src/alsa_stream.h b/src/alsa_stream.h
> index 8572c8b..c68fd6d 100644
> --- a/src/alsa_stream.h
> +++ b/src/alsa_stream.h
> @@ -1 +1,5 @@
> -int tvtime_alsa_thread_startup(char *pdevice, char *cdevice);
> +int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
> +			FILE *__error_fp,
> +			int __verbose);
> +void alsa_thread_stop(void);
> +int alsa_thread_is_running(void);
> diff --git a/src/tvtime.c b/src/tvtime.c
> index 75257d1..d9066cc 100644
> --- a/src/tvtime.c
> +++ b/src/tvtime.c
> @@ -1256,8 +1256,10 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
>       }
> 
>       /* Setup the ALSA streaming device */
> -    tvtime_alsa_thread_startup(config_get_alsa_outputdev( ct ),
> -			       config_get_alsa_inputdev( ct ) );
> +    alsa_thread_startup(config_get_alsa_outputdev( ct ),
> +			config_get_alsa_inputdev( ct ),
> +			30,		/* FIXME: Add a var to adjust latency */
> +			stderr, verbose );
> 
>       /* Setup the speedy calls. */
>       setup_speedy_calls( mm_accel(), verbose );

