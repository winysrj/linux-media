Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42911 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1BWW4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 17:56:18 -0500
Received: by ewy6 with SMTP id 6so1702539ewy.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 14:56:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D658A40.9050604@redhat.com>
References: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
	<4D658A40.9050604@redhat.com>
Date: Wed, 23 Feb 2011 17:56:16 -0500
Message-ID: <AANLkTimbNe6-YwydnRVc+Ng0aW1-9S_Gg6AKfbHaEdxp@mail.gmail.com>
Subject: Re: Question on V4L2 S_STD call
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 23, 2011 at 5:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Not all PAL standards. "Only" the european PAL standards (B/G/D/K/I/H):

Correct.

> PAL/M, PAL/N, PAL/Nc and PAL/60 are not part of it. This is the equivalent
> of the V4L1 definition for PAL (on V4L1, there was just PAL/NSTC/SECAM, and
> a hack, at bttv, for 4 more standards).
>
> In a matter of fact, V4L2_STD_PAL is not a meaningful parameter, as
> it doesn't cover all PAL standards, and if user selects it, an unpredictable
> result may happen, as almost no driver is capable of auto-detecting all
> variants of the PAL standards. The same issue also happens, on some extend,
> with V4L2_STD_SECAM and V4L2_STD_NTSC (the last case generally falls back
> to NTSC/M, so people in Asia will likely have problems).
>
> There's even a worse standard: V4L2_STD_ALL (yes, a few drivers handle it
> properly, for example, tvp5150 can use it for video).
>
> Basically, there's just one way to make users happy with things like PAL:
> enable hardware auto-detection for all standards at the standard mask.
> Unfortunately, this is is generally not possible, due to hardware issues.
>
> The drivers should do things like:
>
> if (standard == V4L2_STD_PAL_I) {
>        /* Select PAL/I standard */
> } else if (standard == V4L2_STD_PAL_N) {
>        /* Select PAL/N standard */
> } else if ((standard & V4L2_STD_MN) == V4L2_STD_MN) {
>        /* enable STD M/N autodetection */
> } else if ((standard & V4L2_STD_PAL && !(standard & ~V4L2_STD_PAL)) {
>        /* enable PAL autodetection for B/G/D/K/H/I */
> ...
> } else {
>        /* enable autodetection for all supported standards */
> }
>
> Testing first for restrict standards, then for more generic ones, adding
> autodetection code for them.
>
>> However, the cx231xx has code for setting up the DIF which basically
>> says:
>>
>> if (standard & V4L2_STD_MN) {
>>  ...
>> } else if ((standard == V4L2_STD_PAL_I) |
>>                         (standard & V4L2_STD_PAL_D) |
>>                       (standard & V4L2_STD_SECAM)) {
>>  ...
>> } else {
>>   /* default PAL BG */
>>   ...
>> }
>
> This doesn't soung wrong to me.

If it were doing "standard == V4L2_STD_PAL_D" instead of "standard &
V4L2_STD_PAL_D", then it would be behaving as you described.  But it's
just checking to see if it's in the mask at all, which means if you
pass "PAL", then you always get the second block.

>> As a result, if you have a PAL-B/G signal and select "PAL" in tvtime,
>> the test passes for PAL_I/PAL_D/SECAM since that matches the bitmask.
>> The result of course is garbage video.
>
> Garbage on some Countries, good video and audio on others. People where
> PAL/D or PAL/I is the standard will be happy with this.

Correct.  I should have been more clear as that is exactly what I meant.

>> So here is the question:
>>
>> How are we expected to interpret an application asking for "PAL" in
>> cases when the driver needs a more specific video standard?
>>
>> I can obviously add code to tvtime in the long term to have the user
>> provide a more specific standard instead of "PAL", but since it is
>> supported in the V4L2 spec, I would like to understand what the
>> expected behavior should be in drivers.
>
> Basically, tvtime does the wrong thing with respect to video standards.
>
> The simplest fix is to enumerate the supported standards and to display
> them to the userspace, letting userspace to select a standard, allowing
> them to tell the driver what standard is needed, and not requiring a restart
> if the user changes the video standard, especially if the number of
> lines doesn't change.
>
> Another way would be to ask user where he lives and then tell the kernel
> driver to use the standards available on that Country only. This won't work
> 100%, as the user may want to force to a specific standard anyway (for
> example, here, most STB's output signals in NTSC/M, but the broadcast and
> official standard is PAL/M). People with equipments like VCR/game consoles
> and other random stuff may also need to force it to PAL/60, NTSC/443, etc
> for the composite/svideo ports.
>
> What most drivers do is to first select the more specific standards,
> assuming that, if userspace is requesting a specific standard, this
> should take precedence over the generic ones. If everything fails, go
> to the default PAL standards.

Yeah, I was trying to provide as seamless an experience for users of
existing applications that have been around forever, such as tvtime.
While I admit that tvtime could definitely stand to improve in
providing more flexibility to users, I was just trying to understand
how applications such as this have managed to work the way it has for
years without more people complaining.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
