Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2ARMy7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:54:59 -0500
Message-ID: <4F16C11F.3040108@redhat.com>
Date: Wed, 18 Jan 2012 10:54:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <4F16BF4D.4070404@googlemail.com>
In-Reply-To: <4F16BF4D.4070404@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 10:47, Gregor Jasny escreveu:
> On 1/18/12 1:19 PM, Mauro Carvalho Chehab wrote:
>> It would be nice to write at the INSTALL what dependencies are needed for
>> the autotools to work, or, alternatively, to commit the files generated
>> by the autoreconf -vfi magic spell there [1].
> 
> The end user gets a tarball created with "make dist" which contains all the m4 files.

Ah, ok. It probably makes sense then to add some scripting at the server to do
a daily build, as the tarballs aren't updated very often. They're updated only
at the sub-releases:
	http://linuxtv.org/downloads/v4l-utils/

> For the developers I will list the dependencies (autotools-dev, pkgconfig and libtool) explicitely.

Ok, thanks!

>> Not sure if it is possible, but it would be great if the build output
>> would be less verbose. libtool adds a lot of additional (generally useless)
>> messages, with makes harder to see the compilation warnings in the
>> middle of all those garbage.
> 
> I will add the AM_SILENT_RULES option later.

Just added it, and fixed two warnings I was not able to notice before, due to
the excess of fast-scrolling messages that were appearing when compiling it
here ;)

Thanks,
Mauro
