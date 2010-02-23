Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0BWIsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:48:31 -0500
Message-ID: <4B839687.4090205@redhat.com>
Date: Tue, 23 Feb 2010 09:49:11 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org>
In-Reply-To: <20100222225426.GC4013@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/22/2010 11:54 PM, Brandon Philips wrote:
> On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
>>> lib/
>>> 	libv4l1/
>>> 	libv4l2/
>>> 	libv4lconvert/
>>> utils/
>>> 	v4l2-dbg
>>> 	v4l2-ctl
>>> 	cx18-ctl
>>> 	ivtv-ctl
>>> contrib/
>>> 	test/
>>> 	everything else
>>>
>
>    git clone git://ifup.org/philips/create-v4l-utils.git
>    cd create-v4l-utils/
>    ./convert.sh
>
> You should now have v4l-utils.git which should have this directory
> struture. If we need to move other things around let me know and I can
> tweak name-filter.sh
>

Ok, so this will give me a local tree, how do I get this onto linuxtv.org ?

Also I need someone to pull:
http://linuxtv.org/hg/~hgoede/libv4l

(this only contains libv4l commits)

Into the:
http://linuxtv.org/hg/v4l-dvb

Repository, I guess I can ask this directly to Douglas?

> Thoughts?

I've one question, I think we want to do tarbal releases
from this new repo (just like I've been doing with libv4l for a while
already), and then want distro's to pick up these releases, right ?

Are we going to do separate tarbals for the lib and utils directories,
or one combined tarbal. I personally vote for one combined tarbal.

But this means we will be inflicting some pains on distro's because their
libv4l packages will go away and be replaced by a new v4l-utils package.
This is something distro's should be able to handle (it happens more often, and I
know Fedora has procedures for this).

An alternative would be to name the repo and the tarbals libv4l, either is fine
with me (although I'm one of the distro packagers who is going to feel the pain
of a package rename and as such wouldn't mind using libv4l as name for the
repo and the new tarbals).

Regards,

Hans
