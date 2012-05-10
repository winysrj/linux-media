Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab2EJIMc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:12:32 -0400
Message-ID: <4FAB7871.7050008@redhat.com>
Date: Thu, 10 May 2012 10:12:33 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 3/5] tea575x-tuner: mark VIDIOC_S_HW_FREQ_SEEK as
 an invalid ioctl.
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <c1bd86921cf9aba29d8edfc30712e9d39fb3dd87.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <c1bd86921cf9aba29d8edfc30712e9d39fb3dd87.1336632433.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


On 05/10/2012 09:05 AM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> The tea575x-tuner framework can support the VIDIOC_S_HW_FREQ_SEEK for only
> some of the tea575x-based boards. Mark this ioctl as invalid if the board
> doesn't support it.
>
> This fixes an issue with S_HW_FREQ_SEEK in combination with priority handling:
> since the priority check is done first it could return -EBUSY, even though
> calling the S_HW_FREQ_SEEK ioctl would return -ENOTTY. It should always return
> ENOTTY in such a case.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   sound/i2c/other/tea575x-tuner.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
> index a63faec..6e9ca7b 100644
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -375,6 +375,9 @@ int snd_tea575x_init(struct snd_tea575x *tea)
>   	tea->vd.v4l2_dev = tea->v4l2_dev;
>   	tea->vd.ctrl_handler =&tea->ctrl_handler;
>   	set_bit(V4L2_FL_USE_FH_PRIO,&tea->vd.flags);
> +	/* disable hw_freq_seek if we can't use it */
> +	if (tea->cannot_read_data)
> +		v4l2_dont_use_cmd(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
>
>   	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
>   	v4l2_ctrl_new_std(&tea->ctrl_handler,&tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
