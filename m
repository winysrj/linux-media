Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3859 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3DAKTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 06:19:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] xawtv: release buffer if it can't be displayed
Date: Mon, 1 Apr 2013 12:19:30 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201303301047.41952.hverkuil@xs4all.nl> <51583081.4000806@redhat.com>
In-Reply-To: <51583081.4000806@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304011219.30985.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun March 31 2013 14:48:01 Hans de Goede wrote:
> Hi,
> 
> On 03/30/2013 10:47 AM, Hans Verkuil wrote:
> > This patch for xawtv3 releases the buffer if it can't be displayed because
> > the resolution of the current format is larger than the size of the window.
> >
> > This will happen if the hardware cannot scale down to the initially quite
> > small xawtv window. For example the au0828 driver has a fixed size of 720x480,
> > so it will not display anything until the window is large enough for that
> > resolution.
> >
> > The problem is that xawtv never releases (== calls QBUF) the buffer in that
> > case, and it will of course run out of buffers and stall. The only way to
> > kill it is to issue a 'kill -9' since ctrl-C won't work either.
> >
> > By releasing the buffer xawtv at least remains responsive and a picture will
> > appear after resizing the window. Ideally of course xawtv should resize itself
> > to the minimum supported resolution, but that's left as an exercise for the
> > reader...
> >
> > Hans, the xawtv issues I reported off-list are all caused by this bug and by
> > by the scaling bug introduced recently in em28xx. They had nothing to do with
> > the alsa streaming, that was a red herring.
> 
> Thanks for the debugging and for the patch. I've pushed the patch to
> xawtv3.git. I've a 2 patch follow up set which should fix the issue with being
> able to resize the window to a too small size.
> 
> I'll send this patch set right after this mail, can you test it with the au0828
> please?

I've tested it and it is not yet working. I've tracked it down to video_gd_configure
where it calls ng_ratio_fixup() which changes the cur_tv_width of 736 to 640. The
height remains the same at 480.

Regards,

	Hans
