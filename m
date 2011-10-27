Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34531 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1J0MEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 08:04:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/6] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
Date: Thu, 27 Oct 2011 14:04:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110271404.44386.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 October 2011 13:17:59 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

This brings the code in sync with the documentation, thanks.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/v4l2-event.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index 53b190c..9f56f18 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -215,6 +215,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  	unsigned long flags;
>  	unsigned i;
> 
> +	if (sub->type == V4L2_EVENT_ALL)
> +		return -EINVAL;
> +
>  	if (elems < 1)
>  		elems = 1;
>  	if (sub->type == V4L2_EVENT_CTRL) {

-- 
Regards,

Laurent Pinchart
