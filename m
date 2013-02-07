Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43871 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030217Ab3BGV6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 16:58:55 -0500
References: <201302071807.47221.hverkuil@xs4all.nl>
In-Reply-To: <201302071807.47221.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] ivtv-alsa: regression fix: remove __init from ivtv_alsa_load
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 07 Feb 2013 16:58:53 -0500
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Message-ID: <b5588d09-bb0a-4571-a580-78e34042f4e3@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>Andy,
>
>Please review this patch. This fix probably should be fast-tracked to
>3.8 and
>queued for stable 3.7.
>
>ivtv-alsa kept crashing my machine every time I loaded it, and this is
>the
>cause.
>
>Regards,
>
>	Hans
>
>This function is called after initialization, so it should never be
>marked
>__init!
>
>Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>---
> drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c
>b/drivers/media/pci/ivtv/ivtv-alsa-main.c
>index 4a221c6..e970cfa 100644
>--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
>+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
>@@ -205,7 +205,7 @@ err_exit:
> 	return ret;
> }
> 
>-static int __init ivtv_alsa_load(struct ivtv *itv)
>+static int ivtv_alsa_load(struct ivtv *itv)
> {
> 	struct v4l2_device *v4l2_dev = &itv->v4l2_dev;
> 	struct ivtv_stream *s;
>-- 
>1.7.10.4

Hans,

I concur.  Now I have to check cx18 for the same problem.

Your patch looks good.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy  
