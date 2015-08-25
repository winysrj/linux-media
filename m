Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37533 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbbHYUer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 16:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <55df3b23389e68b19354011babf0da1d26d0a91a.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<55df3b23389e68b19354011babf0da1d26d0a91a.1440359643.git.mchehab@osg.samsung.com>
Date: Tue, 25 Aug 2015 14:34:46 -0600
Message-ID: <CAKocOOPMBmUKkR=Zz2yxX3e9sLr3ST-cVM0BO7qVFMLN07ktGQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/44] [media] uapi/media.h: Declare interface types
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org, shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Declare the interface types that will be used by the new
> G_TOPOLOGY ioctl that will be defined latter on.
>
> For now, we need those types, as they'll be used on the
> internal structs associated with the new media_interface
> graph object defined on the next patch.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 4e816be3de39..21c96cd7a6ae 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -167,6 +167,35 @@ struct media_links_enum {
>         __u32 reserved[4];
>  };
>
> +/* Interface type ranges */
> +
> +#define MEDIA_INTF_T_DVB_BASE  0x00000000
> +#define MEDIA_INTF_T_V4L_BASE  0x00000100
> +#define MEDIA_INTF_T_ALSA_BASE 0x00000200
> +
> +/* Interface types */
> +
> +#define MEDIA_INTF_T_DVB_FE            (MEDIA_INTF_T_DVB_BASE)
> +#define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_INTF_T_DVB_BASE + 1)
> +#define MEDIA_INTF_T_DVB_DVR    (MEDIA_INTF_T_DVB_BASE + 2)
> +#define MEDIA_INTF_T_DVB_CA     (MEDIA_INTF_T_DVB_BASE + 3)
> +#define MEDIA_INTF_T_DVB_NET    (MEDIA_INTF_T_DVB_BASE + 4)
> +
> +#define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_INTF_T_V4L_BASE)
> +#define MEDIA_INTF_T_V4L_VBI    (MEDIA_INTF_T_V4L_BASE + 1)
> +#define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
> +#define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
> +#define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
> +
> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)

Is it necessary to add ALSA types at this time without ALSA media
controller work?
Can these be added later when ALSA work is done.

thanks,
-- Shuah
