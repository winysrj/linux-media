Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2I3Jxc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 05:53:32 -0400
Message-ID: <506816EF.90001@redhat.com>
Date: Sun, 30 Sep 2012 11:54:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com> <506429D1.4090401@redhat.com> <50645295.1090609@googlemail.com> <5064ABF6.3010206@redhat.com> <5065D9C2.2070701@googlemail.com>
In-Reply-To: <5065D9C2.2070701@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/28/2012 07:09 PM, Frank Schäfer wrote:
> Hi,
>
> Am 27.09.2012 21:41, schrieb Hans de Goede:
>> Hi,
>>
>> On 09/27/2012 03:20 PM, Frank Schäfer wrote:
>>
>> <snip>
>>
>>>> What you've found is a qv4l2 bug (do you have the latest version?)
>>>
>>> Of course, I'm using the latest developer version.
>>>
>>> Even if this is just a qv4l2-bug: how do you want to fix it without
>>> removing the format selction feature ?
>>
>> Well, if qv4l2 can only handle rgb24 data, then it should gray out the
>> format selection (fixing it at rgb24) when not in raw mode.
>
> So you say "just remove this feature from qv4l2".
> I prefer fixing the library / API instead.

No I'm suggesting to keep the feature to select which input format
to use when in raw mode, while at the same time disabling the feature)
when in libv4l2 mode. What use is it to ask libv4l2 for say YUV420 data
and then later ask libv4lconvert to convert this to RGB24, when you could
have asked libv4l2 for RGB24 right away.

>
>>
>> v4lconvert_convert should only be called with
>> src_fmt and dest_fmt parameters which are the result of a
>> v4lconvert_try_format call, which clearly is not the case here!
>
> Why ? Because our library code is broken ?

Because that is a pre-condition which v4lconvert_convert expects
to be met. Not meeting that pre-condition means operating outside
of the designated operating parameters, and as such weird things
may happen.

> Is this important restriction documented somewhere ?

Not explicitly, patches welcome.

>
>
>>
>>>
>>>> one
>>>> is supposed to either use libv4l2, or do raw device access and then
>>>> call libv4lconvert directly.
>>>
>>> Even when using libv4lconvert only, multiple frame conversions are still
>>> causing the same trouble.
>>
>> True, but doing multiple conversions on one frame is just crazy ...
>
> Well, I would say "not necessary in most cases". But I can certainly
> think of use cases (other than what qv4l2 does).
> At least it should be possible and I think this is what application
> programmers expect when using a conversion function from a library.

Right, as said before libv4lconvert is not meant as a generic
format conversion library, and using it as such is not necessarily a
good idea as there are much better alternatives out there for doing
generic format conversion (both more flexible and faster).

More over libv4lconvert is specifically designed to be called once
per frame. Yes another restriction that needs documenting.

>>> But saying that libv4l2 and libv4lconvert can't be used at the same
>>> (although they are separate public libraries) and that
>>> v4lconvert_convert() may only be called once per frame seems to me like
>>> a - I would say "weird" - reinterpretation of the API...
>>> I don't think this is what applications currently expect (qv4l2 doesn't
>>> ;) ) and at least this would need public clarification.
>>
>> Using the 2 at the same time never was the intention libv4lconvert
>> lies *beneath* libv4l2 in the stack.
>
> Yeah, sure.
>
>> Using them both at the same time
>> would be like using some high level file io API, while at the same
>> making lowlevel seek / read / write calls on the underlying fd and
>> then expecting things to behave consistently. 00.9% of all apps should
>> (and do) use the "highlevel" libv4l2 API. Some testing / developer
>> apps like qv4l2 use libv4lconvert directly.
>
> The problem here is, that we actually have TWO high level APIs which
> interact in a - let's call it "unfortunate" - way.

I disagree that they are both highlevel. I know of only 2 tools which
use libv4lconvert directly, qv4l2 and svv, and both of them were written by
kernel developers for driver testing. So in practice everyone who want a
"high" level API is using libv4l2 (which is already low-level enough by
it self).

 > This interaction is not clear for the users (due to the transparent
 > processing stuff) and it doesn't match not what users expect.
 > But I think we can fix it and gain some nice extra features as a bonus.

Then lets document the interaction. I think you don't realize which can
of worms you're opening when you try to make libv4lconvert more generally
usable.

Please read the v4lconvert_convert function very carefully, esp.
the part where it hooks into v4lprocessing (software whitebalance, and
gamma correction). Make sure you understand what
v4lprocessing_pre_processing() does, what the difference is between
convert = 1 and convert = 2, and where *all* the callers are of
v4lprocessing_processing() (hint one is hiding in v4lconvert_convert_pixfmt)

Make sure you understand every single line of v4lconvert_convert! Once
you've done that I will welcome a proposal to make the libv4lconvert API
more general usable which:

1) Does not break any existing use-cases
2) Does not slow down things in anyway (so which does not introduce any
    extra intermediate buffers)

<snip>

>> 2) What is the use case for having separate convert_pixfmt etc.
>> functions available ... ?
>
> We already have them as separate functions, so the only question is:
> does it make sense to make them public ?
> I would say: yes, because this seems to be a sane way to fix a problem.
> And the second reason would be, that the provided operations are usefull
> for applications.

My point is that currently some of them have side-effects, ie
v4lconvert_convert_pixfmt() calling v4lprocessing_processing(), which is
fine as is, but may be a problem when making it public.

I agree that the libv4lconvert API could use an overhaul, but one of the
first things to do would be to untangle the rather glued on atm
libv4lcontrol and libv4lprocessing bits. I have a (partial) plan for this,
but no time. One of the first things which I would like to do is to
move over the software processing bits to a proper plugin model, where
by the plugins themselves also add the necessary "fake" v4l2-ctrls for
their own piece of functionality and where by the giant
quirk list in libv4lconvert/control/libv4lcontrol.c becomes split
in a quirk list per processing plugin, enabling that plugin for the
cameras which need that plugin. libv4lcontrol.c would then just
offer a generic mechanism to add fake controls, and to check if
a camera matches *a* quirklist, which the plugins can then use.

This would then allow for much easier addition of new software processing
plugins, such as for example software autofocus which is needed for
some cams.

All of this can be done without any external API changes atm, and would
have real tangible results, esp. once we start adding more software
processing plugins. Where as exporting more of the libv4lcontrol internals,
will make it much harder to do this much needed overhaul, and buys
us very little tangible advantages (again no normal end user applications
are using libv4lconvert directly).

So what I would like to see happen, if you want to work on libv4lconvert is
to start with doing the much needed overhaul of the internals, and once that
is done making a more generic API available is fine, and if we break the API
in the process that is fine too. But lets start with doing the ground work
on not with exporting internals which are not suitable for exporting atm.

Note that if there were a real need for exporting these internals right now,
things would be different, but I don't see such a real need, and no, sorry,
from my pov qv4l2 does not count, esp. since things can easily be fixed
there.

Note that I've written a proposal for a libv4lprocessing plugins a long time
ago, you can find it here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg18993.html

Regards,

Hans


