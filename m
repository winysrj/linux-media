Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbbJTIU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 04:20:29 -0400
Subject: Re: [PATCH] gspca: correctly checked failed allocation
To: Insu Yun <wuninsu@gmail.com>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1445272994-25312-1-git-send-email-wuninsu@gmail.com>
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5625F947.7000209@redhat.com>
Date: Tue, 20 Oct 2015 10:20:23 +0200
MIME-Version: 1.0
In-Reply-To: <1445272994-25312-1-git-send-email-wuninsu@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 19-10-15 18:43, Insu Yun wrote:
> create_singlethread_workqueue can be failed in memory pressue.
> So, check return value and return -ENOMEM
>
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>   drivers/media/usb/gspca/sq905.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
> index a7ae0ec..b1c25d9a 100644
> --- a/drivers/media/usb/gspca/sq905.c
> +++ b/drivers/media/usb/gspca/sq905.c
> @@ -392,6 +392,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	}
>   	/* Start the workqueue function to do the streaming */
>   	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
> +	if (!dev->work_thread)
> +		return -ENOMEM;
>   	queue_work(dev->work_thread, &dev->work_struct);
>
>   	return 0;

If the thread creation fails we should not send the start command,
so the create_singlethread_workqueue call should be moved
up in the function, while keeping the queue_work at the end.

And if the sq905_command fails then the workqueue should
be destroyed and dev->work_thread should be set to NULL
before returning the sq905_command failure to the caller.

Regards,

Hans
