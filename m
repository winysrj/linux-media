Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56190
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751427AbdFHIoS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 04:44:18 -0400
Date: Thu, 8 Jun 2017 05:44:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: rjkm@metzlerbros.de, linux-media@vger.kernel.org,
        max.kellermann@gmail.com, d.scheller@gmx.net
Subject: Re: [PATCH 0/7] Add block read/write to en50221 CAM functions
Message-ID: <20170608054409.4a6b1b9e@vento.lan>
In-Reply-To: <3c4a40ba-77fa-6eb9-2b29-3ce333b616c7@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
        <20170607125747.63d057c2@vento.lan>
        <a8d025a0-b090-7c58-bb25-aed32111c1de@anw.at>
        <20170607194934.00576613@vento.lan>
        <3c4a40ba-77fa-6eb9-2b29-3ce333b616c7@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Jun 2017 09:31:25 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro!
> 
>  > It should be, instead:
>  > 	From: Ralph Metzler <km@metzlerbros.de>  
> I thought it is enough to write him in the Signed-off-by as first.

No, it isn't. It is possible to have a patch authored by someone that
didn't sign. We don't usually accept it at the Kernel (on exceptional
cases, we might end accepting patches without SOB), but other projects
that use git may not require SOB.

> This From line is automatically generated by Git with Format Patch
> and then used by send. 

Git should take it from the author's name at your git tree. You
can change it with git filter-branch. Something like:

git filter-branch -f --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "My Name" ];
        then
                GIT_AUTHOR_NAME="Other Name";
                GIT_AUTHOR_EMAIL="other@email";
                GIT_COMMITTER_EMAIL="my@email";
		GIT_AUTHOR_DATE=$GIT_COMMITTER_DATE;
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' tag1..tag2

Btw, you can also use filter-branch to rename things at the code, e. g.:

	git filter-branch -f --tree-filter 'for i in $(git grep -l MEDIA_ENT_T_AV_BRIDGE); do sed s,MEDIA_ENT_T_AV_BRIDGE,MEDIA_ENT_T_AV_DMA,g -i $i; done ' tag2..tag3

(tag1, tag2, tag3 can actually be a changeset hash, a branch and/or a tag)

> However I should change that and my mail program
> still accepting it?
> I will try.
> 
> BR,
>     Jasmin



Thanks,
Mauro
