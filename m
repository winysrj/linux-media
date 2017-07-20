Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38026
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964876AbdGTPYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:24:21 -0400
Date: Thu, 20 Jul 2017 12:24:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170720122412.0aaefcfe@vento.lan>
In-Reply-To: <20170711173013.25741b86@audiostation.wuest.de>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <22883.13973.46880.749847@morden.metzler>
        <20170710173124.653286e7@audiostation.wuest.de>
        <22884.38463.374508.270284@morden.metzler>
        <20170711173013.25741b86@audiostation.wuest.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Jul 2017 17:30:13 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> Am Tue, 11 Jul 2017 11:11:27 +0200
> schrieb Ralph Metzler <rjkm@metzlerbros.de>:
> 
> > Daniel Scheller writes:  
> >  > 
> >  > IIRC this was -main.c, and basically the code split, but no
> >  > specific file. However, each of the additionals (hw, io, irq) were
> >  > done with a reason (please also see their commit messages at
> >  > patches 4-6):
> >  > [...]  
> > 
> > As I wrote before, changes like this will break other things like the
> > OctopusNet build tree. So, I cannot use them like this or without
> > changes at other places. And even if I wanted to, I cannot pull
> > anything into the public dddvb repository.  
> 
> Ok, you probably have seen the PRs I created against dddvb, as they
> apply basically the same as is contained in this patchset, and even
> fixes a few minors. Thus, lets not declare this as merge-blocker for
> this patches, please.

I would prefer if we could spend more time trying to find a way where
we can proceed without increasing the discrepancies between upstream
and DD tree, but, instead to reduce. 

I mean, if we know that some change won't be accepted at DD tree,
better to change our approach to another one that it is acceptable
on both upstream and DD trees.


Thanks,
Mauro
