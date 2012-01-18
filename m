Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab2AROwe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 09:52:34 -0500
Message-ID: <4F16DCAD.5010700@redhat.com>
Date: Wed, 18 Jan 2012 12:52:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <4F16BF4D.4070404@googlemail.com> <4F16C11F.3040108@redhat.com> <4F16C2CA.2090401@googlemail.com>
In-Reply-To: <4F16C2CA.2090401@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 11:02, Gregor Jasny escreveu:
> On 1/18/12 1:54 PM, Mauro Carvalho Chehab wrote:
>> Em 18-01-2012 10:47, Gregor Jasny escreveu:
>>> On 1/18/12 1:19 PM, Mauro Carvalho Chehab wrote:
>>>> It would be nice to write at the INSTALL what dependencies are needed for
>>>> the autotools to work, or, alternatively, to commit the files generated
>>>> by the autoreconf -vfi magic spell there [1].
>>>
>>> The end user gets a tarball created with "make dist" which contains all the m4 files.
>>
>> Ah, ok. It probably makes sense then to add some scripting at the server to do
>> a daily build, as the tarballs aren't updated very often. They're updated only
>> at the sub-releases:
>>     http://linuxtv.org/downloads/v4l-utils/
> 
> Judging from the upside-down reports: not the lack of a buildable tarball but the lack of updated distribution packages is a problem. For Ubuntu we have a PPA repository with nightly builds:
> 
> https://launchpad.net/~libv4l/+archive/development
> 
> Do you have similar infrastructure for Fedora / RedHat, too?

There are two separate issues here:

1) users that just get the distro packages.

For them, the updated distro packages is the issue.

For those, it is very good to have v4l-utils properly packaged on Ubuntu.
Thanks for that!

Hans is maintaining v4l-utils at Fedora. I don't think he's currently 
using the -git unstable versions at Fedora Rawhide (the Fedora under 
development distro). Yet, every time a new release is lauched, he
updates the packages for Fedora.

So, I think that this is now properly covered with Fedora and Ubuntu 
(also Debian?). I think that Suse is also doing something similar.

2) users that are testing the neat features that the newest package has.

This covers most of the 900+ subscribers of the linux-media ML.

Those users, in general, don't care much about the distro packages. They
just want to download the latest sources and compile, in order to test
the drivers/tools, and provide us feedback. We want to make life easier
for them, as their test is very important for us to detect, in advance,
when some regression is happened somewhere.

For those users, it may make sense to have a daily tarball or some
user-friendly scripting that would allow them to easily clone the
git tree and use it.

Regards,
Mauro


> 
> Thanks,
> Gregor
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

