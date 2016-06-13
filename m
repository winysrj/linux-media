Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:34943 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423299AbcFMNpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 09:45:01 -0400
Received: by mail-it0-f41.google.com with SMTP id z189so49440675itg.0
        for <linux-media@vger.kernel.org>; Mon, 13 Jun 2016 06:44:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160611195632.GA1403@mwanda>
References: <20160611195632.GA1403@mwanda>
Date: Mon, 13 Jun 2016 09:44:55 -0400
Message-ID: <CABxcv=kH3+dER8k=i4E5VYVYv9gy+rf9gqzOLfVyNkH50w3ZJQ@mail.gmail.com>
Subject: Re: [patch] media: s5p-mfc: fix a couple double frees in probe
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dan,

On Sat, Jun 11, 2016 at 3:56 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The extra calls to video_device_release() are a bug, we free these after
> the goto.
>
> Fixes: c974c436eaf4 ('s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Thanks for the patch but Shuah already posted the same fix before:

https://lkml.org/lkml/2016/6/8/1210

Best regards,
Javier
