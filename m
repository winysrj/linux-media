Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36832 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752985AbcHPLa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 07:30:28 -0400
Date: Tue, 16 Aug 2016 14:29:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-ctrls: append missing h264 profile string
Message-ID: <20160816112949.GA3182@valkosipuli.retiisi.org.uk>
References: <1471338582-1014-1-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471338582-1014-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Stan!

How are you doing? :-)

On Tue, Aug 16, 2016 at 12:09:42PM +0300, Stanimir Varbanov wrote:
> This appends missing "Stereo High" h264 profile string. Without
> it the v4l2 compliance would crash kernel with NULL pointer
> dereference at:
> 
> [   26.882278] [<ffff000008685cbc>] std_validate+0x378/0x42c
> [   26.886967] [<ffff000008687424>] set_ctrl+0x8c/0x134
> [   26.892521] [<ffff00000868755c>] v4l2_s_ctrl+0x90/0xf4
> [   26.897555] [<ffff00000867f3b0>] v4l_s_ctrl+0x4c/0x110
> [   26.902503] [<ffff00000867db04>] __video_do_ioctl+0x240/0x2b4
> [   26.907625] [<ffff00000867d778>] video_usercopy+0x33c/0x46c
> [   26.913441] [<ffff00000867d8bc>] video_ioctl2+0x14/0x1c
> [   26.918822] [<ffff000008678878>] v4l2_ioctl+0xe0/0x110
> [   26.924032] [<ffff0000081da898>] do_vfs_ioctl+0xb4/0x764
> [   26.929238] [<ffff0000081dafcc>] SyS_ioctl+0x84/0x98
> [   26.934707] [<ffff000008082f4c>] __sys_trace_return+0x0/0x4
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index f7abfad9ad23..adc2147fcff7 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -361,6 +361,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Scalable Baseline",
>  		"Scalable High",
>  		"Scalable High Intra",
> +		"Stereo High",
>  		"Multiview High",
>  		NULL,
>  	};

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
