Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK0jpdf012460
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:45:51 -0500
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK0jaDc020664
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:45:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Date: Sat, 20 Dec 2008 01:45:07 +0100
References: <200812192254.mBJMsfia029162@imap1.linux-foundation.org>
	<494C3E20.1070800@oracle.com>
In-Reply-To: <494C3E20.1070800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812200145.08394.hverkuil@xs4all.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH -next/mmotm] media/video/tuner: fix
	tuner_ioctl build error
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Saturday 20 December 2008 01:36:48 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix drivers/media/video/tuner-core.c so that it will build when
> CONFIG_VIDEO_ALLOW_V4L1=n:
>
> drivers/media/video/tuner-core.c:1111: error: 'tuner_ioctl' undeclared
> here (not in a function)
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> cc: v4l-dvb-maintainer@linuxtv.org
> cc: video4linux-list@redhat.com
> ---
>  drivers/media/video/tuner-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- mmotm-2008-1219-1438.orig/drivers/media/video/tuner-core.c
> +++ mmotm-2008-1219-1438/drivers/media/video/tuner-core.c
> @@ -919,6 +919,11 @@ static int tuner_ioctl(struct v4l2_subde
>  	}
>  	return -ENOIOCTLCMD;
>  }
> +#else
> +static int tuner_ioctl(struct v4l2_subdev *sd, int cmd, void *arg)
> +{
> +	return -ENOIOCTLCMD;
> +}
>  #endif
>
>  static int tuner_s_config(struct v4l2_subdev *sd, const struct
> v4l2_priv_tun_config *cfg)

NAK. I've already made a better fix for this and asked Mauro to pull this 
from my tree. The tuner_ioctl function pointer should have been under the 
CONFIG_VIDEO_ALLOW_V4L1 #ifdef as well avoiding the need to make an empty 
function.

Nevertheless, thanks for the effort!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
