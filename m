Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3CaMoc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 08:44:32 -0400
Message-ID: <51583081.4000806@redhat.com>
Date: Sun, 31 Mar 2013 14:48:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xawtv: release buffer if it can't be displayed
References: <201303301047.41952.hverkuil@xs4all.nl>
In-Reply-To: <201303301047.41952.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/30/2013 10:47 AM, Hans Verkuil wrote:
> This patch for xawtv3 releases the buffer if it can't be displayed because
> the resolution of the current format is larger than the size of the window.
>
> This will happen if the hardware cannot scale down to the initially quite
> small xawtv window. For example the au0828 driver has a fixed size of 720x480,
> so it will not display anything until the window is large enough for that
> resolution.
>
> The problem is that xawtv never releases (== calls QBUF) the buffer in that
> case, and it will of course run out of buffers and stall. The only way to
> kill it is to issue a 'kill -9' since ctrl-C won't work either.
>
> By releasing the buffer xawtv at least remains responsive and a picture will
> appear after resizing the window. Ideally of course xawtv should resize itself
> to the minimum supported resolution, but that's left as an exercise for the
> reader...
>
> Hans, the xawtv issues I reported off-list are all caused by this bug and by
> by the scaling bug introduced recently in em28xx. They had nothing to do with
> the alsa streaming, that was a red herring.

Thanks for the debugging and for the patch. I've pushed the patch to
xawtv3.git. I've a 2 patch follow up set which should fix the issue with being
able to resize the window to a too small size.

I'll send this patch set right after this mail, can you test it with the au0828
please?

Thanks,

Hans
