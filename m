Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1786 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2IUMdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 08:33:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 0/3] In non-blocking mode return EAGAIN in hwseek
Date: Fri, 21 Sep 2012 14:33:09 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl> <505C5D8F.5070007@redhat.com>
In-Reply-To: <505C5D8F.5070007@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211433.09033.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 21 2012 14:29:03 Hans de Goede wrote:
> Hi,
> 
> Looks good, but for patch 3/3 you're missing the same changes to
> sound/i2c/other/tea575x-tuner.c

Thanks! I'll add that as another patch.

I keep forgetting about that one :-)

Regards,

	Hans

> On 09/21/2012 01:44 PM, Hans Verkuil wrote:
> > This patch series resolves a problem with S_HW_FREQ_SEEK when called in
> > non-blocking mode. Currently this would actually block during the seek.
> >
> > This is not a good idea. This patch changes the spec and the drivers to
> > return -EAGAIN when called in non-blocking mode.
> >
> > In the future actual support for non-blocking mode might be added to
> > selected drivers, but that will require a new event (SEEK_READY or something
> > like that), and I am not convinced it is worth the effort anyway.
> >
> > Regards,
> >
> > 	Hans
> >
> 
