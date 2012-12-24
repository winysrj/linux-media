Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4616 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2LXJZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 04:25:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH] v4l2-compliance: Reject invalid ioctl error codes
Date: Mon, 24 Dec 2012 10:24:48 +0100
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <1356301444-10191-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1356301444-10191-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212241024.48384.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun December 23 2012 23:24:04 Laurent Pinchart wrote:
> The recent uvcvideo regression that broke pulseaudio/KDE (see commit
> 9c016d61097cc39427a2f5025bdd97ac633d26a6 in the mainline kernel) was
> caused by the uvcvideo driver returning a -ENOENT error code to
> userspace by mistake.
> 
> To make sure such regressions will be caught before reaching users, test
> ioctl error codes to make sure they're valid.

I don't like this change. Error codes should be checked in the test for
the actual ioctl.

Apparently it is QUERYCTRL that is returning the wrong error code in uvc, but
looking at the code in v4l2-test-controls.cpp it is already checking for ENOTTY
or EINVAL and returning a failure if it is a different error code. So why is
that not triggered in this case?

Regards,

	Hans

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  utils/v4l2-compliance/v4l2-compliance.cpp |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> A white list of valid error codes might be more appropriate. I can fix the
> patch accordingly, but I'd like a general opinion first.
> 
> diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
> index 1e4646f..ff1ad9b 100644
> --- a/utils/v4l2-compliance/v4l2-compliance.cpp
> +++ b/utils/v4l2-compliance/v4l2-compliance.cpp
> @@ -112,6 +112,13 @@ int doioctl_name(struct node *node, unsigned long int request, void *parm, const
>  		fail("%s returned %d instead of 0 or -1\n", name, retval);
>  		return -1;
>  	}
> +
> +	/* Reject invalid error codes */
> +	switch (errno) {
> +	case ENOENT:
> +		fail("%s returned invalid error %d\n", name, errno);
> +		break;
> +	}
>  	return e;
>  }
>  
> 
