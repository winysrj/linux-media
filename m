Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:39669 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbcHNTaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 15:30:00 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/14] media: platform: pxa_camera: remove set_crop
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-11-git-send-email-robert.jarzmik@free.fr>
	<53804199-3ac3-2e46-7888-cb9b3e0dd127@xs4all.nl>
Date: Sun, 14 Aug 2016 21:29:56 +0200
Message-ID: <87h9anrvwr.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
>> This is to be seen as a regression as the set_crop function is
>> removed. This is a temporary situation in the v4l2 porting, and will
>> have to be added later.
>
> This is a bit confusing, since in the next patch you say in the commit log:
>
>  - the s_crop() call was removed, judged not working
>    (see what happens soc_camera_s_crop() when get_crop() == NULL)
>
> So the set_crop removal isn't temporary after all? It isn't added back in
> this patch series.
>
> Note that I am OK with removing set_crop if it never worked reliably, but
> then the commit log of this patch should be updated to reflect that.
Well, it's temporary in the sense "I have not added it back yet, but I commit to
add it back within 2 or 3 kernel cycles"

As for the confusion, I think the pxa_camera + mt9m111 set_crop() was not
working, but I didn't say that another camera host + mt9m111 didn't work. I
think set_crop() is not working because pxa_camera lacks code, but that doesn't
prevent mt9m111 to have a set_crop() sensor working implementation.

That's why I say I'm probably adding a regression, and commit to remove it soon
...

Cheers.

--
Robert
