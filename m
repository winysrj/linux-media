Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45085
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbcFPTxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 15:53:40 -0400
Date: Thu, 16 Jun 2016 16:53:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv16 05/13] cec/TODO: add TODO file so we know why this is
 still in staging
Message-ID: <20160616165334.05e94cf0@recife.lan>
In-Reply-To: <1461937948-22936-6-git-send-email-hverkuil@xs4all.nl>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
	<1461937948-22936-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Apr 2016 15:52:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Explain why cec.c is still in staging.

Hmm... as this is for staging, even having pointed several things to
be improved, I may end merging this series. Will decide after finishing
the patch review.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/staging/media/cec/TODO | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>  create mode 100644 drivers/staging/media/cec/TODO
> 
> diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
> new file mode 100644
> index 0000000..c0751ef
> --- /dev/null
> +++ b/drivers/staging/media/cec/TODO
> @@ -0,0 +1,13 @@
> +The reason why cec.c is still in staging is that I would like
> +to have a bit more confidence in the uABI. The kABI is fine,
> +no problem there, but I would like to let the public API mature
> +a bit.
> +
> +Once I'm confident that I didn't miss anything then the cec.c source
> +can move to drivers/media and the linux/cec.h and linux/cec-funcs.h
> +headers can move to uapi/linux and added to uapi/linux/Kbuild to make
> +them public.
> +
> +Hopefully this will happen later in 2016.
> +
> +Hans Verkuil <hans.verkuil@cisco.com>



Thanks,
Mauro
