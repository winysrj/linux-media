Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35805 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbcBGNXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 08:23:10 -0500
Received: by mail-lf0-f41.google.com with SMTP id l143so81671878lfe.2
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 05:23:09 -0800 (PST)
Date: Sun, 7 Feb 2016 14:23:07 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] soc_camera: cleanup control device on async_unbind
Message-ID: <20160207132307.GC3717@bigcity.dyn.berto.se>
References: <1451911723-10868-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1451911723-10868-1-git-send-email-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Wolfram Sang <wsa@the-dreams.de> [2016-01-04 13:48:24 +0100]:

> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>
> I got the following WARN on a simple unbind/bind cycle:
>
> root@Lager:/sys/bus/i2c/drivers/adv7180# echo 6-0020 > unbind
> root@Lager:/sys/bus/i2c/drivers/adv7180# echo 6-0020 > bind
> [   31.097652] adv7180 6-0020: chip found @ 0x20 (e6520000.i2c)
> [   31.123744] ------------[ cut here ]------------
> [   31.128413] WARNING: CPU: 3 PID: 873 at drivers/media/platform/soc_camera/soc_camera.c:1463 soc_camera_async_bound+0x40/0xa0()
> [   31.139896] CPU: 3 PID: 873 Comm: sh Not tainted 4.4.0-rc3-00062-ge8ae2c0b6bca2a #172
> [   31.147815] Hardware name: Generic R8A7790 (Flattened Device Tree)
> [   31.154056] Backtrace:
> [   31.156575] [<c0014bc0>] (dump_backtrace) from [<c0014d80>] (show_stack+0x20/0x24)
> [   31.164233]  r6:c05c5b33 r5:00000009 r4:00000000 r3:00404100
> [   31.170017] [<c0014d60>] (show_stack) from [<c01e2344>] (dump_stack+0x78/0x94)
> [   31.177344] [<c01e22cc>] (dump_stack) from [<c0029e7c>] (warn_slowpath_common+0x98/0xc4)
> [   31.185518]  r4:00000000 r3:00000000
> [   31.189172] [<c0029de4>] (warn_slowpath_common) from [<c0029fa0>] (warn_slowpath_null+0x2c/0x34)
> [   31.198043]  r8:eb38df28 r7:eb38c5d0 r6:eb38de80 r5:e6962810 r4:eb38de80
> [   31.204898] [<c0029f74>] (warn_slowpath_null) from [<c0356348>] (soc_camera_async_bound+0x40/0xa0)
> [   31.213955] [<c0356308>] (soc_camera_async_bound) from [<c03499a0>] (v4l2_async_test_notify+0x9c/0x108)
> [   31.223430]  r5:eb38c5ec r4:eb38de80
> [   31.227084] [<c0349904>] (v4l2_async_test_notify) from [<c0349dd8>] (v4l2_async_register_subdev+0x88/0xd0)
> [   31.236822]  r7:c07115c8 r6:c071160c r5:eb38c5ec r4:eb38de80
> [   31.242622] [<c0349d50>] (v4l2_async_register_subdev) from [<c0337040>] (adv7180_probe+0x2c8/0x3a4)
> [   31.251753]  r8:00000000 r7:00000001 r6:eb38de80 r5:ea973400 r4:eb38de10 r3:00000000
> [   31.259660] [<c0336d78>] (adv7180_probe) from [<c032dd80>] (i2c_device_probe+0x1a0/0x1e4)
>
> This gets fixed by clearing the control device pointer on async_unbind.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Tested-by: Niklas S�derlund <niklas.soderlund@ragnatech.se>

Tested on Koelsch and the camera works fine after a unbind/bind
operation.

> ---
>
> I stumbled over this while playing with OF_DYNAMIC and rebinding various
> devices through that. I have to admit I am not actually using the camera
> interface besides binding to it. This shouldn't make a difference, though :)
>
> Stable material, I'd think.
>
>  drivers/media/platform/soc_camera/soc_camera.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index dc98122e78dc50..361275c9f770d7 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1493,6 +1493,8 @@ static void soc_camera_async_unbind(struct v4l2_async_notifier *notifier,
>  					struct soc_camera_async_client, notifier);
>  	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
>
> +	icd->control = NULL;
> +
>  	if (icd->clk) {
>  		v4l2_clk_unregister(icd->clk);
>  		icd->clk = NULL;
> --
> 2.1.4
>
