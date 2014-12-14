Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40157 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaLNMW1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 07:22:27 -0500
Date: Sun, 14 Dec 2014 10:22:22 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] Update INSTALL instructions and add a
 script to configure
Message-ID: <20141214102222.5b6bbd34@recife.lan>
In-Reply-To: <20141214095156.305ceb3e@recife.lan>
References: <E1Y07L2-0005cD-72@www.linuxtv.org>
	<548D774A.4030902@xs4all.nl>
	<20141214095156.305ceb3e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Sun, 14 Dec 2014 09:51:56 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> > FYI: after running ./bootstrap.sh I get the diff shown below if I run 'git diff'.
> > That suggests that there are autogenerated files in the git repo that do
> > not belong there.

...

I did a few adjustments there, and it should not produce any diff anymore,
at least for gettext versions 0.19.2 and 0.17 (and likely anything in the
middle).

> > 
> > I also see following message twice when running bootstrap:

I also cleaned up the messages.

Regards,
Mauro

