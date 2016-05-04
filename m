Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34128 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbcEDQc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 12:32:28 -0400
Received: by mail-ob0-f182.google.com with SMTP id dm5so23386838obc.1
        for <linux-media@vger.kernel.org>; Wed, 04 May 2016 09:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160504150254.GA1286@phenom.ffwll.local>
References: <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
	<20160412094620.4fbf05c0@lwn.net>
	<CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
	<CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
	<54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
	<874maef8km.fsf@intel.com>
	<13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
	<20160504134346.GY14148@phenom.ffwll.local>
	<CAKMK7uG9hNkG6KxFLQeaCbtPFY7qLiz6s5+qDy9-DcdywkDqrA@mail.gmail.com>
	<20160504085713.3b81856d@lwn.net>
	<20160504150254.GA1286@phenom.ffwll.local>
Date: Wed, 4 May 2016 18:32:27 +0200
Message-ID: <CAKMK7uEDSZ0mR4FPFyJgVOd-cEa_g+OfHoxM1CTOi3y_NxbjPA@mail.gmail.com>
Subject: Re: Kernel docs: muddying the waters a bit
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 4, 2016 at 5:02 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, May 04, 2016 at 08:57:13AM -0600, Jonathan Corbet wrote:
>> On Wed, 4 May 2016 16:18:27 +0200
>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>
>> > > I'd really like to converge on the markup question, so that we can start
>> > > using all the cool stuff with impunity in gpu documentations.
>> >
>> > Aside: If we decide this now I could send in a pull request for the
>> > rst/sphinx kernel-doc support still for 4.7 (based upon the minimal
>> > markdown/asciidoc code I still have). That would be really awesome ...
>>
>> Sorry for my relative absence...I'm still busy dealing with bureaucracy
>> an ocean away from home.  I hope to begin emerging from this mess in the
>> near future.
>>
>> So ... there's the code you have, the work I (+Jani) did, and the work
>> Markus has done.  Which would you have me push into 4.7?
>>
>> The sphinx/rst approach does seem, to me, to be the right one, with the
>> existing DocBook structure remaining in place for those who want/need
>> it.  I'm inclined toward my stuff as a base to work with, obviously :) But
>> it's hackish at best and needs a lot of cleaning up.  It's a proof of
>> concept, but it's hardly finished (one might say it's barely begun...)
>>
>> In the end, I guess, I feel that anything we might try to push for 4.7 is
>> going to look rushed and not ready, and Linus might react accordingly.
>> I'd be more comfortable aiming for 4.8.  I *will* have more time to focus
>> on things in that time frame...  I suspect you're pretty well fed up with
>> this stuff being pushed back, and rightly so.  All I can do is apologize.
>>
>> That said, if you do think there's something out there that is good
>> enough to consider pushing in a week or two, do tell and we can all take
>> a look.
>
> Well I'd just have taken the asciidoc hacks I have currently in my
> topic/kerneldoc branch, converted to sphinx and looked how it fares. It
> should be fairly minimal, and I think the first step we want to do for the
> long-term plan. I hope I can ready something, and then we can look whether
> it's rushed for 4.7 or not.

Ok, discussed this a bit more with Jani on IRC and he really doesn't
like the old design of that branch (it calls the converter for every
kerneldoc comment). So I guess nothing rushed for 4.7, but hopefully
something for 4.8.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
