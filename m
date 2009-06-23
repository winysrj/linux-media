Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33796 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZFWP7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 11:59:45 -0400
Date: Tue, 23 Jun 2009 11:14:34 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245753431.3172.30.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906231100290.24687@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>  <1245525813.3178.24.camel@palomino.walls.org>  <1245538316.3296.36.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu>  <1245557957.3296.215.camel@palomino.walls.org>  <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>  <1245634667.3815.54.camel@palomino.walls.org>  <alpine.LNX.2.00.0906212230200.31693@banach.math.auburn.edu>
  <1245670060.3178.14.camel@palomino.walls.org>  <alpine.LNX.2.00.0906221025080.1721@banach.math.auburn.edu> <1245753431.3172.30.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 23 Jun 2009, Andy Walls wrote:

> On Mon, 2009-06-22 at 10:51 -0500, Theodore Kilgore wrote:
>>
>> On Mon, 22 Jun 2009, Andy Walls wrote:
>>
>>> On Sun, 2009-06-21 at 22:39 -0500, Theodore Kilgore wrote:
>>>> Andy,
>>>>
>>>> You are right. Your camera is emitting JPEG while streaming. I just
>>>> succeeded in creating an image which resembles your test picture by
>>>> extracting the frame data for one frame, tacking on a header, and running
>>>> hex2bin on the combined file. I did not get the thing quite right, because
>>>> your header is from your JPEG photo (640x480) and your stream is probably
>>>> 320x240. But I got something out which is obviously recognizable.
>>>
>>> Excellent.  Going from "It may never work" to "something recognizable"
>>> in one weekend is good progress.
>>
>> Well, sometimes the easy and obvious just works, and one is lucky. If only
>> they were all that easy.
>
> I'd contend most would be easy and obvious, as anything created by
> people is usually easy to understand.  People are generally lazy and
> want to avoid what they perceive as extra effort.  If you couple that
> with management pressure on engineers to keep costs down and maintain
> project schedules, you often end up with very simple solutions.

There is some truth to this, yes.

>
> The data encoding used by the camera is indicative of that.  For this
> camera, the engineers decided to simply drop the (M)JPEG headers to save
> USB communications bandwidth instead of using a different, better
> compression algorithm; or a imlementing new USB 2.0 interface.
>
>
>> Besides, as we well know, this list is a place
>> where geniuses hang out. So perhaps some of the pixie dust has rubbed off
>> on us.
>
> I thought genius was inspiration and perspiration. Pixie dust - I knew
> Edison wasn't telling the whole truth. ;)
>
>
>
>>>
>>>> Therefore with a little bit of further tweaking it will presumably come
>>>> out exactly so. Namely, I have to remember where to stick the two
>>>> dimensions into the header.

Found that, as I said yesterday evening.

>>>
>>> Yes, as far as I'm concerned the problem is solved.  The details are
>>> left as an exercise for the reader. ;)
>>>
>>
>> I will try to get on it. There is nothing left but details, but there are
>> lots of those.
>
> Yes, I agree.  Getting those right is no small task.
>
>
>> The first one is to get the header exactly right.
>
> Well,  given that the Windows driver has the AVI video stream FourCC
> 'vids' appearing four or five times, I suspect there is more than 1
> header template that the Windows driver can tack on to the incoming
> stream.  I'm guessing that which one is used, depends on how the camera
> stream is initialized.

Sort of, yes. At least that is the way it looks over here. The sequence of 
button-push steps for initializing my camera to do streaming is just 
about the same as that for inducing it to shoot an AVI, and then the 
question is whether you turned on capturing from the computer or not. If 
you did, then you get a stream. If you didn't then it seems the camera 
makes an AVI.

>
> There are probably all sorts of header permutations that will yield
> viewable but suboptimal reconstruction. :(
>
> Then again it's a cheap webcam, so by definition any image is probably
> suboptimal.

Well, interestingly, your header and mine, when affixed to my one frame, 
are doing about equally well. But the two headers seem to differ from each 
other.

<snip>

>>> I'm not up to speed on Linux webcam kernel to userspace API details.
>>> However, might I suggest going forward for testing at least, that when
>>> one starts the webcam streaming, the driver emit the stream in the form
>>> of an AVI.  You'd need an AVI header declaring only an MJPEG 'vids'
>>> stream - no 'auds' nor 'idx' - and a 'movi' section with RIFF/AVI chunks
>>> that have MJPEG headers and the webcam payload.
>>
>> For all I know, it might be just a matter of following down a standard
>> path. Perhaps this is all handled already in libv4lconvert, and it is
>> merely a matter of plugging into that. I haven't checked yet, but that is
>> more or less what I expect right now.
>
>
> Ah, OK.

Revision:

It seems that some other drivers are providing the jpeg header. There is a 
file gspca/jpeg.h from which to get it. So perhaps libv4lconvert is not 
much involved after all. As I said, I have not yet looked seriously into 
this. I spent yesterday evening trying to write a module, with which I 
tried to grab a raw frame (no header, no nothing) and it did not succeed. 
Clearly, my efforts need to be refined.

>
>>>
>>> I haven't seen evidence that audio comes from the webcam when it is
>>> streaming, but I haven't looked very much either.
>>
>> Same. Actually, my impression is that these cameras can not walk and chew
>> gum at the same time. I would suspect that the audio is an either/or kind
>> of thing. Either on, and it can record audio but not stream it, or off. I
>> would be very surprised if an el cheapo like the one I have could do more.
>> I could be wrong, of course. Perhaps both of us ought to check closely.
>
> I know it can simultaneously record audio and video to an AVI file in
> it's local storage.  I'm thinking it would not make sense to shovel over
> audio in webcam mode anyway, as most computers have their own microphone
> to collect sound.

Hmmm. If your cam is working like mine (do the same things, basically, to 
shoot an AVI and to stream, I mean), then it probably could do the same 
thing while streaming. Could you look into that?

<snip>

>
> I have no timeline in mind.  Having this webcam work will simply be a
> "nice to have".  I'm available for testing and any
> investigation/research that you don't have time to do.

I don't know how long I can continue to spend so much time on this. There 
is the end of the summer session this Friday, with a final exam and grades 
to compute. Then as I said we are going on vacation on July 7. After we 
are back again, well, then there is time again for this kind of thing.

Theodore Kilgore
