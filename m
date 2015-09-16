Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:34170 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbbIPJtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 05:49:36 -0400
Message-ID: <55F93AE1.2060005@xs4all.nl>
Date: Wed, 16 Sep 2015 11:48:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-compliance: Basic support for array controls
References: <1442395851-6789-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1442395851-6789-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/2015 11:30 AM, Ricardo Ribalda Delgado wrote:
> Without this patch:
> 
> Control ioctls:
> 	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> 	test VIDIOC_QUERYCTRL: OK
> 	fail: v4l2-test-controls.cpp(411): g_ctrl returned an error (22)

That's weird.

At the moment v4l2-compliance doesn't test compound controls at all (that really
should be added!). But it never should see them anyway since V4L2_CTRL_FLAG_NEXT_COMPOUND
is never used, so any compound controls should be ignored.

So why does v4l2-compliance see compound controls? Is there perhaps a bug in the
control framework?

Regards,

	Hans

> 	test VIDIOC_G/S_CTRL: FAIL
> 	fail: v4l2-test-controls.cpp(637): g_ext_ctrls returned an error (28)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 	Standard Controls: 55 Private Controls: 0
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  utils/v4l2-compliance/v4l2-test-controls.cpp | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
> index 526905eef183..eba32a9f7855 100644
> --- a/utils/v4l2-compliance/v4l2-test-controls.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
> @@ -377,6 +377,9 @@ int testSimpleControls(struct node *node)
>  	for (iter = node->controls.begin(); iter != node->controls.end(); ++iter) {
>  		test_query_ext_ctrl &qctrl = iter->second;
>  
> +		if (qctrl.elems > 1)
> +			continue;
> +
>  		info("checking control '%s' (0x%08x)\n", qctrl.name, qctrl.id);
>  		ctrl.id = qctrl.id;
>  		if (qctrl.type == V4L2_CTRL_TYPE_INTEGER64 ||
> @@ -518,6 +521,10 @@ static int checkExtendedCtrl(struct v4l2_ext_control &ctrl, struct test_query_ex
>  
>  	if (ctrl.id != qctrl.id)
>  		return fail("control id mismatch\n");
> +
> +	if (qctrl.elems > 1)
> +		return 0;
> +
>  	switch (qctrl.type) {
>  	case V4L2_CTRL_TYPE_INTEGER:
>  	case V4L2_CTRL_TYPE_INTEGER64:
> @@ -620,7 +627,8 @@ int testExtendedControls(struct node *node)
>  			ctrl.id = qctrl.id;
>  			ctrl.value = qctrl.default_value;
>  		} else {
> -			if (ret != ENOSPC && qctrl.type == V4L2_CTRL_TYPE_STRING)
> +			if (ret != ENOSPC &&
> +				(qctrl.type == V4L2_CTRL_TYPE_STRING || qctrl.elems > 1 ))
>  				return fail("did not check against size\n");
>  			if (ret == ENOSPC && qctrl.type == V4L2_CTRL_TYPE_STRING) {
>  				if (ctrls.error_idx != 0)
> @@ -629,6 +637,10 @@ int testExtendedControls(struct node *node)
>  				ctrl.size = qctrl.maximum + 1;
>  				ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
>  			}
> +			if (ret == ENOSPC && qctrl.elems > 1){
> +				ctrl.ptr = new char[ctrl.size];
> +				ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
> +			}
>  			if (ret == EIO) {
>  				warn("g_ext_ctrls returned EIO\n");
>  				ret = 0;
> @@ -668,7 +680,7 @@ int testExtendedControls(struct node *node)
>  			if (checkExtendedCtrl(ctrl, qctrl))
>  				return fail("s_ext_ctrls returned invalid control contents (%08x)\n", qctrl.id);
>  		}
> -		if (qctrl.type == V4L2_CTRL_TYPE_STRING)
> +		if (qctrl.type == V4L2_CTRL_TYPE_STRING || qctrl.elems > 1)
>  			delete [] ctrl.string;
>  		ctrl.string = NULL;
>  	}
> @@ -708,6 +720,10 @@ int testExtendedControls(struct node *node)
>  			ctrl.size = qctrl.maximum + 1;
>  			ctrl.string = new char[ctrl.size];
>  		}
> +		if (qctrl.elems > 1){
> +			ctrl.size = qctrl.elem_size * qctrl.elems;
> +			ctrl.ptr = new char[ctrl.size];
> +		}
>  		ctrl.reserved2[0] = 0;
>  		if (!ctrl_class)
>  			ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> 

