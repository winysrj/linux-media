Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab2EBWRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 18:17:50 -0400
Message-ID: <4FA1B27A.2030405@redhat.com>
Date: Wed, 02 May 2012 19:17:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, remi@remlab.net,
	nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi> <201205022245.22585.hverkuil@xs4all.nl>
In-Reply-To: <201205022245.22585.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em 02-05-2012 17:45, Hans Verkuil escreveu:
> On Wed May 2 2012 21:13:47 Sakari Ailus wrote:
>> Replace enums in IOCTL structs by __u32. The size of enums is variable and
>> thus problematic. Compatibility structs having exactly the same as original
>> definition are provided for compatibility with old binaries with the
>> required conversion code.
> 
> Does someone actually have hard proof that there really is a problem? You know,
> demonstrate it with actual example code?
> 
> It's pretty horrible that you have to do all those conversions and that code
> will be with us for years to come.
> 
> For most (if not all!) architectures sizeof(enum) == sizeof(u32), so there is
> no need for any compat code for those.

"Most" is not enough. We need a solution for all.

Also, the usage of -fshort-enum compilation directive would cause a V4L2 application 
to not work.

  I've checked with a gcc developer: he said that,
C standard says that the type should be represented as an integer, but it does allow
that it could be represented by a sorter type, like char. Gcc also allows using larger
enumber types, as a compatible extension, but doesn't use (by default) sorter types,
except if packed attribute is used.

As we use __packed on several structs, this can cause troubles.

It seems that the compiler may also choose to use either signed or unsigned integers
for enums.

He also doesn't recommend to use enums for any bitfield, as this is not defined on
C standard, and the way GCC implements it can cause troubles.

I would prefer a simpler solution, but, after thinking for some time, we should really
do something like that. Yes, compat code sucks, but, on the long term, we'll get rid
of all those mess. If we don't do that, I'm sure that this problem will return back in
the future (as this is the second time it returned. If we had fixed it on that time,
all our problems would already be solved nowadays).

> 
> Note that I don't question that using u32 is better than using enums, but I
> really wonder if there is any need for all the conversions.

We can speed-up the conversions, with something like:

enum foo {
	BAR
};

if (sizeof(foo) != sizeof(u32))
	call_compat_logic().

I suspect that sizeof() won't work inside a macro. 

Regards,
Mauro
