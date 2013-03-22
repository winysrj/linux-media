Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4511 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CVOER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 10:04:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
Date: Fri, 22 Mar 2013 15:04:06 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com> <201303201218.48929.hverkuil@xs4all.nl> <CAC-25o-qAs1yB6EqC8bfCXjwCmvWM_2z6SDu0VCuPQVeJvms8Q@mail.gmail.com>
In-Reply-To: <CAC-25o-qAs1yB6EqC8bfCXjwCmvWM_2z6SDu0VCuPQVeJvms8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221504.06707.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu March 21 2013 19:46:03 edubezval@gmail.com wrote:
> Hans,
> 
> 
> <snip>
> 
> >> > Are you still able to test the si4713 driver? Because I have patches
> >>
> >>
> >>
> >> I see. In fact that is my next step on my todo list for si4713. I
> >> still have an n900 that I can fetch from my drobe, so just a matter of
> >> booting it with newer kernel.
> >>
> >> > outstanding that I would love for someone to test for me:
> >> >
> >> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713
> 
> So, I got my hands on my old n900 and thanks to Aaro and lo community
> I could still boot it with 3.9-rc3 kernel! amazing!
> 
> I didn't have the time to look at your patches, but I could do a blind
> run of v4l2-compliance -r 0 on n900. It follows the results:

... 

> 
> 
> # on your branch on the other hand I get a NULL pointer:

I've fixed that (v4l2_dev was never initialized), and I've also rebased my tree
to the latest code. Can you try again?

Regards,

	Hans
