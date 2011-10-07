Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1JGIVl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 04:21:41 -0400
Message-ID: <4E8EB698.8080507@redhat.com>
Date: Fri, 07 Oct 2011 10:21:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl>
In-Reply-To: <201110061423.22064.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/06/2011 02:23 PM, Hans Verkuil wrote:
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

Didn't we've this same discussion back when v4l-utils was formed, and didn't
the dvb-apps people want to keep doing there own tree + release?

I'm fine with this if it gets buy in from the dvb-apps people, but if they
don't want this I'm strongly against it!

Which would leave just media-ctl, I'm fine with that going into v4l-utils,
and Laurent getting direct push access to v4l-utils (if he does not have
that already), but in that case I would like to keep the v4l-utils name as
renaming is a pain for distros and leads to confusion.

Regards,

Hans
