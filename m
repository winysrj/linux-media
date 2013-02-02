Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1403 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3BBJJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 04:09:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.9] videodev2.h fix and em28xx regression fixes
Date: Sat, 2 Feb 2013 10:09:49 +0100
Cc: Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
References: <201301271043.00528.hverkuil@xs4all.nl>
In-Reply-To: <201301271043.00528.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302021009.49200.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 10:43:00 Hans Verkuil wrote:
> Hi Mauro,
> 
> The first patch moves the DV control IDs from videodev2.h to v4l2-controls.h.
> I noticed that they weren't moved when the controls were split off from
> videodev2.h, probably because the patch adding the DV controls and the move
> to v4l2-controls.h crossed one another.
> 
> The second and third patch convert tvaudio and mt9v011 to the control framework.
> These patches were part of my original conversion of em28xx to the control
> framework, but when Devin based his em28xx work on my tree he forgot to pull
> them in.
> 
> Because of that any controls created by the mt9v011 and tvaudio drivers are
> inaccessible from em28xx. By converting those drivers to the control framework
> they are seen again.
> 
> Frank tested the mt9v011 conversion. I have tested the tvaudio conversion
> somewhat with a bttv card that had a tda9850, but if you have additional
> tvaudio cards (and especially an em28xx that uses the tvaudio module), then it
> would be good to do some additional tests. Other than the bttv card I have
> no other hardware to test tvaudio with.

I've removed this pull request and I'll post a new one in a minute. I found
another tvaudio fix that had to be included as well.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 94a93e5f85040114d6a77c085457b3943b6da889:
> 
>   [media] dvb_frontend: print a msg if a property doesn't exist (2013-01-23 19:10:57 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git fixes
> 
> for you to fetch changes up to 7aa966b3c4135b1745a3c5ac60bdd8f79fead355:
> 
>   mt9v011: convert to the control framework. (2013-01-27 10:22:27 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (3):
>       Move DV-class control IDs from videodev2.h to v4l2-controls.h
>       tvaudio: convert to the control framework.
>       mt9v011: convert to the control framework.
> 
>  drivers/media/i2c/mt9v011.c        |  223 +++++++++++++++++++++++++++++++++--------------------------------------------------------------------------
>  drivers/media/i2c/tvaudio.c        |  224 ++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
>  include/uapi/linux/v4l2-controls.h |   24 ++++++++++++
>  include/uapi/linux/videodev2.h     |   22 -----------
>  4 files changed, 166 insertions(+), 327 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
