Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4360 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1JaQRe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:17:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Various ctrl and event frame work patches (version 2)
Date: Mon, 31 Oct 2011 17:17:32 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110311717.32581.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans!

On Monday, October 31, 2011 16:16:43 Hans de Goede wrote:
> Hi All,
> 
> This patch set obsoletes my previous "add v4l2_subscribed_event_ops" set,
> while working on adding support for ctrl-events to the uvc driver I found
> a few bugs in the event code, which this patchset fixes.

Did you see my comments to patches 3/6, 4/6 and 5/6 in version 1?
Those need to be addressed before I can ack them.

Regards,

	Hans

> Changes since version 1:
> -Added a documentation update (update v4l2-framework.txt) to:
>  "v4l2-event: Add v4l2_subscribed_event_ops"
> 
> Regards,
> 
> Hans
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
