Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:40117 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab3H3NVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 09:21:17 -0400
Message-ID: <52209C41.8040402@schinagl.nl>
Date: Fri, 30 Aug 2013 15:21:05 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Agenda for the Edinburgh mini-summit
References: <201308301501.25164.hverkuil@xs4all.nl>
In-Reply-To: <201308301501.25164.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-08-13 15:01, Hans Verkuil wrote:
> OK, I know, we don't even know yet when the mini-summit will be held but I thought
> I'd just start this thread to collect input for the agenda.
>
> I have these topics (and I *know* that I am forgetting a few):
>
> - Discuss ideas/use-cases for a property-based API. An initial discussion
>    appeared in this thread:
>
>    http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195
>
> - What is needed to share i2c video transmitters between drm and v4l? Hopefully
>    we will know more after the upcoming LPC.
>
> - Decide on how v4l2 support libraries should be organized. There is code for
>    handling raw-to-sliced VBI decoding, ALSA looping, finding associated
>    video/alsa nodes and for TV frequency tables. We should decide how that should
>    be organized into libraries and how they should be documented. The first two
>    aren't libraries at the moment, but I think they should be. The last two are
>    libraries but they aren't installed. Some work is also being done on an improved
>    version of the 'associating nodes' library that uses the MC if available.
>
> - Define the interaction between selection API, ENUM_FRAMESIZES and S_FMT. See
>    this thread for all the nasty details:
>
>    http://www.spinics.net/lists/linux-media/msg65137.html
>
> Feel free to add suggestions to this list.
What about a hardware accelerated decoding API/framework? Is there a 
proper framework for this at all? I see the broadcom module is still in 
staging and may never come out of it, but how are other video decoding 
engines handled that don't have cameras or displays.

Reason for asking is that we from linux-sunxi have made some positive 
progress in Reverse engineering the video decoder blob of the Allwinner 
A10 and this knowledge will need a kernel side driver in some framework. 
I looked at the exynos video decoders and googling for linux-media 
hardware accelerated decoding doesn't yield much either.

Anyway, just a thought; if you think it's the wrong place for it to be 
discussed, that's ok :)

oliver
>
> Note: my email availability will be limited in the next three weeks, especially
> next week, as I am travelling a lot.
>
> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

