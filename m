Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455Ab1JGCHm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 22:07:42 -0400
Message-ID: <4E8E5EEA.80906@redhat.com>
Date: Thu, 06 Oct 2011 23:07:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl> <4E8DACAF.5070207@redhat.com> <4E8DE450.7030302@redhat.com>
In-Reply-To: <4E8DE450.7030302@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 14:24, Mauro Carvalho Chehab escreveu:
> Em 06-10-2011 10:27, Mauro Carvalho Chehab escreveu:
>> Em 06-10-2011 09:23, Hans Verkuil escreveu:
>>> Currently we have three repositories containing libraries and utilities that
>>> are relevant to the media drivers:
>>>
>>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
>>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
>>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>>>
>>> It makes no sense to me to have three separate repositories, one still using
>>> mercurial and one that isn't even on linuxtv.org.
>>>
>>> I propose to combine them all to one media-utils.git repository. I think it
>>> makes a lot of sense to do this.
>>>
>>> After the switch the other repositories are frozen (with perhaps a README
>>> pointing to the new media-utils.git).
>>>
>>> I'm not sure if there are plans to make new stable releases of either of these
>>> repositories any time soon. If there are, then it might make sense to wait
>>> until that new stable release before merging.
>>>
>>> Comments?
>>
>> I like that idea. It helps to have the basic tools into one single repository,
>> and to properly distribute it.

Ok, I found some time to do an experimental merge of the repositories. It is available
at:

http://git.linuxtv.org/mchehab/media-utils.git

For now, all dvb-apps stuff is on a separate directory. It makes sense to latter
re-organize the directories. Anyway, the configure script will allow disable
dvb-apps, v4l-utils and/or libv4l. The default is to have all enabled.

One problem I noticed is that the dvb-apps are at version 1.1. So, if we're
releasing a new version, we'll need to jump from 0.9 to dvb-apps version + 1.
So, IMO, the first version with the merge should be version 1.2.

Comments?

Regards,
Mauro
