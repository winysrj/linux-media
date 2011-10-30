Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1662 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab1J3KRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 06:17:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/6] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
Date: Sun, 30 Oct 2011 11:17:39 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110301117.39166.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On Thursday, October 27, 2011 13:17:59 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-event.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 53b190c..9f56f18 100644
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
> 
