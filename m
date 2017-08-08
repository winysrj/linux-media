Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46493
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751464AbdHHKWi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 06:22:38 -0400
Date: Tue, 8 Aug 2017 07:22:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.14] Doc and TGP fixes
Message-ID: <20170808072230.0570754a@vento.lan>
In-Reply-To: <dc878037-1039-be63-cd69-11757235271a@xs4all.nl>
References: <dc878037-1039-be63-cd69-11757235271a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jul 2017 09:38:52 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Here are various documentation fixes/improvements.
> 
> The first patch renames the old pixfmt-0XX.rst files to something I can
> understand since I could never find the right rst file for the colorspace
> documentation...
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:
> 
>    media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/hverkuil/media_tree.git tpg-doc-fixes
> 
> for you to fetch changes up to 2ebc8a9b217c24a2e12f775b1b107ce7b8c28166:
> 
>    v4l2-tpg-core.c: fix typo in bt2020_full matrix (2017-07-28 09:33:58 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (6):
>        media/doc: rename and reorder pixfmt files
>        media/doc: improve bt.2020 documentation
>        media/doc: improve the SMPTE 2084 documentation

>        v4l2-tpg: fix the SMPTE-2084 transfer function

I didn't apply this one, due to its first hunk, that adds an ugly
hack due to v4l-utils. Just remove it and I'll be happy :-)

The other patches in this series were applied, thanks!

Mauro

Thanks,
Mauro
