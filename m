Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:49461 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZBUBSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 20:18:11 -0500
Date: Fri, 20 Feb 2009 19:30:16 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Jean Delvare <khali@linux-fr.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
In-Reply-To: <20090220212327.410a298b@pedra.chehab.org>
Message-ID: <alpine.LNX.2.00.0902201853040.9018@banach.math.auburn.edu>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <20090218071041.63c09ba3@pedra.chehab.org> <20090218140105.17c86bcb@hyperion.delvare> <20090220212327.410a298b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:

> On Wed, 18 Feb 2009 14:01:05 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
>
>> Hi Mauro,
>>
>> On Wed, 18 Feb 2009 07:10:41 -0300, Mauro Carvalho Chehab wrote:
>>> On Wed, 18 Feb 2009 09:55:53 +0100 (CET)
>>> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
>>>
>>>> Not at all. I work with embedded systems and what happens is that you
>>>> effectively take a kernel snapshot for your device and stick to that.
>>>> You're not using v4l-dvb, but you might backport important fixes on
>>>> occasion.
>>>>
>>>> Again, it's not our job. The linux model is to get your drivers into the
>>>> kernel, then let distros take care of the rest, which includes backporting
>>>> if needed to older kernels. We are doing the work that distros should be
>>>> doing. A few years ago I moved ivtv to v4l-dvb and the kernel with the
>>>> express purpose to be finally free of keeping it backwards compatible with
>>>> older kernels. Now I find myself doing the same AGAIN.
>>>>
>>>> And you are talking about that mythical user that needs it. I've yet to
>>>> SEE that user here and telling me that it is essential to their product.
>>>>
>>>> PROVE to me that it is really necessary and really our job, and esp. my
>>>> job, since *I'm* the one keeping the backwards compatibility for i2c
>>>> modules alive. All I hear is 'there might be', 'I know some company', 'I
>>>> heard'.
>>>>
>>>> Right now there is crappy code in the kernel whose only purpose is to
>>>> facilitate support for old kernels. That's actually against the kernel
>>>> policy.
>>>>
>>>> One alternative is it create a separate repository just before the compat
>>>> code is removed, and merge important fixes for drivers in there. That
>>>> should tide us over until RHEL 6 is released.
>>>>
>>>> Which also raises the other question: what criterium is there anyway to
>>>> decide what is the oldest kernel to support? RHEL 5 will no doubt be used
>>>> for 1-2 years after RHEL 6 is release, do we still keep support for that?
>>>> Old kernels will be used for a long time in embedded systems, do we still
>>>> keep support for that too?
>>>
>>> Hans, I'm doing backport since 2005. So, you are not the only one that are
>>> doing backports. On V4L, this started ever since. In the case of DVB, we
>>> started backport on 2006. Before that, they use to support only the latest
>>> kernel version.
>>>
>>> If you get a snapshot of our tree of about 6 months to one year ago, we had
>>> even support for linux-2.4 I2C (and yes, this works - I have a tree here for
>>> vivi and bttv drivers based on that i2c support, working with 2.4).
>>
>> Not necessarily something to be proud about. This only shows how slowly
>> v4l has evolved in the past few years. Big changes that should have
>> happen have been constantly postponed in the name of compatibility.
>
> No change I'm aware of were postponed due to previous kernel compatibility.
>
>>> In the past, our criteria were simply to support all 2.6 versions and the
>>> latest 2.4 versions. Sometime after having the last 2.4 distro moving their
>>> stable repo to 2.6, we decided to drop 2.4, because we got no complains to keep
>>> 2.4 on that time.
>>>
>>> Maybe the current solution for i2c backport is not the better one, and we
>>> need to use another approach. If the current i2c backport is interfering on the
>>> development, then maybe we need to re-think about the backport implementation.
>>> The backport shouldn't affect the upstream. It were never affected until the
>>> recent i2c backport. Even the 2.4 i2c backport didn't interfere upstream, even
>>> having a completely different implementation on 2.4.
>>
>> Actually, 2.6 kernels up to 2.6.13 had an i2c API very similar to what
>> 2.4 had. The binding model changes we are undergoing now are way more
>> intrusive than the migration from 2.4 to early 2.6.
>
> This is true for the drivers that are using the newer model. However, there are
> still several drivers that use the old model (bttv, em28xx, cx88 - maybe
> others).
>
> I think that maybe we'll need some legacy-like support for bttv and cx88, since
> there are some boards that relies on the old i2c method to work. On those
> boards (like cx88 Pixelview), the same board model (and PCB revision) may or
> may not have a separate audio decoder. On those devices that have an audio
> decoder, the widely used solution is to load tvaudio module and let it bind at
> the i2c bus, on such cases.
>
>>>> The only reasonable criterium I see is technical: when you start to
>>>> introduce cruft into the kernel just to support older kernels, then it is
>>>> time to cut off support to those kernels.
>>>
>>> The criteria for backport is not technical.
>>
>> That technical isn't the only criteria, I agree with. But claiming that
>> technical isn't a criteria at all is plain wrong. This is equivalent to
>> claiming that development time doesn't cost anything.
>
> Well, what's the technical criteria? I don't see much #if's inside the i2c part
> of the drivers.
>
>>>                                       (...) It is all about offering a version
>>> that testers with standard distros can use it, without needing to use the
>>> latest -rc kernel.
>>>
>>> I'm fine to drop support to unused kernels, but the hole idea to have backport
>>> is to allow an easy usage of the newer drivers by users with their environment.
>>> If we start removing such code, due to any other criteria different than having
>>> support for kernels that people are still using on their desktop and enterprise
>>> environments,
>>
>> You're aiming at the wrong target, I am afraid. "Enterprise
>> environments" have _nothing_ to do with upstream development, by
>> definition. More on that below.
>>
>>>         (...) then it is time to forget about -hg and use -git instead,
>>> supporting only the latest tip kernel, just like almost all other maintainers
>>> do.
>>>
>>> While we are stick on have backport, we need at least to support the latest
>>> desktop and enterprise kernel versions of the major distros.
>>>
>>> So, it is a matter of deciding what we want:
>>> 	keep our current criteria of offering backport kernels that include
>>> 	at least the kernel version used on the major desktop and enterprise
>>> 	kernel distros
>>
>> No, not enterprise kernels!
>>
>>> OR
>>> 	just use -git and drop all backport code.
>>>
>>> Both solutions work for me, although I prefer to keep backport, even having more trouble[1].
>>>
>>> Anything else and we will enter of a grey area that will likely go nowhere.
>>
>> I am sorry but I don't follow you here. You are basically claiming that
>> allowing enterprise users (who typically run RHEL or SLED) to build
>> bleeding-edge drivers off the v4l-dvb repository is very important, but
>> allowing non-enterprise users and kernel developers (who typically run
>> Fedora or openSUSE) isn't that important? I believe this is exactly the
>> other way around.
>
> No. I'm saying that we should not exclude an user just because it uses a RHEL
> kernel (btw, there are some versions at RHEL aimed for desktop and notebooks
> also using 2.6.18).
>
>> I am working on L3 support for SLE products, so I know very well what
>> enterprise customers want, and what they don't. I doubt that RHEL
>> customers are any different from SLE ones. Enterprise customers don't
>> give a damn to the v4l-dvb repository. All they know about and want are
>> packages provided by the vendor, which change as little as possible
>> (that is, bug fixes only.) Running bleeding-edge, untrusted and
>> unmaintained drivers is the last thing they want. If they need a driver
>> for a recent piece of hardware, they open a feature request for the
>> next service pack, and leave it to the OS vendor to backport the
>> driver and maintain it for the next 5 years or so.
>
> True. But it is also true that there are some free versions based on those
> enterprise kernels that also use the same base system.
>
> I'm not trying to defend any particular distro here. The point is: there are a
> large amount of different V4L/DVB devices. I doubt that the developers will
> ever have all boards in the market. That's basically the reason why we support
> backport. We should really try to have the largest base of testers that it is
> possible. If we are excluding people from the community because of the
> diversity of their environments, we will likely loose some important feedbacks.
>
>> As a side note, I doubt that the v4l-dvb repository would always work
>> that well for enterprise distribution kernels anyway. All the tests are
>> based on the kernel version, but the enterprise kernels diverge a lot
>> over time from the upstream version they were originally based on, so I
>> wouldn't be surprised if things broke from times to times.
>
> True, but, when something breaks, people complain and the support is added. The
> better way of adding a backport is by adding a small search string at
> v4l/scripts/make_config_compat.pl and adding the backport code at compat. This
> solves the issues with the distro kernels much better than just checking for a
> specific kernel version.
>
>> The actual audience for the v4l-dvb repository is users who do NOT have
>> a support contract with the OS vendor. That is, home users. These do
>> not run RHEL and SLE, especially if they have recent hardware, given
>> how bad hardware support is in enterprise distributions. Home users
>> will want their hard disk controller, graphics adapter and sound chip
>> to work before they even consider getting support for their TV adapter
>> from the v4l-dvb repository. Which means that they will be running a
>> recent version of Fedora, openSUSE or equivalent.
>>
>> Now, if you look at the support policy of Fedora and openSUSE, you'll
>> see that they are maintained for 13 [1] to 24 [2] months. In practice,
>> the oldest supported Fedora is Fedora 9, featuring kernel 2.6.25, and
>> the oldest supported openSUSE is openSUSE 10.3, featuring kernel
>> 2.6.22. Which is why I claim that there is no point in supporting
>> anything older than that. When openSUSE 10.3 goes out of maintenance
>> (end of 2009), we can even drop support for kernels < 2.6.25.
>>
>> [1] http://fedoraproject.org/wiki/LifeCycle
>> [2] http://en.opensuse.org/SUSE_Linux_Lifetime
>>
>> There is a reason why the Linux market has been segmented into
>> enterprise distributions and community distributions. Ignoring that
>> reason and trying to support all distributions with the same upstream
>> repository simply doesn't work.
>>
>> So, I don't buy your claim that we should either support old enterprise
>> kernels or not support any old kernel at all. Just like I don't buy
>> your claim that the technical aspect shouldn't be taken into account
>> when deciding what kernels you want to support. I think we have to be
>> pragmatic here. We want to support kernels which users really care
>> about (and these are the ones in maintained popular non-enterprise
>> distributions) and which don't cost too much to support from a
>> technical point of view.
>
> Now, the issue is of a different nature. Since I do most of the backports on
> v4l-dvb, I can say that the big effort happens when an API changes upstream.
> Let's take, for example, the last dvbnet changes: They moved some data from a
> priv struct into a net core struct. This happened sometime during 2.6.29-rc
> cycle.
>
> The trivial solution, done by most maintainers, is to just use 2.6.29-rc
> kernel as the basis for development. No backport efforts are needed. They can
> focus their work looking ahead.
>
> In our case, if we want the same code to work with 2.6.28 and 2.6.29-rc, we
> need to find a creative way to backport the patch without adding much #ifs
> (using for example compat.h), or to add those #ifs at the code.
>
> Either way, after the backport patch, there's no need to maintain the
> backport, especially if we use the v4l/scripts/make_config_compat.pl script.
>
> The backported code inside the #ifs don't need to be changed.
>
> Ok, having lots of #if's inside the code looks ugly, but those if's and the
> compat code are removed upstream, so, developers can see the upstream code
> without any backport [1].
>
> So, the issue here is not preserving the backport patches forever, but,
> instead, the need for someone to do the backports. This is time consuming and
> requires a developer that could be doing drivers improvements instead of
> loosing time with backports.
>
> In fact, Hans is not the only one developer asking for dropping -hg and use
> -git instead. Several others already asked this publicly or in priv. Using a
> different model from the rest of the subsystems is not scaling well anymore. We
> have almost 300 different drivers, and the current number of commits per day is
> very high.
>
> I think we should really consider some alternatives to use -git (with the
> standard kernel tree there), instead of our current model.
>
> Maybe we should have some sort of scripts to auto-generate tarballs with
> backport patches inside (alsa has a model like this). They are now using -git
> for development, and stopped using -hg. The issue here is that we should take
> some time to think on how this will work, and design a set of scripts to
> generate the backport tree.
>
> [1] In the very specific case of i2c, Hans adopted a different solution, due to
> the need to emulate the old i2c behaviour for drivers that weren't ported to
> the new i2c. In order to cleanup the code, we need first to port all drivers to
> the new i2c model. Then, we can implement the i2c backport on the same way as
> all the other drivers.
>
>> Now, if you think that giving up the hg tree and only supporting Linus'
>> latest kernel is the way to go, I'm not going to prevent you from going
>> down that road. As a kernel developer, that would make me very happy.
>> But I remember that the hg tree is there to help users test the newest
>> developments without running a bleeding-edge kernel, and that certainly
>> makes some sense.
>
> I agree that we shouldn't just use -git and forget about all the users of
> v4l-dvb hg tree. That's why I've asked Hans to open a separate thread: in order
> to remove -hg, in favor of -git, we need to have some solutions to keep
> allowing the users to compile and test with their environments, without asking
> they to upgrade to the latest kernel version. So, we'll need good ideas and
> volunteers to implement.
>
> Cheers,
> Mauro

Hoping that I can offer some helpful comments on this thread, as someone 
who came along only in the last couple of months or so:

1. One of the most interesting features which I found in the video for 
Linux project is the ability to work somewhat independently of the 
particular kernel version running on the local machine. This is valuable, 
in the sense that it saves a lot of wasted time and effort just keeping up 
with which kernel version to use. It was also something which is done so 
cleverly that at first I could not believe it. Congratulations to those 
who thought this arrangement up.

2. Sometimes, there is a real problem with a particular version of the 
kernel which has nothing to do with the task at hand, but it sure can get 
in the way. As a recent example, soon after starting to work with Adam 
Baker on the sq905 module (and furthermore having at the time the false 
impression that the gspca work meant I should be running the latest thing 
out there) I upgraded from 2.6.27.7 to 2.6.28. Well, there was a rather 
serious USB bug in 2.6.28. So then _that_ had to be straightened out. 
Things like that do not promote smooth progress but rather interfere with 
it.

3. I just bought an eeePC. It is running some 2.6.21.x kernel. My 
reaction: I do not believe they should be doing that. I would not feel 
like accommodating them. Comparison: someone wrote to me complaining about 
problems with libgphoto2-2.1.3, which his distro was still releasing, when 
libgphoto2-2.3.x was already out and his problem had been solved 24 months 
before. I told him to upgrade and his problems would go away. He wanted me 
to fix his old version. I explained that this has been done, and he should 
avail himself of that by installing a new version. Somewhere there is a 
line, and that guy crossed it.

Trying to put all this together:

I think that the semi-independence from the particular kernel-du-jour is a 
good thing and would seem to me to make progress in the specific area of 
video to be smoother. Modular or semi-modular development is something 
nice. One can concentrate on the subject at hand and not on daily kernel 
upgrading. Nice.

I also would not want to bust my butt to support someone's ancient kernel. 
After all, quite often the reason there is a new kernel version is that 
some long-undiscovered bug suddenly got discovered. Not all change is 
just for fun, or just to support new stuff. Some of those bugs had 
far-reaching consequences, recall. So to support one of the affected 
kernels involves what, exactly?

Hoping that these comments help toward some good conclusion of this issue.

Theodore Kilgore
