Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4503 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3FNOof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 10:44:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] Don't call G_TUNER unless actually performing a tuning related call
Date: Fri, 14 Jun 2013 16:44:20 +0200
Cc: linux-media@vger.kernel.org
References: <1371218366-16081-1-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1371218366-16081-1-git-send-email-dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141644.20188.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 14 2013 15:59:26 Devin Heitmueller wrote:
> Making G_TUNER calls can take a long time on some tuners, in
> particular those that load firmware or do power management.  As a
> result, we don't want to call G_TUNER unless the user is actually
> doing a tuning related call.  The current code makes a G_TUNER
> call regardless of what command the user is attempting to perform.
> 
> Problem originally identified on the HVR-950q, where even doing
> operations like toggling from the composite to the s-video input
> would take over 1000ms.
> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>

I've committed this. Thanks, this makes a lot of sense!

Regards,

	Hans

> ---
>  utils/v4l2-ctl/v4l2-ctl-tuner.cpp | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> index ebe74d3..9af6b13 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> @@ -254,6 +254,13 @@ void tuner_set(int fd)
>  		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  	double fac = 16;
>  
> +	if (!options[OptSetFreq] && ! options[OptSetTuner] && !options[OptListFreqBands]
> +	    && !options[OptSetModulator] && !options[OptFreqSeek]) {
> +		/* Don't actually call G_[MODULATOR/TUNER] if we don't intend to
> +		   actually perform any tuner related function */
> +		return;
> +	}
> +
>  	if (capabilities & V4L2_CAP_MODULATOR) {
>  		type = V4L2_TUNER_RADIO;
>  		modulator.index = tuner_index;
> 
