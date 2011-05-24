Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab1EXBmi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 21:42:38 -0400
Message-ID: <4DDB0D08.2000503@redhat.com>
Date: Mon, 23 May 2011 22:42:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [GIT PATCHES FOR 2.6.40] Fixes
References: <201105231306.56050.hverkuil@xs4all.nl>
In-Reply-To: <201105231306.56050.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 08:06, Hans Verkuil escreveu:
> Hi Mauro,
> 
> Here are a few fixes: the first fixes a bug in the wl12xx drivers (I hope Matti's
> email is still correct). The second fixes a few DocBook validation errors, and
> the last fixes READ_ONLY and GRABBED handling in the control framework.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:
> 
>   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)
> 
> are available in the git repository at:
>   ssh://linuxtv.org/git/hverkuil/media_tree.git fixes
> 
> Hans Verkuil (3):
>       wl12xx: g_volatile_ctrl fix: wrong field set.
>       Media DocBook: fix validation errors.

The two above are fixes...

>       v4l2-ctrls: drivers should be able to ignore READ_ONLY and GRABBED flags

But this one is a change at the behaviour. I need to analyse it better. The idea
of a "read only" control that it is not read only seems too weird on my tired eyes.

I'll take a more careful look on it tomorrow.

Thanks,
Mauro.

> 
>  Documentation/DocBook/dvb/dvbproperty.xml    |    5 ++-
>  Documentation/DocBook/v4l/subdev-formats.xml |   10 ++--
>  drivers/media/radio/radio-wl1273.c           |    2 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c      |    2 +-
>  drivers/media/video/v4l2-ctrls.c             |   59 +++++++++++++++++---------
>  5 files changed, 50 insertions(+), 28 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

