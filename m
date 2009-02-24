Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbZBXU0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 15:26:09 -0500
Date: Tue, 24 Feb 2009 17:23:51 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kilgota@banach.math.auburn.edu
cc: Adam Baker <linux@baker-net.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu>
Message-ID: <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org>
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009, kilgota@banach.math.auburn.edu wrote:

>
>
> On Mon, 23 Feb 2009, Adam Baker wrote:
>
>>  On Monday 23 February 2009, Mauro Carvalho Chehab wrote:
>> >  On Sat, 21 Feb 2009 12:53:57 +0100
>> > 
>> >  Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > >  Hi Adam,
>> > > 
>> > >  Sorry for the late reply, it's been very busy.
>> > 
>> >  Me too.
>
> <big snip>
>
>> > > >  The interest in detecting if a driver provides this informnation is 
>> > > >  to
>> > > >  allow libv4l to know when it should use the driver provided 
>> > > >  information
>> > > >  and when it should use its internal table (which needs to be 
>> > > >  retained
>> > > >  for backward compatibility). With no detection capability the 
>> > > >  driver
>> > > >  provided info should be ignored for USB IDs in the built in table.
>> > > > 
>
> <snip>
>
>> 
>> > 
>> >  Ok, this is nothing that kernel needs to handle, but, at userspace, we 
>> >  need
>> >  to have a file where the user could edit and store the camera position, 
>> >  to
>> >  override whatever we have in kernel.
>>
>>  Unfortunately what that doesn't address is the problem that first started
>>  this
>>  discussion. A camera where the orientation information is contained in
>>  the
>>  USB messages from the camera so the driver is the only thing that can
>>  reasonably access it.
>
> Alas, this is so true. What started the entire discussion about passing the 
> info about sensor orientation is a set of cameras all of which have the same 
> Vendor:Product ID but require different handling of the data (vflip and 
> hflip, or just vflip) depending upon information which can only be obtained 
> by communication with the camera, *not* by just knowing its Vendor:Product 
> ID.
>
> Therefore, it is a little bit disheartening to see discussions -- again -- 
> which come back to some kind of "internal table" in V4L, or which come back 
> to things like "have a file where the user could edit and store the camera 
> position, to override whatever we have in kernel."
>
> Repeating the obvious, which apparently still needs to be repeated because 
> not all of the participants in the discussion "get it":
>
> 1. The "internal table" in V4L could not handle this problem, because the 
> internal table would be based upon what information? The USB Vendor:Product 
> number? For that matter, no other table could work, either. Well, actually, 
> a table could work. It would have to be inside the module supporting the 
> camera, and the matter of which table entry corresponds to what camera would 
> have to be settled by passing a USB command to the camera and then parsing 
> the camera's response. So now the question is how to get the information out 
> of the module, which can only be collected and analysed inside the module.
>
> 2. The "have a file where the user could edit" idea may seem attractive to 
> some, because it shoves the whole problem of agreeing on the appropriate way 
> to get needed information out of a kernel module and into userspace onto 
> someone not present during the current discussion, the user. However, this 
> is not a solution, and thinking about it just a little bit ought to make 
> that totally obvious. This is a strongly worded statement, so I will proceed 
> to explain why the matter is so obvious.
>
> Let us assume the very best, and assume that every app which is V4L 
> conformant has a "one time" initialization step and creates a directory 
> $HOME/.app containing stored settings. So we might have a file called 
> $HOME/.app/sq905. This file gets automatically written when the hapless user 
> hooks up his sq905 camera the first time, and has to go through a choice 
> routine to decide which side of the frame is up and which side is to the 
> left and to the right. One could even take serious steps to make this 
> otherwise unnecessary and silly sequence to be as really nice and "user 
> friendly" as it could possibly be, and set this all up to be done with a 
> sequence of mouse clicks and then the file, very kindly, gets written 
> automatically. Those of you who are thinking that this "file a user could 
> edit" is the way to go are, presumably, thinking along these lines. Well 
> there are at least four things which are obviously wrong with this 
> "solution":
>
> 2.1. The user is forced to deal with something which the user should not 
> even have to confront. The user is called upon to remedy an omission and a 
> deficiency which was ignored at a lower level, because a bunch of developers 
> could not come together on a reasonable course of action. Well, some don't 
> like to see this one, so there are three more reasons.
>
> 2.2 Every camera is going to require a file for itself in $HOME/.app even if 
> there is nothing that the user needs to do. Many of the supported cameras 
> need nothing of the kind, so this would be kind of silly.
>
> 2.3 The user has two apps for dealing with webcams. So now the user needs to 
> have another directory called $HOME/.app2 with similar files in it?
>
> 2.4 (and this one is the worst of all) The user has two cameras which are 
> both powered by the same kernel module, and the two cameras need two 
> different things done. Now what??? Both cameras can not simultaneously have 
> a valid entry in $HOME/.app/sq905 which tells what to do with the data out 
> of the camera. Because what is right for one of them is wrong for the other. 
> Further to add to this, one of the tests which was run on this very module 
> was to see if it will run two of the same kind of camera simultaneously. It 
> passed the test. Now someone wants the data to be right-side up from both 
> cameras, and correctly oriented left-to right. Is that an unreasonable 
> desire on the part of a user? Of course not. Again, now what????
>
> There is no way out of this series of dilemmas and absurdities with the 
> "file a user could edit" approach. None.
>
> So, please, could we get serious and actually come up with a reasonable 
> solution? To put the matter completely in perspective, the support for the 
> affected set of devices is otherwise quite complete, and the only thing 
> remaining is to come up with a reasonable solution, which would provide a 
> pleasing experience to users.

Theodore,

You're considering just one subset of the V4L usages: notebook webcams. If 
you think about non-notebook webcams [1] or about security cams, you'll 
see that the only way for you to have the flipping information is inside 
some userspace file.

For example, I have here one video input bttv board with 16 cameras,
connected on 4 bttv chips. I have also a Pelco camera, that has just one 
support socket. Depending on the place you mount it, the camera has to be 
rotated by 180 degrees. It can also be useful to mount it rotated by 90 
degrees.

After mounting the cameras, no matter what apps you are using (a streaming 
video app to broadcast it via internet, a security app, etc), the rotation
information for that input, on that particular PCI, bus won't change.

As we've standardized the VIDIOC_QUERYCAP bus_info, now, the information 
for the camera at input 3 of bttv hardware at PCI addres 03:00.3 is 
unique. It is also unique the same information for a notebook mounted 
webcam (since the USB bus ID won't change for that devices).

So, if we standardize where this information is stored, for example, at 
/etc/libv4l and/or at ~/.libv4lrc, and let libv4l handle such info, this 
will be something consistent for all applications using libv4l. Other apps 
that might not want to trust on libv4l can also read the info at the same 
file.

So, I really think that this should be part of the approach.

I agree that we should have a way to get a hint about a camera rotation,
if this is somehow provided by reading at the hardware.

[1] Normal webcams can be mounted on some hardware and have some 
orientations that would be different than expected. I've seen this before 
on some PC-based harware where the camera is enclosed inside the clause, 
like on Automatic Transfer Machines. Also, the user may want to use the 
camera on an inverted position, to make easy to fix it somewhere.

  -- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
