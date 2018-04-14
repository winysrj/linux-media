Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60275 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbeDNKvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 06:51:38 -0400
Date: Sat, 14 Apr 2018 07:51:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Smatch and sparse errors
Message-ID: <20180414075127.5b0d8909@vento.lan>
In-Reply-To: <4ecc96e9-fb47-3365-cd33-c35febba801d@anw.at>
References: <20180411122728.52e6fa9a@vento.lan>
        <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
        <20180414064648.0ad264fa@vento.lan>
        <4ecc96e9-fb47-3365-cd33-c35febba801d@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Apr 2018 12:06:34 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro/Hans!
> 
> > Then you're probably not using the right version  
> Might be ...
> The build script from Hans uses the Versions from here:
>    git://repo.or.cz/smatch.git

That's right. The last patch on this repo is:

	53b881888d7b (origin/master, origin/HEAD) check_or_vs_and: ignore the kernel's min/max macros

And the patch that adds -Wpointer-arith applies cleanly at the top of
it.

>    git://git.kernel.org/pub/scm/devel/sparse/sparse.git

That's wrong.

Sparse nowadays are getting updates on this dir:

		url = git://git.kernel.org/pub/scm/devel/sparse/chrisl/sparse.git

I still track the old repo. My config for it is:

[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
[remote "origin"]
	url = git://git.kernel.org/pub/scm/devel/sparse/sparse.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[remote "sparse-chris"]
	url = git://git.kernel.org/pub/scm/devel/sparse/chrisl/sparse.git
	fetch = +refs/heads/*:refs/remotes/sparse-chris/*

> 
> > Yesterday, I added both trees I'm using here at:
> > 	https://git.linuxtv.org/mchehab/sparse.git/
> > 	https://git.linuxtv.org/mchehab/smatch.git/  
> Maybe we should use your version in the build script.
> Hans?
> 
> > IMHO, all 4 patches are disabling false-positive only warnings,
> > although the 4th patch might have something useful, if fixed to
> > properly handle the 64-bit compat macros.  
> Another good reason for using your version. Doing so, you can fix/extend
> sparse/smatch and the daily build will automatically use that.
> 
> BR,
>    Jasmin



Thanks,
Mauro
