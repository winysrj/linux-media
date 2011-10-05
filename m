Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:54065 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab1JEOAN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 10:00:13 -0400
Date: Wed, 5 Oct 2011 09:00:12 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 5/8] [media] pvrusb2: initialize standards mask before
 detecting standard
In-Reply-To: <1317758000-21154-5-git-send-email-mchehab@redhat.com>
Message-ID: <alpine.DEB.1.10.1110050857090.9044@cnc.isely.net>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com> <1317758000-21154-2-git-send-email-mchehab@redhat.com> <1317758000-21154-3-git-send-email-mchehab@redhat.com> <1317758000-21154-4-git-send-email-mchehab@redhat.com>
 <1317758000-21154-5-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro:

With the line you've just added, then the " = arg" assignment in the 
immediate prior line is effectively dead code.  Try this instead:

 	case VIDIOC_QUERYSTD:
 	{
-		v4l2_std_id *std = arg;
+		v4l2_std_id *std = V4L2_STD_ALL;
 		ret = pvr2_hdw_get_detected_std(hdw, std);
 		break;
 	}

  -Mike


On Tue, 4 Oct 2011, Mauro Carvalho Chehab wrote:

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index 0d029da..ce7ac45 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -230,6 +230,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_QUERYSTD:
>  	{
>  		v4l2_std_id *std = arg;
> +		*std = V4L2_STD_ALL;
>  		ret = pvr2_hdw_get_detected_std(hdw, std);
>  		break;
>  	}
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
