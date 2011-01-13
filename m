Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab1AMMn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 07:43:29 -0500
Message-ID: <4D2EF36B.8050007@redhat.com>
Date: Thu, 13 Jan 2011 10:43:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch] addition to v2.6.35_i2c_new_probed_device.patch (was:
 Re: Debug code in HG repositories)
References: <AANLkTin6g15UzWuN8XHRUwwGUPWpSnWwVAU1GxvXCcNz@mail.gmail.com>
In-Reply-To: <AANLkTin6g15UzWuN8XHRUwwGUPWpSnWwVAU1GxvXCcNz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-01-2011 02:43, Vincent McIntyre escreveu:
> On 1/12/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>>> which on the face of it suggests
>>>   btty-input.c
> 
> already handled, my mistake.
> 
>>>   cx88-input.c
> the search string was in a comment
> 
>>>   hdpvr-i2c.c
> see below
> 
> 
>> I have no time currently to touch on it, since I still have lots of patches
>> to
>> take a look and submit for the merge window. So, if you have some time,
>> could you please prepare and submit a patch fixing it?
> 
> This seems to be a relatively simple patch, inline below.
> This is against the linux-media tree,  I could not figure out how
> to turn it into a clean patch of
> media_build/backports/v2.6.35_i2c_new_probed_device.patch
> I did look for guidance on how to do this in
> media_build/README.patches  but could not find anything that looked
> relevant.

Well, there are two ways for doing it:

1) with two copies of linux/, one without your changes, and the other with
your changes;

2) you may create a temporary tree, just to do your patch. That's the way
I use. To avoid causing any confusion, I generally create the second
tree with mercurial.

Something like:

	$ cd media_build/linux/
	$ hg init
	$ hg add *
	$ hg commit

Then, I change the files, and I do:

	$ hg diff > ../backports/my_new_patch.patch

In this specific case, before actually changing the files, I would do:

	$ patch -p1 -i ../backports/v2.6.35_i2c_new_probed_device.patch -R
	$ hg commit
	$ patch -p1 -i ../backports/v2.6.35_i2c_new_probed_device.patch
	<edit the files>
	$ hg diff > ../backports/v2.6.35_i2c_new_probed_device.patch

> The code now compiles for me but I don't know if it will actually
> work, I don't have the hardware.

Ok, I did the above procedure, adding your patch to the diff. Please test.

Thanks,
Mauro
