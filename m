Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0DII7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 04:59:39 -0400
Message-ID: <4BBEECBF.3050607@redhat.com>
Date: Fri, 09 Apr 2010 11:00:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"'vimarsh.zutshi@nokia.com'" <vimarsh.zutshi@nokia.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: Re: V4L2 and Media controller mini-summit in Helsinki 14.--16. June
References: <4BBA3BC3.2060205@maxwell.research.nokia.com> <201004090858.52251.hverkuil@xs4all.nl>
In-Reply-To: <201004090858.52251.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/09/2010 08:58 AM, Hans Verkuil wrote:
> On Monday 05 April 2010 21:36:35 Sakari Ailus wrote:
>> Hello everyone,
>>
>> I'm glad to announce Nokia will be hosting a V4L2 and Media controller
>> mini-summit in Helsinki, Finland from 14th to 16th June --- that's from
>> Monday to Wednesday. The event replaces the V4L2 Media Controller
>> mini-summit in Oslo in April / May proposed by Hans Verkuil. Just the
>> location is different; Hans is still responsible for the technical content.
>
> Then I'd better start on that technical content :-)
>
> Here is a short overview of the topics I want to put on the agenda (in no
> particular order):
>
> - Media controller progress. Especially with regards to the roadmap of getting
>    this merged.
>
> - Memory handling. See this link for a report on a preliminary meeting:
>    http://www.mail-archive.com/linux-media@vger.kernel.org/msg16618.html
>    It would be nice if we can spend some more time on the memory pool
>    concept.
>
> - V4L1 removal. We need to decide how we are going to do this. In particular
>    the role that libv4l1 can play in this is of interest.

Let me chime in here by mail, as I assume I won't be able to attend (see below),
libv4l1 can completely replace the in kernel compatibility layer. Moreover it
cannot only completely replace it, it can even do a better job then the
in kernel compat layer. Actually in many cases libv4l1 is already needed for
v4l1 apps to work with v4l2 drivers:
1) Many v4l2 drivers don't implement VIDIOCGMBUF, which in the kernel compat
    implementation is something which needs to be handled at the driver level
    and thus separately for each driver. Since this is a rather important ioctl
    this means in practice that v4l1 apps won't work with these drivers using
    the kernel compat ioctl support. libv4l1 emulates VIDIOCGMBUF without needing
    any special driver support (it can even emulate it on drivers which only
    support read()). One well known example of a driver missing VIDIOCGMBUF
    support is uvcvideo.

2) Many video devices produce video formats v4l1 apps don't grok (and there aren't
    even VIDEO_PALETTE_FOO defines for them). libv4l1 will use libv4l2 + libv4lconvert
    to let the app see well known formats.

So I definitely believe that libv4l1 can meet all v4l1 compat needs, and even do a
better job then the in kernel code. But ...

libv4l1 atm is not ready to fully replace the kernel compat ioctl stuff, as it relies
on it in some cases. This is fixable, and fixing it isn't hard, but this needs someone
to work on it. Patches welcome :)


> - Work on the V4L core framework: what is in place, what still needs to be
>    done, what other parts can be moved to the core.
>
> - Compliance tests. I'd like to start discussing this as well. I think we
>    have to start work on a tool that will do basic compliance testing of new
>    (and existing) drivers. The API is so big that it is way too easy to forget
>    things. My guess is that at least 80% of all drivers violate the spec in
>    one way or another. Relates as well to the framework topic: if we can move
>    more into the core, then it is much easier to enforce spec compliance.
>
> - Anything else someone wants to discuss?

I know that there are various people who would like to use libv4l's video processing
to work together with video processing abilities of various SOC's (Nokia and Intel come
to mind here). So that the controlling of those video processing abilities (lens correction,
whitebalance, etc, etc.) can be done with libv4l processing plugins rather then with
solutions using custom ioctl's and daemons as is done now.

I plan to write a RFC with a new libv4l plugin API for this in time for it to be discussed
at the summit.

It certainly would be nice if I could be present at the summit to discuss this in person,
but -ENOBUDGET. If any of the companies interested in this work would be willing to
sponsor my travel to the summit that would be great!

Regards,

Hans
