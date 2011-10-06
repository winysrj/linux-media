Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935645Ab1JFN1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 09:27:13 -0400
Message-ID: <4E8DACAF.5070207@redhat.com>
Date: Thu, 06 Oct 2011 10:27:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl>
In-Reply-To: <201110061423.22064.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 09:23, Hans Verkuil escreveu:
> Currently we have three repositories containing libraries and utilities that
> are relevant to the media drivers:
>
> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>
> It makes no sense to me to have three separate repositories, one still using
> mercurial and one that isn't even on linuxtv.org.
>
> I propose to combine them all to one media-utils.git repository. I think it
> makes a lot of sense to do this.
>
> After the switch the other repositories are frozen (with perhaps a README
> pointing to the new media-utils.git).
>
> I'm not sure if there are plans to make new stable releases of either of these
> repositories any time soon. If there are, then it might make sense to wait
> until that new stable release before merging.
>
> Comments?

I like that idea. It helps to have the basic tools into one single repository,
and to properly distribute it.

I think through, that we should work to have an smart configure script that
would allow enabling/disabling the several components of the utils, like the
--enable/--disable approach used by autoconf scripts:
	--enable-libv4l
	--enable-dvb
	--enable-ir
	--enable-v4l
	--enable-mc
	...

Of course, using "--disable-libv4l" would mean that libv4l-aware utils would
be statically linked with the current libv4l libraries.

This would help distributions to migrate to it, as they can keep having separate
packages for each component for the existing stable distros, while merging
into a single source package for future distros.

Regards,
Mauro
