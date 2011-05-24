Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1EXOPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 10:15:05 -0400
Message-ID: <4DDBBD64.5060107@redhat.com>
Date: Tue, 24 May 2011 11:15:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl>
In-Reply-To: <201105240850.35032.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-05-2011 03:50, Hans Verkuil escreveu:
> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>> during the weekend, I decided to add alsa support also on xawtv3, basically
>> to provide a real usecase example. Of course, for it to work, it needs the
>> very latest v4l2-utils version from the git tree.
> 
> Please, please add at the very least some very big disclaimer in libv4l2util
> that the API/ABI is likely to change. As mentioned earlier, this library is
> undocumented, has not gone through any peer-review, and I am very unhappy with
> it and with the decision (without discussion it seems) to install it.

With respect to the other stuff inside libv4l2util, they are there for a long time,
and not much has changed since them. Yet, I'm not a big fan of exporting them, as
they may not be useful to other applications.

With respect to the new API I've added, there are not much to change at the 
get_media_devices stuff. It has just 5 methods: one to retrieve info, one to free data, 
one to display all info (used by v4l2-sysfs-path tool), and two for getting the alsa
devices. Of course, new functions can always be added, and the structs might need more
fields.

I've added a proper documentation for it. I also added a macro with a version number 
for the library. This will help userspace apps that would use it to check for the 
version number.

That's said, I'm moving the get_media_devices into a new library, to avoid mixing
it with other stuff.

As I said, I'm OK to postpone the install to happen for the -next version of v4l2-utils,
so I've commented for now the install scripts for it.

> Once you install it on systems it becomes much harder to change.
> 
> Regards,
> 
> 	Hans

Mauro
