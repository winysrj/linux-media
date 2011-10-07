Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4969 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1JGGFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 02:05:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
Date: Fri, 7 Oct 2011 08:05:30 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
References: <201110061423.22064.hverkuil@xs4all.nl> <4E8DE450.7030302@redhat.com> <4E8E5EEA.80906@redhat.com>
In-Reply-To: <4E8E5EEA.80906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110070805.31054.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, October 07, 2011 04:07:38 Mauro Carvalho Chehab wrote:
> Em 06-10-2011 14:24, Mauro Carvalho Chehab escreveu:
> > Em 06-10-2011 10:27, Mauro Carvalho Chehab escreveu:
> >> Em 06-10-2011 09:23, Hans Verkuil escreveu:
> >>> Currently we have three repositories containing libraries and utilities that
> >>> are relevant to the media drivers:
> >>>
> >>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
> >>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
> >>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
> >>>
> >>> It makes no sense to me to have three separate repositories, one still using
> >>> mercurial and one that isn't even on linuxtv.org.
> >>>
> >>> I propose to combine them all to one media-utils.git repository. I think it
> >>> makes a lot of sense to do this.
> >>>
> >>> After the switch the other repositories are frozen (with perhaps a README
> >>> pointing to the new media-utils.git).
> >>>
> >>> I'm not sure if there are plans to make new stable releases of either of these
> >>> repositories any time soon. If there are, then it might make sense to wait
> >>> until that new stable release before merging.
> >>>
> >>> Comments?
> >>
> >> I like that idea. It helps to have the basic tools into one single repository,
> >> and to properly distribute it.
> 
> Ok, I found some time to do an experimental merge of the repositories. It is available
> at:
> 
> http://git.linuxtv.org/mchehab/media-utils.git
> 
> For now, all dvb-apps stuff is on a separate directory. It makes sense to latter
> re-organize the directories. Anyway, the configure script will allow disable
> dvb-apps, v4l-utils and/or libv4l. The default is to have all enabled.
> 
> One problem I noticed is that the dvb-apps are at version 1.1. So, if we're
> releasing a new version, we'll need to jump from 0.9 to dvb-apps version + 1.
> So, IMO, the first version with the merge should be version 1.2.
> 
> Comments?

Strange:

$ git clone git://git.linuxtv.org/mchehab/media-utils.git                                                             
Cloning into media-utils...                                                                                                                  
fatal: The remote end hung up unexpectedly

I've no problem with other git trees.

Regards,

	Hans
