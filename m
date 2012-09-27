Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab2I0TkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 15:40:20 -0400
Message-ID: <5064ABF6.3010206@redhat.com>
Date: Thu, 27 Sep 2012 21:41:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com> <506429D1.4090401@redhat.com> <50645295.1090609@googlemail.com>
In-Reply-To: <50645295.1090609@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/27/2012 03:20 PM, Frank Schäfer wrote:

<snip>

>> What you've found is a qv4l2 bug (do you have the latest version?)
>
> Of course, I'm using the latest developer version.
>
> Even if this is just a qv4l2-bug: how do you want to fix it without
> removing the format selction feature ?

Well, if qv4l2 can only handle rgb24 data, then it should gray out the
format selection (fixing it at rgb24) when not in raw mode.

v4lconvert_convert should only be called with
src_fmt and dest_fmt parameters which are the result of a
v4lconvert_try_format call, which clearly is not the case here!

>
>> one
>> is supposed to either use libv4l2, or do raw device access and then
>> call libv4lconvert directly.
>
> Even when using libv4lconvert only, multiple frame conversions are still
> causing the same trouble.

True, but doing multiple conversions on one frame is just crazy ...

> Hans, first of all, I would like to say that my intention is not to
> savage your work.
> I know API design and maintanance is very difficult and you are doing a
> great job.
> Things like this just happen and we have to make the best out of it.

I will gladly admit that since libv4lconvert has organically grown
things like flipping and software processing, the API is no longer ideal :)

>
> But saying that libv4l2 and libv4lconvert can't be used at the same
> (although they are separate public libraries) and that
> v4lconvert_convert() may only be called once per frame seems to me like
> a - I would say "weird" - reinterpretation of the API...
> I don't think this is what applications currently expect (qv4l2 doesn't
> ;) ) and at least this would need public clarification.

Using the 2 at the same time never was the intention libv4lconvert
lies *beneath* libv4l2 in the stack. Using them both at the same time
would be like using some high level file io API, while at the same
making lowlevel seek / read / write calls on the underlying fd and
then expecting things to behave consistently. 00.9% of all apps should
(and do) use the "highlevel" libv4l2 API. Some testing / developer
apps like qv4l2 use libv4lconvert directly. And I must admit that
I've considered simple making the libv4lconvert API private at times.

>
> So let's see if there is a possibility to fix the issue by improving the
> libraries without breaking the API.
>
> What about the following solution:
> - make v4lconvert_convert_pixfmt() and v4lconvert_crop() public
> functions and fix qv4l2 to use them instead of v4lconvert_convert()
> - also make the flip and rotation functions (v4lconvert_flip(),
> v4lconvert_rotate90()) publicly available

That would need some careful review of their API's but after that yes
that should be doable.

> - modify libv4l2 to call v4lconvert_convert_pixfmt() and the
> flip+rotation+crop functions instead of v4lconvert_convert()
 >
> - fix v4lconvert_convert() to not do transparent image flipping/rotation
> (means => call v4lconvert_convert_pixfmt() and v4lconvert_crop() only).

Erm, no, have you looked at v4lconvert_convert it does a lot
of magic with figuring out how much intermediate buffers it needs
(skipping steps where possible), caches those buffers rather then re-alloc
them every frame, etc.

Making it do less means loosing some chances for optimization, and frankly
it works well. I don't see why we would need some do some stuff but not all
function when we also offer all the separate steps for users who want them.

Also I still consider the rotate 90 for pac7302 part of the pixfmt conversion,
this is something specific to how these cameras encode the picture, not
a generic thing.

> For API-clean-up:
> - create a copy of (the fixed) v4lconvert_convert() called something
> like v4lconvert_convert_crop()
> - declare v4lconvert_convert() as deprecated so that we can remove it
> sometime in the future
>
> What do you think ?

2 things:

1) qv4l2 needs to be fixed to not show to format selection in wrapped mode

2) What is the use case for having separate convert_pixfmt etc. functions available ... ?

Regards,

Hans
