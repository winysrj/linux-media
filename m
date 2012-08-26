Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40940 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab2HZW5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 18:57:23 -0400
Subject: Re: RFC: Core + Radio profile
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mike Isely <isely@pobox.com>
Date: Sun, 26 Aug 2012 18:56:58 -0400
In-Reply-To: <201208241431.04984.hverkuil@xs4all.nl>
References: <201208221140.25656.hverkuil@xs4all.nl>
	 <201208221211.47842.hverkuil@xs4all.nl> <5034E1C2.30205@redhat.com>
	 <201208241431.04984.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1346021822.2466.60.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-08-24 at 14:31 +0200, Hans Verkuil wrote:
> Hi Mauro,
> 
> Thanks for your review!
> 
> On Wed August 22 2012 15:42:26 Mauro Carvalho Chehab wrote:
> > Em 22-08-2012 07:11, Hans Verkuil escreveu:


> > >> Also note that the core profile description is more strict than the spec.
> > 
> > IMO, that's the right approach: The specs should define the several API
> > aspects; the profile should mandate what's optional and what's mandatory.
> > 
> > >> For example, G/S_PRIORITY are currently optional,
> > 
> > After putting the profiles there, we should remove "optional" tags elsewhere,
> > as the profiles section will tell what's mandatory and what is optional, as
> > different profiles require different mandatory arguments.
> > 
> > >> but I feel that all new drivers should implement this, especially since it
> > >> is very easy to add provided you use struct v4l2_fh. 
> > 
> > I agree on making G/S_PRIORITY mandatory.

 
> > >> Note that these profiles are primarily meant for driver developers. The V4L2
> > >> specification is leading for application developers.
> > 
> > This is where we diverge ;) We need profiles primary for application developers,
> > for them to know what is expected to be there on any media driver of a certain
> > kind.

+1

> > Ok, internal driver-developer profiles is also needed, in order for them to
> > use the right internal API's and internal core functions.
> 
> Well, it is all very nice to just say e.g. 'G/S_PRIORITY is mandatory' in the
> profile section, but the reality is that it is hit and miss whether or not it
> is implemented. Even if we manage to convert all drivers to implement G/S_PRIO,
> then it is still not something an app developer can rely on because many users
> use older kernel versions.


A profile should either
a. make no statement about G/S_PRIORITY,
b. should make them mandatory, or
c. should state explicitly they should not be implemented.

The V4L2 spec already implies they are optional:

"... V4L2 defines the VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY ioctls to
request and query the access priority associate with a file descriptor.
Opening a device assigns a medium priority, compatible with earlier
versions of V4L2 and drivers not supporting these ioctls."
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the profile make them mandatory, legacy driver non-compliance with
this should be reported.  Better still, a driver should not be claimed
to be profile compliant until the non-compliance is fixed.

We are not going to have the drivers compliant with profiles all at
once.

In the long view, applications evolve too.  As drivers move to comply
with profiles, and old kernel versions are dropped from main stream
distros, application writers can get rid of complex code to handle V4L2
quirks and exceptions.


> Which is why IMHO the spec should be leading for app development. The profile
> sections are a handy summary of what you can expect from drivers for specific
> types of hardware, but it can't be leading except when it comes to new driver
> development or driver changes in areas covered by the profile(s).

I disagree here.  I guess that is obvious by now. ;)



> > >>
> > >> Note: There are a few drivers that use a radio (pvrusb2) or video (ivtv)
> > >> node to stream the audio. These are legacy exceptions to the rule.
> > 
> > What an application developer should do with that???
> 
> Nothing. A generic application cannot support audio for these devices.
> You need specialized apps for that.
> 
> > If this should not be supported anymore, then we need instead to either
> > fix the drivers that aren't compliant with the specs or move them to
> > staging, in order to let them to be either fixed or dropped, if none
> > cares enough to fix.
> 
> Well, the problem is that people are actually using the existing, nonstandard,
> APIs for ivtv (and probably pvrusb2 as well).

Please note that the profile need not prohibit the legacy radio audio
API.  That way the legacy drivers can be compliant with the profile
without removing existing functionality.

It will be sufficient for the profile to require all drivers to
implement the ALSA interface.  No sane person is going to work to
inplement the legacy oddball audio interface in a driver after the ALSA
interface is done.


> For ivtv it is probably not too difficult to add ALSA support.
> 
> Andy, I know you implemented ALSA support for cx18, do you know how much work
> it would be to do the same for ivtv?

I implemented the cx18-alsa-* skeleton; DEvin actually got it hooked up
to ALSA and working.  There are still some aspects of it that are dead
code - i.e. the ALSA controls for volume - even though the skeleton has
them.


> If Andy has absolutely no time, then I can try to find time to add ALSA support
> to ivtv. But the existing API should probably remain (if possible).

The cx18-alsa-* code and glue is certainly copyable to ivtv.  I might
suggest one difference: don't make ivtv-alsa it's own module.  Just
build it in to the ivtv driver and reduce some module-glue complexity.
ALSA audio interface is going to be mandated by the profile anyway, so
there really isn't much point in a modular implemetation,

I might have time to do this.  But that is probably an optimistic
statement too.

> It's probably more work to fix this for pvrusb2, though.

Agree.

> > --
> > 
> > That's said, I think that the RFC proposal is going on the right direction.
> > It is very good to see it moving forward!

Ditto.

Regards,
Andy


