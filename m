Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58312 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbZEXWMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 18:12:52 -0400
Date: Sun, 24 May 2009 17:26:45 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] to libv4lconvert, to do decompression for sn9c2028
 cameras
In-Reply-To: <4A19849F.3040000@redhat.com>
Message-ID: <alpine.LNX.2.00.0905241718400.25840@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu> <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu> <4A144E41.6080806@redhat.com> <alpine.LNX.2.00.0905231628240.24795@banach.math.auburn.edu>
 <4A191837.4070002@hhs.nl> <alpine.LNX.2.00.0905241208010.25546@banach.math.auburn.edu> <4A19849F.3040000@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 24 May 2009, Hans de Goede wrote:

>
>
> On 05/24/2009 07:22 PM, Theodore Kilgore wrote:
>> 
>> 
>> On Sun, 24 May 2009, Hans de Goede wrote:
>> 
>>> Hi,
>>> 
>>> Thanks for the patch, but I see one big issue with this patch,
>>> the decompression algorithm is GPL, where as libv4l is LGPL.
>>> 
>>> Any chance you could get this relicensed to LGPL ?
>> 
>> Hmmm. Come to think of it, that _is_ a problem, isn't it? I will see
>> what I can do about it, but it might take a while.
>> 
>
> Yes I'm afraid it is :(
>
> Regards,
>
> Hans
>

I seem to recall that I asked Harald Ruda about this once before, and he 
gave permission. The question arose because libgphoto2 is also LGPL, and I 
was thinking it might be nice if the decomp code for those cameras would 
be LGPL, too. Clearly, I never got around to making the change even though 
I asked him about it and he said yes, go right ahead.

But naturally that is the mail from him that I can not find. I have lots 
of other mails, including the original one in which he said that he had 
read a post of mine to gphoto-devel about the decompression issue for 
these cameras.

Well, I have sent him another mail, hoping that he is still active on the 
macam project, and I also will try to search through backup files and such 
to look for the mail. You can imagine, that was back in 2005 and several 
machine failures and hard drive failures in particular have taken place 
since then. I do try to back up stuff that I think is important, by 
having a copy of it on several machines. Let us hope that either I find 
something, or he answers the mail.

Theodore Kilgore
