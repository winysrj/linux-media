Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44043 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZHBS4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 14:56:47 -0400
Date: Sun, 2 Aug 2009 14:12:28 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
In-Reply-To: <20090802103350.19657a07@tele>
Message-ID: <alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr> <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu> <20090802103350.19657a07@tele>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 2 Aug 2009, Jean-Francois Moine wrote:

> On Sat, 1 Aug 2009 16:56:06 -0500 (CDT)
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
>
>> Several cameras are supported here, which all share the same USB
>> Vendor:Product number when started up in streaming mode. All of these
>> cameras use bulk transport for streaming, and all of them produce
>> frames in JPEG format.
>
> Hi Theodore,
>
> Your patch seems ok, but:
>
> - there is no kfree(sd->jpeg_hdr). Should be in stop0().

OK. Will do, and resend, as asked. But before I do that, there is the 
second item. It seems to raise questions of policy. I think it is 
appropriate to raise that question for general discussion.

>
> - as there is only one vend:prod, one line is enough in gspca.txt.

This is a question about which I have been curious for quite some time, 
and I think that now is a good time to ask it.

Just what policy do we have about this? The information which links brand 
and model to driver ought to be presented somewhere. If it does not go 
into gspca.txt then where exactly is the appropriate place to put said 
information?

As to these three particular cameras, perhaps one should take into account 
here the fact that what we actually have here is three "different" 
cameras, put on the market by three different vendors, and in at least two 
different parts of the world. The Sakar camera and the Cobra camera are 
for sale in the US. The FlyOne camera is for sale in Germany and perhaps 
in some other parts of Europe. Furthermore, in stillcam mode they are all 
three of them standard mass storage devices, but they have different IDs 
from what is listed here (good for them about that!) and the stillcam IDs 
are distinct, too. So in other words they are not the same camera, at all, 
in spite of the fact that they all use the same ID when set up in webcam 
mode.

A more general consideration is that the buyer of a camera is not helped 
at all by knowing that a particular chipset combination is supported. No. 
The buyer can only go by the make and model which are printed on the 
outside of the plastic bubble pack. So what exactly are we, the 
developers, to do in order to make the relevant information available to 
the public? There is some wiki, of course. But it seems to me the wiki 
itself ought to refer to the gspca.txt file, among other things.

I do think that one of the easy ways to address the above issue of helping 
the camera purchaser would be to agree that gspca.txt ought to contain the 
information for each individual camera which is supported. This would make 
the file longer, but it is in my opinion a small price to pay, when the 
goal is to have complete information, put in a central place.

In going over the gspca.txt file, I also see that the jeilinj entries are 
the only place where there is a "duplicate" entry, so that I am at this 
time in non-conformity. But, on checking, I also see that the SQ905 
cameras (2770:9120) and the SQ905C cameras (2770:905c) are not listed at 
all in gspca.txt. This could be claimed as an example of my ignorance that 
I am supposed to put something there. But it is also related to the fact 
that

-- there are twenty-five (25) cameras listed in 
libgphoto2/camlibs/sq905/library.c, which were reported to me as working 
with that particular stillcam driver. This list does not include several 
other cameras that I only heard about vaguely, or that I do not even know 
about at all because nobody ever reported them to me. So if I am supposed 
to pick just one of these, then which one do I list in gspca.txt, when as 
far as I know they all ought to work with the gspca sq905 driver?

and, as for the SQ905C cameras

-- there are seventeen (17) cameras listed in 
libgphoto2/camlibs/digigr8/library.c, which were reported to me as working 
with that particular stillcam driver. This list does not include several 
other cameras that I only heard about vaguely, or that I do not even know 
about at all because nobody ever reported them to me. If I am supposed to 
pick just one of these, then which one do I list in gspca.txt, when as far 
as I know they all ought to work with the gspca sq905c driver?

For the above reasons, I have up to this point not listed any of these 
cameras in gspca.txt at all, as supported. Probably that is not the right 
thing to do, either?

Now, in addition to the above, there is another problem which will hit 
very soon, probably soon after the time that Thomas Kaiser gets back from 
his vacation and starts to work again. This is the matter of the mr97310a 
driver, which is almost finished now. What we have there is a list of 
cameras which are all functionally identical as still cameras, but as 
webcams the functionality differs in minor details. Here is what happens:

08ca:0111	Aiptek Pencam VGA+	(supported, listed in gspca.txt)

093a:010f 	several cameras, some functionally identical to the Aiptek 
camera, and some which as webcams require a different init procedure and 
use different control procedures! There are two different basic cameras 
with the same USB number, and it has been necessary to create undocumented 
commands to be able to tell which kind of camera we have! This has been 
done, at this point. But as to documentation the question arises, that if 
we choose just one of these to list in gspca.txt, should we pick one of 
"Type 1" or one of "Type 2" to list?

093a:010e	several cameras with this ID number, which also fall into 
two disjoint sets when run in webcam mode, again requiring the development 
of previously undocumented commands to be able to detect and classify 
which camera it is, before initializing it. Again, which one of these 
cameras is one supposed to list in gspca.txt?

Also the above account of the unexpected complications of the mr97310a 
driver raises the natural problem that the same thing might happen yet 
again. The differences in behavior of the different cameras seem to be 
connected to such external characteristics as the type of LCD display used 
on the outside of the camera, or other minor details in the construction. 
Who is to say that there can not be a "Type 3" in either of the two cases 
where two types have already been discovered? What is the safe thing to 
do? Well, it seems to me, the only thing appropriate is to list explicitly 
all the mr97310a cameras currently supported, and in the future to list 
explicitly any other one which is reported as working.

As I said, this question of what to do with the mr97310a documentation 
will come up very soon, unless one merely avoids the question by refusing 
to make a choice. So the question of documentation becomes rather serious.

I hope that the occasion is now appropriate one deciding this issue of 
documentation. My opinion is that gspca.txt ought to list individually 
each camera which is known to work, as well as the driver used and the USB 
ID.

Theodore Kilgore
