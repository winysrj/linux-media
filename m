Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4910 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3HaGnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 02:43:49 -0400
Message-ID: <52219093.7080409@xs4all.nl>
Date: Sat, 31 Aug 2013 08:43:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Agenda for the Edinburgh mini-summit
References: <201308301501.25164.hverkuil@xs4all.nl>
In-Reply-To: <201308301501.25164.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/30/2013 03:01 PM, Hans Verkuil wrote:
> OK, I know, we don't even know yet when the mini-summit will be held but I thought
> I'd just start this thread to collect input for the agenda.
> 
> I have these topics (and I *know* that I am forgetting a few):
> 
> - Discuss ideas/use-cases for a property-based API. An initial discussion
>   appeared in this thread:
> 
>   http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195
> 
> - What is needed to share i2c video transmitters between drm and v4l? Hopefully
>   we will know more after the upcoming LPC.
> 
> - Decide on how v4l2 support libraries should be organized. There is code for
>   handling raw-to-sliced VBI decoding, ALSA looping, finding associated
>   video/alsa nodes and for TV frequency tables. We should decide how that should
>   be organized into libraries and how they should be documented. The first two
>   aren't libraries at the moment, but I think they should be. The last two are
>   libraries but they aren't installed. Some work is also being done on an improved
>   version of the 'associating nodes' library that uses the MC if available.
> 
> - Define the interaction between selection API, ENUM_FRAMESIZES and S_FMT. See
>   this thread for all the nasty details:
> 
>   http://www.spinics.net/lists/linux-media/msg65137.html
> 
> Feel free to add suggestions to this list.

I got another one:

VIDIOC_TRY_FMT shouldn't return -EINVAL when an unsupported pixelformat is provided,
but in practice video capture board tend to do that, while webcam drivers tend to map
it silently to a valid pixelformat. Some applications rely on the -EINVAL error code.

We need to decide how to adjust the spec. I propose to just say that some drivers
will map it silently and others will return -EINVAL and that you don't know what a
driver will do. Also specify that an unsupported pixelformat is the only reason why
TRY_FMT might return -EINVAL.

Alternatively we might want to specify explicitly that EINVAL should be returned for
video capture devices (i.e. devices supporting S_STD or S_DV_TIMINGS) and 0 for all
others.

Regards,

	Hans
