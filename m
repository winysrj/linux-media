Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:60253 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbeBJIkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 03:40:11 -0500
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
Message-ID: <26a090fe-fb39-8f68-aa4e-ce4f9f6b0781@users.sourceforge.net>
Date: Sat, 10 Feb 2018 09:39:41 +0100
MIME-Version: 1.0
In-Reply-To: <ca67319a-622b-e35e-dfb5-045dd04b4deb@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Do any contributors get into the mood to take another look at software updates
>> from my selection of change possibilities in a more constructive way?
>>
>> Do you need any additional development resources?
> 
> One last time: either post per-driver patches with all the cleanups for a driver
> in a single patch,

I find such a change combination unsafe.


> or a per-directory patch (drivers/media/pci, usb, etc) doing the same cleanup
> for all drivers in that directory.

Would you dare to apply any (of my) scripts for the semantic patch language
directly on the whole directory for multi-media software?


> I prefer the first approach, but it's up to you.

Can you handle bigger patches really better than similar patch series?


> We don't have the time to wade through dozens of one-liner cleanup patches.

Are there any further possibilities to consider around consequences
from a general change resistance?

Will any development (or management) tools like “quilt fold” make the regrouping
of possible update steps more convenient and safer? 

Regards,
Markus
