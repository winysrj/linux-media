Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab0FCO4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 10:56:01 -0400
Message-ID: <4C07C281.8090304@redhat.com>
Date: Thu, 03 Jun 2010 11:56:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: Which GIT repository for 2.6.35/2.6.36
References: <20100603103947.4458bac3@tele>
In-Reply-To: <20100603103947.4458bac3@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-06-2010 05:39, Jean-Francois Moine escreveu:
> Hi Mauro,
> 
> I am lost with the GIT repositories at LinuxTv.org.
> 
> My local development repository is based on
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> origin and git://linuxtv.org/v4l-dvb.git master
> 
> When moving any local branch, the kernel is 2.6.33.
> Looking at 'origin/HEAD', the kernel is 2.6.34.
> Then, looking at http://git.linuxtv.org/linux-2.6.git, the kernel is
> 2.6.35-rc1.
> 
> A problem appeared when some gspca testers signalled compilation errors
> with kernels 2.6.34. Looking more carefuly, I see that, in the file
> 	drivers/media/video/gspca/zc3xx.c
> there is no
> 	#include <linux/slab.h>
> in the local branches, nor in v4l-dvb master, while it exists in
> v4l-dvb devel/for_v2.6.34.
> 
> Looking at http://git.linuxtv.org/linux-2.6.git, I see that there is a
> recent change about the files slab.h et gfp.h (commit
> 5a0e3ad6af8660be21ca98a971cd00f331318c05) which touches gspca files
> again.
> 
> I do not think I will put anything more in the new kernel (2.6.35),
> but what with 2.6.36? Some gspca files have been changed in kernels
> 2.6.34 and 2.6.35, and these changes don't appear in the v4l-dvb
> repository. What can I do?
> 
> - if I continue to develop with v4l-dvb, there will be permanent merge
>   problems with the future kernel.
> 
> - if I base my local repository directly on the last 2.6.35, there will
>   be problems with v4l-dvb.
> 
> Otherwise, at LinuxTv.org, is there any development repository in sync
> with both the last kernel and the video stuff?

I'm experimenting some adjustments on the procedures I'm using to handle patches,
in order to solve some troubles I've identified during the last merge period.
During this time, the better thing to do is to base your tree at Linus tree.

As I've created separate staging trees, per subject, each branch can be based
on different object references, provided that they are already merged upstream.

Cheers,
Mauro

