Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:5572 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3G3NXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 09:23:42 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH] v4l2_compliance: -EINVAL is expected when ret is not 0
Date: Tue, 30 Jul 2013 15:13:37 +0200
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org
References: <1375189163-32510-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375189163-32510-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307301513.37971.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 30 July 2013 14:59:23 Ricardo Ribalda Delgado wrote:
> Otherwise the driver can never return a register

Good catch! I didn't test this as root, which I should have done.

Thanks!

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  utils/v4l2-compliance/v4l2-test-debug.cpp |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/v4l2-compliance/v4l2-test-debug.cpp b/utils/v4l2-compliance/v4l2-test-debug.cpp
> index 90c5b90..fa42d2c 100644
> --- a/utils/v4l2-compliance/v4l2-test-debug.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-debug.cpp
> @@ -49,7 +49,7 @@ int testRegister(struct node *node)
>  		return ret;
>  	// Not allowed to call VIDIOC_DBG_G_REGISTER unless root
>  	fail_on_test(uid && ret != EPERM);
> -	fail_on_test(uid == 0 && ret != EINVAL);
> +	fail_on_test(uid == 0 && ret && ret != EINVAL);
>  	fail_on_test(uid == 0 && !ret && reg.size == 0);
>  	chip.match.type = V4L2_CHIP_MATCH_BRIDGE;
>  	chip.match.addr = 0;
> 
