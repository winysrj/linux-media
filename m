Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:47052 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeCWMYj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:24:39 -0400
Subject: Re: [PATCH 30/30] media: cec-core: fix a bug at cec_error_inj_write()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <c1b1e1d6a1588d099720f8c6509736b01ccdc6ae.1521806166.git.mchehab@s-opensource.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <8296b805-029a-88b5-ffdb-e35300a1f9b2@cisco.com>
Date: Fri, 23 Mar 2018 13:24:37 +0100
MIME-Version: 1.0
In-Reply-To: <c1b1e1d6a1588d099720f8c6509736b01ccdc6ae.1521806166.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/18 12:57, Mauro Carvalho Chehab wrote:
> If the adapter doesn't have error_inj_parse_line() ops, the
> write() logic won't return -EINVAL, but, instead, it will keep
> looping, because "count" is a non-negative number.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/cec/cec-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> index ea3eccfdba15..b0c87f9ea08f 100644
> --- a/drivers/media/cec/cec-core.c
> +++ b/drivers/media/cec/cec-core.c
> @@ -209,14 +209,14 @@ static ssize_t cec_error_inj_write(struct file *file,
>  	if (IS_ERR(buf))
>  		return PTR_ERR(buf);
>  	p = buf;
> -	while (p && *p && count >= 0) {
> +	while (p && *p) {
>  		p = skip_spaces(p);
>  		line = strsep(&p, "\n");
>  		if (!*line || *line == '#')
>  			continue;
>  		if (!adap->ops->error_inj_parse_line(adap, line)) {
> -			count = -EINVAL;
> -			break;
> +			kfree(buf);
> +			return -EINVAL;
>  		}
>  	}
>  	kfree(buf);
> 
