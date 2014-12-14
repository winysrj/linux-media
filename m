Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40153 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbaLNLwC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 06:52:02 -0500
Date: Sun, 14 Dec 2014 09:51:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] Update INSTALL instructions and add a
 script to configure
Message-ID: <20141214095156.305ceb3e@recife.lan>
In-Reply-To: <548D774A.4030902@xs4all.nl>
References: <E1Y07L2-0005cD-72@www.linuxtv.org>
	<548D774A.4030902@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Sun, 14 Dec 2014 12:40:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/14/2014 12:26 PM, Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following patch were queued at the 
> > http://git.linuxtv.org/cgit.cgi/v4l-utils.git tree:
> > 
> > Subject: Update INSTALL instructions and add a script to configure
> > Author:  Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Date:    Sun Dec 14 09:26:20 2014 -0200
> > 
> > Just running autoconf -vfi will override some needed configs
> > at libdvbv5-po. So, add a bootstrap.sh script and document it.
> 
> FYI: after running ./bootstrap.sh I get the diff shown below if I run 'git diff'.
> That suggests that there are autogenerated files in the git repo that do
> not belong there.

Yes, I'm aware of that. The bootstrap.sh is for now a hack to allow
building it with different versions of gettext. I suspect that there are
better ways of doing that, so I prefer to not remove the files generated
by gettextize for now.

> 
> I also see following message twice when running bootstrap:
> 
> -------
> Please create libdvbv5-po/Makevars from the template in libdvbv5-po/Makevars.template.
> You can then remove libdvbv5-po/Makevars.template.
> 
> Please run 'aclocal -I m4' to regenerate the aclocal.m4 file.
> You need aclocal from GNU automake 1.9 (or newer) to do this.
> Then run 'autoconf' to regenerate the configure file.
> 
> You might also want to copy the convenience header file gettext.h
> from the /usr/share/gettext directory into your package.
> It is a wrapper around <libintl.h> that implements the configure --disable-nls
> option.
> 
> Press Return to acknowledge the previous three paragraphs.

This is also due to the hack of running gettextize at
bootstrap.sh.

We might add a >/dev/null to avoid showing such useless messages,
although I'm trying to see if I can find a better way to implement it.

Regards,
Mauro
