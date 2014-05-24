Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:41809 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaEXTTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 15:19:11 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 399111730AE
	for <linux-media@vger.kernel.org>; Sat, 24 May 2014 19:11:53 +0000 (UTC)
Message-ID: <1400958648.22191.3.camel@joe-AO725>
Subject: Re: [PATCH] msi3103: Use time_before_eq()
From: Joe Perches <joe@perches.com>
To: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: crope@iki.fi, m.chehab@samsung.com, gregkh@linuxfoundation.org,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 24 May 2014 12:10:48 -0700
In-Reply-To: <1400957276-13222-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400957276-13222-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2014-05-24 at 20:47 +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_before_eq() instead of plain, error-prone math.

A couple of unrelated, trivial notes: (repeated a few times)

> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
[]
> @@ -208,7 +208,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
>  	}
>  
>  	/* calculate samping rate and output it in 10 seconds intervals */

s/samping/sampling/

> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
>  		unsigned long jiffies_now = jiffies;
>  		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

Perhaps better to subtract then convert
instead of convert twice then subtract.


