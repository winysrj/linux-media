Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2167C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 11:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98A52084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 11:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfCKLQm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 07:16:42 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:43721 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbfCKLQm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 07:16:42 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3Iv6hPmep4HFn3Iv9hDOxU; Mon, 11 Mar 2019 12:16:40 +0100
Subject: Re: [PATCH v2 1/4] media: v4l: Simplify dev_debug flags
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
References: <20190227170706.6258-1-ezequiel@collabora.com>
 <20190227170706.6258-2-ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <810424a2-93e8-207d-90b6-887b032d6546@xs4all.nl>
Date:   Mon, 11 Mar 2019 12:16:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190227170706.6258-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKYnu9Osc/3ZWwS4Q57xMfJAy6A1B1vna+TS3aYNBEMYnsWwNnWA2XtXwt3DW2iYPiIfh93jcfqQHudw0OwBUGSFKQXufthpcpjGztawEKJJKgoQg/oB
 EAJaiCYyU5HB7sSaG2N4VMlik12rIzF11pXUXzsTAPTzpE2tNxXEGso8oYM3UIPsEDZSL1fn0kTa6gTRPXByLTSS9j7u3iRLa1q2nC9+37tioRG6y++UxnjO
 l96QHia/VO95yzqVmPVLahlS0icPu6KEg+4jIMhhjhrnFM8yRfV6iuRLPiTK0Sed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/27/19 6:07 PM, Ezequiel Garcia wrote:
> In preparation to cleanup the debug logic, simplify the dev_debug
> usage. In particular, make sure that a single flag is used to
> control each debug print.
> 
> Before this commit V4L2_DEV_DEBUG_STREAMING and V4L2_DEV_DEBUG_FOP
> were needed to enable read and write debugging. After this commit
> only the former is needed.

The original idea was that ioctls are logged with V4L2_DEV_DEBUG_IOCTL
and file ops with V4L2_DEV_DEBUG_FOP. And to see the streaming ioctls
or fops you would have to add V4L2_DEV_DEBUG_STREAMING in addition to
DEBUG_IOCTL/FOP.

This patch changes the behavior in that the streaming fops are now
solely controlled by V4L2_DEV_DEBUG_STREAMING.

I do agree with this change, but this requires that the same change is
done for the streaming ioctls (DQBUF/QBUF) and that the documentation in
Documentation/media/kapi/v4l2-dev.rst is updated (section "video device
debugging").

Of course, the documentation should also mention the new dev_debug
module parameter and the new debug flag for debugging controls.

Regards,

	Hans

> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d7528f82a66a..34e4958663bf 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -315,8 +315,7 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
>  		return -EINVAL;
>  	if (video_is_registered(vdev))
>  		ret = vdev->fops->read(filp, buf, sz, off);
> -	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
> -	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
> +	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
>  		dprintk("%s: read: %zd (%d)\n",
>  			video_device_node_name(vdev), sz, ret);
>  	return ret;
> @@ -332,8 +331,7 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
>  		return -EINVAL;
>  	if (video_is_registered(vdev))
>  		ret = vdev->fops->write(filp, buf, sz, off);
> -	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
> -	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
> +	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
>  		dprintk("%s: write: %zd (%d)\n",
>  			video_device_node_name(vdev), sz, ret);
>  	return ret;
> 

