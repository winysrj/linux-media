Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab1GXPVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 11:21:11 -0400
Message-ID: <4E2C38BF.80901@redhat.com>
Date: Sun, 24 Jul 2011 17:22:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?ISO-8859-1?Q?Jean-Fran=E7ois_Moine?= <moinejf@free.fr>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] pwc: precedence bug in pwc_init_controls()
References: <20110723185303.GA3711@shale.localdomain>
In-Reply-To: <20110723185303.GA3711@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks I've added your patch to my gspca/pwc tree and
send an updated pull request to Mauro including your patch.

Regards,

Hans


On 07/23/2011 08:53 PM, Dan Carpenter wrote:
> '!' has higher precedence than'&' so we need parenthesis here.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
> index e9a0e94..8c70e64 100644
> --- a/drivers/media/video/pwc/pwc-v4l.c
> +++ b/drivers/media/video/pwc/pwc-v4l.c
> @@ -338,7 +338,7 @@ int pwc_init_controls(struct pwc_device *pdev)
>   	if (pdev->restore_factory)
>   		pdev->restore_factory->flags = V4L2_CTRL_FLAG_UPDATE;
>
> -	if (!pdev->features&  FEATURE_MOTOR_PANTILT)
> +	if (!(pdev->features&  FEATURE_MOTOR_PANTILT))
>   		return hdl->error;
>
>   	/* Motor pan / tilt / reset */
