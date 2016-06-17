Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45205
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbcFQIyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 04:54:41 -0400
Date: Fri, 17 Jun 2016 05:54:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gregor Jasny <gjasny@googlemail.com>
Subject: Re: Can you look at this apps build warning?
Message-ID: <20160617055435.6cbd1b5d@recife.lan>
In-Reply-To: <5763A448.1010003@xs4all.nl>
References: <5763A448.1010003@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Jun 2016 09:18:32 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> From the daily build:
> 
> apps: WARNINGS
> dvb-sat.c:188:14: warning: unused variable 's' [-Wunused-variable]
> 
> The fix is easy of course (delete static char s[1024];), but it is a bit surprising and I just
> want to make sure there isn't something else going on.

Thanks for noticing.

That line is bogus. I added it together with some other debug code,
while I was trying to understand why the newer libdvbv5.mo was not
being used on my system.

There's actually an weird issue that was happening on my system.
Here, I installed v4l-utils at the /usr/local prefix.

For the dvbv5-scan, it should load the v4l-utils.mo translation.

It did it right:

open("/usr/local/share/locale/pt_BR.utf8/LC_MESSAGES/v4l-utils.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/local/share/locale/pt_BR/LC_MESSAGES/v4l-utils.mo", O_RDONLY) = 3

But, for the library, it looked only at the /usr prefix:

open("/usr/share/locale/pt_BR.utf8/LC_MESSAGES/libdvbv5.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/pt_BR/LC_MESSAGES/libdvbv5.mo", O_RDONLY) = 3

So, it was loading an old copy of the translation messages.

Btw, there is a similar issue I noticed a few weeks ago,
related to pkg-config: it is also not looking for libdvbv5.pc
at /usr/local prefix. I also had to manually force pkg-config
to also seek under /usr/local by setting an env var:

export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):/usr/local/lib/pkgconfig

I didn't try to identify the reason for that yet. I *suspect* that 
this is not related to v4l-utils autoconfig, but, instead, to some
patches that are missing when pkg-config and glibc search patches
on Fedora 23.

In any case, I'm c/c Gregor. He may know a little bit more about
such issues.

Anyway, with regards to the unused code, just fixed it upstream.

Thanks,
Mauro
