Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:35611 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750799AbdA0Wt7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 17:49:59 -0500
Message-ID: <1485556233.12563.142.camel@perches.com>
Subject: Re: [PATCH 6/6] staging: bcm2835-v4l2: Apply spelling fixes from
 checkpatch.
From: Joe Perches <joe@perches.com>
To: Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2017 14:30:33 -0800
In-Reply-To: <20170127215503.13208-7-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
         <20170127215503.13208-7-eric@anholt.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-27 at 13:55 -0800, Eric Anholt wrote:
> Generated with checkpatch.pl --fix-inplace and git add -p out of the
> results.

Maybe another.

> diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
[]
> @@ -239,7 +239,7 @@ static int bulk_receive(struct vchiq_mmal_instance *instance,
>  		pr_err("buffer list empty trying to submit bulk receive\n");
>  
>  		/* todo: this is a serious error, we should never have
> -		 * commited a buffer_to_host operation to the mmal
> +		 * committed a buffer_to_host operation to the mmal
>  		 * port without the buffer to back it up (underflow
>  		 * handling) and there is no obvious way to deal with
>  		 * this - how is the mmal servie going to react when

Perhaps s/servie/service/ ?


