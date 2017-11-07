Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60273 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753736AbdKGKtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 05:49:18 -0500
Date: Tue, 7 Nov 2017 08:49:08 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH] [media] dvb-core: dvb_frontend_handle_ioctl(): init err
 to -EOPNOTSUPP
Message-ID: <20171107084908.48985365@vento.lan>
In-Reply-To: <20171030221808.4642-1-d.scheller.oss@gmail.com>
References: <20171030221808.4642-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Oct 2017 23:18:08 +0100
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Fixes: d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic")
> 
> The mentioned commit cleaned up the ioctl handling, but caused an issue
> with the DVBv3 when they're not defined in a frontend's fe_ops: When a
> userspace application checks for existence and success of a fe_ops with ie.
> 
>   if (!ioctl(fd, FE_READ_BER, &val))
> 
> this will not report failure anymore since in dvb_frontend_handle_ioctl(),
> err is unitialised and thus zero, and "case FE_READ_BER" (and the
> following) doesn't care about the case that fe_op isn't set by the frontend
> driver. So, success is always reported while the value at the passed ptr
> isn't updated. This breaks userspace applications relying on v3 stats.
> 
> Fix this by initialising err to -EOPNOTSUPP like it was before the commit.
> This only affects (and fixes) the DVBv3 stat ioctls, every other handled
> ioctl sets err to a proper return value.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
> Discovered and tested with TVHeadend (current GIT master HEAD) which does
> fallback to DVBv3 stats inquiry when v5 is absent.
> 
>  drivers/media/dvb-core/dvb_frontend.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index daaf969719e4..cc64fa38a1df 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2113,6 +2113,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
>  
>  	dev_dbg(fe->dvb->device, "%s:\n", __func__);
>  
> +	err = -EOPNOTSUPP;
> +

This patch is incomplete and will cause troubles with DVBv5. The
right fix is:

	https://patchwork.linuxtv.org/patch/45277/


Could you please test reply to its tread with a tested-by if it passes 
on your tests?

Thanks,
Mauro
