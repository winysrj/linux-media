Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58115 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbbKQRM0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 12:12:26 -0500
Date: Tue, 17 Nov 2015 15:12:21 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.5] Various fixes/enhancements
Message-ID: <20151117151221.267670ea@recife.lan>
In-Reply-To: <20151117151032.2c8f88e6@recife.lan>
References: <5645E594.4090905@xs4all.nl>
	<20151117151032.2c8f88e6@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Nov 2015 15:10:32 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 13 Nov 2015 14:28:52 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Mauro,
> > 
> > A large pile of various fixes and enhancements.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:
> > 
> >   [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git for-v4.5a
> > 
> > for you to fetch changes up to 54adb10d0947478b3364640a131fff1f1ab190fa:
> > 
> >   v4l2-dv-timings: add new arg to v4l2_match_dv_timings (2015-11-13 14:15:55 +0100)
> > 
> > ----------------------------------------------------------------
> > Antonio Ospite (1):
> >       gspca: ov534/topro: prevent a division by 0
> 
> 
> > Antti Palosaari (2):
> >       hackrf: move RF gain ctrl enable behind module parameter
> >       hackrf: fix possible null ptr on debug printing
> 
> The Antti's patches were already merged via his pull request.
> I added them for v4.4, as they fix a regression and a serious 
> trouble that could burn the hardware on a driver added on 4.3.
> 
> The other patches got merged.

Just noticed that a patch in your series broke kABI documentation.
Please send me a fixup patch:
	.//include/media/v4l2-dv-timings.h:117: warning: No description found for parameter 'match_reduced_fps'

Regards,
Mauro
