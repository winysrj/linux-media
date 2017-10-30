Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33577 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdJ3KsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 06:48:08 -0400
Subject: Re: Adjustments for a lot of function implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>,
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
 <049aa1b4-6291-ec24-1ffb-77ae8d1cdb63@users.sourceforge.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <804550a6-1096-12f1-a0ec-1ccd6bcc191e@xs4all.nl>
Date: Mon, 30 Oct 2017 11:48:03 +0100
MIME-Version: 1.0
In-Reply-To: <049aa1b4-6291-ec24-1ffb-77ae8d1cdb63@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2017 11:40 AM, SF Markus Elfring wrote:
>>>>> Feel free to repost, but only if you organize the patch as either fixing the same type of
>>>>> issue for a whole subdirectory (media/usb, media/pci, etc)
>>>
>>> Just for the record, while this may work for media, it won't work for all
>>> subsystems.  One will quickly get a complaint that the big patch needs to
>>> go into multiple trees.
>>
>> For the record: this only applies to drivers/media.
> 
> Interesting …
> 
> 
>> We discussed what do to with series like this during our media summit last Friday
> 
> Would you like to share any more information from this meeting?

??? I did that: either one patch per directory with the same type of change,
or one patch per driver combining all the changes for that driver.

> 
> 
>> and this was the conclusion of that.
> 
> I would appreciate further indications for a corresponding change acceptance.
> 
> I found a feedback by Mauro Carvalho Chehab more constructive.
> 
> [GIT,PULL,FOR,v4.15] Cleanup fixes
> https://patchwork.linuxtv.org/patch/43957/
> 
> “…
> This time, I was nice and I took some time doing:
> 
> 	$ quilt fold < `quilt next` && quilt delete `quilt next`
> …”

Yes, and you were told not to do it like that again.

Regards,

	Hans
