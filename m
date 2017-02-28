Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37295 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdB1VlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 16:41:14 -0500
Received: by mail-wm0-f48.google.com with SMTP id v77so22169074wmv.0
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 13:40:28 -0800 (PST)
Date: Tue, 28 Feb 2017 21:33:19 +0000
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        anton@corp.bluecherry.net
Subject: Re: [PATCH] [media] tw5864: use dev_warn instead of WARN to shut up
 warning
Message-ID: <20170228213319.GB7977@dell-m4800.Home>
References: <20170228211453.3688400-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228211453.3688400-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2017 at 10:14:37PM +0100, Arnd Bergmann wrote:
> tw5864_frameinterval_get() only initializes its output when it successfully
> identifies the video standard in tw5864_input. We get a warning here because
> gcc can't always track the state if initialized warnings across a WARN()
> macro, and thinks it might get used incorrectly in tw5864_s_parm:
> 
> media/pci/tw5864/tw5864-video.c: In function 'tw5864_s_parm':
> media/pci/tw5864/tw5864-video.c:816:38: error: 'time_base.numerator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> media/pci/tw5864/tw5864-video.c:819:31: error: 'time_base.denominator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Using dev_warn() instead of WARN() avoids the __branch_check__() in
> unlikely and lets the compiler see that the initialization is correct.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch.
Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

See the note below.

> ---
>  drivers/media/pci/tw5864/tw5864-video.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
> index 9421216bb942..4d9994a11c22 100644
> --- a/drivers/media/pci/tw5864/tw5864-video.c
> +++ b/drivers/media/pci/tw5864/tw5864-video.c
> @@ -717,6 +717,8 @@ static void tw5864_frame_interval_set(struct tw5864_input *input)
>  static int tw5864_frameinterval_get(struct tw5864_input *input,
>  				    struct v4l2_fract *frameinterval)
>  {
> +	struct tw5864_dev *dev = input->root;
> +
>  	switch (input->std) {
>  	case STD_NTSC:
>  		frameinterval->numerator = 1001;
> @@ -728,8 +730,8 @@ static int tw5864_frameinterval_get(struct tw5864_input *input,
>  		frameinterval->denominator = 25;
>  		break;
>  	default:
> -		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
> -		     input->std);
> +	        dev_warn(&dev->pci->dev, "tw5864_frameinterval_get requested for unknown std %d\n",
> +			 input->std);
>  		return -EINVAL;
>  	}

Looks good, though, arguably, it could fit 80 columns better if you put
the string literal to separate line.
