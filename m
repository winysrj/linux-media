Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46313 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753043Ab3HaOkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 10:40:22 -0400
Date: Sat, 31 Aug 2013 17:40:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Message-ID: <20130831144018.GK2835@valkosipuli.retiisi.org.uk>
References: <201308301501.25164.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308301501.25164.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 30, 2013 at 03:01:25PM +0200, Hans Verkuil wrote:
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

- Multi-format frames and metadata. Support would be needed on video nodes
  and V4L2 subdev nodes. I'll prepare the RFC for the former; the latter has
  an RFC here:

  <URL:http://www.spinics.net/lists/linux-media/msg67295.html>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
