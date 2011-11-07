Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2064 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1KGJKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 04:10:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT FIXES FOR 3.2 <resend>] Fixes for event framework
Date: Mon, 7 Nov 2011 10:10:33 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4EB79528.60106@redhat.com>
In-Reply-To: <4EB79528.60106@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071010.33633.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Is there a reason why this fix:

v4l2-ctrl: Send change events to all fh for auto cluster slave controls

isn't part of this pull request? Or do you want me to make a pull request for
that?

Regards,

	Hans

On Monday, November 07, 2011 09:22:00 Hans de Goede wrote:
> Hi Mauro et all,
> 
> Please pull from me tree for the following event framework fixes:
> 
> The following changes since commit b82b12633773804713fc10ae5d0006be2b5bf943:
> 
>    staging: Move media drivers to staging/media (2011-11-01 23:55:06 -0200)
> 
> are available in the git repository at:
>    git://linuxtv.org/hgoede/gspca.git eventfixes
> 
> Hans de Goede (3):
>        v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
>        v4l2-event: Remove pending events from fh event queue when unsubscribing
>        v4l2-event: Don't set sev->fh to NULL on unsubscribe
> 
>   drivers/media/video/v4l2-ctrls.c |    4 ++--
>   drivers/media/video/v4l2-event.c |   10 +++++++++-
>   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
