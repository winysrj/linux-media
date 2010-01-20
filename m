Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1698 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0ATI4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 03:56:33 -0500
Message-ID: <12e7fb96118720cc47555e3a12a5fd53.squirrel@webmail.xs4all.nl>
In-Reply-To: <4B56C078.8000502@redhat.com>
References: <4B55445A.10300@infradead.org>
    <201001190853.11050.hverkuil@xs4all.nl>
    <4B5592BF.8040201@infradead.org> <4B56C078.8000502@redhat.com>
Date: Wed, 20 Jan 2010 09:55:57 +0100
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Douglas Landgraf" <dougsland@gmail.com>,
	"Brandon Philips" <brandon@ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> Hi,
>
> On 01/19/2010 12:08 PM, Mauro Carvalho Chehab wrote:
>> Hans Verkuil wrote:
>>> On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
>
> <snip>
>
>>> I do have one proposal: parts of our hg tree are independent of git:
>>> v4l2-apps,
>>> possibly some firmware build code (not 100% sure of that),
>>> v4l_experimental,
>>> perhaps some documentation stuff. My proposal is that we make a
>>> separate hg
>>> or git tree for those. It will make it easier to package by distros and
>>> it makes it
>>> easier to maintain v4l2-apps et al as well. It might even simplify
>>> Douglas's work
>>> by moving non-essential code out of the compat hg tree.
>>
>> It may make sense, but I have some comments about it:
>
> <snip>
>
>> 	4) v4l2-apps - I agree that splitting it could be a good idea, provided
>> that we find
>> a way to handle the few cases where we have "example" applications at
>> the media docs.
>>>
>
> Note that v4l2-apps also contains libv4l, it so happens that I've been
> discussing moving
> libv4l to its own git tree with Brandon Philips. Preferably to a place
> which also offers
> some form of bug tracking. The advantages of having libv4l in its own tree
> are:
>
> -it is maintained independent of the hg tree anyways
> -it has regular versioned tarbal releases, it would be good to be able to
> tag these
>   inside the used scm, which is hard to do when the scm is shared with
> other unrelated
>   code which does not end up in said tarballs
> -this means having a much smaller tree making it easier to clone
> -no longer having an often old (stale) libv4l in the master hg repository
>   (this is partially my fault as I should send pull requests for libv4l
> moe often,
>    but why all this synchronization overhead when its independent anyways)
>
> As said when discussing this with Brandon we were thinking about using
> something
> like github, as that offers bug tracking too. But I can understand if you
> would prefer
> to keep libv4l at linuxtv.org .
>
> The last few fays I've been working on making a stand alone version of the
> uvcdynctrl
> tool, which is meant to send a userspace database of vendor specific
> controls to
> the uvcvideo driver, after which they will show up as regular v4l2
> controls.
>
> The uvcdynctrl utility is part of the libwebcam project:
> http://www.quickcamteam.net/software/libwebcam
>
> But given that libwebcam is unmaintained and not used by anything AFAIK,
> I'm patching
> uvcdynctrl to no longer need it. The plan is to add uvcdynctrl to libv4l
> soon, as that
> is needed to be able to control the focus on some uvc autofocus cameras.
>
> This means that libv4l will be growing a set of utilities, currently just
> uvcdynctrl
> (and its database and udev scripts), but given this precedent we could add
> more
> utilities to libv4l. I wouldn't mind moving v4l2-ctl and v4l2-dbg to
> libv4l, this would
> also have the advantage that since most distro's ship libv4l these
> utilities would
> actually become available to end users (which AFAIK currently they are not
> in most
> distros).

It seems to me that creating a v4l2-apps tree (similar to dvb-apps) would
solve most of these issues (except for bug tracking). We would need to do
some rearranging in the directory structure of v4l2-apps, though. It is a
bit of a mix of production code like libv4l and v4l2-ctl, v4l2-dbg.
cx18-ctl and ivtv-ctl, and more test or debug oriented tools. The latter
do not need to be packaged by distros.

Personally I would prefer to keep v4l2-apps on linuxtv.org. But the strict
commit procedure that we have for the main v4l-dvb repo can be relaxed
here. So it should be possible for you to have commit rights so you can
use it as your master repository.

Mauro, what do you think?

Regards,

        Hans

>
> Regards,
>
> Hans
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

