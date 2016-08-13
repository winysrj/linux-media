Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54891 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbcHNJaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 05:30:03 -0400
Subject: Re: [PATCH v3 00/14] pxa_camera transition to v4l2 standalone device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2402d569-742d-482a-ac8f-3868f59510f3@xs4all.nl>
Date: Sat, 13 Aug 2016 21:02:11 +0200
MIME-Version: 1.0
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
> Hi Hans,
> 
> We're leaving the domain of the RFC to a proper submission.
> 
> This is very alike to what you reviewed earlier, the code is very close, and :
>  - the split between patches is done to better isolate cleanups from real code
>  - start_streaming() was implemented
>  - your remarks have been taken into account (please double-check if you're
>    happy with it)
>  - v4l2-compliance -f and v4l2-compliance -s were run without any error, and 6 warnings
> 	warn: v4l2-test-formats.cpp(713): TRY_FMT cannot handle an invalid pixelformat.
> 	warn: v4l2-test-formats.cpp(714): This may or may not be a problem. For more information see:
> 	warn: v4l2-test-formats.cpp(715): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>  - soc_camera is not touched anymore
>  - the driver is still functional from a capture point of view as before
>   (ie. taking a real picture)
>  
> I'm still relying on soc_mediabus, hence the not-so-nice Makefile diff hunk.
> 
> The only architecture which will have its deconfigs impacted is pxa, under my
> maintainance, and once the review is finished and you have a landing cycle I'll
> complete with a simple serie on the pxa side (defconfig + platform data).
> 
> I've also put the whole serie here if you want to fetch and review from git directly :
>  - git fetch https://github.com/rjarzmik/linux.git work/v4l2
> 
> Happy review.

As you can see from my replies I only have a few small review comments remaining.

Can you fix it and post a v4 (rebased to the latest kernel)? Please also add the
v4l2-compliance -f output to the cover letter.

Unless I see something new I plan to make a pull request of v4 for 4.9.

I hope to post my conversion of the atmel-isi driver soon, and that might give
you some ideas on how to get rid of the soc-mbus stuff in a follow-up patch.

Regards,

	Hans
