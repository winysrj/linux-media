Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:39001 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758361Ab0FCIif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 04:38:35 -0400
Date: Thu, 3 Jun 2010 10:39:47 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Which GIT repository for 2.6.35/2.6.36
Message-ID: <20100603103947.4458bac3@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I am lost with the GIT repositories at LinuxTv.org.

My local development repository is based on
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
origin and git://linuxtv.org/v4l-dvb.git master

When moving any local branch, the kernel is 2.6.33.
Looking at 'origin/HEAD', the kernel is 2.6.34.
Then, looking at http://git.linuxtv.org/linux-2.6.git, the kernel is
2.6.35-rc1.

A problem appeared when some gspca testers signalled compilation errors
with kernels 2.6.34. Looking more carefuly, I see that, in the file
	drivers/media/video/gspca/zc3xx.c
there is no
	#include <linux/slab.h>
in the local branches, nor in v4l-dvb master, while it exists in
v4l-dvb devel/for_v2.6.34.

Looking at http://git.linuxtv.org/linux-2.6.git, I see that there is a
recent change about the files slab.h et gfp.h (commit
5a0e3ad6af8660be21ca98a971cd00f331318c05) which touches gspca files
again.

I do not think I will put anything more in the new kernel (2.6.35),
but what with 2.6.36? Some gspca files have been changed in kernels
2.6.34 and 2.6.35, and these changes don't appear in the v4l-dvb
repository. What can I do?

- if I continue to develop with v4l-dvb, there will be permanent merge
  problems with the future kernel.

- if I base my local repository directly on the last 2.6.35, there will
  be problems with v4l-dvb.

Otherwise, at LinuxTv.org, is there any development repository in sync
with both the last kernel and the video stuff?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
