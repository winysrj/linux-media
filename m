Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54629 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0DBSeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 14:34:46 -0400
Received: by gwb19 with SMTP id 19so277951gwb.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 11:34:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <y2x1a297b361004021124jb2cc1b9ctc2c8bfb7c5a5f320@mail.gmail.com>
References: <201004011937.39331.hverkuil@xs4all.nl>
	 <4BB4E4CC.3020100@redhat.com>
	 <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com>
	 <x2v829197381004021053nf77e2d42q4f1614eced7f999d@mail.gmail.com>
	 <y2x1a297b361004021124jb2cc1b9ctc2c8bfb7c5a5f320@mail.gmail.com>
Date: Fri, 2 Apr 2010 14:34:44 -0400
Message-ID: <y2j829197381004021134gf51277c6wdfe2d1c892e7f12f@mail.gmail.com>
Subject: Re: [RFC] Serialization flag example
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 2, 2010 at 2:24 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi Devin,
>
>> Hello Manu,
>>
>> The argument I am trying to make is that there are numerous cases
>> where you should not be able to use both a particular DVB and V4L
>> device at the same time.  The implementation of such locking should be
>> handled by the v4l-dvb core, but the definition of the relationships
>> dictating which devices cannot be used in parallel is still the
>> responsibility of the driver.
>>
>> This way, a bridge driver can say "this DVB device cannot be used at
>> the same time as this V4L device" but the actual enforcement of the
>> locking is done in the core.  For cases where the devices can be used
>> in parallel, the bridge driver doesn't have to do anything.
>
> I follow what you mean. Why I emphasized that it shouldn't be at the
> core, but basically in the bridge driver:
>
> Case 1
> - there is a 1:n relation, In this case there is only 1 path and 3
> users sharing that path
> In such a case, You can use such a mentioned scheme, where things do
> look okay, since it is only about locking a single path.
>
> Case 2
> - there is a n:n relation, in this case there are n paths and n users
> In such a case, it is hard to make the core aware of all the details,
> since there could be more than 1 resource of the same category;
> Mapping each of them properly won't be easy, as for the same chip
> driver Resource A on Card A, would mean different for Resource A on
> Card B.
>
> Case 3
> - there is a m:n relation, in this case, there are m paths and n users
> This case is even more painful than the previous ones.
>
> In cases 2 & 3, the option to handle such cases is using a
> configuration scheme based on the card type. I guess handling such
> would be quite daunting and hard to get right. I guess it would be
> much more efficient and useful to have such a feature to be made
> available in the bridge driver as it is a resource of the card
> configuration, rather than a common bridge resource.

Hi Manu,

I don't have any problem with a bridge choosing to implement some much
more complicated scheme to meet its own special requirements.
However, it feels like the vast majority of bridges would fall into
scenario #1, and having that functionality in the core would mean that
all of those bridges would work properly (only needing a 2 line code
change).  Hence, making the core handle the common case and still
allowing the bridge maintainer to override the logic if necessary
would seem like an ideal solution.

Nothing I have suggested precludes the bridge maintainer from *not*
adding the code making the association in the core and instead adding
his/her own locking infrastructure to the bridge driver.

Right now, I can think of five or six bridges all of which fall into
category #1.  Should we really add effectively the exact same locking
code to all those bridges, running the risk of of screwing up the
cut/paste?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
