Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44360 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbbIKIEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 04:04:04 -0400
Message-ID: <55F28AA9.3000408@xs4all.nl>
Date: Fri, 11 Sep 2015 10:02:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 1/8] [media] videobuf2: Replace videobuf2-core
 with videobuf2-v4l2
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com> <1441797597-17389-2-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1441797597-17389-2-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2015 01:19 PM, Junghak Sung wrote:
> Make videobuf2-v4l2 as a wrapper of videobuf2-core for v4l2-use.
> And replace videobuf2-core.h with videobuf2-v4l2.h.
> This renaming change should be accompanied by the modifications
> of all device drivers that include videobuf2-core.h.
> It can be done with just running this shell script.
> 
> replace()
> {
> str1=$1
> str2=$2
> dir=$3
> for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
> do
>     echo $file
>     sed "s/$str1/$str2/g" $file > $file.out
>     mv $file.out $file
> done
> }
> 
> replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
> replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"
> replace "videobuf2-core" "videobuf2-v4l2" "drivers/usb/gadget/"
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

However, see one small comment below:

<snip>

> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
> index 8f61456..bef9127 100644
> --- a/include/media/videobuf2-dvb.h
> +++ b/include/media/videobuf2-dvb.h
> @@ -6,7 +6,7 @@
>  #include <dvb_demux.h>
>  #include <dvb_net.h>
>  #include <dvb_frontend.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>

I actually think this should remain core.h since videobuf2-dvb.c/h has
nothing to do with v4l2.

Regards,

	Hans

>  
>  struct vb2_dvb {
>  	/* filling that the job of the driver */

