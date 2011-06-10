Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:59716 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab1FJMWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 08:22:35 -0400
Subject: Re: [GIT PATCHES FOR 2.6.40] Fixes
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>
In-Reply-To: <201105231306.56050.hverkuil@xs4all.nl>
References: <201105231306.56050.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 15:22:22 +0300
Message-ID: <1307708542.7423.5.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On Mon, 2011-05-23 at 13:06 +0200, ext Hans Verkuil wrote:
> Hi Mauro,
> 
> Here are a few fixes: the first fixes a bug in the wl12xx drivers (I hope Matti's
> email is still correct). The second fixes a few DocBook validation errors, and

I'm still here... And it's a nice surprise that the wl1273 radio driver
hasn't been deprecated or has it... I actually could add some features
to it.

Cheers,
Matti

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
>       v4l2-ctrls: drivers should be able to ignore READ_ONLY and GRABBED flags
> 
>  Documentation/DocBook/dvb/dvbproperty.xml    |    5 ++-
>  Documentation/DocBook/v4l/subdev-formats.xml |   10 ++--
>  drivers/media/radio/radio-wl1273.c           |    2 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c      |    2 +-
>  drivers/media/video/v4l2-ctrls.c             |   59 +++++++++++++++++---------
>  5 files changed, 50 insertions(+), 28 deletions(-)


