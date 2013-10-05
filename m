Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:41101 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3JEDGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 23:06:20 -0400
Date: Fri, 4 Oct 2013 22:01:19 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 02/14] pvrusb2: fix sparse warning
In-Reply-To: <1380895312-30863-3-git-send-email-hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.2.00.1310042200560.4999@ivanova.isely.net>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl> <1380895312-30863-3-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: Mike Isely <isely@pobox.com>

  -Mike

On Fri, 4 Oct 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2871:13: warning: symbol 'pvr2_hdw_get_detected_std' was not declared. Should it be static?
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mike Isely <isely@pobox.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> index c4d51d7..ea05f67 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -2868,7 +2868,7 @@ static void pvr2_subdev_set_control(struct pvr2_hdw *hdw, int id,
>  		pvr2_subdev_set_control(hdw, id, #lab, (hdw)->lab##_val); \
>  	}
>  
> -v4l2_std_id pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw)
> +static v4l2_std_id pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw)
>  {
>  	v4l2_std_id std;
>  	std = (v4l2_std_id)hdw->std_mask_avail;
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
