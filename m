Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:52141 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbZJCTPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 15:15:10 -0400
Date: Sat, 3 Oct 2009 12:07:53 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tuner-simple: possible read buffer overflow?
In-Reply-To: <4AC79FE0.6030008@gmail.com>
Message-ID: <Pine.LNX.4.58.0910031206260.30284@shell2.speakeasy.net>
References: <4AC79FE0.6030008@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Oct 2009, Roel Kluin wrote:
> Prevent read from t_params->ranges[-1].
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> This is only required when t_params->count can be 0, can it?

Shouldn't be possible, or the tuner would be useless.

> -	if (i == t_params->count) {
> +	if (i == t_params->count && i) {
>  		tuner_dbg("frequency out of range (%d > %d)\n",
>  			  *frequency, t_params->ranges[i - 1].limit);
>  		*frequency = t_params->ranges[--i].limit;
