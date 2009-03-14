Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11848 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912AbZCNVvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 17:51:33 -0400
Date: Sat, 14 Mar 2009 22:51:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Update remaining references to old video4linux list
Message-ID: <20090314225123.232b426f@hyperion.delvare>
In-Reply-To: <200903142239.35484.hverkuil@xs4all.nl>
References: <20090314222514.7a2b44f6@hyperion.delvare>
	<200903142239.35484.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, 14 Mar 2009 22:39:35 +0100, Hans Verkuil wrote:
> On Saturday 14 March 2009 22:25:14 Jean Delvare wrote:
> > The video4linux-list@redhat.com list is deprecated, point the users to
> > the new linux-media list instead.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  linux/Documentation/video4linux/bttv/README  |    4 ++--
> >  linux/drivers/media/radio/radio-si470x.c     |    4 ++--
> >  linux/drivers/media/video/bt8xx/bttv-cards.c |    2 +-
> >  v4l/scripts/make_kconfig.pl                  |    4 ++--
> >  4 files changed, 7 insertions(+), 7 deletions(-)
> > (...)
>
> I've already done this in my tree. It's probably easier for Mauro to just
> pull from my v4l-dvb tree.

Sure, no problem.

Thanks,
-- 
Jean Delvare
