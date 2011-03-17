Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53907 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab1CQAHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 20:07:12 -0400
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes !=
 chunk size
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1300307071-19665-6-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
	 <1300307071-19665-6-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 20:07:22 -0400
Message-ID: <1300320442.2296.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-03-16 at 16:24 -0400, Jarod Wilson wrote:
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/staging/lirc/lirc_zilog.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> index 407d4b4..5ada643 100644
> --- a/drivers/staging/lirc/lirc_zilog.c
> +++ b/drivers/staging/lirc/lirc_zilog.c
> @@ -950,6 +950,10 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
>  				ret = copy_to_user((void *)outbuf+written, buf,
>  						   rbuf->chunk_size);
>  				written += rbuf->chunk_size;
> +			} else {
> +				zilog_error("Buffer read failed!\n");
> +				ret = -EIO;
> +				break;

No need to break, just let the non-0 ret value drop you out of the while
loop.

Regards,
Andy

>  			}
>  		}
>  	}


