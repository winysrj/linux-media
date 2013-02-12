Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4766 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3BLI3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:29:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup was the wrong way around
Date: Tue, 12 Feb 2013 09:28:55 +0100
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl> <5118F4F4.1070602@redhat.com> <CA+6av4kxho5-UJB=BCTqd+qH-ATGzBUvds7TDpenjb7W73rKVQ@mail.gmail.com>
In-Reply-To: <CA+6av4kxho5-UJB=BCTqd+qH-ATGzBUvds7TDpenjb7W73rKVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302120928.55962.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 16:32:58 Arvydas Sidorenko wrote:
> On Mon, Feb 11, 2013 at 2:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > That doesn't make sense either. Arvydas, it worked fine for you before, right?
> > That is, if you use e.g. v3.8-rc7 then your picture is the right side up.
> >
> 
> It is upside down using any v3.7.x or v3.8-rc7. I didn't pay attention
> in the older versions, but I am aware of this issue since pre-v3.
> 
> On Mon, Feb 11, 2013 at 2:41 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > Arvydas, can you please run "sudo dmidecode > dmi.log", and send me or
> > Hans V. the generated dmi.log file? Then we can add your laptop to the
> > upside-down model list.
> >
> 
> $ sudo dmidecode


Thanks!

I've updated my stkwebcam git branch (note: it was rebased, so you can't just
do a git pull). If you can do a final test?

Regards,

	Hans
