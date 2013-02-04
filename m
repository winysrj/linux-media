Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54667 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3BCPe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:34:56 -0500
Received: by mail-pa0-f53.google.com with SMTP id bg4so2905372pad.12
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:34:55 -0800 (PST)
Message-ID: <510F3B46.1010607@gmail.com>
Date: Sun, 03 Feb 2013 23:38:30 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 09/18] tlg2300: add missing video_unregister_device.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <b16063fd51aef975fa54b1ebf9d62d88f5c9f48b.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <b16063fd51aef975fa54b1ebf9d62d88f5c9f48b.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-radio.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index 80307d3..0f958f7 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -334,6 +334,7 @@ int poseidon_fm_init(struct poseidon *p)
>  
>  int poseidon_fm_exit(struct poseidon *p)
>  {
> +	video_unregister_device(&p->radio_data.fm_dev);
>  	v4l2_ctrl_handler_free(&p->radio_data.ctrl_handler);
>  	return 0;
>  }
Acked-by: Huang Shijie <shijie8@gmail.com>
