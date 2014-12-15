Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37929 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLOQf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:35:28 -0500
Message-ID: <548F0DC8.2090005@collabora.com>
Date: Mon, 15 Dec 2014 11:35:20 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com> <548C17C9.2060809@redhat.com> <548C6607.10700@collabora.com> <548D5D26.5080504@redhat.com> <548D9D93.1080301@collabora.com> <548F051E.805@redhat.com>
In-Reply-To: <548F051E.805@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-15 10:58, Hans de Goede a écrit :
> Hi,
>
> Hmm, is that jpeg overflow still there with my recent (aprok 2-3 weeks 
> ago) fix
> for this?
I'll need to check, might have been my fault too, since I was trying to 
reallocate the frames segment to implement support for CREATE_BUFS, 
without proper knowledge of the code. If we could have 1 allocation per 
frame, it would be trivial to implement. Could be made as a rework 
first. I wouldn't not worry too much for now, I apology for the noise.

>> This is getting a bit annoying. Specially that we are pushing forward 
>> having m2m decoders to only be usable through libv4l2 (HW specific 
>> parsers). Is there a long term plan or are we simply pushing the dust 
>> toward libv4l2 ?
>
> I think that trying to bold support for all of this into libv4l2 is 
> not necessarily
> a good idea. Then again if we're going to use libv4l2 plugins to do 
> things like
> media-controller pipeline setups for apps which are not 
> media-controller aware,
> maybe it is ...
>
> libv4l2 was mostly created to get the then current generation of v4l2 
> apps to work
> with webcams which have funky formats without pushing fmt conversion 
> into the kernel
> as several out of tree drivers were doing.
>
> It may be better to come up with a better API for libv4lconvert, and 
> let apps which
> want to do advanced stuff deal with conversion themselves, while 
> keeping all the
> conversion code in a central place, but that does leave the 
> media-controller issue.
>
> Note that I've aprox. 0 time to work on libv4l now a days ...
>
> What we really need is an active libv4l maintainer. Do not get me 
> wrong, Gregor
> has been doing a great job at maintaining it, but if we want to do 
> some architectural
> rework (or just a complete rewrite) I think we need someone who knows 
> the v4l2 API,
> media-controller, etc. a lot better.
>
Thanks for this information, and thanks for the effort so far. I didn't 
want to make this comment discouraging. I do cheer anyone taking care 
right now, and anyone that would come up next. As you mention, there has 
been plan (and currently active work) toward depending on libv4l to 
support cameras that need media-controller, decoders that need parsers, 
etc. I think these ideas are fine, but when bringing these ideas we 
should care more of how we are doing to add and test these in libv4l2, 
in a way that it's all very usable.

cheers,
Nicolas
