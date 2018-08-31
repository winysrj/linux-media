Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33310 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727191AbeHaMf2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 08:35:28 -0400
Subject: Re: [PATCH 3/5] media: cec: move compat_ioctl handling to cec-api.c
To: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Cc: y2038@lists.linaro.org, awalls@md.metrocast.net,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20180827195649.4170969-1-arnd@arndb.de>
 <20180827195649.4170969-3-arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9fb23fab-4d52-a35d-03bf-ddd49c238ff3@xs4all.nl>
Date: Fri, 31 Aug 2018 10:29:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180827195649.4170969-3-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/27/2018 09:56 PM, Arnd Bergmann wrote:
> All the CEC ioctls are compatible, and they are only implemented
> in one driver, so we can simply let this driver handle them
> natively.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Mauro, feel free to pick this up when you process the others in this
patch series.

Regards,

	Hans

> ---
>  drivers/media/cec/cec-api.c |  1 +
>  fs/compat_ioctl.c           | 12 ------------
>  2 files changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
> index b6536bbad530..9067728feb60 100644
> --- a/drivers/media/cec/cec-api.c
> +++ b/drivers/media/cec/cec-api.c
> @@ -665,6 +665,7 @@ const struct file_operations cec_devnode_fops = {
>  	.owner = THIS_MODULE,
>  	.open = cec_open,
>  	.unlocked_ioctl = cec_ioctl,
> +	.compat_ioctl = cec_ioctl,
>  	.release = cec_release,
>  	.poll = cec_poll,
>  	.llseek = no_llseek,
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index e38e6c785459..33f48933a865 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1195,18 +1195,6 @@ COMPATIBLE_IOCTL(VIDEO_CLEAR_BUFFER)
>  COMPATIBLE_IOCTL(VIDEO_SET_STREAMTYPE)
>  COMPATIBLE_IOCTL(VIDEO_SET_FORMAT)
>  COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
> -/* cec */
> -COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
> -COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
> -COMPATIBLE_IOCTL(CEC_ADAP_S_LOG_ADDRS)
> -COMPATIBLE_IOCTL(CEC_ADAP_G_PHYS_ADDR)
> -COMPATIBLE_IOCTL(CEC_ADAP_S_PHYS_ADDR)
> -COMPATIBLE_IOCTL(CEC_G_MODE)
> -COMPATIBLE_IOCTL(CEC_S_MODE)
> -COMPATIBLE_IOCTL(CEC_TRANSMIT)
> -COMPATIBLE_IOCTL(CEC_RECEIVE)
> -COMPATIBLE_IOCTL(CEC_DQEVENT)
> -
>  /* joystick */
>  COMPATIBLE_IOCTL(JSIOCGVERSION)
>  COMPATIBLE_IOCTL(JSIOCGAXES)
> 
