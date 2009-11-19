Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36494 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbZKSRBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 12:01:30 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 19 Nov 2009 11:01:28 -0600
Subject: RE: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE40155A5149B@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
 <200911180819.11199.hverkuil@xs4all.nl> <4B03A11D.9090404@infradead.org>
 <200911180832.35450.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40155A51446@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155A51446@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

It is hard for me to get the v4l2-apps compile on my build environment.
Unless someone can help me to resolve the build issue, I wouldn't be able to update the v4l2-apps or Alternately someone volunteer to add this support
based on the API.

Thanks and regards,

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
>Sent: Thursday, November 19, 2009 11:26 AM
>To: Hans Verkuil; Mauro Carvalho Chehab
>Cc: linux-media@vger.kernel.org
>Subject: RE: Help in adding documentation
>
>BTW,
>
>I don't know what is qt4/qt3 that you are referring to.
>I see qv4l2 in the directory v4l2-apps/qv4l2.
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>>Sent: Wednesday, November 18, 2009 2:33 AM
>>To: Mauro Carvalho Chehab
>>Cc: Karicheri, Muralidharan; linux-media@vger.kernel.org
>>Subject: Re: Help in adding documentation
>>
>>On Wednesday 18 November 2009 08:24:13 Mauro Carvalho Chehab wrote:
>>> Hans Verkuil wrote:
>>> > On Wednesday 18 November 2009 08:04:10 Mauro Carvalho Chehab wrote:
>>> >> Karicheri, Muralidharan escreveu:
>>> >>> Mauro,
>>> >>>
>>> >>> Thanks to your help, I could finish my documentation today.
>>> >>>
>>> >>> But I have another issue with the v4l2-apps.
>>> >>>
>>> >>> When I do make apps, it doesn't seem to build. I get the following
>>error
>>> >>> logs... Is this broken?
>>> >> Well... no, it is not really broken, but the build system for v4l2-
>>apps
>>> >> needs serious improvements. There are some know issues on it:
>>> >> 	- It doesn't check/warn if you don't have all the dependencies
>>> >> 	  (qv4l2 and v4l2-sysfs-path require some development libraries
>>> >> 	   that aren't available per default when gcc is installed - I
>>> >> 	   think the other files there are ok);
>>> >> 	- make only works fine when calling on certain directories (it
>used
>>to work
>>> >> 	  fine if you call it from /v4l2-apps/*) - but, since some
>patch, it
>>now requires
>>> >> 	  that you call make from /v4l2-apps, in order to create v4l2-
>>apps/include.
>>> >> 	  After having it created, make can be called from a /v4l2-apps
>>subdir;
>>> >> 	- for some places (libv4l - maybe there are other places?), you
>need
>>to
>>> >> 	  have the latest headers installed, as it doesn't use the one
>at the
>>tree.
>>> >> 	- qv4l2 only compiles with qt3.
>>> >
>>> > I have a qt4 version available in my v4l-dvb-qv4l2 tree. Just no time
>>to work
>>> > on a series of patches to merge it in the main repo. And it is missing
>>string
>>> > control support.
>>> >
>>> > If anyone is interested, then feel free to do that work. This new qt4
>>version
>>> > is much better than the qt3 version.
>>>
>>> IMO, the better is to have both versions on separate dirs, and let the
>>building
>>> system to check if qt4 is available. If so, build the qt4 version
>instead
>>of
>>> qt3 (a configure script, for example). Otherwise, warn users that it is
>>compiling
>>> a legacy application, due to the lack of the proper dependencies.
>>
>>I'm not going to maintain the qt3 version. Personally I think it is
>>pointless
>>having two tools for this and it only creates confusion and unnecessary
>>maintenance cost. Of course, all this is moot as long as the new version
>is
>>still unmerged.
>>
>>BTW: everything inside v4l2-apps should use the generated headers inside
>>v4l2-apps/include. These are generated from the headers in the tree and
>yes,
>>it would be nice if v4l2-apps/Makefile would have a proper dependency to
>>generate them. Now only the top-level Makefile knows about it. After that
>>include directory is generated you can do a make in v4l2-apps.
>>
>>But libv4l should use those headers and not the installed headers.
>>Something
>>may have been broken since when I last wrote that code.
>>
>>Regards,
>>
>>	Hans
>>
>>--
>>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

