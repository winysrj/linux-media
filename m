Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:54898 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBBMar (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 07:30:47 -0500
Subject: Re: Adjustments for a lot of function implementations
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, Jan Kara <jack@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
 <356f75b2-d303-7f10-b76c-95e2f686bd3c@xs4all.nl>
 <14619198-bebe-d215-5324-a14fbc2103fb@users.sourceforge.net>
 <alpine.DEB.2.20.1710301745530.2160@hadrien>
 <ebf37d57-38c6-b3de-5a66-dbb1c13fd63a@xs4all.nl>
 <049aa1b4-6291-ec24-1ffb-77ae8d1cdb63@users.sourceforge.net>
 <804550a6-1096-12f1-a0ec-1ccd6bcc191e@xs4all.nl>
 <f082b1ae-1be4-440a-6a81-68446c67243e@users.sourceforge.net>
 <ca67319a-622b-e35e-dfb5-045dd04b4deb@xs4all.nl>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <4772aced-f43a-f4f4-c593-b42c7b862a37@users.sourceforge.net>
Date: Fri, 2 Feb 2018 13:30:30 +0100
MIME-Version: 1.0
In-Reply-To: <ca67319a-622b-e35e-dfb5-045dd04b4deb@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> One last time: either post per-driver patches with all the cleanups for a driver
> in a single patch,

I preferred to offer source code adjustments according to specific transformation
patterns mostly for each software module separately (also in small patch series).


> or a per-directory patch (drivers/media/pci, usb, etc) doing the same cleanup
> for all drivers in that directory.

I am curious if bigger patch packages would be easier to get accepted.

Or would you get frightened still by any other change combination?



> I prefer the first approach,

We have got different preferences for a safe patch granularity.


> but it's up to you.

I imagine that there are more development factors involved.


> We don't have the time to wade through dozens of one-liner cleanup patches.

It is usual that integration of update suggestions will take some time.
How would the situation change if I would dare to regroup possible update steps?


> I don't understand what is so difficult about this.

There are communication difficulties to consider since your terse information
from your conference meeting.

If you would insist on patch squashing, would you dare to use a development tool
like “quilt fold” also on your own once more?

Regards,
Markus
