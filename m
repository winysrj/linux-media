Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:43489 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1033381AbeBOOi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 09:38:56 -0500
Subject: Re: [PATCH] media: radio: Critical interrupt bugfix for si470x over
 i2c
To: Douglas Fischer <fischerdouglasc@gmail.com>,
        linux-media@vger.kernel.org
References: <20180126184210.1830c59f@Constantine>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <31a2f2ec-56ce-ed78-cee8-c92a7beed1f6@xs4all.nl>
Date: Thu, 15 Feb 2018 15:38:55 +0100
MIME-Version: 1.0
In-Reply-To: <20180126184210.1830c59f@Constantine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/01/18 00:42, Douglas Fischer wrote:
> Fixed si470x_start() disabling the interrupt signal, causing tune
> operations to never complete. This does not affect USB radios
> because they poll the registers instead of using the IRQ line.
> 
> Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
> ---
> 
> diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> linux/drivers/media/radio/si470x/radio-si470x-common.c ---
> linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> 2018-01-15 21:58:10.675620432 -0500 +++
> linux/drivers/media/radio/si470x/radio-si470x-common.c
> 2018-01-16 16:54:23.699770645 -0500 @@ -377,8 +377,13 @@ int
> si470x_start(struct si470x_device *r goto done; /* sysconfig 1 */
> -	radio->registers[SYSCONFIG1] =
> -		(de << 11) & SYSCONFIG1_DE;		/* DE*/
> +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN;
> +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_STCIEN;
> +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDS;

Just do:

	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN | SYSCONFIG1_STCIEN |
					SYSCONFIG1_RDS;

> +	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;

Why is this cleared?

> +	radio->registers[SYSCONFIG1] |= 0x1 << 2;

What's this? It doesn't use a define, so either add one or add a comment.

> +	if (de)
> +		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
>  	retval = si470x_set_register(radio, SYSCONFIG1);
>  	if (retval < 0)
>  		goto done;
> 

Also, this is now set in si470x_start, so the same code can now be removed
in si470x_fops_open for i2c.

In general I would feel happier if you just add a 'bool is_i2c' argument to
si470x_start and only change SYSCONFIG1 for the i2c case.

Regards,

	Hans
