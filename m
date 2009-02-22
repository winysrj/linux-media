Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40796 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZBVBDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 20:03:34 -0500
Date: Sat, 21 Feb 2009 19:15:51 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
In-Reply-To: <200902212347.47109.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902211811500.10147@banach.math.auburn.edu>
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 21 Feb 2009, Adam Baker wrote:

> On Saturday 21 February 2009, Hans Verkuil wrote:
>
>> The high rate of changes and new drivers means that keeping up the
>> backwards compatibility becomes an increasingly heavy burden.
>>
>> This leads to two questions:
>>
>> 1) Can we change our development model in such a way that this burden is
>> reduced?
>
> Possibly but even just spreading the burden better (and avoiding the compat
> code affecting the main tree in the case of i2c) would be a worthwhile
> change.
>
>> 2) How far back do we want to support older kernels anyway?

<long snip>

>> B: Switch to a git tree and drop compatibility completely
>>
>> Pros:
>>
>> - makes driver development and v4l-dvb maintenance very easy.
>> - no compatibility issues anymore, this saves a lot of time.
>> - ability to change kernel code outside the driver/media part.
>> - received patches against the latest git tree are easy to apply.
>>
>
> Ensures that driver changes get tested in the kernel they will be released in
> so there is less chance of a change elsewhere breaking your change. Also
> means more people are testing pre release kernels so might have stopped the
> USB bug in 2.6.28 making it to the released kernel.

This is a valid counter-point to something I said earlier. OTOH, there is 
still the question about whether "modular" development has benefits which 
outweigh the monolithic approach. I had never thought about the issue 
myself until confronted with the way that it is done here. But there are 
benefits to the "modular" approach, too. I did not know them before trying 
it out.

>
>> Cons:
>>
>> - no compatibility means that the initial testbase will be reduced
>> substantially since it will be too difficult for many users to install the
>> bleeding-edge kernel. So real feedback won't come in until the code is
>> released as part of the main distros kernels.
>> - the same is true for ourselves: we need to continuously upgrade our
>> kernel, which is not always an option.
>>

Yes.

>
> It also means that a git pull can result in a long long rebuild if the
> upstream has just pulled a load of changes to other subsystems.

Again yes. One is trying to get work done, and someone else did big 
changes. Well, so you can't just compile blindly. You really do have to 
look at those changes. OK, so do "make menuconfig" and read some of the 
docs about the new stuff you never heard of before, some of which might 
make your machine work ever so much better -- or break it if you change 
this and don't change that, and you see where this is going. I said 
earlier that anyone who is a developer is pleased to keep current with the 
kernel, but at least that should mean that not more than once every couple 
of weeks should one be forced to spend time on that???

>
>>
>> 2 How many kernels to support?
>> ------------------------------
>
>> Keeping support for older kernels should come with an expiry date as at
>> some point in time the effort involved outweighs the benefits.
>
> I think the outweighs the benefits point is critical here and indicates what
> the break point should be.
>
>>
>> Oldest supported Ubuntu kernel is 2.6.22 (7.10):

This is a bit optimistic.

Matter of fact, I just bought a brand new eeePC in January, on which Asus 
chose to install Xandros. The response to uname -r is (I put this on a 
separate line in order to highlight it)

2.6.21.4-eeepc

Now, some might not think of Xandros as a leading distro. It certainly 
would not have been my first choice. The choice of such an old kernel 
confirms that impression. But the netbook hardware platform, I would say, 
is a rather important one. The point is, if one is going to start looking 
for kernels that are obviously too old to mess with but are in common use 
then one has to go back even beyond 2.6.22. If it were my choice, I 
wouldn't.

>> In my view these criteria strike a good balance between supporting our
>> users so we can good test coverage, and limiting the effort involved in
>> supporting the compatibility code. And they are also based on simple facts:
>> whenever the oldest regularly supported kernel changes, we can go in and
>> remove some of the compat code. No need for discussions, the rules are
>> clear and consistent.
>
> I don't think anyone will (or need) actively track theses dates unless the
> code is causing them a headache but the rule is still a useful guide - if the
> compat code is causing you a problem and the 3 most popular distros have
> EOLed the relevant kernel it can be dropped without discussion by whoever
> administers the compat repository, otherwise it should be discussed on the ML
> first.
>
> The only question then would be how to choose the 3. I don't think 1 and 2 are
> in much dispute but I suspect OpenSUSE is slugging it out for 3rd place with
> Debian.
>
>>
>> And luckily, since the oldest kernel currently in regular use is 2.6.22
>> that makes a very good argument for dropping the i2c compatibility mess.

Well, it is not the oldest kernel in "regular use" as I have just 
demonstrated. I like this pragmatic approach, but that is the trouble with 
it. OTOH, I can also point out that the eeePC runs beautifully on Slax 
from an SD card slid into the slot, and Slax uses 2.6.27.8 and furthermore 
quite recent copies of this project's software compile and install nicely 
on that "guest" operating system and run not only gspca cameras but also 
the built-in webcam. So, from this two points. They are already made, but 
the example ought to make both of them over again.

1. I was smart enough to install a distro on an SD card. I don't claim big 
credit for that. All of you who read this obviously are, too. So are lots 
of other people who do not frequent kernel-related lists. It was not even 
what I would call difficult to do that. The pont is, you did not and do 
not need to cater to those who would feel forced to use the 2.6.21.4 that 
came on the machine. Not at all. Those people are not in the first 
place the users who are going to test your new software by trying to 
compile it.

2. If in addition to everything else I would have been forced to compile a 
kernel right away on that machine, on the grounds that the 2.6.27.8 which 
came with Slax was not recent enough, and I need a current git tree 
instead, then the testing which I just reported as completely successful 
would probably not have happened. Not that I could not do that, too, but 
it starts to become a matter of time spent.

> Unfortunately this all omits one important point, are there any key developers
> for whom dropping support for old kernels will cause them a problem which
> could reduce their productivity.  Mauro has stated that it would cause him a
> problem but I can't tell how big a problem it would really be.

I will not claim to be a key developer. But I just gave an example in 
which dropping a 2.6.27.x kernel (which some would want now to call "old") 
would have reduced my productivity. I just tested this stuff in an 
environment and on a hardware platform where some of you might be pleased 
to know it all works.

Again, my solution is keep the development process modular. Unless there 
is some really sudden and huge change, nothing will suddenly break. One or 
two versions back will continue to work 95% of the time, at least. If 
there is a big change which will break everything which was done before 
day before yesterday, then publicize it and explain. I would hope that a 
solution like this could obviate the need for most of the #ifdef s for 
compatibility and save a lot of trouble.

Theodore Kilgore
