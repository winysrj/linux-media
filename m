Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3559 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1IZMp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 08:45:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
Date: Mon, 26 Sep 2011 14:45:08 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E7D5561.6080303@redhat.com>
In-Reply-To: <4E7D5561.6080303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261445.08191.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, September 24, 2011 05:58:25 Mauro Carvalho Chehab wrote:
> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
> > Hello Mauro,
> > 
> > I've collected pending selection API patches together with pending
> > videobuf2 and Samsung driver fixes to a single git branch. Please pull
> > them to your media tree.
> > 
> 
> > Marek Szyprowski (1):
> >       staging: dt3155v4l: fix build break
> 
> I've applied this one previously, from the patch you sent me.
> 
>  
> > Tomasz Stanislawski (6):
> >       v4l: add support for selection api
> >       v4l: add documentation for selection API
> 
> I need more time to review those two patches. I'll probably do it at the next week.

I also still need to review these patches, I will also be doing that this week.
Real-life interfered for the past 3-4 weeks, and I've just triaged all the
accumulated emails from that period. Jeez, linux-media is starting to resemble
linux-kernel when it comes to the volume of postings...

If this trend continues than the only way you're able to follow the traffic is
if your name is Jon Corbet :-)

Regards,

	Hans

> I generally start analyzing API changes based on the DocBook, so, let me point a few
> things I've noticed on a quick read, at the vidioc-g-selection.html DocBook-generated page:
> 
> 1) "The coordinates are expressed in driver-dependant units"
> 
> Why? coordinates should be expressed in pixels, as otherwise there's no way to
> use this API on a hardware-independent way.
> 
> 2)
>     0 - driver is free to adjust size, it is recommended to choose the crop/compose rectangle as close as possible to the original one
> 
>     SEL_SIZE_GE - driver is not allowed to shrink the rectangle. The original rectangle must lay inside the adjusted one
> 
>     SEL_SIZE_LE - drive is not allowed to grow the rectangle. The adjusted rectangle must lay inside the original one
> 
>     SEL_SIZE_GE | SEL_SIZE_LE - choose size exactly the same as in desired rectangle.
> 
> The macro names above don't match the definition, as they aren't prefixed by V4L2_.
> 
> 3) There was no hyperlink for the struct v4l2_selection, as on other API definitions.
> 
> 4) the language doesn't seem too consistent with the way other ioctl's are defined. For example,
> you're using struct::field for a field at the struct. Other parts of the API just say "field foo of struct bar".
> 
> 5) There's not a single mention at the git commit or at the DocBook about why the old crop API
> is being deprecated. You need to convince me about such need (ok, I followed a few discussions in
> the past, but, my brain patch buffer is shorter than the 7000 patchwork patches I reviewed just on
> this week). Besides that: do we really need to obsolete the crop API for TV cards? If so, why? If not,
> you need to explain why a developer should opt between one ioctl set of the other.
> 
> 6) You should add a note about it at hist-v4l2.html page, stating what happened, and why a new crop
> ioctl set is needed.
> 
> 7) You didn't update the Experimental API Elements or the Obsolete API Elements at the hist-v4l2.html
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
