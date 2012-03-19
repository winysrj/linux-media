Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab2CSWsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:48:17 -0400
Message-ID: <4F67B7AA.7090000@redhat.com>
Date: Mon, 19 Mar 2012 19:48:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Martin Dauskardt <martin.dauskardt@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: media_build: how can I test older drivers?
References: <201203191918.42972.martin.dauskardt@gmx.de>
In-Reply-To: <201203191918.42972.martin.dauskardt@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-03-2012 15:18, Martin Dauskardt escreveu:
> To find the responsible patch for a regression, I need to test older drivers. 
> (1, 3 or 6 months ago)  How can I do this with media_build? 
> 
> I don't really understand how the build script works. It seems that it doesn't 
> use the current media_tree.git, but loads instead a driver snapshot 
> (http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2) which is at 
> the moment from March 9.

In a matter of fact, it supports several different modes of work. The default one is 
to download a tarball.

If you use:

	$ ./build.sh --main-git

it will download a copy of the main tree, and compile using it as a reference.

Yet, bisecting is not trivial. You'll need to run git bisect under the subdir
where the tree was copied. Also, the compilation may fail, due to the backport
patches, that won't be synchronized, especially if you're using an old Kernel that
requires lots of backport patches to compile/work, as the backport patches always
consider the very latest version of the media_tree.

If you want to bisect, it is likely easier to clone the media_tree and bisect on
it directly.

> 
> Can I simply change the name of the link for the bz2-package in 
> linux/Makefile?

Regards,
Mauro
