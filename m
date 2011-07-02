Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4897 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1GBJ7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 05:59:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: V4L2_PIX_FMT_SE401: can support be removed from libv4lconvert.c?
Date: Sat, 2 Jul 2011 11:59:21 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201107021141.20932.hverkuil@xs4all.nl> <4E0EEB43.9020703@redhat.com>
In-Reply-To: <4E0EEB43.9020703@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021159.21252.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, July 02, 2011 11:56:19 Hans de Goede wrote:
> Hi,
> 
> On 07/02/2011 11:41 AM, Hans Verkuil wrote:
> > Hi Hans,
> >
> > V4L2_PIX_FMT_SE401 was removed in the latest videodev2.h. I assume that that
> > code can also be removed from libv4lconvert.c?
> 
> If you look at the history you will see that support for it was actually
> added to libv4lconvert recently. The reason for this is that together
> with my pwc driver I also have a new se401 driver queued up in my local
> tree :)
> 
> So V4L2_PIX_FMT_SE401 has not been removed from the latest videodev2.h,
> it has not been added yet (I've queued up a separate patch for that).
> 
> So if you want to update the videodev2.h copy in v4l-utils, please
> leave in the V4L2_PIX_FMT_SE401 define.

Ah, so it will be added again to videodev2.h once your se401 driver is merged.

Good, I'll leave in that define.

Regards,

	Hans

> 
> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
