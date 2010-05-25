Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0EYKay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 06:30:54 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4PAUqol032196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 25 May 2010 06:30:52 -0400
Message-ID: <4BFBA73A.8020305@redhat.com>
Date: Tue, 25 May 2010 12:32:26 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: huzaifas@redhat.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4l1: move v4l1 ioctls from kernel to libv4l1:VIDIOCGCHAN
References: <1274781999-19738-1-git-send-email-huzaifas@redhat.com>
In-Reply-To: <1274781999-19738-1-git-send-email-huzaifas@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks, added to my tree and pushed.

Regards,

Hans

On 05/25/2010 12:06 PM, huzaifas@redhat.com wrote:
> From: Huzaifa Sidhpurwala<huzaifas@redhat.com>
>
> move VIDIOCGCHAN to libv4l1
>
> Signed-off-by: Huzaifa Sidhpurwala<huzaifas@redhat.com>
> ---
>   lib/libv4l1/libv4l1.c |   39 ++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 38 insertions(+), 1 deletions(-)
>
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index 9bfddd3..f64025a 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -624,7 +624,44 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
>
>   		if ((devices[index].flags&  V4L1_SUPPORTS_ENUMINPUT)&&
>   				(devices[index].flags&  V4L1_SUPPORTS_ENUMSTD)) {
> -			result = SYS_IOCTL(fd, request, arg);
> +
> +			v4l2_std_id sid;
> +
> +			input2.index = chan->channel;
> +			result = SYS_IOCTL(fd, VIDIOC_ENUMINPUT,&input2);
> +			if (result<  0)
> +				break;
> +
> +			chan->channel = input2.index;
> +			memcpy(chan->name, input2.name,
> +				min(sizeof(chan->name), sizeof(input2.name)));
> +
> +			chan->name[sizeof(chan->name) - 1] = 0;
> +			chan->tuners =
> +				(input2.type == V4L2_INPUT_TYPE_TUNER) ? 1 : 0;
> +
> +			chan->flags = (chan->tuners) ? VIDEO_VC_TUNER : 0;
> +			switch (input2.type) {
> +			case V4L2_INPUT_TYPE_TUNER:
> +				chan->type = VIDEO_TYPE_TV;
> +				break;
> +			default:
> +			case V4L2_INPUT_TYPE_CAMERA:
> +				chan->type = VIDEO_TYPE_CAMERA;
> +				break;
> +			}
> +			chan->norm = 0;
> +			if (SYS_IOCTL(fd, VIDIOC_G_STD,&sid) == 0) {
> +				if (sid&  V4L2_STD_PAL)
> +					chan->norm = VIDEO_MODE_PAL;
> +				if (sid&  V4L2_STD_NTSC)
> +					chan->norm = VIDEO_MODE_NTSC;
> +				if (sid&  V4L2_STD_SECAM)
> +					chan->norm = VIDEO_MODE_SECAM;
> +				if (sid == V4L2_STD_ALL)
> +					chan->norm = VIDEO_MODE_AUTO;
> +			}
> +
>   			break;
>   		}
>
