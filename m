Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0ATPlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 10:41:25 -0500
Message-ID: <4B57241E.2060107@infradead.org>
Date: Wed, 20 Jan 2010 13:41:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>,
	Brandon Philips <brandon@ifup.org>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org>    <201001190853.11050.hverkuil@xs4all.nl>    <4B5592BF.8040201@infradead.org> <4B56C078.8000502@redhat.com> <12e7fb96118720cc47555e3a12a5fd53.squirrel@webmail.xs4all.nl>
In-Reply-To: <12e7fb96118720cc47555e3a12a5fd53.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>>> 	4) v4l2-apps - I agree that splitting it could be a good idea, provided
>>> that we find
>>> a way to handle the few cases where we have "example" applications at
>>> the media docs.
>> Note that v4l2-apps also contains libv4l, it so happens that I've been
>> discussing moving
>> libv4l to its own git tree with Brandon Philips. Preferably to a place
>> which also offers
>> some form of bug tracking. The advantages of having libv4l in its own tree
>> are:
>>
>> -it is maintained independent of the hg tree anyways
>> -it has regular versioned tarbal releases, it would be good to be able to
>> tag these
>>   inside the used scm, which is hard to do when the scm is shared with
>> other unrelated
>>   code which does not end up in said tarballs
>> -this means having a much smaller tree making it easier to clone
>> -no longer having an often old (stale) libv4l in the master hg repository
>>   (this is partially my fault as I should send pull requests for libv4l
>> moe often,
>>    but why all this synchronization overhead when its independent anyways)
>>
>> As said when discussing this with Brandon we were thinking about using
>> something
>> like github, as that offers bug tracking too. But I can understand if you
>> would prefer
>> to keep libv4l at linuxtv.org .

Hans G.,

I prefer to keep it at linuxtv.org, and together with v4l2-apps. The rationale
is that there are applications that are dependent on libv4l (like v4l2grab).
We're also about to commit a gtk webcam application based on libv4l. So, IMO,
the better is to keep all of those applications together.

As we're discussing about having a separate tree for v4l2-apps, maybe the better
is to port it to -git (in a way that we can preserve the log history).

>>
>> The last few fays I've been working on making a stand alone version of the
>> uvcdynctrl
>> tool, which is meant to send a userspace database of vendor specific
>> controls to
>> the uvcvideo driver, after which they will show up as regular v4l2
>> controls.
>>
>> The uvcdynctrl utility is part of the libwebcam project:
>> http://www.quickcamteam.net/software/libwebcam
>>
>> But given that libwebcam is unmaintained and not used by anything AFAIK,
>> I'm patching
>> uvcdynctrl to no longer need it. The plan is to add uvcdynctrl to libv4l
>> soon, as that
>> is needed to be able to control the focus on some uvc autofocus cameras.
>>
>> This means that libv4l will be growing a set of utilities, currently just
>> uvcdynctrl
>> (and its database and udev scripts), but given this precedent we could add
>> more
>> utilities to libv4l. I wouldn't mind moving v4l2-ctl and v4l2-dbg to
>> libv4l, this would
>> also have the advantage that since most distro's ship libv4l these
>> utilities would
>> actually become available to end users (which AFAIK currently they are not
>> in most
>> distros).

IMO, we should not mix libv4l with the applications that use libv4l. It is good
to have separate dirs for different things, like what we currently have under
v4l2-apps.
 
> It seems to me that creating a v4l2-apps tree (similar to dvb-apps) would
> solve most of these issues

Agreed.

> (except for bug tracking).

Well, I don't see why not adding a bug tracking system for v4l2-apps an dvb-apps,
if needed. Are you thinking on something specific?

> We would need to do
> some rearranging in the directory structure of v4l2-apps, though.

Yes. Maybe we can move the tools that aren't meant to be used on distros on a separate
dir, like contrib, having a separate make install for building them.

Also, we need to use some config tool like autoconf that will seek for dependencies
and or require the needed ones or not compile the applications that depends on some
library.

> It is a bit of a mix of production code like libv4l and v4l2-ctl, v4l2-dbg.
> cx18-ctl and ivtv-ctl, and more test or debug oriented tools. The latter
> do not need to be packaged by distros.

Yes.

> Personally I would prefer to keep v4l2-apps on linuxtv.org. But the strict
> commit procedure that we have for the main v4l-dvb repo can be relaxed
> here. 

What do you mean by a "relaxed" one? Currently, there's no defined procedure for 
the applications there: several different CodingStyles were used on the different 
applications and no standard criteria were used to ack/nack changes there.

IMO, we should go on the opposite direction: we need to have some standard rules
also for it (but, it can be more relaxed than what we have in kernel).

For sure, one rule we need to define is what criteria will be used to classify
an application as something that will be compiled/installed by default, and what
applications are development-oriented applications. On some cases, this is clear
(for example, the API compliance test applications are developer-oriented, while
libv4l is a standard user-oriented one). However, a debug application (like v4l2-dbg)
is a development application, but it may be nice to have it available at the
distros, to help users to help check/report problems).

It may also be useful to define a minimum set of coding style, like how applications
should be indented 

> So it should be possible for you to have commit rights so you can
> use it as your master repository.

Maybe the better owner for v4l2-apps would be Hans G., since most of the changes there
are related to libv4l.

On the experiences we had with v4l-dvb tree, it is not a good idea to allow multiple
people to commit at the master repository, since, when a conflict rises between two
different developers, this can cause lots of heat. Also, it is easy to corrupt a tree,
as a push with -f flag can remove (or hide, on -git) the objects inserted by someone else.

So, IMO, every tree should have a single owner.

> Mauro, what do you think?

See above.

Cheers,
Mauro
