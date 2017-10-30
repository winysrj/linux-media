Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:52968 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbdJ3Kk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 06:40:59 -0400
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
Message-ID: <049aa1b4-6291-ec24-1ffb-77ae8d1cdb63@users.sourceforge.net>
Date: Mon, 30 Oct 2017 11:40:10 +0100
MIME-Version: 1.0
In-Reply-To: <ebf37d57-38c6-b3de-5a66-dbb1c13fd63a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>> Feel free to repost, but only if you organize the patch as either fixing the same type of
>>>> issue for a whole subdirectory (media/usb, media/pci, etc)
>>
>> Just for the record, while this may work for media, it won't work for all
>> subsystems.  One will quickly get a complaint that the big patch needs to
>> go into multiple trees.
> 
> For the record: this only applies to drivers/media.

Interesting …


> We discussed what do to with series like this during our media summit last Friday

Would you like to share any more information from this meeting?


> and this was the conclusion of that.

I would appreciate further indications for a corresponding change acceptance.

I found a feedback by Mauro Carvalho Chehab more constructive.

[GIT,PULL,FOR,v4.15] Cleanup fixes
https://patchwork.linuxtv.org/patch/43957/

“…
This time, I was nice and I took some time doing:

	$ quilt fold < `quilt next` && quilt delete `quilt next`
…”


Regards,
Markus
