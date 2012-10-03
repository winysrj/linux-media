Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51880 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2JCLWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 07:22:51 -0400
Received: by bkcjk13 with SMTP id jk13so6039599bkc.19
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 04:22:49 -0700 (PDT)
Message-ID: <506C11F8.7090105@googlemail.com>
Date: Wed, 03 Oct 2012 13:22:48 +0300
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com> <506429D1.4090401@redhat.com> <50645295.1090609@googlemail.com> <5064ABF6.3010206@redhat.com> <5065D9C2.2070701@googlemail.com> <506816EF.90001@redhat.com>
In-Reply-To: <506816EF.90001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am 30.09.2012 11:54, schrieb Hans de Goede:
> Hi,
>
> On 09/28/2012 07:09 PM, Frank Schäfer wrote:
>> Hi,
>>
>> Am 27.09.2012 21:41, schrieb Hans de Goede:
>>> Hi,
>>>
>>> On 09/27/2012 03:20 PM, Frank Schäfer wrote:
>>>
>>> <snip>
>>>
>>>>> What you've found is a qv4l2 bug (do you have the latest version?)
>>>>
>>>> Of course, I'm using the latest developer version.
>>>>
>>>> Even if this is just a qv4l2-bug: how do you want to fix it without
>>>> removing the format selction feature ?
>>>
>>> Well, if qv4l2 can only handle rgb24 data, then it should gray out the
>>> format selection (fixing it at rgb24) when not in raw mode.
>>
>> So you say "just remove this feature from qv4l2".
>> I prefer fixing the library / API instead.
>
> No I'm suggesting to keep the feature to select which input format
> to use when in raw mode, while at the same time disabling the feature)
> when in libv4l2 mode. What use is it to ask libv4l2 for say YUV420 data
> and then later ask libv4lconvert to convert this to RGB24, when you could
> have asked libv4l2 for RGB24 right away.

I assume the idea behind input format selction when using libv4l2 is to
provide a possibilty to test libv4l2 ?
I'm not sure if we really need this.
If not, sure, we can simply remove it to get rid of the problem.



<snip> [we both agree that the current design/behavior is "suboptimal",
needs to be documented and should be improved]

> ...
>>>> But saying that libv4l2 and libv4lconvert can't be used at the same
>>>> (although they are separate public libraries) and that
>>>> v4lconvert_convert() may only be called once per frame seems to me
>>>> like
>>>> a - I would say "weird" - reinterpretation of the API...
>>>> I don't think this is what applications currently expect (qv4l2
>>>> doesn't
>>>> ;) ) and at least this would need public clarification.
>>>
>>> Using the 2 at the same time never was the intention libv4lconvert
>>> lies *beneath* libv4l2 in the stack.
>>
>> Yeah, sure.
>>
>>> Using them both at the same time
>>> would be like using some high level file io API, while at the same
>>> making lowlevel seek / read / write calls on the underlying fd and
>>> then expecting things to behave consistently. 00.9% of all apps should
>>> (and do) use the "highlevel" libv4l2 API. Some testing / developer
>>> apps like qv4l2 use libv4lconvert directly.
>>
>> The problem here is, that we actually have TWO high level APIs which
>> interact in a - let's call it "unfortunate" - way.
>
> I disagree that they are both highlevel. I know of only 2 tools which
> use libv4lconvert directly, qv4l2 and svv, and both of them were
> written by
> kernel developers for driver testing. So in practice everyone who want a
> "high" level API is using libv4l2 (which is already low-level enough by
> it self).

Hmmm... that's a weird argumentation.
Because only a few applications are using it, it is not a high level API ?
And assuming that we really know all users of a public API is very
dangerous...


>
> > This interaction is not clear for the users (due to the transparent
> > processing stuff) and it doesn't match not what users expect.
> > But I think we can fix it and gain some nice extra features as a bonus.
>
> Then lets document the interaction. I think you don't realize which can
> of worms you're opening when you try to make libv4lconvert more generally
> usable.
>
> Please read the v4lconvert_convert function very carefully, esp.
> the part where it hooks into v4lprocessing (software whitebalance, and
> gamma correction). Make sure you understand what
> v4lprocessing_pre_processing() does, what the difference is between
> convert = 1 and convert = 2, and where *all* the callers are of
> v4lprocessing_processing() (hint one is hiding in
> v4lconvert_convert_pixfmt)

Yeah, it's a bit tricky, but understandable.
At the moment, the plan is not to change WHAT is done in this function,
but WHERE it is done.


>
> Make sure you understand every single line of v4lconvert_convert! Once
> you've done that I will welcome a proposal to make the libv4lconvert API
> more general usable which:
>
> 1) Does not break any existing use-cases
> 2) Does not slow down things in anyway (so which does not introduce any
>    extra intermediate buffers)
>

Sure. Will do that.
Basically, the idea is to make libv4lconvert a pure toolbox with methods for
- for V4L_PIX_FORMAT conversion
- cropping
- horizontal+vertical flipping
- rotation
- processing (applying filters => auto whitebalance, auto gain, gamma
correction etc.)
- ...
of frames. Most of these methods are already there and only need to be
made public (some with small extenstions/modifiactions).

The whole "magic" (transparent flipping, rotation, ...) should be done
inside libv4l.
Does that make sense for you ?


> <snip>
>
>>> 2) What is the use case for having separate convert_pixfmt etc.
>>> functions available ... ?
>>
>> We already have them as separate functions, so the only question is:
>> does it make sense to make them public ?
>> I would say: yes, because this seems to be a sane way to fix a problem.
>> And the second reason would be, that the provided operations are usefull
>> for applications.
>
> My point is that currently some of them have side-effects, ie
> v4lconvert_convert_pixfmt() calling v4lprocessing_processing(), which is
> fine as is, but may be a problem when making it public.

Yes, I have to think about that.

>
> I agree that the libv4lconvert API could use an overhaul, but one of the
> first things to do would be to untangle the rather glued on atm
> libv4lcontrol and libv4lprocessing bits. I have a (partial) plan for
> this,
> but no time. One of the first things which I would like to do is to
> move over the software processing bits to a proper plugin model, where
> by the plugins themselves also add the necessary "fake" v4l2-ctrls for
> their own piece of functionality and where by the giant
> quirk list in libv4lconvert/control/libv4lcontrol.c becomes split
> in a quirk list per processing plugin, enabling that plugin for the
> cameras which need that plugin. libv4lcontrol.c would then just
> offer a generic mechanism to add fake controls, and to check if
> a camera matches *a* quirklist, which the plugins can then use.

Btw, did you ever think about making the device list a text file ?
You know editing a text file is much easer than updating the whole
library. ;)

>
> This would then allow for much easier addition of new software processing
> plugins, such as for example software autofocus which is needed for
> some cams.
>
> All of this can be done without any external API changes atm, and would
> have real tangible results, esp. once we start adding more software
> processing plugins. Where as exporting more of the libv4lcontrol
> internals,
> will make it much harder to do this much needed overhaul, and buys
> us very little tangible advantages (again no normal end user applications
> are using libv4lconvert directly).

I agree. First overhaul the internals, then extend the API.

>
> So what I would like to see happen, if you want to work on
> libv4lconvert is
> to start with doing the much needed overhaul of the internals, and
> once that
> is done making a more generic API available is fine, and if we break
> the API
> in the process that is fine too. But lets start with doing the ground
> work
> on not with exporting internals which are not suitable for exporting atm.

100% agreement.

>
> Note that if there were a real need for exporting these internals
> right now,
> things would be different, but I don't see such a real need, and no,
> sorry,
> from my pov qv4l2 does not count, esp. since things can easily be fixed
> there.
>
> Note that I've written a proposal for a libv4lprocessing plugins a
> long time
> ago, you can find it here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg18993.html

Thanks, I will consider it.

Regards,
Frank

>
> Regards,
>
> Hans
>
>


