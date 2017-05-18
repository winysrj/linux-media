Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42599 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751486AbdERTA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 15:00:57 -0400
Date: Thu, 18 May 2017 19:48:28 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Michael Buesch <m@bues.ch>, anton@corp.bluecherry.net
Subject: Re: [PATCH 1/4] [media] tw5864, fc0011: better handle WARN_ON()
Message-ID: <20170518184828.GA6449@dell-m4800>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 18, 2017 at 11:06:43AM -0300, Mauro Carvalho Chehab wrote:
> As such macro will check if the expression is true, it may fall through, as
> warned:

> On both cases, it means an error, so, let's return an error
> code, to make gcc happy.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/pci/tw5864/tw5864-video.c | 1 +
>  drivers/media/tuners/fc0011.c           | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
> index 2a044be729da..e7bd2b8484e3 100644
> --- a/drivers/media/pci/tw5864/tw5864-video.c
> +++ b/drivers/media/pci/tw5864/tw5864-video.c
> @@ -545,6 +545,7 @@ static int tw5864_fmt_vid_cap(struct file *file, void *priv,
>  	switch (input->std) {
>  	default:
>  		WARN_ON_ONCE(1);
> +		return -EINVAL;
>  	case STD_NTSC:
>  		f->fmt.pix.height = 480;
>  		break;

Hi Mauro,

Thanks for the patch.

I actually meant it to fall through, but I agree this is not how it
should be.
I'm fine with this patch. Unfortunately I don't possess tw5864 hardware
now. CCing Anton Sviridenko whom I've handed it (I guess he's on
Bluecherry Maintainers groupmail as well).

Anton, just in case, could you please ensure the driver with this patch
works well in runtime?
