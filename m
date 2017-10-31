Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:54542 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752495AbdJaI2v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 04:28:51 -0400
Subject: Re: Adjustments for a lot of function implementations
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, Jan Kara <jack@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
 <356f75b2-d303-7f10-b76c-95e2f686bd3c@xs4all.nl>
 <14619198-bebe-d215-5324-a14fbc2103fb@users.sourceforge.net>
 <alpine.DEB.2.20.1710301745530.2160@hadrien>
 <ebf37d57-38c6-b3de-5a66-dbb1c13fd63a@xs4all.nl>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <f4bd5363-894f-57ee-a557-555ac700ea1a@users.sourceforge.net>
Date: Tue, 31 Oct 2017 09:27:56 +0100
MIME-Version: 1.0
In-Reply-To: <ebf37d57-38c6-b3de-5a66-dbb1c13fd63a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>> but will reject the others, not just this driver but all of them
>>>> that are currently pending in our patchwork (https://patchwork.linuxtv.org).

I find it very surprising that you rejected 146 useful update suggestions
so easily.


>>>> Feel free to repost, but only if you organize the patch as either fixing
>>>> the same type of issue for a whole subdirectory (media/usb, media/pci, etc)
>>
>> Just for the record, while this may work for media, it won't work for all
>> subsystems.  One will quickly get a complaint that the big patch needs to
>> go into multiple trees.
> 
> For the record: this only applies to drivers/media.

What does this software area make it so special in comparison to
other Linux subsystems?


> We discussed what do to with series like this during our media summit
> last Friday and this was the conclusion of that.

* Have you taken any other solution approaches into account than
  a quick “rejection”?

* Could your reaction have been different if the remarkable number of
  change possibilities were sent by different authors (and not only me)?

* How should possibly remaining disagreements about affected implementation
  details be resolved now?

* Are you looking for further improvements around development tools
  like “patchwork” and “quilt”?

* Will you accept increasing risks because of bigger patch sizes?


>>>> or fixing all issues for a single driver.
>>>
>>> I find that I did this already.

* Can such an information lead to differences in the preferred patch granularity?

* How do you think about this detail?


>>>> Actual bug fixes (like the null pointer patch in this series) can still be posted as
>>>> separate patches, but cleanups shouldn't.
>>>
>>> I got an other software development opinion.

How would you ever like to clean up stuff in affected source files
which was accumulated (or preserved somehow) over years?


>>>> Just so you know, I'll reject any future patch series that do not follow these rules.

I guess that this handling will trigger more communication challenges.


>>>> Just use common sense when posting these things in the future.

Our “common sense” seems to be occasionally different in significant ways.


>>>> I would also suggest that your time might be spent more productively
>>>> if you would work on some more useful projects.

I distribute my software development capacity over several areas.
Does your wording indicate a questionable signal for further contributions?

Regards,
Markus
