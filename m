Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZKRHYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 02:24:45 -0500
Message-ID: <4B03A11D.9090404@infradead.org>
Date: Wed, 18 Nov 2009 05:24:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Help in adding documentation
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com> <A69FA2915331DC488A831521EAE36FE401559C5D80@dlee06.ent.ti.com> <4B039C6A.8090907@infradead.org> <200911180819.11199.hverkuil@xs4all.nl>
In-Reply-To: <200911180819.11199.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Wednesday 18 November 2009 08:04:10 Mauro Carvalho Chehab wrote:
>> Karicheri, Muralidharan escreveu:
>>> Mauro,
>>>
>>> Thanks to your help, I could finish my documentation today.
>>>
>>> But I have another issue with the v4l2-apps.
>>>
>>> When I do make apps, it doesn't seem to build. I get the following error
>>> logs... Is this broken?
>> Well... no, it is not really broken, but the build system for v4l2-apps
>> needs serious improvements. There are some know issues on it:
>> 	- It doesn't check/warn if you don't have all the dependencies
>> 	  (qv4l2 and v4l2-sysfs-path require some development libraries
>> 	   that aren't available per default when gcc is installed - I
>> 	   think the other files there are ok);
>> 	- make only works fine when calling on certain directories (it used to work
>> 	  fine if you call it from /v4l2-apps/*) - but, since some patch, it now requires
>> 	  that you call make from /v4l2-apps, in order to create v4l2-apps/include.
>> 	  After having it created, make can be called from a /v4l2-apps subdir;
>> 	- for some places (libv4l - maybe there are other places?), you need to
>> 	  have the latest headers installed, as it doesn't use the one at the tree.
>> 	- qv4l2 only compiles with qt3.
> 
> I have a qt4 version available in my v4l-dvb-qv4l2 tree. Just no time to work
> on a series of patches to merge it in the main repo. And it is missing string
> control support.
> 
> If anyone is interested, then feel free to do that work. This new qt4 version
> is much better than the qt3 version.

IMO, the better is to have both versions on separate dirs, and let the building
system to check if qt4 is available. If so, build the qt4 version instead of
qt3 (a configure script, for example). Otherwise, warn users that it is compiling
a legacy application, due to the lack of the proper dependencies.

Cheers,
Mauro.
