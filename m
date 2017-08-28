Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:55670 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdH1Slr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 14:41:47 -0400
Date: Mon, 28 Aug 2017 15:41:37 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] [media] solo6x10:  make video_device const
Message-ID: <20170828184136.GA9847@pirotess.bf.iodev.co.uk>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
 <1503746014-16489-4-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503746014-16489-4-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/Aug/2017 16:43, Bhumika Goyal wrote:
> Make this const as it is only used in a copy operation.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> index 3266fc2..99ffd1e 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> @@ -630,7 +630,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
>  	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device solo_v4l2_template = {
> +static const struct video_device solo_v4l2_template = {
>  	.name			= SOLO6X10_NAME,
>  	.fops			= &solo_v4l2_fops,
>  	.ioctl_ops		= &solo_v4l2_ioctl_ops,
> -- 
> 1.9.1
> 

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
