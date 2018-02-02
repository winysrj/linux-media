Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:54593 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750773AbeBBK3M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 05:29:12 -0500
Subject: Re: Adjustments for a lot of function implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>,
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ca67319a-622b-e35e-dfb5-045dd04b4deb@xs4all.nl>
Date: Fri, 2 Feb 2018 11:29:06 +0100
MIME-Version: 1.0
In-Reply-To: <f082b1ae-1be4-440a-6a81-68446c67243e@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/18 10:55, SF Markus Elfring wrote:
>> ??? I did that: either one patch per directory with the same type of change,
>> or one patch per driver combining all the changes for that driver.
> 
> Do any contributors get into the mood to take another look at software updates
> from my selection of change possibilities in a more constructive way?
> 
> Do you need any additional development resources?

One last time: either post per-driver patches with all the cleanups for a driver
in a single patch, or a per-directory patch (drivers/media/pci, usb, etc) doing
the same cleanup for all drivers in that directory.

I prefer the first approach, but it's up to you.

We don't have the time to wade through dozens of one-liner cleanup patches.

I don't understand what is so difficult about this.

Regards,

	Hans
