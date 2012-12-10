Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58655 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2LJP4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 10:56:08 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2040656lag.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 07:56:06 -0800 (PST)
Message-ID: <50C60620.2010603@googlemail.com>
Date: Mon, 10 Dec 2012 16:56:16 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
References: <201212101407.09338.hverkuil@xs4all.nl>
In-Reply-To: <201212101407.09338.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.12.2012 14:07, schrieb Hans Verkuil:

<snip>
> 3) This document describes the situation we will have when the submaintainers
> take their place early next year. So please check if I got that part right.
...

> Reviewed-by/Acked-by
> ====================
>
> Within the media subsystem there are three levels of maintainership: Mauro
> Carvalho Chehab is the maintainer of the whole subsystem and the
> DVB/V4L/IR/Media Controller core code in particular, then there are a number of
> submaintainers for specific areas of the subsystem:
>
> - Kamil Debski: codec (aka memory-to-memory) drivers
> - Hans de Goede: non-UVC USB webcam drivers
> - Mike Krufky: frontends/tuners/demodulators In addition he'll be the reviewer
>   for DVB core patches.
> - Guennadi Liakhovetski: soc-camera drivers
> - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the reviewer
>   for Media Controller core patches.
> - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
>   receivers and transmitters). In addition he'll be the reviewer for V4L2 core
>   patches.
>
> Finally there are maintainers for specific drivers. This is documented in the
> MAINTAINERS file.
>
> When modifying existing code you need to get the Reviewed-by/Acked-by of the
> maintainer of that code. So CC that maintainer when posting patches. If said
> maintainer is unavailable then the submaintainer or even Mauro can accept it as
> well, but that should be the exception, not the rule.
>
> Once patches are accepted they will flow through the git tree of the
> submaintainer to the git tree of the maintainer (Mauro) who will do a final
> review.
>
> There are a few exceptions: code for certain platforms goes through git trees
> specific to that platform. The submaintainer will still review it and add a
> acked-by or reviewed-by line, but it will not go through the submaintainer's
> git tree.
>
> The platform maintainers are:
>
> TDB
>
> In case patches touch on areas that are the responsibility of multiple
> submaintainers, then they will decide among one another who will merge the
> patches.

I've read this "when the submaintainers take their place early next
year, everything will be fine" several times now.
But can anyone please explain me what's going to change ?
AFAICS, the above exactly describes the _current_ situation.
We already have sub-maintainers, sub-trees etc, right !? And the people
listed above are already doing the same job at the moment.

Looking at patchwork, it seems we are behind at least 1 complete kernel
release cycle.
And the reason seems to be, that (at least some) maintainers don't have
the resources to review them in time (no reproaches !).

But to me this seems to be no structural problem.
If a maintainer (permanently) doesn't have the time to review patches,
he should leave maintainership to someone else.

So the actual problem seems to be, that we don't have enough
maintainers/reviewers, right ?


<snip>

> Patchwork
> =========
>
> Patchwork is an automated system that takes care of all posted patches. It can
> be found here: http://patchwork.linuxtv.org/project/linux-media/list/
>
> If your patch does not appear in patchwork after [TBD], then check if you used
> the right patch tags and if your patch is formatted correctly (no HTML, no
> mangled lines).
>
> Whenever you patch changes state you'll get an email informing you about that.

What if people send a V2 of a patch (series). Should they mark V1 as
superseeded themselves ?
And what about maintainers not using patchwork ? Are they nevertheless
supposed to take care of the status of their patches ?

Regards,
Frank

